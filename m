Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061022;
	b=5V9G8DrJ9pMg2ou9CwMHL8ATyFi5grI2Rs2rtmA+sYDaYzQAscRKNLfCZRmS7ByHhSBP
	 rXb3Hy6VPLwyQfy+wKk769QNGa/5UY1yWYEDUtPYD3iwuPSvWzE65F+JaN9CNNFJklo64
	 okL2eBUC7l2bSUIguKtBlC1iXPHHxaRPn9IFdbpBUxTzFICT0m/0uA4Z0FqKxW69ls96H
	 mDIc8YzceAdx+o96aDlwuGqZnHSXfawoCEeG36fDh7uem47p6AxOiCR5N2qQg4IhSaKv4
	 UDjZvnjQT35hTlBrTBIIzgE2gbPrfBZ4Tbl1T4fLfNVykbesY1v80pA4KY2O2owN3NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rrOS0LZALFqRuEOgMoCyC0VNqClLzub6kWslokmnSvg=;
	b=LmiEjSPVhjHe/Z6qI2c2bkkIo3Nkl5Ce1tQY4qyZy+XJQSHUj7s3kit8AYcKpKvdRIbo
	 4b5v3cyVlnaY7XNA3ZklV3jvXjQipUeUQ23qK1wta+V/arDmVwYFNBDlTYAWObvfWR24S
	 Nsi+x3aAcRemIte4UoryFi+7MIJzE6koLUpOQs5wuSn7mWHtZ7B2D6m6oheHAYJ2msrwV
	 WfQb7Uue8okuZje7H9OP7oAgADNL8ULWci54eoUosJwEHAqCqFOcgyeB9hMM3teKY+2fx
	 /vdeukW/YWOs11TT3GAtmDtmXKk71GNQ7rf/dwlMFj9SXtehGLuLBLhzYw6q8FweFAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Iptz+lR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F946082BE2;
	Sat,  7 Nov 2026 14:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Iptz+lR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5771D1F0089F;
	Sat,  7 Nov 2026 14:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061021;
	bh=rrOS0LZALFqRuEOgMoCyC0VNqClLzub6kWslokmnSvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Iptz+lRV6xfELD9KoJbWqJ0qoUzsJrsqCsBvUo1zxhFyKBfZB6C/6SHh743xXFqG
	 sd7785qQG6cQBxenDHuXQpTO83y5ugwslQ1hE8VcQc1uOO4kH4tC65b7oLhC1/fywJ
	 V43dJtTLB7D8rhRFLiZ69CHk0N7KmMPpyoZnN754=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Liu <liuyun01@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0359/1536] NFS: Verify symlink inode before caching target
Date: Sat,  7 Nov 2026 08:39:35 -0500
Message-ID: <20261107135007.742798291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 3265f1998ae9a9282a8a6ca95467d9572d6ebb82 ]

nfs_symlink() copies the symlink target into a folio before issuing the
SYMLINK RPC.  After a successful reply, it caches that folio in the
instantiated inode mapping and assumes that the dentry now names a
symlink.

If the dentry is instantiated with a non-symlink inode, the raw symlink
target folio can be inserted into the wrong mapping.  When that inode is
a directory, reclaim or unmount later calls nfs_readdir_clear_array()
through nfs_dir_aops and interprets the symlink target as a readdir
cache array, which can lead to invalid kfree() calls.

A vmcore from a 4.19-based kernel showed the crash when reclaiming a
directory mapping on unmount:

  Stack trace:
   nfs_readdir_clear_array+0x4d/0x70 [nfs]
   page_cache_free_page.isra.35+0x1a/0x90
   delete_from_page_cache_batch+0x1cf/0x2c0
   truncate_inode_pages_range+0x24d/0x910
   [...]
   nfs_evict_inode+0x15/0x30 [nfs]
   evict+0x115/0x2b0
   dispose_list+0x48/0x60
   evict_inodes+0x16c/0x1b0
   generic_shutdown_super+0x3f/0x120
   nfs_kill_super+0x1b/0x40 [nfs]
   deactivate_locked_super+0x3f/0x70
   cleanup_mnt+0x3b/0x80

The current code still has the same unchecked cache insertion pattern,
so it may be susceptible to the same failure mode.

Verify that the instantiated inode is a symlink before caching the
target folio.  If the type is wrong, drop the suspect dentry and skip
the cache insertion while preserving the successful SYMLINK result.

Co-developed-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 5c9c156838678..0356b80e4a357 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2648,6 +2648,12 @@ int nfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		return error;
 	}
 
+	if (unlikely(!d_is_symlink(dentry))) {
+		d_drop(dentry);
+		folio_put(folio);
+		return 0;
+	}
+
 	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
 
 	/*
-- 
2.53.0



