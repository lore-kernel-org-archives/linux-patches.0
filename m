Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036017;
	b=zz0jhxN5BNbO9FdtrI3FCH+NrBZN95GcPZsKGyX7th2OAxIkh+NH7ezziDv0CWYM75tB
	 IRwyB8qPCWe6s/ijFfzNC+ORwicoySy0ZUZE/hwc/XMdAkzpPqCfWV9WJfKTIAtaRyjln
	 dFXN8EVFAfz27OsJT7/8Vk4MBWLkgc/SHOilniIet+ZjLfNKlOOojp8ueZ7wRp6gxm1Ym
	 xqkkQMP5ObnTvytXU+1outop+CtRoZn9/wauMWyi6LracCvnaNr7IL4voISb5j+MKQu0k
	 ksaKEEVj+tjWnCYy1dTP9cx2JC4f5dX//rkWyAaCx7KLA3Kmk73fl2IYkqme8aSFEEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hksa0LrEo/MaPyFeIr126ns2ilVGQJlKbdwdAcWmjM8=;
	b=1pV08rENd+pcBEeFp9eN4AKPwZNwVOINZ1b0kFgM7rC8vSb53v5PlRSr+UxcGh713umF
	 T8MMF98j9zu1uEMfoTMeMOMGrCFPmI5oWZfcKoc8NKXloXJBO05GosaxqN9La+8Y07W8V
	 iNZbRQQzq9aUtsAsHJIl0VnoN0RXRrkW0Ja+coZ0Y/8kpiaoGqsA+ecJ0OhcnqHktVdvn
	 kx0DA+COeR6mqucxPIcCu4QkT0yyXj3A/cUW6/AhMrvGDhZFpv2sbKO+PdAjxr6xr4qwV
	 XAVNQTMbDSnSugtbVAcfj0JicR4yI4rprEN2+POqxA30TI0brsMVYa/bTyuwoMcGn6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XehT5s7g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D729606A31C;
	Wed, 18 Nov 2026 21:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XehT5s7g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33211F000C4;
	Wed, 18 Nov 2026 21:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036017;
	bh=Hksa0LrEo/MaPyFeIr126ns2ilVGQJlKbdwdAcWmjM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XehT5s7gmDKUnKzvVErlgxxP24q0d56pRVuNc4lZdeB03Xt0AJAMNNPdRD/cHlsSR
	 8OXu/6MByeacYQHCNaNf9XrCufsQNuV+OmPRfpdFoYc9usfwu/VhrHW3IG4H8/0L9q
	 GzBLNQTOq22bHEfIQF4H6M1HNHOaeVvy1hQZ6Yf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0908/3318] nilfs2: fix checkpoint root lifetime on sysfs errors
Date: Wed, 18 Nov 2026 15:25:30 +0100
Message-ID: <20261118150346.746458193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 59fda8ce0790b..e0f860aef81ff 100644
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
index d1891dd4a5109..f9b10b4e22c01 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -865,6 +865,26 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
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
@@ -881,29 +901,17 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
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



