@tool
extends Inventory
class_name InventoryGrid

signal size_changed

const KEY_WIDTH: String = "width"
const KEY_HEIGHT: String = "height"
const KEY_SIZE: String = "size"
const KEY_GRID_POSITION: String = "grid_position"
const DEFAULT_SIZE: Vector2i = Vector2i(10, 10)

@export var size: Vector2i = DEFAULT_SIZE :
    get:
        return size
    set(new_size):
        assert(new_size.x > 0, "Inventory width must be positive!")
        assert(new_size.y > 0, "Inventory height must be positive!")
        var old_size = size
        size = new_size
        update_configuration_warnings()
        if !Engine.is_editor_hint():
            if _bounds_broken():
                size = old_size
        if size != old_size:
            emit_signal("size_changed")


func _get_configuration_warnings() -> PackedStringArray:
    if !_is_sorted():
        return PackedStringArray(["Inventory not sorted!"])
    if _bounds_broken():
        return PackedStringArray(["Inventory bounds broken!"])
    return PackedStringArray()


func _get_prototype_size(prototype_id: String) -> Vector2i:
    if item_protoset:
        var width: int = item_protoset.get_item_property(prototype_id, KEY_WIDTH, 1)
        var height: int = item_protoset.get_item_property(prototype_id, KEY_HEIGHT, 1)
        return Vector2i(width, height)
    return Vector2i(1, 1)


func get_item_position(item: InventoryItem) -> Vector2i:
    assert(has_item(item), "Item not found in the inventory!")
    return item.get_property(KEY_GRID_POSITION, Vector2i.ZERO)


func _get_item_index(item: InventoryItem) -> int:
    var item_index: int = get_items().find(item)
    assert(item_index >= 0, "The inventory does not contain this item!")
    return item_index


func get_item_size(item: InventoryItem) -> Vector2i:
    var item_width: int = item.get_property(KEY_WIDTH, 1)
    var item_height: int = item.get_property(KEY_HEIGHT, 1)
    if item.get_property("rotated", false):
        var temp = item_width
        item_width = item_height
        item_height = temp
    return Vector2i(item_width, item_height)


func get_item_rect(item: InventoryItem) -> Rect2i:
    var item_pos := get_item_position(item)
    var item_size := get_item_size(item)
    return Rect2i(item_pos, item_size)
    

func _ready():
    super._ready()
    
    assert(size.x > 0, "Inventory width must be positive!")
    assert(size.y > 0, "Inventory height must be positive!")
    _sort_if_needed()
    connect("item_modified", Callable(self, "_on_item_modified"))
    update_configuration_warnings()


func _is_sorted() -> bool:
    for item1 in get_items():
        for item2 in get_items():
            if item1 == item2:
                continue

            var rect1: Rect2i = get_item_rect(item1)
            var rect2: Rect2i = get_item_rect(item2)
            if rect1.intersects(rect2):
                return false;

    return true


func _on_item_added(item: InventoryItem) -> void:
    if !rect_free(get_item_rect(item), item):
        var free_place = find_free_place(item)
        if Verify.vector_positive(free_place):
            move_item_to(item, free_place)
    
    _sort_if_needed()

    super._on_item_added(item)
    update_configuration_warnings()


func _on_item_removed(item: InventoryItem) -> void:
    if item.properties.has(KEY_GRID_POSITION):
        item.properties.erase(KEY_GRID_POSITION)

    super._on_item_removed(item)
    update_configuration_warnings()


func _on_item_modified(_item: InventoryItem) -> void:
    update_configuration_warnings()


func _bounds_broken() -> bool:
    for item in get_items():
        if !rect_free(get_item_rect(item), item):
            return true

    return false


func add_item(item: InventoryItem) -> bool:
    if item.properties.has(KEY_GRID_POSITION):
        var item_position = item.properties[KEY_GRID_POSITION]
        return add_item_at(item, item_position)

    var free_place = find_free_place(item)
    if !Verify.vector_positive(free_place):
        return false

    return add_item_at(item, free_place)


