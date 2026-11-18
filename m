Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027900;
	b=wYDC+lwdgAer9Ky32QO+m6qly4YkDYlzXk2/wQXn/NkFHzN5wS+AWyZGbqBopxKJ2FXW
	 S2IUSMW2tQ7+xvu/DC0JgQoFC9lB4VCoahXjd/U/58i8ydFviKUFqGdUkQZFUMc2Iu0FN
	 9TsLJ41+R1h9MAgZlQdoo2hkXeLQBB3B9V4iAbO76XwiQmInMuk7Q/CPvvuMDIYfJLvZ2
	 cgAscHEiWJ8N4a53k4i/NmeAaSALa7GvGvcIPorhzrdsDtV52fwKqZAvHc2ccuDnClf/X
	 IhFFYuOPKQx6ls+Dq2i0YXW4xn/QATlXRrSSVyRmd5xfdJqxvG0VqDBiLxLeUM7vyIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=95xfdOLuElKCyHh6UVVdtwV5I2wIRym0Re+ql6h5zKA=;
	b=ejWLtkSf+8otv1HP00le8o7e+o7K2aTtUguAERFqhA6VanLu9t9cgyimIBO8uZV77d5M
	 2u6XyC6vpaGv7VowboX0fDwI7NjgFx0qxIZPKXXgYURSaR4geeTCioGWqljPDOhfGFznW
	 fCUqcxXIBBuXC2CR3DJbGK2uiS6dS4FkiUFsblLjvqOTvY1Rfmth4hiPTsKg5iX/+47b6
	 apeLId8lFHQ8ug2UsPpSH1awP+GYjiEBdHy15YZCLMNh4YhMLau3qdSb0Kb3+ym9/avDy
	 UsZTrOcCdF9XaiPZxTUhIOkSwc/eZwpuaTDnlTqUYMqMWIMYiirAkWpzhNMjWFNsnDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YcvEWsqm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2AE606A325;
	Wed, 18 Nov 2026 18:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YcvEWsqm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40B61F000C4;
	Wed, 18 Nov 2026 18:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027900;
	bh=95xfdOLuElKCyHh6UVVdtwV5I2wIRym0Re+ql6h5zKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcvEWsqm6C2CFYADMkggot/ISe78UNk+h251pp2H/NGNaXRisruie+JUFy9p4FPJ0
	 j/PpRJKjE37BrAX9GGH1gNa6FAoQwVYqTfe29w4esjolsfV2MjhfnVsr2hRSeKqd5O
	 XP27hC/2+lFdE0IWw9EKIwwtyibI4pmRVaZs7KWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1951/2151] ceph: mark the superblock active after mounting
Date: Wed, 18 Nov 2026 16:01:26 +0100
Message-ID: <20261118150232.831395115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f6bf24b5c683e..4ca777f30a48e 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1347,6 +1347,15 @@ static int ceph_get_tree(struct fs_context *fc)
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



