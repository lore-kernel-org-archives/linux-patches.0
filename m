Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062108;
	b=udpj4VeI56Wc817EgeAEeBor/G5RO9Tb7U4gV6ceca+fqsMgl/W6AN0jX6xYsZRnD06B
	 itkzxCAnBOocwqWCyc8X9rBqo10kQL9xa6HI4bKQWmqUvXnlZQykg28QpEozuZleZLOuR
	 XMDD1YhRLZ0OI1bcUnLLROv2XNdTEEe6izJCsRJNXZtHmHJxzMCg3PrT8KdoSoffOY0XM
	 +zVDFizyB2wvPA2mNtRkiLIEQELtdfbYATVNG0EKGvW7oD6jFhwb51zNQvk1vu63Uhm79
	 awXeV3pXPV7HWvzDghLuZ4rEHRnal8LDX2cRrnbMwRZEtBZu1a5PxR3KXD9hjxverow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qax3wnZP2fVa8mHfF3bFFDWWbH3MDTG0GE3lethCdYw=;
	b=HOHvaWudUHs6Jt6Icx9s1qfDiHEmR9A97Kg85cV3F3Vgvh9DF86/RkCPX8akSMo258sC
	 mDfnxBFGIrxCnEmqsre2ZT12iXzr/8jpb0iWYoEmR6LRGuIvBu0GtsvPGdj6DP2yrviqM
	 v6n8MlDsmhWK6Z44+682DYR4qT+CXy+hP+ZSDI3fFaZ5H54IaqWzfkbWR8wdTI9dbiV8o
	 AQ/XCdF5Jqa/MYfK9Q36A3i6O5MnUxb3uQPfKc6+e0VUAKJshsWZakI2qB/IFGm7u3DDZ
	 8EPw2tdLWtxR3bDsUj/vKXrHWIoS7Y3mqK4KX3Vimghoo0LiCL5btMzTTc+WabTNdZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XsK54wIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03575606A32F;
	Thu, 19 Nov 2026 04:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XsK54wIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554B71F000C4;
	Thu, 19 Nov 2026 04:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062107;
	bh=qax3wnZP2fVa8mHfF3bFFDWWbH3MDTG0GE3lethCdYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XsK54wIUxzD0edNL6d2imOsjYoTYtQEP1YLNxnbfYA1f7YgOh1S7yRzPaFzFlTjw8
	 hkZqW7ZyKUwI1dhaa41yB3Gn9YIzSijVplqk07zLBgsbWM1yfBv61LVJqjpNVdv0X5
	 86JwY+sIii12kWLGZTlvLCjTnwRp/P2rr5r8Qx7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1775/1848] ceph: mark the superblock active after mounting
Date: Wed, 18 Nov 2026 16:03:33 +0100
Message-ID: <20261118150033.678515421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubo.li@clyso.com>

[ Upstream commit 32eacfae3b16f6a9c0c20f946115abf5a091c922 ]

ceph_get_tree() calls sget_fc() directly and so never goes through
vfs_get_super(), which is what sets SB_ACTIVE after fill_super for
filesystems that use it.  Before commit 82995cc6c5ae ("libceph, rbd,
ceph: convert to use the new mount API") the flag used to be set by
get_sb_nodev(), which did this for ceph, but the conversion dropped it.

SB_ACTIVE is required for iput_final() to retain an inode on the
inode LRU instead of evicting it once its last reference goes away.
This has gone unnoticed because ceph sets inode_just_drop() for
->drop_inode, which always asks for eviction, so the retain branch in
iput_final() was never reachable.  The next patch makes ->drop_inode()
able to retain inodes, and that needs the flag to actually work.

Set it once the mount is up, like nfs_get_tree() does.

Fixes: 82995cc6c5ae ("libceph, rbd, ceph: convert to use the new mount API")
Signed-off-by: Xiubo Li <xiubo.li@clyso.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index a7ec8d99dc45b..52f630f5c8e7d 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1113,6 +1113,15 @@ static int ceph_get_tree(struct fs_context *fc)
 	dout("root %p inode %p ino %llx.%llx\n", res,
 	     d_inode(res), ceph_vinop(d_inode(res)));
 	fc->root = fsc->sb->s_root;
+
+	/*
+	 * The mount is up.  sget_fc() leaves SB_ACTIVE unset, and, unlike
+	 * filesystems that go through vfs_get_super(), nothing else sets
+	 * it here, so iput_final() would always evict an inode whose
+	 * ->drop_inode() asks to retain it.  Set it like nfs_get_tree()
+	 * does.
+	 */
+	sb->s_flags |= SB_ACTIVE;
 	return 0;
 
 out_splat:
-- 
2.53.0



