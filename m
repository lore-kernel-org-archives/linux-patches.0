Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021734;
	b=Oa9hJ55E0R6G/aFUFkgZQSBVBs9NvA8HUWV/2qEPqjum/xakov8DiF3zxQcHgvemG5Ij
	 bSuRpQO+J/HO+v5FxXAT8eJY4ljttGk/aHDdUWncJAPz83fpUvP01A3FwFKXLXAFrsY9u
	 19fyJ2YqgvWaWdvn7i5swEnaP5arNkAPMW9WTEafeBD1y6i0yNP19IswUXmbBhAvlUwdw
	 RbatSMazprihFM85703LBDgqr1ZNcG9F20vx/Myou3yN9Ha9hwb4bYKaFC7TS2lIGzSt7
	 +CGlv27e9ZgS+agAWrKouMxrq2GY99j9Q21HwDOP7k0VOaNhhMpk7u1VfJ8ws1sk0fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I0N9r7L7oDU5D1bzVh3igTzDanE7q5iMGB/bfNl8288=;
	b=KZpTS9asY/mbb3jqdpeeK4+yUrTzCigOr8C2v0o+hbTZsXKZ5mG/ZLM2HxzHeFBV0vgo
	 4Fom/Kxcr+FMhqifAibCOTag6jy9k8ghJe8sQ8Vv87fSmqelm4LqwsWN/82xlmKELIwWK
	 /vAbl6DyS7CxEo7oHDyFUP0CRlkexYCZlrk41X6bNOZDHmGfO5khHYZ6ZRWaEsV8c3lSq
	 Z0aLHQKEe5lslY73UJDNn2lK0U+Nt9A+HmR3WcZPk95DOTR6VbEMYsnnH+Wts7MJ0T9Ly
	 3FwwlZ4lK73JIOh9nSszrhPrIP8kzSwAb+Qx37Icp3MwNaS3svYtFVp34TND1IGm93Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ruz0MPab;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FC160A261A;
	Wed, 18 Nov 2026 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ruz0MPab
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7531F000C8;
	Wed, 18 Nov 2026 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021734;
	bh=I0N9r7L7oDU5D1bzVh3igTzDanE7q5iMGB/bfNl8288=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ruz0MPab7eZPMFIEQa/qiEDwrByD/l1ZudEHubehq5UXY44JahFPZEmZF6pf1fE4+
	 VQoZwbPQ+4pPgIh/gJpRlhFijavukf6Dv1hPz8/ShOgSy08Tn6olwCFbC6eCRhwax2
	 0TASZKzhh53WCS/bMJlSulQFAgs+56cAhj1yG6qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2413/2651] ceph: mark the superblock active after mounting
Date: Wed, 18 Nov 2026 16:00:53 +0100
Message-ID: <20261118150412.161759951@linuxfoundation.org>
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
index 72935f665f11c..4306d6b3b995f 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1368,6 +1368,15 @@ static int ceph_get_tree(struct fs_context *fc)
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



