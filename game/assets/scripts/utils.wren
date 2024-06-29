import "framework" for GameObject, Transform, MeshFilter, MeshRenderer, Collider, RigidBody, Light

class StaticModel is GameObject {
    construct new(data) {
        super(data)

        _trx = addComponent(Transform)
        _mf = addComponent(MeshFilter)
        _mr = addComponent(MeshRenderer)
        _coll = addComponent(Collider)
    }

    // Components
    transform { _trx }
    meshFilter { _mf }
    meshRenderer { _mr }
    collider { _coll }

    start() {}
    update() {}
}

GameObject.register(StaticModel)