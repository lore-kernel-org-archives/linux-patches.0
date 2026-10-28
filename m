Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213538;
	b=VRgOjSosa1XEv5bdSiG+RhE9OXONfwY8nuo05i8Xy6jLq/rVLUEEfJB1cgg7l78c8Ap8
	 C1TpiMGhje23hJz2T8Nf1erFUhw7r3A65jwwmnmMGx4fABwRhydKwQn7q7rDhI6JjWx3X
	 paeEuqDpBAblQUv/y7YKEUhvClyHjqT5MLFA7Uct7yLADACbXEvYj1UeD2njWvARhdIsZ
	 FUSj0Byr8qBPxmFofFPlK8HppPZqBcRLBY+kp42Eu3dgEhOPOMW5F4FExwYle0TqIcyfi
	 izbsvqeLOFAgx9PY1RtnQ5o5NP6qLcZt5b1AaB7arKq/vsBf25kM4WVdz1q0nT2bF9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jPU1vaY/F6gAbgHI9pa7E9Fi3JgbOxV8dVPrYJNbSfY=;
	b=3PgkaegMx03Y+gX+kQgCdAfahG+UBB2VQ65WK2Y+8+BS3y4bXJKf6rQiTJE7lZBxEMrD
	 6R6elskhE1vxaRFzYYrRY9CemxiuVgY3TWrNC/Teu26v6JuA5EdvgAeuV26oarEzdWYpO
	 PSiCR2G9iKhB1xjh7wWQhBJG82h4UN+eif6f5G7Iw229c4JETyAEZUdeoYUkuNY7bKE9m
	 8ptb8oUARLcn4DlhuKArDO+gRxbDDFpa4D4gat6xZeSCDMgmtJaFOmD3HlWSDU119+41E
	 C6+cCr/wwCvZ6ftJYgjRWdqEkozxsV9SiGQ1cjApAGtduZ/Uu4aLcLZrRfP1cDyxGyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rPZYjtCs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF97606A31A;
	Wed, 28 Oct 2026 18:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rPZYjtCs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1111F031E4;
	Wed, 28 Oct 2026 18:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213537;
	bh=jPU1vaY/F6gAbgHI9pa7E9Fi3JgbOxV8dVPrYJNbSfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPZYjtCsoEq7MszNslqPZC5zwzFPaAOC8d6KMJIQ5FWIOZCmQns7j8LsMTQ+C8Hdj
	 BJPDc78aiHt3huFKfkfGrqCRmaQH5wf/zLVTiKGYl81A3I09PlJ1N90QQTALZ/q6/E
	 bn16u+hN+BeH7t7rMaEJHBnAtzpKXs2RHbfGWH8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0542/1887] namespace: check the target before walking it in do_mount_setattr()
Date: Wed, 28 Oct 2026 17:43:58 +0100
Message-ID: <20261028170511.689599548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

[ Upstream commit 08f4288a37ef4b3d19b4a9599ec3048219cac828 ]

When mount_setattr() changes the propagation type to MS_SHARED
do_mount_setattr() takes namespace_sem and calls invent_group_ids()
which walks the whole target tree with next_mnt() and allocates a peer
group id for every mount that doesn't have one.

Whether the caller may touch the target at all is only checked
afterwards under mount_lock. If it may not, cleanup_group_ids() walks
the tree a second time on the way out to free the ids again.

A detached tree that a file descriptor keeps alive, a mount in another
mount namespace or a mount below the root of an anonymous mount
namespace does a bunch of allocation work that is completely useless
because it will fail and revert right after.

Do the right thing and check the target right after taking namespace_sem
instead. A mount leaves its namespace only under namespace_sem so the
mount stays stable. The check under mount_lock stays for the case where
no propagation change is requested and namespace_sem isn't taken.
Callers get the same EINVAL as before.

Fixes: 2a1867219c7b ("fs: add mount_setattr()")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-5-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: replaced anon_ns_root() with explicit checks using existing mount helpers. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index f2729ffdc5c52..cf866f5dbd1c5 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4224,6 +4224,13 @@ static int do_mount_setattr(struct path *path, struct mount_kattr *kattr)
 		 * propagation.
 		 */
 		namespace_lock();
+		/* invent_group_ids() walks the tree, only walk a mounted one */
+		if (!is_mounted(&mnt->mnt) ||
+		    ((mnt_has_parent(mnt) || !is_anon_ns(mnt->mnt_ns)) &&
+		     !check_mnt(mnt))) {
+			namespace_unlock();
+			return -EINVAL;
+		}
 		if (kattr->propagation == MS_SHARED) {
 			err = invent_group_ids(mnt, kattr->recurse);
 			if (err) {
@@ -4236,6 +4243,7 @@ static int do_mount_setattr(struct path *path, struct mount_kattr *kattr)
 	err = -EINVAL;
 	lock_mount_hash();
 
+	/* Checked under namespace_sem already if the propagation changes. */
 	/* Ensure that this isn't anything purely vfs internal. */
 	if (!is_mounted(&mnt->mnt))
 		goto out;
-- 
2.53.0



