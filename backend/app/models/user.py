from sqlalchemy import Boolean, Column, String, DateTime, Enum
from sqlalchemy.sql import func

from app.db.session import Base
import uuid

class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, index=True, default=lambda: str(uuid.uuid4()))
    email = Column(String, unique=True, index=True, nullable=False)
    username = Column(String, unique=True, index=True, nullable=False)
    full_name = Column(String, index=True)
    hashed_password = Column(String, nullable=False)
    role = Column(Enum("admin", "user", "editor", name="user_role"), default="user")
    status = Column(Enum("active", "pending", "banned", name="user_status"), default="active")
    is_active = Column(Boolean(), default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())