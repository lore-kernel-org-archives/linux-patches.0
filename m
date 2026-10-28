Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215035;
	b=upx0A0sXroO2hb/d5A6/oBRdt0oxAHSAwOTeMJuPytsrsaCjhEeqVGbniAlU5vizul8A
	 w7aNPaIsRNg1KljOi3scf/qRmX1IDlo6j8/Sn6gWZdmO4hnnWf59lM1SUVUCzlfYeeD8j
	 9V/4Iqs7zO7OACbZvEo+Pv10zHwTcDlVSRE/82bU6aNubMMIVD7yxbz0N535Ij/LFE4Pw
	 7RvKZ2CiVrdauvXK1E6E2SMsmgQfAY4qCJPvdEoxGwANEEsj89XZCqAfHj1MuxRm/zEQ4
	 1jxF9xvYBKB9AHgzp5iD93YsqwxPeS7KeT0W/4xvER6x2vNTh7KQxF9wrbBzx2yOoAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2l1uB1uJGmdOnR6sASxgIYlyyUMdiXyktbn7CF+D/Y4=;
	b=Z1UKx2vJIPLEeiRpWDUbu715+V3rgTJGlHTFODMdIOKx1skdWLHoCiQNgpUS2wbBav0n
	 UUiieocysMtDSDYKym3H6Zx9siSBJt5+zOiSYzLy7eWTMxR2NmUVv5K5YsBU3VgBbpBNx
	 CVhlvt6fchS+/qGimCxF1n+13OZGciObmWZfEpHQ3NDjtMljVfWCz3vdLD4tLE6Xeve6r
	 DFf3gRLLMIunIT7vVCk8hZiQY/3js9AYUhhAyOTJBlNOwn0CDyKXMAKSXazpI3puBe+In
	 idE49ognbID9XAxmwwWVmgE9n+T4e7fxdXqhwQfalpXkoj3hxc8kmgSLUVCKQKjXoIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mIFGEsoL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5257606A31A;
	Wed, 28 Oct 2026 19:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mIFGEsoL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B5C1F01825;
	Wed, 28 Oct 2026 19:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215034;
	bh=2l1uB1uJGmdOnR6sASxgIYlyyUMdiXyktbn7CF+D/Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIFGEsoLPfenYTWUPz6MoXQwO9ckxstz3YsM1PTHCsHl/OuNlLawVnGRp7/3pLsrN
	 bM13p+CM9xVpjkNy36OWQWQ+FA7PwZi5n0oktBvBgoJbREJP+nvC/AXzUOrUuN3B8k
	 lNcA3WBH1oODXTVKAxFGAdsQMJJg33giFyDrvYWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Baokun Li <libaokun1@huawei.com>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1042/1887] ext4: dont set EXT4_GET_BLOCKS_CONVERT when splitting before submitting I/O
Date: Wed, 28 Oct 2026 17:52:18 +0100
Message-ID: <20261028170523.123584455@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit feaf2a80e78f89ee8a3464126077ba8683b62791 ]

When allocating blocks during within-EOF DIO and writeback with
dioread_nolock enabled, EXT4_GET_BLOCKS_PRE_IO was set to split an
existing large unwritten extent. However, EXT4_GET_BLOCKS_CONVERT was
set when calling ext4_split_convert_extents(), which may potentially
result in stale data issues.

Assume we have an unwritten extent, and then DIO writes the second half.

   [UUUUUUUUUUUUUUUU] on-disk extent        U: unwritten extent
   [UUUUUUUUUUUUUUUU] extent status tree
            |<-   ->| ----> dio write this range

First, ext4_iomap_alloc() call ext4_map_blocks() with
EXT4_GET_BLOCKS_PRE_IO, EXT4_GET_BLOCKS_UNWRIT_EXT and
EXT4_GET_BLOCKS_CREATE flags set. ext4_map_blocks() find this extent and
call ext4_split_convert_extents() with EXT4_GET_BLOCKS_CONVERT and the
above flags set.

Then, ext4_split_convert_extents() calls ext4_split_extent() with
EXT4_EXT_MAY_ZEROOUT, EXT4_EXT_MARK_UNWRIT2 and EXT4_EXT_DATA_VALID2
flags set, and it calls ext4_split_extent_at() to split the second half
with EXT4_EXT_DATA_VALID2, EXT4_EXT_MARK_UNWRIT1, EXT4_EXT_MAY_ZEROOUT
and EXT4_EXT_MARK_UNWRIT2 flags set. However, ext4_split_extent_at()
failed to insert extent since a temporary lack -ENOSPC. It zeroes out
the first half but convert the entire on-disk extent to written since
the EXT4_EXT_DATA_VALID2 flag set, but left the second half as unwritten
in the extent status tree.

   [0000000000SSSSSS]  data                S: stale data, 0: zeroed
   [WWWWWWWWWWWWWWWW]  on-disk extent      W: written extent
   [WWWWWWWWWWUUUUUU]  extent status tree

Finally, if the DIO failed to write data to the disk, the stale data in
the second half will be exposed once the cached extent entry is gone.

Fix this issue by not passing EXT4_GET_BLOCKS_CONVERT when splitting
an unwritten extent before submitting I/O, and make
ext4_split_convert_extents() to zero out the entire extent range
to zero for this case, and also mark the extent in the extent status
tree for consistency.

Fixes: b8a8684502a0 ("ext4: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Cc: stable@kernel.org
Message-ID: <20251129103247.686136-4-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5f588728a27fb..ed62b52473580 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3730,11 +3730,15 @@ static int ext4_split_convert_extents(handle_t *handle,
 	/* Convert to unwritten */
 	if (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
 		split_flag |= EXT4_EXT_DATA_VALID1;
-	/* Convert to initialized */
-	} else if (flags & EXT4_GET_BLOCKS_CONVERT) {
+	/* Split the existing unwritten extent */
+	} else if (flags & (EXT4_GET_BLOCKS_UNWRIT_EXT |
+			    EXT4_GET_BLOCKS_CONVERT)) {
 		split_flag |= ee_block + ee_len <= eof_block ?
 			      EXT4_EXT_MAY_ZEROOUT : 0;
-		split_flag |= (EXT4_EXT_MARK_UNWRIT2 | EXT4_EXT_DATA_VALID2);
+		split_flag |= EXT4_EXT_MARK_UNWRIT2;
+		/* Convert to initialized */
+		if (flags & EXT4_GET_BLOCKS_CONVERT)
+			split_flag |= EXT4_EXT_DATA_VALID2;
 	}
 	flags |= EXT4_GET_BLOCKS_PRE_IO;
 	return ext4_split_extent(handle, inode, ppath, map, split_flag, flags);
@@ -3899,7 +3903,7 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 	/* get_block() before submitting IO, split the extent */
 	if (flags & EXT4_GET_BLOCKS_PRE_IO) {
 		ret = ext4_split_convert_extents(handle, inode, map, ppath,
-					 flags | EXT4_GET_BLOCKS_CONVERT);
+						 flags);
 		if (ret < 0) {
 			err = ret;
 			goto out2;
-- 
2.53.0



