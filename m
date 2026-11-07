Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064150;
	b=gMAEy4WqlrqNCEW9g1GyW52s3CmOKfM1mn20L2lB41Ob5KqQ8WFYSdnJciScSwssjDwI
	 BLxIkCwn8B72fGsHgqhCDyQXdO0DxQHnZ4zprYeMNTc9JGcRBtiHzaBqSNgXrnxk7sxkP
	 8J1w5iJHOhg621VUfIGJcF2kcC7GXh/bbLeYcwHs1eQpD+7ZddptD4+yBBPJ+W4Xcjcl3
	 9sTjAkRo6HPHF+jRlJVFG2nPDakdOfc+mCqIzYh5tdrnQdJ3FwLzw1erAg84WzlP6Q3+E
	 goRRBoIdBMD4v5V40JnVz42Jy9Akfb9gOiMTzYv86mJzP2rfoa/eoC7Fo5VBX3YDChA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EY5jLeWQtf5MJWAio4kCJtcuR6L4YrJ47WhQZhoZ4Yg=;
	b=Povy53X20ej33zhPHW4oFF8l86hkzGIZ42rVDH1pv68g7zWoG8GpewDQa9pms/6Zdiug
	 OH1wNKjN3HXOCDI0zAcbLLVzOxwx73i7s310VySrfU35MfdhCAo2Sw6WgPgWZvFkZoMjy
	 MM26KVjQa22drT9Grg5juqc0AbnhhOG1XzHGP++Cr5Kf5hBrD9Y+BBRjI7qeed2hbuoR2
	 LjW5r/AeyBf+YkI3rz2iemEpj6UHs2nqvQ8eGMlCXXMp+l1mWMCXD7dzSCsCUlDLsIBZC
	 pfNZHvjA6/EZt6NLpJI7XwVgcYtqTd/3E37jY8i4/RfL/R7cIPWLhVcnGXdRemDo5Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZ+HOQ52;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C452606B8AD;
	Sat,  7 Nov 2026 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZ+HOQ52
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7481F008A5;
	Sat,  7 Nov 2026 15:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064150;
	bh=EY5jLeWQtf5MJWAio4kCJtcuR6L4YrJ47WhQZhoZ4Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZ+HOQ52CIKhhIIlTosgtbyO6ktNF1LlxIuzDc5OgTI413PAHeXck2tqe+Mmv+wdH
	 lyvAzJ1qLOzXgTPwm/wa8ykXGOKNpIkpyFFgpxMXsLg7kYfX6aMiUVSgiI8YuoYdjh
	 8QCDr5oPBYmEP+HaScsashsWUCA+8DiZX3BJzmL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0248/1257] nilfs2: fix checkpoint root lifetime on sysfs errors
Date: Sat,  7 Nov 2026 08:42:24 -0500
Message-ID: <20261107134946.358935530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit 2cb947450e0e5a88bb6bb5fca6dbfda1910e74b0 ]

nilfs_find_or_create_root() links a new checkpoint root into the
checkpoint tree and drops ns_cptree_lock before creating the root's
sysfs group.  If nilfs_sysfs_create_snapshot_group() then fails, the
root is freed while it is still reachable from ns_cptree, so a
concurrent nilfs_lookup_root() can dereference freed memory.

nilfs_sysfs_create_snapshot_group() allocates memory and creates sysfs
nodes and may sleep, so it cannot run under the ns_cptree_lock spinlock.
Reorder the creation path so that the sysfs group is set up before the
root is published: initialize the root, create its sysfs group outside
the lock, and only then take ns_cptree_lock to link it into the tree.
On sysfs failure the root was never visible and is freed directly; in
the unlikely case a root with the same checkpoint number is already
present, the sysfs group of the new root is removed before it is freed.
Concurrent insertions are already serialized by ns_snapshot_mount_mutex,
so only the race against nilfs_lookup_root() needs to be closed.

Because kobject_put() does not guarantee that the embedded kobject's
release callback has run by the time it returns
(CONFIG_DEBUG_KOBJECT_RELEASE defers it), the container must not be
freed until the release completes.  Keep that wait_for_completion() of
snapshot_kobj_unregister inside the sysfs helpers, so both the creation
error path and nilfs_sysfs_delete_snapshot_group() wait for the release
before their callers free the root.

Fixes: dd70edbde262 ("nilfs2: integrate sysfs support into driver")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c     |  5 ++++-
 fs/nilfs2/the_nilfs.c | 34 +++++++++++++++++++++-------------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index bc52afbfc5c73..5bb74a45ad1ed 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -195,8 +195,10 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 					    "%llu", root->cno);
 	}
 
-	if (err)
+	if (err) {
 		kobject_put(&root->snapshot_kobj);
+		wait_for_completion(&root->snapshot_kobj_unregister);
+	}
 
 	return err;
 }
@@ -204,6 +206,7 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
 {
 	kobject_put(&root->snapshot_kobj);
+	wait_for_completion(&root->snapshot_kobj_unregister);
 }
 
 /************************************************************************
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index f3805e7aabeb5..38c6d4afefba9 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -887,6 +887,26 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 	if (!new)
 		return NULL;
 
+	new->cno = cno;
+	new->ifile = NULL;
+	new->nilfs = nilfs;
+	refcount_set(&new->count, 1);
+	atomic64_set(&new->inodes_count, 0);
+	atomic64_set(&new->blocks_count, 0);
+
+	/*
+	 * Register the sysfs group before publishing the root in the
+	 * checkpoint tree.  nilfs_sysfs_create_snapshot_group() can sleep,
+	 * so it must run outside ns_cptree_lock; creating it first also
+	 * ensures a concurrent nilfs_lookup_root() can never observe a root
+	 * whose sysfs registration later fails and gets freed.
+	 */
+	err = nilfs_sysfs_create_snapshot_group(new);
+	if (err) {
+		kfree(new);
+		return NULL;
+	}
+
 	spin_lock(&nilfs->ns_cptree_lock);
 
 	p = &nilfs->ns_cptree.rb_node;
@@ -903,29 +923,17 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 		} else {
 			refcount_inc(&root->count);
 			spin_unlock(&nilfs->ns_cptree_lock);
+			nilfs_sysfs_delete_snapshot_group(new);
 			kfree(new);
 			return root;
 		}
 	}
 
-	new->cno = cno;
-	new->ifile = NULL;
-	new->nilfs = nilfs;
-	refcount_set(&new->count, 1);
-	atomic64_set(&new->inodes_count, 0);
-	atomic64_set(&new->blocks_count, 0);
-
 	rb_link_node(&new->rb_node, parent, p);
 	rb_insert_color(&new->rb_node, &nilfs->ns_cptree);
 
 	spin_unlock(&nilfs->ns_cptree_lock);
 
-	err = nilfs_sysfs_create_snapshot_group(new);
-	if (err) {
-		kfree(new);
-		new = NULL;
-	}
-
 	return new;
 }
 
-- 
2.53.0



