Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032982;
	b=Nt2CUaf9V4OrQYsMkGkisrtjouDdIKh+/vNENTWCVsh7OdFcPh8b5jAi3x8JQj3tAEL0
	 bdbbz5YbiPsp0C9h15zSFLqso/7UQdLC1diX+zw1A6IZVFdkCBQ0/N5c6veGS+UfOOvK0
	 QRxc/LndLOFAXDpfr2AUh6N00lv099GddZhwBJdY4X1ljQPaqkGMBYF9inlOXHNgbMRIS
	 ysW1qaNViMDnbsoMTcqhZR7Yn7dWJdUjkGaxfO+M0KBvxdt1kbBALgQ2Tp+0CibiFx4KH
	 fqAGRzjdBtZLaYsFJWynYIrwZ1nk7QTvLHmejb/+jgEIe0PgOQ7Ajk1pI4YcwSbLYTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sfJ/9dIoYW/qSv5PsaRbBX9MfcQIWSQL+XHl0r/46jw=;
	b=vMHfOgECQdlStS+pQM3b0icomhsshR97o/ZlOvSe8qaISpiB2TjFcws9Su+KA9qcSYGZ
	 QnHBzAmW9J/mmtaUvv4jxOOwd4u3JMsCUEJIp/mcW2n83qwRL68zOhLp9783LEslt5593
	 b/zMUXJGPgqIZXamj8FeXZWec2DNNxwXXXZxTGP6A2ORxgufijvro5lbQYA6/hQTVFGMm
	 Dh/i/0TTD0Oc0o1ZFLUZLzz7RCG8gutrNkxVRIN0Psj9u9kQsz5+lb17QgsrttDTY7J7K
	 KgKM0hSzeE8Jmm4+QA2tsTTv9GE8Et/k7yMdjxUZrTeDAyKVflrV9B5ElOpwpu//nJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iVN4+sGP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3DF606A320;
	Wed, 18 Nov 2026 20:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iVN4+sGP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473761F000C4;
	Wed, 18 Nov 2026 20:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032981;
	bh=sfJ/9dIoYW/qSv5PsaRbBX9MfcQIWSQL+XHl0r/46jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iVN4+sGPBWf1bH8qDvWnE/xrkhOViQOfqnGgyykhc81yLcadMgSGFedgNqlVo4m8E
	 EnxDdSgA7dld2OjJgrMHfvGi++U/HXOewXn4ygEHSB6PLlPkaLxTcv6xD3swAS+IQR
	 Vpt/mAP6s3uqWqvNCh5WSy41vkFdPX02bvAlXFkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1564/1756] ceph: mark the superblock active after mounting
Date: Wed, 18 Nov 2026 16:01:31 +0100
Message-ID: <20261118150111.764958450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 96d582f71beaa..bd315aaaff13c 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1348,6 +1348,15 @@ static int ceph_get_tree(struct fs_context *fc)
 	doutc(fsc->client, "root %p inode %p ino %llx.%llx\n", res,
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



