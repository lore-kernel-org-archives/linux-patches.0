Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215023;
	b=WOQgFZ8jNI5bnh+G8QkcqBRrovJPPnI2NqPb+YG44L0tGpnCNPgTukN3eg4w/wm+FG7I
	 nklUlVgm38ukSdX9MyuQnRFjxPxlSa+r3Dr5ys/taAF4McuHZzI+f1Uh/yEcfmfqusgxL
	 jwn68Xan6JhK9EbkvTBe+5+Nq/mtFNjSGSq4P94rIn9yelCAgc/zRb70oBxeee+fTQnks
	 CU5mt5ptdOF7belbTVsYmBmsUmiUXWNLKHScLgVk5y/6cVCU589h8lNYfuklYOgsIie3N
	 B2aAejXH+1M3GphIjkqb+6nZJtD64C6EpuMsJM5PXBb7srCyISZcC9hxwPrwFRtT7lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VezCQQXo+ECcGVrAKgeCKJoqvumA+EOdgQpKc+E/QPE=;
	b=Li4uuhGbFF2Pfq9WOFGtY00Ur6vxul+an8V6+BdkOfz2t988R06f5WLarfci2Ot5v71f
	 sA6W/dCT4Xg3lvYnU0oy4LUSYrgD/HA9Mx09BZd5obsctbwKTg8k1Hwt71T6IcCcRVc9b
	 mviyJ105xhcUGIp8H1HfVCWKos0nyHp4K9mMQhoyaEsYhy14F4lk9OuIxRNuEaYtFsO2J
	 Oe13PTYfr6o+4YI9o19OpqlK4Pj1H9+7F0iuMgdbyXtCBIoEWWcAe6niciAN2P7Ao9ouS
	 7ZNKmzVksgxTEbtlqcjt5FdB6Q5abTiFjJ4oTxU5holruUpu8TPNOgYOPNY5oBZtvxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vcjDnvNV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CFF606A325;
	Wed, 28 Oct 2026 19:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vcjDnvNV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAD81F01825;
	Wed, 28 Oct 2026 19:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215023;
	bh=VezCQQXo+ECcGVrAKgeCKJoqvumA+EOdgQpKc+E/QPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcjDnvNV8a09YFd4M3+KV8cNdyfhivaJEWQGegYBFnobADYFj0bN2+RrAP7vspT0u
	 bg4VXieltCUNT13KnCyFgPs9+Npf7WSYHFPzfRo9fyPcPNPYUgnm5Du38qirK3c0hT
	 VvOiQqY7mr4JKeC1tyAc5aspS+Gfs/i8AEmMYED0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1065/1887] selinux: allow multiple opens of /sys/fs/selinux/policy
Date: Wed, 28 Oct 2026 17:52:41 +0100
Message-ID: <20261028170523.645156993@linuxfoundation.org>
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

From: Stephen Smalley <stephen.smalley.work@gmail.com>

[ Upstream commit a02cd6805562305f936e807da83e253b719dd965 ]

Currently there can only be a single open of /sys/fs/selinux/policy at
any time. This allows any process to block any other process from
reading the kernel policy. The original motivation seems to have been
a mix of preventing an inconsistent view of the policy size and
preventing userspace from allocating kernel memory without bound, but
this is arguably equally bad. Eliminate the policy_opened flag and
shrink the critical section that the policy mutex is held. While we
are making changes here, drop a couple of extraneous BUG_ONs.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/selinux/20100726193414.19538.64028.stgit@paris.rdu.redhat.com/
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/selinuxfs.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 8fd1428a60e18..5fbb24cce1b51 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -74,7 +74,6 @@ struct selinux_fs_info {
 	int *bool_pending_values;
 	struct dentry *class_dir;
 	unsigned long last_class_ino;
-	bool policy_opened;
 	struct dentry *policycap_dir;
 	unsigned long last_ino;
 	struct selinux_state *state;
@@ -401,41 +400,29 @@ static int sel_open_policy(struct inode *inode, struct file *filp)
 	struct policy_load_memory *plm = NULL;
 	int rc;
 
-	BUG_ON(filp->private_data);
-
-	mutex_lock(&fsi->state->policy_mutex);
-
 	rc = avc_has_perm(&selinux_state,
 			  current_sid(), SECINITSID_SECURITY,
 			  SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL);
 	if (rc)
-		goto err;
-
-	rc = -EBUSY;
-	if (fsi->policy_opened)
-		goto err;
+		return rc;
 
-	rc = -ENOMEM;
 	plm = kzalloc(sizeof(*plm), GFP_KERNEL);
 	if (!plm)
-		goto err;
+		return -ENOMEM;
 
+	mutex_lock(&fsi->state->policy_mutex);
 	rc = security_read_policy(state, &plm->data, &plm->len);
 	if (rc)
 		goto err;
-
 	if ((size_t)i_size_read(inode) != plm->len) {
 		inode_lock(inode);
 		i_size_write(inode, plm->len);
 		inode_unlock(inode);
 	}
-
-	fsi->policy_opened = 1;
+	mutex_unlock(&fsi->state->policy_mutex);
 
 	filp->private_data = plm;
 
-	mutex_unlock(&fsi->state->policy_mutex);
-
 	return 0;
 err:
 	mutex_unlock(&fsi->state->policy_mutex);
@@ -448,13 +435,8 @@ static int sel_open_policy(struct inode *inode, struct file *filp)
 
 static int sel_release_policy(struct inode *inode, struct file *filp)
 {
-	struct selinux_fs_info *fsi = inode->i_sb->s_fs_info;
 	struct policy_load_memory *plm = filp->private_data;
 
-	BUG_ON(!plm);
-
-	fsi->policy_opened = 0;
-
 	vfree(plm->data);
 	kfree(plm);
 
-- 
2.53.0



