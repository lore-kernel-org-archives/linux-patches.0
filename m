Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216469;
	b=CWXjOz9CIgjhwRQtQv0THyMhrKdjFEfIxgfnbv3OqZxoIVEix1QxMMORwvBSZhjjkild
	 Iej3g54rOzBEsJL16cBdtK3pc6zbIHnyliyntKoeQCPPpwnCMQOxswBmFWjUJaxCzO1Td
	 GvwnEHW5hN0+IvSBm1fhUcSDc7gbk+Ri9r32l5sWfsd9bt3eot+nIDxzD35l29DGqzu0L
	 utTx/OzkL5BVoOP6cmfYKsSunfgN5nRt1hh384rZUhJJ7Lgj2atm02V61AoQcxNBeg4QV
	 /lGCv/I/tvq4DaV/wve4UuGavG6IQQwPCPCNRNRg9UWVNsvK1hDqjpbfi8LNlFg1Fjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+EEs2deBRqS2+sowinQ9coWaXrKpcZoWmoYdCeIveJw=;
	b=4HRbOmEljv4j/Q8dBX29fr9u4goK7c8af6E1cPp8iePXSRFyUZvmboZsWhHM+deCfEgd
	 J3JwY0fxIr/i6W4avKK1v9zmuyYFc0hSBvlI8KQvpFx9GjVIpsIbHWV985FvfG6Cw0u3b
	 A8tsk2rIH/aaf2mQeeR5EU6JkRB0wkKrbwxH4sKjNlvyt8yOTzKUyGcu1R/eIMdovlmgM
	 Fuj80NPoO1xK4CwtRAKZnjMRWGWwbnY3Nd2AjMevVRKpLIna2Cc/eKDBW4ro//3ch9eCG
	 k5R9+9/zTTCN2l1dwXM1fnhNhill37tvboGx9GNa+qWWtFsd725TCFf7wLB7F2PvqeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zTd0SwMW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EDD606A32E;
	Wed, 28 Oct 2026 19:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zTd0SwMW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78CD1F01829;
	Wed, 28 Oct 2026 19:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216469;
	bh=+EEs2deBRqS2+sowinQ9coWaXrKpcZoWmoYdCeIveJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zTd0SwMWgzGUd6E/smCWCA//Eks7KtnxMOgRSW9ob2iDoWnG5zJzgtZUbFxcEwStp
	 mWkBUBleciRaWDNCMx/3y5lqyVbRPZxwkiGpvuWS9yNCn+Zsbb8Xq/6dOkO7fKp65w
	 QRaZd2X/YUXMHcv+7aH7Cv7xBC/6TnRdziPp8KIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	Sun YangKai <sunyangkai@fnnas.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1568/1887] btrfs: check if root is readonly when setting posix acl
Date: Wed, 28 Oct 2026 18:01:04 +0100
Message-ID: <20261028170535.148572808@linuxfoundation.org>
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

From: Sun YangKai <sunyangkai@fnnas.com>

[ Upstream commit 01c2f41fc441f75b3f9326443372faceb1cb6638 ]

For a filesystem which has btrfs read-only property set to true, all
write operations including acl and xattr should be denied. However, acl
can still be set even if btrfs ro property is true.

This happens because no function on the set_acl code path checks the root
is readonly or not. It was checked in btrfs_setxattr_trans() but got
removed in commit 353c2ea735e4 ("btrfs: remove redundant readonly root
check in btrfs_setxattr_trans")

That commit didn't check if all the callers properly check the root's
read-only flag. A previous fix is commit b51111271b03 ("btrfs: check if
root is readonly while setting security xattr").

Always check if the root is read-only before performing the set acl
operation.

Fixes: 353c2ea735e4 ("btrfs: remove redundant readonly root check in btrfs_setxattr_trans")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Sun YangKai <sunyangkai@fnnas.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/acl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 548d6a5477b42..038dc7315be90 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -116,6 +116,9 @@ int btrfs_set_acl(struct user_namespace *mnt_userns, struct inode *inode,
 	int ret;
 	umode_t old_mode = inode->i_mode;
 
+	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+		return -EROFS;
+
 	if (type == ACL_TYPE_ACCESS && acl) {
 		ret = posix_acl_update_mode(mnt_userns, inode,
 					    &inode->i_mode, &acl);
-- 
2.53.0



