#this is the database portion of a memegenerator knockoff I wrote in python, using sqlalchemy, cherrypy and genshi.
#i suppose if you aren't familiar with those it might not make the most sense, but if you understand python it should be fairly easy to figure out. lol @ self-documenting code.

import sys, os
from sqlalchemy import Column, String, Text, Integer, BigInteger, SmallInteger, DateTime, ForeignKey, Index, UniqueConstraint, create_engine
from sqlalchemy.orm import relationship, sessionmaker
from sqlalchemy.ext.declarative import declarative_base
import config

Table = declarative_base()

class User(Table):
        __tablename__ = 'users'
        id = Column(BigInteger, primary_key = True)
        name = Column(String(255), nullable = False)
        fb_user_id = Column(String(255))

class Image(Table):
        __tablename__ = 'images'
        id = Column(BigInteger, primary_key = True)
        uploaded_by_id = Column(BigInteger, ForeignKey(User.id), nullable = False)
        uploaded_by = relationship(User)
        uploaded_date = Column(DateTime, nullable = False)
        title = Column(String(255), nullable = False)
        file_name = Column(String(255), nullable = False)

class CaptionedImage(Table):
        __tablename__ = 'captioned_images'
        id = Column(BigInteger, primary_key = True)
        created_by_id = Column(BigInteger, ForeignKey(User.id), nullable = False, index = True)
        created_by = relationship(User)
        created_date = Column(DateTime, nullable = False)
        image_id = Column(BigInteger, ForeignKey(Image.id), nullable = False, index = True)
        image = relationship(Image)
        title = Column(String(255))
        text_top = Column(String(255))
        text_bottom = Column(String(255))
        file_name = Column(String(255), nullable = False)
        score = Column(BigInteger, nullable = False)

        def url(self):
                return config.image_url + '/' + self.file_name

class CaptionVote(Table):
        __tablename__ = 'caption_votes'
        id = Column(BigInteger, primary_key = True)
        user_id = Column(BigInteger, ForeignKey(User.id), nullable = False)
        user = relationship(User)
        captioned_image_id = Column(BigInteger, ForeignKey(CaptionedImage.id), nullable = False)
        captioned_image = relationship(CaptionedImage)
        score = Column(SmallInteger, nullable = False)

        __table_args__ = (Index('ix_user', user_id, captioned_image_id), UniqueConstraint(user_id, captioned_image_id))

class Comment(Table):
        __tablename__ = 'comments'
        id = Column(BigInteger, primary_key = True)
        user_id = Column(BigInteger, ForeignKey(User.id), nullable = False)
        user = relationship(User)
        date = Column(DateTime, nullable = False)
        caption_id = Column(BigInteger, ForeignKey(CaptionedImage.id), nullable = False, index = True)
        captioned_image = relationship(CaptionedImage)
        parent_comment_id = Column(BigInteger, ForeignKey('comments.id'), index = True)
        replies = relationship('Comment')
        text = Column(Text, nullable = False)
        score = Column(BigInteger, nullable = False)

class CommentVote(Table):
        __tablename__ = 'comment_votes'
        id = Column(BigInteger, primary_key = True)
        user_id = Column(BigInteger, ForeignKey(User.id), nullable = False)
        user = relationship(User)
        comment_id = Column(BigInteger, ForeignKey(Comment.id), nullable = False)
        comment = relationship(Comment)
        score = Column(SmallInteger, nullable = False)

        __table_args__ = (Index('ix_user', user_id, comment_id), UniqueConstraint(user_id, comment_id))

_engine = create_engine('mysql://%s:%s@%s/%s' % (config.db_user, config.db_password, config.db_host, config.db_name))
_session_maker = sessionmaker(bind = _engine)

class Session:
        def __init__(self):
                self.session = _session_maker()

        def __getattr__(self, k):
                return getattr(self.session, k)

        def __enter__(self, *args):
                return self

        def __exit__(self, *args):
                self.session.close()

Table.metadata.create_all(_engine)

