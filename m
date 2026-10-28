Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213544;
	b=KmDQiezjp3BDdWQ4h/2DZAOjJBk9o9T0F0VkB0IDmu9Zgk3bj8zO3LvOANzfJTk6k0mB
	 byqg3RnOAMOipi9FPkB44Ct4r+bxX3XFLVU719h5f5QaPV151GI+GpCBP52x5iJDrReoZ
	 CAWLNFYduKPp87P2/RANdAyHlvpaDuu1Mr8gJzdB68rPrfCS+EklupqziGxvB3S4fxzhx
	 XAhyHy9jq5zeXY6KH02csqYM44/ZG7L8YahXO9Gx4eVvfmBRvrbcxxqwlCfmpJsBixhfz
	 htNN5JZfSpd/3VcM2lnb96d6pFh+OYQ8gObv1LPBicGEON/ze19oC8fg0JtevRatxjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1PvJgzviKuefUGtKZfPCqcDtBkKjy9pHn/Ee/hu+/H8=;
	b=S6UMo6BB9TuoKwQq81l3AsoidYewrLkFHJWBEYYTyzUhmfuljccPFYBa/hk8W8x0eANY
	 iMcYy/nPpb4x1f07ytEVUaE5rIJP5qNDfXMeiC19KKoorKSavdgqVAYY3SumpYOIwkcE4
	 hKcDsVx6qzrOhfjag4iHpp4hP1/FQRrPoOu9Cx6/uLLvEOzxefY2qp4FFlW75fWqnqZm/
	 vQqXrbyBpa485oinkfSwf/OF8Hj2GNfJYp5hLfE3oMWLaJD55lKALhCU3E+cdwfIxSNfZ
	 kapgC8IpnfFTwNlzZF18c+saTZEOpv35YcTKwciwQW1fyY+sPVCqsmhEIUVHn6kaBNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qk1PzhEV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7CE606A31A;
	Wed, 28 Oct 2026 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qk1PzhEV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2B41F031E0;
	Wed, 28 Oct 2026 18:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213543;
	bh=1PvJgzviKuefUGtKZfPCqcDtBkKjy9pHn/Ee/hu+/H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qk1PzhEVaDXfgvBpVVgQpsSRMpT5rxD84A3FjbulSTidUrp8tvN3mPJweoyI0z+JG
	 +mMy81/PkUc9Qta1QKYm+eE9v2omlHP5+BXh3vDkoc8btCUOycpe3LViw77PwjPnPP
	 P553N0mIlXwwyVMpmmuMULDj/XQnnjq4QnHXIMnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0544/1887] namespace: handle mount locking for automounts correctly
Date: Wed, 28 Oct 2026 17:44:00 +0100
Message-ID: <20261028170511.738476264@linuxfoundation.org>
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

[ Upstream commit 33aadc7c72055fca93cb5a3691d836ebf8b31c9b ]

If mounts are propagated across user namespaces, attach_recursive_mnt()
locks every copy of the source mount to protect overmounts from
vanishing and revealing the underlying files or directories.

The user namespace is taken from the caller's mount namespaces since
this is where the mounts end up. Except, that's not always true.
Automounts may legitimately get popped in by tasks located in a
different mount and user namespace during path lookup.

Then check doesn't make sense at that point. The copy in the namespace
of the parent - which may be the host's - is now locked and the host
cannot change the flags of its own mounts anymore.

Here's the reproducer:

- host has debugfs mounted nosuid,nodev,noexec and shared
- tracefs automount below it is not yet active
- hand a child process a directory descriptor on that mount
- child process enters auser and mount namespace
- child process' namespace now holds a locked copy of the host's debugfs
  mount that receives propagation from it
- child process stats "tracing/." through the descriptor
- lookup runs on the host's mount so the automount lands below the host's mount
- propagation puts a copy below the child's copy
- both try to clear the flags on the mount they got, with a bind remount:

    host, on its own automount:            MS_REMOUNT|MS_BIND = EPERM
    child, on the copy in its namespace:   MS_REMOUNT|MS_BIND = 0

So the lock landed on the host's mount instead of the child's copy.
Congrats. So we need to compare with the owner of the namespace the
mount actually gets mounted on. For all regular cases that is the
caller's mount namespace and so nothing changes.

Detached trees in anonymous mount namespaces by be handed over via
SCM_RIGHTS or inherited in other ways on purpose so the attaching task's
mount namespace is authoritative, not the creator of the detached tree.

Fixes: 132c94e31b8b ("vfs: Carefully propogate mounts across user namespaces")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-6-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Adjusted attach_recursive_mnt() context for direct dest_mnt and dest_mp arguments instead of the pinned_mountpoint interface. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index cf866f5dbd1c5..c07e9e857f999 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2219,14 +2219,30 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 			struct mountpoint *dest_mp,
 			bool moving)
 {
-	struct user_namespace *user_ns = current->nsproxy->mnt_ns->user_ns;
 	HLIST_HEAD(tree_list);
 	struct mnt_namespace *ns = dest_mnt->mnt_ns;
+	struct user_namespace *user_ns = ns->user_ns;
 	struct mountpoint *smp;
 	struct mount *child, *p;
 	struct hlist_node *n;
 	int err;
 
+	/*
+	 * A caller in an unprivileged mount namespaces may trigger an
+	 * automount and propagate locked mounts into privileged mount
+	 * namespaces. Take ownership from the target mount namespace.
+	 * It's equivalent for everything but the automount case.
+	 *
+	 * Detached trees in anonymous mount namespaces by be handed
+	 * over via SCM_RIGHTS or inherited in other ways on purpose
+	 * the attaching task's mount namespace is authoritative, not
+	 * the creator of the detached tree.
+	 */
+	if (is_anon_ns(ns))
+		user_ns = current->nsproxy->mnt_ns->user_ns;
+	else
+		user_ns = ns->user_ns;
+
 	/* Preallocate a mountpoint in case the new mounts need
 	 * to be tucked under other mounts.
 	 */
-- 
2.53.0



