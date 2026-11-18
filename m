Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042420;
	b=gskiNUTgpSrbUEqZ3I0oRe0wSU1rqX5wAdk0jULlmhuVsitPZc9x5gHiuMvic4kYbrIu
	 A/eok7OvitPElOH57t1EhDALJMaQt0LpuIqIZXLOA/ecfD6b3HLHLOwNMMawFPaSO4Jv/
	 da9zgQg+swvos28JFz+wE9r9ABDOop2/dmt2htMnVJCZ5kJIphPv0w3bQoPT5fu/H+0TX
	 bn85EbbEYy8jAJAdAWenmVPxTxd6DU+FoRl36d385z5/ChGaC2jQenFYLM2mMiQYAxzr6
	 wNFa4MRyUoKNaWxt5i0NFvsoE4kbwbFwrvOK0HV7zHzAJdybRLdT1wvG/eGDxrTs1uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rriIXGiK6pJL4YFkZ7s4kJPCa8FB+QInUEoW2Kmoa1w=;
	b=rZJ7TI7XI6IPe5fAUZRAXBM3JKwNTF+mtcgSUopajwoaEg99tLZAIsuXJ30sP1x/N4Gc
	 W36qyqHmUZ8vY0ii00Ov7CsC1Z6XqHJobjGoSKCK3GHjnQYT8TLO3t7fP0gMU5PNsna6i
	 ZMYGI98OQ+F8rneCpAH055qnDMBke8BtknD7sF7gwHWjYzO0er4Fwt5p1cZGySHbGKI82
	 3Neyg/O9SVUbYu+ZdvXtsS5t0exeND19BhvbelZhIcnC03tuSImZd/HBjp0VegDTU1wb/
	 Mfrn/7MF4Z5jkK3/k01FYQj7Kqwx+/a5yghHG1XV+hjfgqRlSsZc8fcIGL/4drvy+uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kY+ivbUK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEA0606A325;
	Wed, 18 Nov 2026 22:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kY+ivbUK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDD21F000C4;
	Wed, 18 Nov 2026 22:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042420;
	bh=rriIXGiK6pJL4YFkZ7s4kJPCa8FB+QInUEoW2Kmoa1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kY+ivbUKOwST1Sbt2dcZApPXq3dVyMWVkn3WinqQ03HwcLURRm8TLBsuE/uWiQ6Qt
	 8fv6R5TsOqCDU1sB+EnlTA06i/keeHUZGoukYGLbvBT8QmadKm+AmBemT9ASctBk4t
	 xccGoHXOao9aq6M0jL2xmJ8ZdyMCGnCJCugldMMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3165/3318] ceph: mark the superblock active after mounting
Date: Wed, 18 Nov 2026 16:03:07 +0100
Message-ID: <20261118150454.792166783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e4298a6c7c41c..8d6e60cc461f9 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1361,6 +1361,15 @@ static int ceph_get_tree(struct fs_context *fc)
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



