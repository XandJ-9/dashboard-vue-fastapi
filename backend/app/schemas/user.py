from typing import Optional
from datetime import datetime
from pydantic import BaseModel, EmailStr, Field
import uuid


# 共享属性
class UserBase(BaseModel):
    email: Optional[EmailStr] = None
    username: Optional[str] = None
    full_name: Optional[str] = None
    is_active: Optional[bool] = True
    role: Optional[str] = "user"
    status: Optional[str] = "active"


# 创建用户时需要的属性
class UserCreate(UserBase):
    email: EmailStr
    username: str
    password: str
    full_name: Optional[str] = None


# 更新用户时可以更新的属性
class UserUpdate(UserBase):
    password: Optional[str] = None


# 数据库中存储的用户属性
class UserInDBBase(UserBase):
    id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# 返回给API的用户信息
class User(UserInDBBase):
    pass


# 存储在数据库中的用户信息，包含密码
class UserInDB(UserInDBBase):
    hashed_password: str


# 用户登录请求
class UserLogin(BaseModel):
    username: str
    password: str


# 令牌响应
class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: User


# 令牌载荷
class TokenPayload(BaseModel):
    sub: Optional[str] = None