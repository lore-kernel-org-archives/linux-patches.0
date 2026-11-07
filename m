Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061425;
	b=eky/1dCQCHdNZaUh513wB9ZxrIOV5p8NuTUdsU6OGl1Xn7tHAc62+kU0nvgn0k/DyqYI
	 fb7h7ColBOBdFkIQkvcLLJXCqDASK3RfMrukoX0qn8ESJmmLOw0TIb/lQvqha5Yayy4jc
	 gNNriRyqbGXoLhg3UIhoUUJAolYpA94MslREtooYKLp/sRedScBJozpmVFrtB2LDObVjM
	 ZdQQZ7KUnkNzzk6FUl/g+n32/C1P+lMhmQksMB6M9wbeLHVaq1yGENMIeRIHtzTQUHFAD
	 tmOEW51dF0vmxb4U00PoAhzVu79ZZLaaaU/HRFIfcRN9BcPl/F1TlhCtEOXdDbbaR/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3+E1ZbkbDRDkrfQKVPYKfQFvTd/UHB9JNB7ikwjFDno=;
	b=ueeRnc00XknOs2Ix3oT48/hBbA0WN+fFQ9WdzjmEJsbLULqpxf0IdxjVmDchJ+EZwnyY
	 zsc3QUuEmWB3tam8ppz0v83qVQC2bPvyMwxsvuqDk/OFLP2OBKEzjGFmdLzAhWYrn5W4r
	 wx6bzOjyXStIV6En/1fcQGIfysE0vnVboRFCDMgtYaTVmx5KVs0LeStr6rlwx+cz/4cwo
	 /YiUA9x8K9MfWLGf48BPGduhDLIlxzaFGk5AYIrAM6lw5z1J9+L46d4jEHKjEs2woIaNu
	 0iJs/MlGQxfWuyVKP5nt2sbtQDVjfmcqDW5FIeamQsM9irfF5AMv8cy3WmXK2SdhCFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZK+9q35Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F20606A326;
	Sat,  7 Nov 2026 14:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZK+9q35Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA60F1F0089F;
	Sat,  7 Nov 2026 14:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061425;
	bh=3+E1ZbkbDRDkrfQKVPYKfQFvTd/UHB9JNB7ikwjFDno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZK+9q35ZcPLPzay2gp1uj9ck7y90oS2ht9ZUYoQMAnNq0O0caePI8eFt8kPzxlEzY
	 vd3ms1IWfFTNz7u7eUxfR3yPpSIg1x3XjO7v0skkW8igm65NlYcr5zrnVUYPurfWsf
	 7gxu2oZL3DDb+TGzrT5KlBee2adykACtqDRGT4cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0534/1536] fs: dont silently unmount busy mounts
Date: Sat,  7 Nov 2026 08:42:30 -0500
Message-ID: <20261107135012.606200364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 6857e209015f95be7a8f19a9cd5dac345b9b9859 ]

The propagate_mount_busy() helper exists to decide whether a synchronous
can suceed. It does that by looking at the copies of the victims in the
mounts its parent propagates to. One of those functions from propagation
hell.

It skips a copy that has child mounts except for the case of a single
child mount covering the copy's root. That algorithm used to be exact.
It isn't anymore.

