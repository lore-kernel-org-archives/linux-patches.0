Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E192815E5D6;
	Tue, 18 Jun 2024 12:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714870; cv=none; b=Ki3wNS/QCg4T4X7RXfk1J2Ss6Nb8Q+azLoTyUk0ih5H+L4Tq5wGQuAGNzlmYCF6iwwDRoMYZ8l68wIprfhT7w4ma5YqQxVpeKcTPUcYnIR0bXOR48JE6n1FiQz4LdVd/ykkNr6GsF+W6F4tLiV4ZojyuekHBjMWT55wUvmjn8RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714870; c=relaxed/simple;
	bh=CGgkyt2G6p1LA5PFV6mNjdTQovczFbVFVG6irR11Lss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWjoBSI35gn+hRFtX15Zi4X4843cdUFJBry6n1ynmbCY9PQIoDTmWlyZCg5B2cX4Xj9phMt7zLfM6rr7PdVOGvbFEdIrHeQFMlbAyfZn3r4a1MZ9we2tnrdf4V8BI75JjNXl4Q/NlBYzO1q1J7OoMXMOXfJ9IfQA175eM2hzkJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILWA/Jzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILWA/Jzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F25C32786;
	Tue, 18 Jun 2024 12:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714869;
	bh=CGgkyt2G6p1LA5PFV6mNjdTQovczFbVFVG6irR11Lss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILWA/JzmZ9YMPYA77VuJgRCStmJszEkQTUdExOSZlj00nOqS0yrXVoRCwhZ2v4O6s
	 2/aAOoyLUq7K2YD7tTcIKFjd7KCRrKhHYRIF+D8K96ujrY80tioVqrfiNSM1Nzl8Rn
	 6mb5wim2yonomH4/V+hcbpUN85tE01zONIsARvxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/770] file: Rename fcheck lookup_fd_rcu
Date: Tue, 18 Jun 2024 14:29:30 +0200
Message-ID: <20240618123411.786608479@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 460b4f812a9d473d4b39d87d37844f9fc30a9eb3 ]

Also remove the confusing comment about checking if a fd exists.  I
could not find one instance in the entire kernel that still matches
the description or the reason for the name fcheck.

The need for better names became apparent in the last round of
discussion of this set of changes[1].

[1] https://lkml.kernel.org/r/CAHk-=wj8BQbgJFLa+J0e=iT-1qpmCRTbPAJ8gd6MJQ=kbRPqyQ@mail.gmail.com
Link: https://lkml.kernel.org/r/20201120231441.29911-10-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/files.rst          | 6 +++---
 arch/powerpc/platforms/cell/spufs/coredump.c | 2 +-
 fs/notify/dnotify/dnotify.c                  | 2 +-
 include/linux/fdtable.h                      | 8 ++++----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/files.rst b/Documentation/filesystems/files.rst
index ea75acdb632c0..bcf84459917f5 100644
--- a/Documentation/filesystems/files.rst
+++ b/Documentation/filesystems/files.rst
@@ -62,7 +62,7 @@ the fdtable structure -
    be held.
 
 4. To look up the file structure given an fd, a reader
-   must use either fcheck() or files_lookup_fd_rcu() APIs. These
+   must use either lookup_fd_rcu() or files_lookup_fd_rcu() APIs. These
    take care of barrier requirements due to lock-free lookup.
 
    An example::
@@ -70,7 +70,7 @@ the fdtable structure -
 	struct file *file;
 
 	rcu_read_lock();
-	file = fcheck(fd);
+	file = lookup_fd_rcu(fd);
 	if (file) {
 		...
 	}
@@ -104,7 +104,7 @@ the fdtable structure -
    lock-free, they must be installed using rcu_assign_pointer()
    API. If they are looked up lock-free, rcu_dereference()
    must be used. However it is advisable to use files_fdtable()
-   and fcheck()/files_lookup_fd_rcu() which take care of these issues.
+   and lookup_fd_rcu()/files_lookup_fd_rcu() which take care of these issues.
 
 7. While updating, the fdtable pointer must be looked up while
    holding files->file_lock. If ->file_lock is dropped, then
diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index 026c181a98c5d..60b5583e9eafc 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -74,7 +74,7 @@ static struct spu_context *coredump_next_context(int *fd)
 	*fd = n - 1;
 
 	rcu_read_lock();
-	file = fcheck(*fd);
+	file = lookup_fd_rcu(*fd);
 	ctx = SPUFS_I(file_inode(file))->i_ctx;
 	get_spu_context(ctx);
 	rcu_read_unlock();
diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index e45ca6ecba959..e85e13c50d6d4 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -327,7 +327,7 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	}
 
 	rcu_read_lock();
-	f = fcheck(fd);
+	f = lookup_fd_rcu(fd);
 	rcu_read_unlock();
 
 	/* if (f != filp) means that we lost a race and another task/thread
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index a45fa2ef723f5..695306cc5337a 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -105,10 +105,10 @@ static inline struct file *files_lookup_fd_rcu(struct files_struct *files, unsig
 	return files_lookup_fd_raw(files, fd);
 }
 
-/*
- * Check whether the specified fd has an open file.
- */
-#define fcheck(fd)	files_lookup_fd_rcu(current->files, fd)
+static inline struct file *lookup_fd_rcu(unsigned int fd)
+{
+	return files_lookup_fd_rcu(current->files, fd);
+}
 
 struct task_struct;
 
-- 
2.43.0