func add_item_at(item: InventoryItem, position: Vector2i) -> bool:
    var item_size := get_item_size(item)
    var rect := Rect2i(position, item_size)
    if rect_free(rect):
        item.properties[KEY_GRID_POSITION] = position
        if item.properties[KEY_GRID_POSITION] == Vector2i.ZERO:
            item.properties.erase(KEY_GRID_POSITION)
        return super.add_item(item)

    return false


func create_and_add_item_at(prototype_id: String, position: Vector2i) -> InventoryItem:
    var item = create_and_add_item(prototype_id)
    if item:
        move_item_to(item, position)
    return item


func get_item_at(position: Vector2i) -> InventoryItem:
    for item in get_items():
        if get_item_rect(item).has_point(position):
            return item
    return null


func move_item_to(item: InventoryItem, position: Vector2i) -> bool:
    var item_size := get_item_size(item)
    var rect := Rect2i(position, item_size)
    if rect_free(rect, item):
        _move_item_to_unsafe(item, position)
        emit_signal("contents_changed")
        return true

    return false


func _move_item_to_unsafe(item: InventoryItem, position: Vector2i) -> void:
    item.properties[KEY_GRID_POSITION] = position
    if item.properties[KEY_GRID_POSITION] == Vector2i.ZERO:
        item.properties.erase(KEY_GRID_POSITION)


func transfer(item: InventoryItem, destination: Inventory) -> bool:
    return transfer_to(item, destination, Vector2i.ZERO)


func transfer_to(item: InventoryItem, destination: InventoryGrid, position: Vector2i) -> bool:
    var item_size = get_item_size(item)
    var rect := Rect2i(position, item_size)
    if destination.rect_free(rect):
        if super.transfer(item, destination):
            destination.move_item_to(item, position)
            return true

    return false


func rect_free(rect: Rect2i, exception: InventoryItem = null) -> bool:
    if rect.position.x + rect.size.x > size.x:
        return false
    if rect.position.y + rect.size.y > size.y:
        return false

    for item in get_items():
        if item == exception:
            continue
        var item_pos := get_item_position(item)
        var item_size := get_item_size(item)
        var rect2 := Rect2i(item_pos, item_size)
        if rect.intersects(rect2):
            return false

    return true


func find_free_place(item: InventoryItem) -> Vector2i:
    var item_size = get_item_size(item)
    for x in range(size.x - (item_size.x - 1)):
        for y in range(size.y - (item_size.y - 1)):
            var rect := Rect2i(Vector2i(x, y), item_size)
            if rect_free(rect, item):
                return Vector2i(x, y)

    return Vector2i(-1, -1)


func _compare_items(item1: InventoryItem, item2: InventoryItem) -> bool:
    var rect1 := Rect2i(get_item_position(item1), get_item_size(item1))
    var rect2 := Rect2i(get_item_position(item2), get_item_size(item2))
    return rect1.get_area() > rect2.get_area()


func sort() -> bool:
    var item_array: Array[InventoryItem]
    for item in get_items():
        item_array.append(item)
    item_array.sort_custom(Callable(self, "_compare_items"))

    for item in item_array:
        _move_item_to_unsafe(item, -get_item_size(item))

    for item in item_array:
        var free_place := find_free_place(item)
        if !Verify.vector_positive(free_place):
            return false
        move_item_to(item, free_place)

    return true


func _sort_if_needed() -> void:
    if !_is_sorted() || _bounds_broken():
        sort()


func reset() -> void:
    super.reset()
    self.size = DEFAULT_SIZE


func serialize() -> Dictionary:
    var result: Dictionary = super.serialize()

    # Store Vector2i as string to make JSON conversion easier later
    result[KEY_SIZE] = var_to_str(size)
    return result


func deserialize(source: Dictionary) -> bool:
    if !Verify.dict(source, true, KEY_SIZE, TYPE_STRING):
        return false

    reset()

    if !super.deserialize(source):
        return false

    var s: Vector2i = str_to_var(source[KEY_SIZE])
    self.size = s

    return true
