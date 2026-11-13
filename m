Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585673;
	b=M9PBQUrxS9hpsKDQPa8IkdiHXGFsreVSXSySUQX8gBlMpozua2x8CG8pDa8fz7mv5XsW
	 9E4s6jpKvnHe8RMKmhziE8CVCp+Fi7PGzhVcN+uZgjegTKMIU7HqIcPh2NfKe9LSI0uth
	 WBNUnNNfAItWTvlil4ryJc7YPwhygGrc9BROA9J4Mii4N0MlezhgyGRHynMVKPTBn2IFn
	 BZKx9q8s/2ibKg6duWBGjfBKrPnaWdl06n8Hn2HX6ooGXQP6pBeeMuyZbG0aMYPI97DdZ
	 nBvX+pcIPqUzKkkHGGOydev4Hst204jt5x1b9+B25uqLwLnwq/kjiEMtbgQ3aOouqaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ILJ6oNMvAlVIq01zIsKCcGxhbQvXRyAGGA25dJkd7l8=;
	b=qx7DXJ4PSVBUfVqO7fbUC68Emk2OVnPm0PkOtV3ijUg9EdfL/XDjMUFu9lfuGeg2TkGZ
	 VmcfD+XpExmpzdscYiz14Ll5X/IVQAs6BihuyY92bU1t6uYdB/h24r7UFJZoEZzXHQ8zx
	 a3aSiZM96l1zXwJX4bNRXcEGiR/kpEBI5AlMf+JJvbqKqZE55XvGaX5o5UkBqpWMV/xcT
	 AEkr7s1UlfhXJzjrhvvHGo1bRkm5kvEFbD8kE/f6aQ6h6PpDPsBVjz9npBCeAccURYojZ
	 2yBW13VpCmGYeB4NghZeULMhX/hjnGM7yZPd48AssUw4nyL4OoX5ElXL1SnNiLKkK0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XKUYlckA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1074560744C9;
	Fri, 13 Nov 2026 16:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XKUYlckA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41EB1F000C5;
	Fri, 13 Nov 2026 16:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585672;
	bh=ILJ6oNMvAlVIq01zIsKCcGxhbQvXRyAGGA25dJkd7l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKUYlckAXNrDBHtnhKkoFFaVA5H5sQZ7Nv5bcWoGM64ESKiitZOhpaiKauiF4qqbB
	 S06vJGr6jS5vdqjzJVKlsV2BctXAFNDFO9T2hxQn/HwFIGSEpV9k543iDQGELoUglU
	 q5BZ0FwR8KtJnDdIsUzVZZ0KJovNkwabHtTJX1q8=
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
Subject: [PATCH 7.3 286/507] xfs: clamp the pNFS layout range to the maximum file size
Date: Fri, 13 Nov 2026 10:49:50 -0500
Message-ID: <20261113153804.964086571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 19eb18e1290cf..7153e7a1e1de6 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -176,10 +176,9 @@ xfs_fs_map_blocks(
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



