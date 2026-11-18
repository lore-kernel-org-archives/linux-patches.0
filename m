Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015933;
	b=Li1M48Bb2Rl5Ks48WwXCaxz8eid3qQtS66IsW/8ZsZf/VgSHMVC8gcsFVXw9JlM7IVAe
	 9AK/fMx4hruSSEI1enTpWps0al76KGYdgpcfkt1tm2djEMeK33m0/SOPWFrxZFaiT2oHQ
	 YE/EqB6dicr3omuhPOCRxfEHckFzb+rPjXeBIH4qq5QnMT3i6w+d4udRWKnPFHee1n0T2
	 wET6AT3Jn7vc9nV6CkIiKFj7xwwwF0wLHBcFGPkcK2+XLPx51U+XqN8PS9qNmoao9i/n8
	 vdO4QJGyYeosviIhtvSJH2O0owRYMQgT4S2KPGKtfZiXtDCRW/STCmj5/c/OW4xI65Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QHQh0QSYCjftR5DE248YBqPJNWNDUq6oiF3dE643/AQ=;
	b=bU+VWkNnHokeh6iE/Z2L7cTA6yZhwq/CaQnYV71SwWC8OVzjYu4Bpb1h+B6rgERg01iv
	 VFwnOes3UfA3IAR+8eRtYouhLdgs8yR6/Hbi5PKth01ck0f35JBa5EITVTOA9bdUGOcuS
	 ZeB70LIhKi1EyDPRbM4cW1r6fI4ryi91FQX83jMiflbqowrvKiXsWwWTrU8bI8T6nKrGz
	 +z/IqlX/1ggsdbz+KD2q7vYJom3hLfD8jx7DB4W2qqRYrOPGw0qUPMbGKkaDpKa/P8gAn
	 d2ZdMmH2POE0XHC+6G5PturLtCP1S472JqH0idIxLBj/1gyFgxtghPwC7d5+o0KGrqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FI7DmT3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5F460A261C;
	Wed, 18 Nov 2026 15:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FI7DmT3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCBA1F000D0;
	Wed, 18 Nov 2026 15:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015932;
	bh=QHQh0QSYCjftR5DE248YBqPJNWNDUq6oiF3dE643/AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FI7DmT3/jQnpP+lPLWOKhU74pee0Oiql590TgFf1Veungsc1oIxvrabcTr2dgR/lN
	 S71CABBglgLidw193wy2vmqRMwrwQNrMLVXWGbK08VBwX/+n/Hu6wGHD9mqzqVEN1X
	 kQrGoqEUqQdpz77IWZcISxQT52W+E+0BV6zCSEyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0350/2651] kernfs: fix up the unlocked attribute reads on the creation paths
Date: Wed, 18 Nov 2026 15:26:30 +0100
Message-ID: <20261118150300.438479985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

[ Upstream commit 81bdc85b4c086502f4446a58eb5d25f29bb5e9f7 ]

Two creation paths read a live node's attributes without holding
kernfs_iattr_rwsem, which kernfs_iop_setattr() takes for writing.  They
need different fixes.

kernfs_create_link() copies the target's ia_uid and then its ia_gid into
the new link.  A chown of the target between the two reads leaves the
link with the old uid and the new gid, an owner the target never had.
Read both under the rwsem.

kernfs_new_node() reads the parent's mode and ia_gid for S_ISGID
inheritance.  Either value is fine there: the node does not exist yet,
so nothing orders a racing chmod or chown against the creation.  Taking
the rwsem would only pick between two answers that are both right.  Mark
the reads with READ_ONCE() instead.

The pointer that leads to them is already fine: __kernfs_iattrs()
publishes kernfs_node::iattr with try_cmpxchg(), and both sides read it
with READ_ONCE(), like the rest of fs/kernfs.

The Fixes tag is for the symlink half.  kernfs_create_link() has read
the pair unlocked since it started copying the target's owner; only the
name of the lock its writer takes has changed.  The READ_ONCE() markings
are not a fix.

Fixes: 488dee96bb62 ("kernfs: allow creating kernfs objects with arbitrary uid/gid")
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://patch.msgid.link/20260905191613.3143937-5-shakeel.butt@linux.dev
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c     | 12 +++++++++---
 fs/kernfs/symlink.c | 17 ++++++++++++++---
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 82bbaeb326aab..4bfb7a353f429 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -736,13 +736,19 @@ struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
 {
 	struct kernfs_node *kn;
 
-	if (parent->mode & S_ISGID) {
+	/*
+	 * The mode and the gid below are read unlocked on purpose: they feed
+	 * a node that does not exist yet, so nothing orders a racing chmod or
+	 * chown against this creation.
+	 */
+	if (READ_ONCE(parent->mode) & S_ISGID) {
 		/* this code block imitates inode_init_owner() for
 		 * kernfs
 		 */
+		struct kernfs_iattrs *attrs = READ_ONCE(parent->iattr);
 
-		if (parent->iattr)
-			gid = parent->iattr->ia_gid;
+		if (attrs)
+			gid = READ_ONCE(attrs->ia_gid);
 
 		if (flags & KERNFS_DIR)
 			mode |= S_ISGID;
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index 90e2b3221b83d..3e53105d3abf1 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -31,9 +31,20 @@ struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 	kuid_t uid = GLOBAL_ROOT_UID;
 	kgid_t gid = GLOBAL_ROOT_GID;
 
-	if (target->iattr) {
-		uid = target->iattr->ia_uid;
-		gid = target->iattr->ia_gid;
+	/*
+	 * A symlink takes its owner from its target, so both fields have to
+	 * come from the same moment: read them under kernfs_iattr_rwsem, or
+	 * a chown of the target racing this could leave the link with the
+	 * old uid and the new gid.  The section ends before kernfs_add_one()
+	 * takes kernfs_rwsem.
+	 */
+	scoped_guard(rwsem_read, &kernfs_root(target)->kernfs_iattr_rwsem) {
+		struct kernfs_iattrs *attrs = READ_ONCE(target->iattr);
+
+		if (attrs) {
+			uid = attrs->ia_uid;
+			gid = attrs->ia_gid;
+		}
 	}
 
 	kn = kernfs_new_node(parent, name, S_IFLNK|0777, uid, gid, KERNFS_LINK);
-- 
2.53.0



