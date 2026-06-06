Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7437927AC48
	for <patches@lists.linux.dev>; Sat,  6 Jun 2026 06:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780726312; cv=none; b=R/1icPXOUdXcf09Y/CJOHOh48SGR2uPuK9NLi0fDtEatoqY37/ZTSzviDjcHyMAXnays3kDurv/MryxGDzmSeNY2MZp4P+5jwuB8gqKijBzKULO9bzaYvijrsKxZFa6oLOYMjh2D0D87jZNBf9K8mZ8XisAcs02NLL8EiRFXI+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780726312; c=relaxed/simple;
	bh=x+w9SGxZBWO4hPXg8E+A/q/4ScS0BqeDSCrwJNo6iBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOta53Q6+jwNduAT7ZQaUvjx7HYJwpQDkIOiemDv2l56DYa0TYbS8mBMzTHt1awwtkqDXJfH/QLkK2HqwQZ8tTXUM9pJCDPa0FtkIb6P3/JpuB1tWbc+4fu9N5yqkDj58a7oa6yAsqM75N2+RNujFrqRn02tUDmgpbrG3nmwkNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ByFGC+bg; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ByFGC+bg"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45ef41adbc1so1941245f8f.0
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 23:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780726309; x=1781331109; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+ggg4zFesK0IrYb2saIE8cPaSi4XEf6KWehvtWp5AY=;
        b=ByFGC+bg96A8WIeEHh/sx+G/ennwl/SMYBoRMVHkQmoKT9Pi8nntUA14fKFslEzyy2
         nwTOOlKfU5/pwF5J7GFrmPtt1cncvjcAcacjm2wV7Ww5Zsw8ReMu4nnAZ9Fn65NtAqcX
         fte2rvXKbI/O4gbpBOX1UO60UjyPqq9FXjMJm0tinHe+VV3TW/vy19uEi//gQSEy7QO7
         564uy32rtrtsUUCqTvYr5YuNFXUbMV9HfWEvRyNpelKhvhkMuX6mhN/bgukgvsqP8K9q
         K4WtzLjW/B5XzOaJVQGthA8+MwXPH0jl5lzf3Bq4OtKFouOPuXNdSewo68we10zSWB3n
         ctAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780726309; x=1781331109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0+ggg4zFesK0IrYb2saIE8cPaSi4XEf6KWehvtWp5AY=;
        b=sTHZZjXnd2yiWQkdjVGpKT9n3nDjrjFOI4tAHbCZnS2fFjpKs6lRpuyH/Id/QHlkVQ
         Irllk7d+xm31O9dPr89o2gYoohAa2tICVj4I6PVK0ZiS0YYyNORfdEvozN4L9j1+DbDh
         JTOESFSwImXKziNQUZ6AMAd/mlxjV/mM0wFK1MYi8kkviQoXDIs/9Vrolc7nCGO3Q7OS
         CmNKGUd6jQxD1kOXw6ieQc2Vww6q55vnvF/r9Py5N7pcN32oj7FXJEkWMi2YTt33aRcV
         1AOii2oYewLF8Zr+qGqytSMSu4P+9THpu0IU+PPm32gZtSMK5rwUxnqDOpSnx80Ix314
         14Vg==
X-Forwarded-Encrypted: i=1; AFNElJ9doC3PaPuch3e8a3Y+QA3VzFTpOVQpygjqEd5thhddISWewOu0J3UUS+1rfBCXguBaiHo3EFZL@lists.linux.dev
X-Gm-Message-State: AOJu0YxohO3yCFv7bbiQiq14QhBelhgBegOEI4DSRT/q0CyabXzv8wIG
	GCelaN+S5bDhxk5DEVPJjwYSl0vP8IR1NLI09XokMYvTTZo+5slz5G/9
X-Gm-Gg: Acq92OGtLmkg0mPX9SSFksD84wJsQgrZNjPhMy7XQfFXoxpmrA2QGo9ZezkmqmQ/jhs
	SOqmQlRi3eWrcx9aG9823drQQ+tvAxtnKQEejDPZVi3kNPieMBgGkpVsuTa/L/qxncghBxpNt29
	eT1BFcjdVEdr+RSqeJnbK2XgnvbSwENK06MVSGCKRjFw7+oE846oDIizFBILhXTvxsmfR0OW5SR
	aWw3KtEI7BYvBGH1E24xMZRc7fVVQNjWV/2BZfZbHujnKyUych0WzgMGIq5UKHYsuzoOYsNE6ka
	pe/Ghq2wlbt77o1NpWVkTf8+VREdZmVristDgQzJZlFRQVnNBROvqu/Q9wR1+fJuIj9Lq3yxu/j
	w0FBebAzSsfsvRnOeCCW/f5MzDHlCEdx7zLIBqx4uYOKgxHsVD84h1K9qYh4WDRT8ayMMUjLLhN
	pZ8QDf72eo4eb4E8FTyc5HMRYJVgup6vVsheVy4jaY
X-Received: by 2002:adf:e014:0:20b0:45e:f29d:d438 with SMTP id ffacd0b85a97d-46030618a38mr7876243f8f.28.1780726308885;
        Fri, 05 Jun 2026 23:11:48 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46028a6dce6sm24115947f8f.30.2026.06.05.23.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 23:11:48 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	ltp@lists.linux.it,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andy Lutomirski <luto@amacapital.net>,
	Collin Funk <collin.funk1@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Stefan Metzmacher <metze@samba.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH 2/5] vmsplice: change argument type back to "int"
Date: Sat,  6 Jun 2026 06:10:28 +0000
Message-ID: <20260606061031.3744880-3-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260606061031.3744880-1-safinaskar@gmail.com>
References: <20260606061031.3744880-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

My previous vmsplice patchset changed vmsplice argument from
"int" to "unsigned long". This may cause problems, so let's
change it back.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/read_write.c          | 2 +-
 include/linux/syscalls.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index e224e7cb8..77487b307 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1218,7 +1218,7 @@ SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
 /*
  * Legacy preadv2/pwritev2 wrapper.
  */
-SYSCALL_DEFINE4(vmsplice, unsigned long, fd, const struct iovec __user *, vec,
+SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, vec,
 		unsigned long, vlen, unsigned int, flags)
 {
 	if (unlikely(flags & ~SPLICE_F_ALL))
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a86a88207..46a3ec954 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -514,7 +514,7 @@ asmlinkage long sys_ppoll_time32(struct pollfd __user *, unsigned int,
 			  struct old_timespec32 __user *, const sigset_t __user *,
 			  size_t);
 asmlinkage long sys_signalfd4(int ufd, sigset_t __user *user_mask, size_t sizemask, int flags);
-asmlinkage long sys_vmsplice(unsigned long fd, const struct iovec __user *vec,
+asmlinkage long sys_vmsplice(int fd, const struct iovec __user *vec,
 			     unsigned long vlen, unsigned int flags);
 asmlinkage long sys_splice(int fd_in, loff_t __user *off_in,
 			   int fd_out, loff_t __user *off_out,
-- 
2.47.3

