Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050498;
	b=tx8JlrpEw1YOTzqseFCmNVACC3wViWgKxPhP+/NPoqgidCYCkn5W+6nuHrBPZUMaKE6Z
	 0LPudZqUxq/eugV8rmKDUUedWD0Grj/0jBUMoeh2IXHA9DTNPx+R4iNiUrrDaMMg30QPO
	 K3XucUdXpwFQPV/0Okfd59QT4dQ0Bz+Bq09mGSok3VXMIiee9TAdhPAt8Arn81yQpZaRI
	 /T3SKzpw7VeS8elI0F3Un5xnbS1bHRjYoFSTVwLj6kcJUll2f/A4bufPdC6RaUnCA9GYA
	 P56BfKi+sEdr5hBAm3z8qv7GOUlA6LpSpgXkTjeDJMyptIHA45roz47T63IT0LAZOmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N4hFwBkmVlt43Tp0LeJkFgAabe0QShkzPB1Wnp54G1M=;
	b=w7hjFSCZCYjp3ZfQk8qMI436r2TEBbvQonm9aLl7OgOPydcAYn2POR2416bjrc+MRoaY
	 +n4T5EgH+BwP8dmdFnYlH0yzgP8273XO5MVMPsR4J5WF/1sxRY/40t6YSMQoGAS+j4PeY
	 BwaGnz3u3LCSp7Edg8k2eZ8HS25qnSAOYIDXOA39CdiTWlya+bkSlVRgBnam8oif8OVLe
	 4XRm5fCj1oWYpSvGUIwF9PgvrQAhC0APNXsehB6BMCOJ0c6wXNTiDMBN5bh4eIw3pWWEq
	 6ijXPlX+tjqc1MO/N6QxJeR8lLeNogikVw2REmrMl5kDVsjR2ZgBeQdV1eVibZUDlUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KXWr8Vy4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F3D606A320;
	Thu, 19 Nov 2026 01:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KXWr8Vy4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B752E1F000C4;
	Thu, 19 Nov 2026 01:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050498;
	bh=N4hFwBkmVlt43Tp0LeJkFgAabe0QShkzPB1Wnp54G1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KXWr8Vy4tTJV7kRRSb2qRleKH8KWH9jjXb9xwA3TuEX5HqFPFsy6+H9ZKKAVOnH5O
	 HIwmEJo1m6ykWe0p9mrb0JYgFjNeft7onzK/2DzSotYy7/Vktn1z8RqR6+F6Ct+PDD
	 rrsJ2Lmn+6KIjmr9mDTyS4Yo4h/u05je/vDqmdIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2729/2857] ceph: mark the superblock active after mounting
Date: Wed, 18 Nov 2026 16:02:43 +0100
Message-ID: <20261118150339.881910848@linuxfoundation.org>
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
index 2dee4ca9f7a72..77bd924228279 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1267,6 +1267,15 @@ static int ceph_get_tree(struct fs_context *fc)
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



