import logging
from sqlalchemy.orm import Session

from app import crud, schemas
from app.core.config import settings
from app.db import base  # noqa: F401

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def init_db(db: Session) -> None:
    # Create initial admin user
    user = crud.user.get_by_email(db, email=settings.FIRST_ADMIN_EMAIL)
    if not user:
        user_in = schemas.UserCreate(
            email=settings.FIRST_ADMIN_EMAIL,
            username=settings.FIRST_ADMIN_USERNAME,
            password=settings.FIRST_ADMIN_PASSWORD,
            full_name="Admin",
            role="admin",
            status="active",
            is_active=True,
        )
        user = crud.user.create(db, obj_in=user_in)
        logger.info(f"Admin user created with email: {settings.FIRST_ADMIN_EMAIL}")
    else:
        logger.info(f"Admin user already exists with email: {settings.FIRST_ADMIN_EMAIL}")