Originally only childless copies were unmounted during propagation.
And 1064f874abc0 ("mnt: Tuck mounts under others instead of creating
shadow/side mounts.") ended up adding covered mounts to both sides in
one go.

Along came 99b19d16471e ("mnt: In propgate_umount handle visiting mounts
in any order") and that started to unmount more than before:

[1]: A copy of a mount is unmounted when each of its children is either
     its overmount or a copy of the victim itself. In the former case
     the overmount gets reparented. In the latter case the copy of the
     victim will end up being unmounted.

So propagate_umount() ended up being rewritten without adjusting
propagate_mount_busy(). And currently propagate_mount_busy() doesn't
look at copies of the victim that have two or more children nor a single
child that is not the overmount.

So any such copy in [1] is not checked for
references. The result is that a synchronous unmount succeeds, pulling
out a mount that is still in use.

A container can run into this with its own mounts. The host shares a
tree with the container and the host has a mount in that tree:

  mount -t tmpfs none /mnt
  mount --make-shared /mnt
  mount -t tmpfs none /mnt/a

The container's /mnt is a slave copy of the host mount. The container
now takes a detached copy of the tree and mounts that copy beneath its
propagated copy of /mnt/a and keeps the file descriptor to the tree
open:

  unshare -m --propagation unchanged
  mount --make-rslave /
  fd = open_tree(AT_FDCWD, "/mnt", OPEN_TREE_CLONE | AT_RECURSIVE)
  move_mount(fd, "", AT_FDCWD, "/mnt/a", MOVE_MOUNT_BENEATH)

  grep /mnt /proc/self/mountinfo
  775 355 ... /mnt ...     master:646
  777 775 ... /mnt/a ...   master:646
  776 777 ... /mnt/a ...   master:647
  778 777 ... /mnt/a/a ... master:647

The now attached tree (777) is now mounted beneath the container's copy
of /mnt/a. That's also where the host mount sits (as seen from the host
mount namespace). So the propagated copy (776) of the host's mount is on
top of its root and the copy of that (778) is inside it. Now the host
runs:

  umount /mnt/a

and it succeeds. The moved tree tree and the copy inside of it are gone
from the container. Now only the propagated copy is left and it got
reparented to where it was before:

  grep /mnt /proc/self/mountinfo
  775 355 ... /mnt ... master:646
  776 775 ... /mnt/a ...

But the file descriptor still refers to the moved tree. So a synchronous
umount detached a mount that is still in use.

Teach propagate_mount_busy() the same checks that propagate_umount()
does. It now checks for a single victim mount without children
for which it can assume that MNT_LOCKED is cleared on every copy like
propagate_umount() does. The copies form chains. IOW, when a copy itself
receives propagation from the victim's parent then the mount at the same
mountpoint inside that copy is a copy as well. Whether a mount receives
propagation from the victim's can simply be checked by walking its
masters. Walk each chain once from its top so we are sure that nested
copies stay linear. Check every reference once of every copy that gets
unmounted.

Link: https://patch.msgid.link/20260923-work-mount-fixes-v1-5-f424cf8d3242@kernel.org
Fixes: 99b19d16471e ("mnt: In propgate_umount handle visiting mounts in any order")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Replaced the missing m->overmount with a root-mountpoint check and scaled the refcount check by the number of allowed children, since children pin their parent here; removed the unused find_topper(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pnode.c | 125 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 93 insertions(+), 32 deletions(-)

diff --git a/fs/pnode.c b/fs/pnode.c
index a799e0315cc9a..425f566e52459 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -331,21 +331,6 @@ int propagate_mnt(struct mount *dest_mnt, struct mountpoint *dest_mp,
 	return ret;
 }
 
-static struct mount *find_topper(struct mount *mnt)
-{
-	/* If there is exactly one mount covering mnt completely return it. */
-	struct mount *child;
-
-	if (!list_is_singular(&mnt->mnt_mounts))
-		return NULL;
-
-	child = list_first_entry(&mnt->mnt_mounts, struct mount, mnt_child);
-	if (child->mnt_mountpoint != mnt->mnt.mnt_root)
-		return NULL;
-
-	return child;
-}
-
 /*
  * return true if the refcount is greater than count
  */
@@ -394,20 +379,103 @@ bool propagation_would_overmount(const struct mount *from,
 	return false;
 }
 
+/* Does @m receive propagation from @parent? */
+static bool receives_from(struct mount *m, struct mount *parent)
+{
+	if (m == parent)
+		return false;
+	for (; m; m = m->mnt_master)
+		if (m == parent || peers(m, parent))
+			return true;
+	return false;
+}
+
+/*
+ * Does @m receive propagation from the victim's parent as well? If so, then
+ * the mount at the victim's mountpoint inside of @m is a umount candidate as
+ * well. So it's the next candidate in the chain. Otherwise the chain ends at
+ * @m.
+ */
+static struct mount *next_candidate(struct mount *m, struct mount *victim)
+{
+	if (!receives_from(m, victim->mnt_parent))
+		return NULL;
+	return __lookup_mnt(&m->mnt, victim->mnt_mountpoint);
+}
+
+/*
+ * Would propagate_umount() pull out a mount of the chain of candidates that
+ * starts at @c, and does that mount have references beyond its own?
+ *
+ * This mirrors how trim_one(), trim_ancestors() and handle_locked() handle a
+ * synchronous umount:
+ *
+ * - single victim
+ * - without children
+ * - with MNT_LOCKED already cleared on every candidate by propagate_mount_unlock()
+ *
+ * A copy of the victim gets unmounted when each of its children is
+ * the next candidate in the chain or its overmount, unless the next
+ * unmount candidate is not its overmount and some unmount candidate further
+ * down has a child outside the chain.  Keep this in sync with
+ * Documentation/filesystems/propagate_umount.txt.
+ */
+static bool chain_busy(struct mount *c, struct mount *victim)
+{
+	struct mount *m, *n, *next, *deepest = NULL;
+	bool above;
+
+	/* the deepest candidate with a child outside the chain */
+	for (m = c; m; m = next) {
+		next = next_candidate(m, victim);
+		list_for_each_entry(n, &m->mnt_mounts, mnt_child) {
+			if (n != next && n != victim) {
+				deepest = m;
+				break;
+			}
+		}
+	}
+
+	above = deepest != NULL;	/* @deepest is at or below @m */
+	for (m = c; m; m = next) {
+		bool goes = true;
+		int count = 1;
+
+		next = next_candidate(m, victim);
+		list_for_each_entry(n, &m->mnt_mounts, mnt_child) {
+			if (n != next && n->mnt_mountpoint != m->mnt.mnt_root &&
+			    n != victim) {
+				goes = false;
+				break;
+			}
+			count++;
+		}
+		if (goes && next && next->mnt_mountpoint != m->mnt.mnt_root &&
+		    above && m != deepest)
+			goes = false;
+		if (m == deepest)
+			above = false;
+		if (goes && do_refcount_check(m, count))
+			return true;
+	}
+	return false;
+}
+
 /*
  * check if the mount 'mnt' can be unmounted successfully.
  * @mnt: the mount to be checked for unmount
  * NOTE: unmounting 'mnt' would naturally propagate to all
  * other mounts its parent propagates to.
- * Check if any of these mounts that **do not have submounts**
- * have more references than 'refcnt'. If so return busy.
+ * Check if any of the mounts that propagate_umount() would pull out
+ * along with it have more references than their own. If so return busy.
  *
  * vfsmount lock must be held for write
  */
 int propagate_mount_busy(struct mount *mnt, int refcnt)
 {
-	struct mount *m, *child, *topper;
 	struct mount *parent = mnt->mnt_parent;
+	struct dentry *mp = mnt->mnt_mountpoint;
+	struct mount *m;
 
 	if (mnt == parent)
 		return do_refcount_check(mnt, refcnt);
@@ -420,23 +488,16 @@ int propagate_mount_busy(struct mount *mnt, int refcnt)
 	if (!list_empty(&mnt->mnt_mounts) || do_refcount_check(mnt, refcnt))
 		return 1;
 
+	/* the candidates are the mounts at @mp below the receivers */
 	for (m = propagation_next(parent, parent); m;
-	     		m = propagation_next(m, parent)) {
-		int count = 1;
-		child = __lookup_mnt(&m->mnt, mnt->mnt_mountpoint);
-		if (!child)
-			continue;
+	     m = propagation_next(m, parent)) {
+		struct mount *c = __lookup_mnt(&m->mnt, mp);
 
-		/* Is there exactly one mount on the child that covers
-		 * it completely whose reference should be ignored?
-		 */
-		topper = find_topper(child);
-		if (topper)
-			count += 1;
-		else if (!list_empty(&child->mnt_mounts))
+		/* each chain once, from its top: skip receivers that are candidates */
+		if (!c || (mnt_has_parent(m) && m->mnt_mountpoint == mp &&
+			   receives_from(m->mnt_parent, parent)))
 			continue;
-
-		if (do_refcount_check(child, count))
+		if (chain_busy(c, mnt))
 			return 1;
 	}
 	return 0;
-- 
2.53.0



