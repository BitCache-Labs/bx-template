import "core" for Time
import "device" for Input, Key, MouseButton
import "math" for Math, Vec3, Quat, Mat4
import "physics" for Physics, CollisionFlags
import "graphics" for Graphics
import "framework" for GameObject, Transform, Camera, AudioListener, MeshFilter, MeshRenderer, Animator, CharacterController, Attributes

class PlayerCamera is GameObject {
    construct new(data) {
        super(data)

        _trx = addComponent(Transform)
        _cam = addComponent(Camera)
    }

    // Components
    transform { _trx }
    camera { _cam }

    // Variables
    target { _target }
    target=(x) { _target = x }

    distance { _distance }
    distance=(v) { _distance = v }

    offset { _offset }
    offset=(v) { _offset = v }

    angles { _angles }
    angles=(v) { _angles = v }

    start() {
        _mx = Input.getMouseX()
        _my = Input.getMouseY()

        distance = 5
        offset = Vec3.new(0, 2, 0)
        angles = Vec3.new(0, 0, 0)

        if (target) {
            _targetPos = target.transform.position.copy
        }
    }

    update() {
        if (target) {
            var dx = _mx - Input.getMouseX()
            var dy = _my - Input.getMouseY()
            _mx = Input.getMouseX()
            _my = Input.getMouseY()

            angles = angles + Vec3.new(-dy * 0.1, dx * 0.1, 0)
            if (angles.x < -89) angles.x = -89
            if (angles.x > 89) angles.x = 89
            transform.rotation = Quat.euler(angles.x, angles.y, angles.z)

            var ypos = _targetPos.y
            _targetPos = target.transform.position.copy
            _targetPos.y = Math.lerp(ypos, _targetPos.y, 0.1)

            var targetPos = _targetPos + offset
            var fwd = transform.rotation * Vec3.new(0, 0, 1)
            var hit = Physics.rayCast(targetPos, -fwd, distance, CollisionFlags.default, CollisionFlags.all ^ CollisionFlags.character)
            if (hit.hasHit) {
                transform.position = hit.point + fwd * 0.5
            } else {
                transform.position = targetPos + transform.rotation * Vec3.back * distance
            }
        }
    }
}

class PlayerCharacter is GameObject {
    construct new(data) {
        super(data)

        _trx = addComponent(Transform)
        _mf = addComponent(MeshFilter)
        _mr = addComponent(MeshRenderer)
        _anim = addComponent(Animator)
        _cc = addComponent(CharacterController)
        _att = addComponent(Attributes)
    }

    // Components
    transform { _trx }
    meshFilter { _mf }
    meshRenderer { _mr }
    animator { _anim }
    controller { _cc }
    attributes { _att }

    // Variables
    camera { _cam }
    camera=(v) { _cam = v }

    move { _m }
    move=(v) { _m = v }

    moveSpeed { _ms }
    moveSpeed=(v) { _ms = v }

    start() {
        camera = GameObject.create(PlayerCamera)
        camera.target = this

        move = Vec3.new(0, 0, 0)
        moveSpeed = 10
    }

    update() {
        move = Vec3.new(0, 0, 0)
        //move.z = Input.getKey(Key.w) ? 1 : Input.getKey(Key.s) ? -1 : 0;
        if (Input.getKey(Key.w)) {
            move.z = move.z + 1
        } else if (Input.getKey(Key.s)) {
            move.z = move.z - 1
        }
        if (Input.getKey(Key.a)) {
            move.x = move.x + 1
        } else if (Input.getKey(Key.d)) {
            move.x = move.x - 1
        }

        transform.rotation = Quat.euler(0, camera.angles.y, 0)

        if (move.sqrMagnitude > 0) {
            move = (transform.rotation * move).normalized
        }

        controller.moveVector = move * moveSpeed * Time.deltaTime
    }
}

GameObject.register(PlayerCamera)
GameObject.register(PlayerCharacter)