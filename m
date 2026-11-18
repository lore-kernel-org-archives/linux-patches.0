Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056897;
	b=vGV9ZpfLEp8jTYHMPH5bn/kuNUCvwggWdbLHj0w7qyrZeDAFdNrE7q4XVky2/NKLfGGY
	 NuWBDP+tIPEK4jLvy9OFPITaYhU0iGMUXZ48sU20FRjfEmrxSOnLhTyNUDf8QqTwvz1Kx
	 wBBSzRaEZ9hAq+GtXgvGOXJ8qNyvq5wveBKILPNSMSS/ahq+UelvVRViKuFhIaqLdF+HZ
	 DuE2ks3+JhLLF7QfaKwnDU0OkcWbKIT9eCr9DBqLK6eJhPw/jast98Yxil9ilUe0swcyw
	 /7YWGN93wXq5WaAmUn0Q//QAy1EYfPrqIyb0UtvLtKXcB4qoULQZVDfQT42Y4utXNhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Do2PsKGYV0hbKXCOpl8r5VM+jGubeVokSgNqvgeIddo=;
	b=uP3W+/8wKF+RFRzo/ok3SAUJ6mRUqvboFB2wJYCyot0aw6IfMOvBU6SrEX5dE5d5Ti6B
	 N4GN4t2apAfk4OM36GmiddvVX7mO9XAxq/nJe6329CLSZqnqbRTGXs9Zlo6EZ9M5swB2K
	 6ZHzPLyT9hD606G+8i0EwAMeXEhVTdKP8z6zv//WntdCogKXkipuI4/0QbIvkhdMg+MI9
	 1qQRBXaVObEOxKJyvupp1to/k6Vml0QuIlwqUzYrkfn/+nvB143L0hlYmikKhr4QyT85T
	 VXEskNGqwqhom/mCJjb7EM3TcOIlJwxi96nfH4E++WlXzAKKR02J/5KJ6GAgwVh9wkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GiaUOCQk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EF0606A31C;
	Thu, 19 Nov 2026 02:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GiaUOCQk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569B71F000C4;
	Thu, 19 Nov 2026 02:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056896;
	bh=Do2PsKGYV0hbKXCOpl8r5VM+jGubeVokSgNqvgeIddo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GiaUOCQkzfjZqoRVvJTGV1JGl2couOfwrfn67AdF0pNShW99s9FA0Kmjjj0ucAYj0
	 pm5TpgavPt1jNg1G5hOUMbl9Lc+DbhIC7a3hx9RIi5IAXHV8KP1DAM4WKxkLRd8shl
	 kMsm02h2gXZ05tUst/knMmorh71hXI9HIXbdoY6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2124/2214] ceph: mark the superblock active after mounting
Date: Wed, 18 Nov 2026 16:03:20 +0100
Message-ID: <20261118150135.536811390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e520ad25454a9..ff771715f6d5e 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1118,6 +1118,15 @@ static int ceph_get_tree(struct fs_context *fc)
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



