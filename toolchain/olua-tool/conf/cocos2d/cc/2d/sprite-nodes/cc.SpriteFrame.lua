local cls = class()
cls.CPPCLS = "cocos2d::SpriteFrame"
cls.LUACLS = "cc.SpriteFrame"
cls.SUPERCLS = "cc.Ref"
cls.func("new", new_ccobj(cls))
cls.prop('rotated', 'bool isRotated()', 'void setRotated(bool rotated)')
cls.prop('texture', 'Texture2D* getTexture()', 'void setTexture(Texture2D* pobTexture)')
cls.funcs([[
    static SpriteFrame* create(const std::string& filename, const Rect& rect)
    static SpriteFrame* create(const std::string& filename, const Rect& rect, bool rotated, const Vec2& offset, const Size& originalSize)
    static SpriteFrame* createWithTexture(Texture2D* pobTexture, const Rect& rect)
    static SpriteFrame* createWithTexture(Texture2D* pobTexture, const Rect& rect, bool rotated, const Vec2& offset, const Size& originalSize)
    const Rect& getRectInPixels()
    void setRectInPixels(const Rect& rectInPixels)
    bool isRotated()
    void setRotated(bool rotated)
    const Rect& getRect()
    void setRect(const Rect& rect)
    const Rect& getCenterRect()
    void setCenterRectInPixels(const Rect& centerRect)
    bool hasCenterRect()
    @unpack const Vec2& getOffsetInPixels()
    void setOffsetInPixels(@pack const Vec2& offsetInPixels)
    @unpack const Size& getOriginalSizeInPixels()
    void setOriginalSizeInPixels(@pack const Size& sizeInPixels)
    @unpack const Size& getOriginalSize()
    void setOriginalSize(@pack const Size& sizeInPixels)
    Texture2D* getTexture()
    void setTexture(Texture2D* pobTexture)
    @unpack const Vec2& getOffset()
    void setOffset(@pack const Vec2& offsets)
    @unpack const Vec2& getAnchorPoint()
    void setAnchorPoint(@pack const Vec2& anchorPoint)
    bool hasAnchorPoint()
    SpriteFrame *clone()
    // void setPolygonInfo(const PolygonInfo &polygonInfo)
    // const PolygonInfo& getPolygonInfo()
    bool hasPolygonInfo()
    bool initWithTexture(Texture2D* pobTexture, const Rect& rect)
    bool initWithTextureFilename(const std::string& filename, const Rect& rect)
    bool initWithTexture(Texture2D* pobTexture, const Rect& rect, bool rotated, const Vec2& offset, const Size& originalSize)
    bool initWithTextureFilename(const std::string& filename, const Rect& rect, bool rotated, const Vec2& offset, const Size& originalSize)
]])

return cls