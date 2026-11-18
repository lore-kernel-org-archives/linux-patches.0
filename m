Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044186;
	b=QpwmPAkSKu5/ojBgjHzhXbaY9F3bDPbfsQrcgSxeKWSfyr8EF9d7fb9M6aLdXlqbDBs9
	 23VBI6oyVVGatVWMxaKPRKiVtzFpzE12oFFRR9bmVBeM1IiEiuHmgJnwHnHu0peMY1SU5
	 533fstGVzoqjYSICfC1BUok/lcc+NCjRlz6OsvZD0XjiOO33JRUSG/7ctub5fzVAoqORL
	 3xVrV6nwzBEyeaJreI7Ufc/MqEYFJdu4nYv5cEk5+I6qeT/ZYle8bDnf5LuJjredTW1UY
	 A3B8E2mAdsS3ffS+RjfKnAnn0jW+5DSzVZQBt7PyP2i4UrA9udxvmO1E5VNvFUKsvgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A16ulvCepaILxTtCzWL1mgmhUzqWxFqq3aL28V4MGSY=;
	b=xRduWi8eIMvs9rSwqmG2cZvhWQVsq5NKq8GpA0uPX0OAfgF/nm5bF6KmJpi+VSMKsLAa
	 /GLBSLEi/kw9FzZXa9S4CBo17UX7D9//lWdD1s8zGYmPstPCJwCzM75BJSLdu8Oj+Dy7f
	 kyww/gE8VXzAIZKK/UjtjQ0R8LdEhWA2D3HM1A86mIAbXwT4khfSyLUEE7uOtovQn+4L1
	 BjSUKm8WrpLVGFwpLD1+3I2rwi/icUoCJw9Mrgr/1CMUWR9D60DMB823BFhUIRRjbLe5Z
	 VFKDGmb11dGWAabIvl8ob6OAxwNmaVREgSRmDPFks/S6brct5QJDCbcuuisNo3xjtbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JAYoERW6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1634606A32F;
	Wed, 18 Nov 2026 23:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JAYoERW6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD53D1F000C4;
	Wed, 18 Nov 2026 23:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044186;
	bh=A16ulvCepaILxTtCzWL1mgmhUzqWxFqq3aL28V4MGSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAYoERW6n37sGOlVBQMFhwPNoW72u+4N4jqkEyYLoVWKNIOIa/IlXbOh4AhjUNO8i
	 9vHWdgTbPJXWG98J6oxXXwpsSKv+T/WMrT6RwmqUFoyerErAakyMUiEvkQlW9p05LB
	 FhVgx5yC8suLokfkz/z1QBdqJmP912BGvYHhTlzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0479/2857] namespace: check a recursive bind mount for mount namespace loops
Date: Wed, 18 Nov 2026 15:25:13 +0100
Message-ID: <20261118150218.685958249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit c640a01a78e42302879006ed7b7d5a9a943ba815 ]

do_loopback() refuses to bind mount the file of a mount namespace that
is as old as the caller's or older because a mount namespace that holds
a mount of its own file, or of an ancestor's, would cause a cycle. But
it only checks the dentry the bind mount starts from. With MS_REC
everything below it is copied and do_loopback() passes
CL_COPY_MNT_NS_FILE so mount namespace files below the source are
copied.

That's fine for a source in the caller's own mount namespace. Every
mount namespace file in there passed the same check when it was
bind-mounted. It isn't fine for a source in another mount namespace.
may_copy_tree() accepts a bind mount of any nsfs or pidfs file no matter
what mount namespace it lives in so that /proc/<pid>/ns/<ns> and pidfds
can be bind mounted. If we create a bind-mount stack of mount namespaces
file descriptors the kernel will copy them irrespective of their
ancestoral relationship to the mount namespace in question:

  151 146 0:7 net:[4026531833] /tmp/nrc/y rw - nsfs nsfs rw
  152 151 0:7 mnt:[4026532293] /tmp/nrc/y rw - nsfs nsfs rw

Mount 152 is a mount of the mount namespace file of mount namespace
4026532293 inside mount namespace 4026532293. That namespace and every
mount in it are leaked... All it takes is a process in an older mount
namespace that stacks the file and repeating it leaks without limit:

  after control: Shmem:               380 kB
  child: mount(/proc/self/fd/6, MS_BIND|MS_REC): ok
  after cycle: Shmem:             65916 kB

do_move_mount() runs check_for_nsfs_mounts() over a detached tree for
exactly that reason. Do the same for the copy before it is grafted.

Fixes: e149ed2b805f ("take the targets of /proc/*/ns/* symlinks to separate fs")
Fixes: ef4144ac2dec ("pidfs: allow bind-mounts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260930-work-mount-fixes-3-v1-4-be34c83956ae@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Adapted the graft_tree() call to the older three-argument signature and moved check_for_nsfs_mounts() above do_loopback() so it compiles. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 50 +++++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c07e9e857f999..f534ebc90c9cf 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2468,6 +2468,28 @@ static struct mount *__do_loopback(struct path *old_path, int recurse)
 	return mnt;
 }
 
+/*
+ * Check that there aren't references to earlier/same mount namespaces in the
+ * specified subtree.  Such references can act as pins for mount namespaces
+ * that aren't checked by the mount-cycle checking code, thereby allowing
+ * cycles to be made.
+ */
+static bool check_for_nsfs_mounts(struct mount *subtree)
+{
+	struct mount *p;
+	bool ret = false;
+
+	lock_mount_hash();
+	for (p = subtree; p; p = next_mnt(p, subtree))
+		if (mnt_ns_loop(p->mnt.mnt_root))
+			goto out;
+
+	ret = true;
+out:
+	unlock_mount_hash();
+	return ret;
+}
+
 /*
  * do loopback mount.
  */
@@ -2504,7 +2526,11 @@ static int do_loopback(struct path *path, const char *old_name,
 		goto out2;
 	}
 
-	err = graft_tree(mnt, parent, mp);
+	/* the copy may carry mount namespace files from below the source */
+	if (recurse && !check_for_nsfs_mounts(mnt))
+		err = -EINVAL;
+	else
+		err = graft_tree(mnt, parent, mp);
 	if (err) {
 		lock_mount_hash();
 		umount_tree(mnt, UMOUNT_SYNC);
@@ -2790,28 +2816,6 @@ static inline int tree_contains_unbindable(struct mount *mnt)
 	return 0;
 }
 
-/*
- * Check that there aren't references to earlier/same mount namespaces in the
- * specified subtree.  Such references can act as pins for mount namespaces
- * that aren't checked by the mount-cycle checking code, thereby allowing
- * cycles to be made.
- */
-static bool check_for_nsfs_mounts(struct mount *subtree)
-{
-	struct mount *p;
-	bool ret = false;
-
-	lock_mount_hash();
-	for (p = subtree; p; p = next_mnt(p, subtree))
-		if (mnt_ns_loop(p->mnt.mnt_root))
-			goto out;
-
-	ret = true;
-out:
-	unlock_mount_hash();
-	return ret;
-}
-
 static int do_set_group(struct path *from_path, struct path *to_path)
 {
 	struct mount *from, *to;
-- 
2.53.0



