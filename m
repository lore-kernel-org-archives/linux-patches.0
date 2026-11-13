Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590390;
	b=RN47WuaAqYjxM4GrV0gwdva2ZWGXalVaU/E7sXBxDX+OkjQASE/LSzsdjQIG5854/BwU
	 oWEywl/OmlZ9G9agoh1dmfYNTLW8GSI2tqZHaR4qYBh9tHoW7pstupR1eEWkEaza5srzn
	 yA8Mn42K+v+dVi2E5GzguQunt94sQK4+7iIQ5yB61ckZ84/jIQUN8/eRTfGIyR2l7aWij
	 K70KNrgZRj0qu0Ioswc0v9r7UnCGAN+9wdNW0klgQkMSE7a4c/D0Vxq5DoJzYGbfcEk7L
	 UMAfVRs7xSAxbI6DF0w7tJGlx6wYxz55sixzvMin5g7pC3wFedfsZqvQi0IP8ZZtLvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QzqLauJ6g2U1TCabKgmxHvkRHklKQCGtdvbyeX4ZIMg=;
	b=QchKbN0WUAo055qLfymo9Rt7OL1RwOnXqUb5J7v4tN02kcqSXRI1dfQyI8jO5BO8jSwu
	 jHjaLR0MfNP0DeYKhaCbA1irTSIidx0BXefi8sAWAXTYrB7wYvTPOWuMZdSPLziKsmBqW
	 UR6QPeiXWg0Xd8N0RWtP0DDXo3MCTxiqsqNKmZuolxfBqoua/+wRNLUPZRFfaYyPGaUIV
	 ZJd9pXNCTBE8RUKV6iU8BuGjS7rvYBJLTBVtuyAKJeMZSpngN845FsALdS9EOZcVme48c
	 xtvh1GVh/HkhAhPVOpuwMBF7/zE+r3Fm3oGCfsOvLJESD7jk7IkYNwzP2xlgWjJqKQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJQN1zvc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670CA606B348;
	Fri, 13 Nov 2026 17:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJQN1zvc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C011F000C4;
	Fri, 13 Nov 2026 17:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590390;
	bh=QzqLauJ6g2U1TCabKgmxHvkRHklKQCGtdvbyeX4ZIMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJQN1zvc4MowcetIgipjaT0O2AILV093DhxFvVeCIdYaCOTWX3Bu/rxXoLBUtALLh
	 T8kDLuaCSQv/iO18fBbDzYL2FfF1oEp26dqIVXC7nzaox38ipZM+CK/+Wm0XeP65dH
	 NJ+Uf/jCLfS2YjJ4B5gRuJ1GXjUbMWoZGjWxlIwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 358/686] xfs: clamp the pNFS layout range to the maximum file size
Date: Fri, 13 Nov 2026 10:48:11 -0500
Message-ID: <20261113153833.039790937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 29f3c1be4e554c9dbc66e13333034e0947477cb6 ]

xfs_fs_map_blocks() lets two bad layout ranges through. An offset of
2^63 or more is negative and passes "offset > limit". A length above
the limit, such as NFS4_UINT64_MAX, wraps "offset > limit - length"
and stays unclamped. With NFS4_UINT64_MAX, a read layout is built from
an uninitialized mapping.

Reject a negative offset and one at the limit, and clamp the length.
This needs "xfs: cap the block count of xfs_iomap_write_direct() at one
extent".

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_pnfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index b880d061ee90c..298fdc9e9f1c3 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -177,10 +177,9 @@ xfs_fs_map_blocks(
 	if (!write)
 		limit = max(limit, round_up(i_size_read(inode),
 				     inode->i_sb->s_blocksize));
-	if (offset > limit)
+	if (offset < 0 || offset >= limit)
 		goto out_unlock;
-	if (offset > limit - length)
-		length = limit - offset;
+	length = min_t(u64, length, limit - offset);
 
 	error = filemap_write_and_wait(inode->i_mapping);
 	if (error)
-- 
2.53.0



