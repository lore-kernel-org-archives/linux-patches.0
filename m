Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4185C134AC;
	Tue, 21 Oct 2025 20:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076993; cv=none; b=iQ8NVhJRk2TH2bW1csHpMze50tw7rCaGf5hRSiYiFPXX4kejpkOrizC1AfnxAZBe9HuEhXP5AJHKERViicE2snlonbfaASwEqlYe1QxK8yxEhHVJWHuAyouEylTtUzprgoBV3EMfhl5dlO+gBfO2BSsPj24wBi+HD5fZj979oVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076993; c=relaxed/simple;
	bh=kDVZbe5zguTu9oivbNjs7kK/FFeZUHk4iEEUZWLhiGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oxf+pCh03Gqdf4TXCEKPXfoWjz/JmBRDGtOI4Hu8tm0Rz3OGgzkAQ1P6RPYFxKu0ZhL9nsb/GaNpA7ZzZEheY6DF9O/pKm0YRGX1ct/Kyf8G+1HlGRMpUvoUMsBVs+Nf0NS2t81GXRXYzZtKgZt+eiG/mt2jF7ogt/Wfrg18hvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yq+1Qol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yq+1Qol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB805C4CEF1;
	Tue, 21 Oct 2025 20:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076993;
	bh=kDVZbe5zguTu9oivbNjs7kK/FFeZUHk4iEEUZWLhiGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yq+1QolasnUS2Wm7lJi2UUPT+sTPZU+InJP1fXF44OT+8VtRs/pNCEew9gnS7pr2
	 3kD6yE4dgpCO8NfASXdBN0/0CP8BB+YXv8y3AI0tN2EkMKlStkZ7avTaDrrWe6qBHK
	 TH0bcyuunL5HJVoWJSkei1QtEXrdBSRT199R70BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/136] nfsd: Drop dprintk in blocklayout xdr functions
Date: Tue, 21 Oct 2025 21:51:31 +0200
Message-ID: <20251021195038.438521583@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit e339967eecf1305557f7c697e1bc10b5cc495454 ]

Minor clean up. Instead of dprintk there are appropriate error codes.

Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: d68886bae76a ("NFSD: Fix last write offset handling in layoutcommit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/blocklayoutxdr.c |   40 +++++++---------------------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

--- a/fs/nfsd/blocklayoutxdr.c
+++ b/fs/nfsd/blocklayoutxdr.c
@@ -139,28 +139,19 @@ nfsd4_block_decode_layoutupdate(__be32 *
 	struct iomap *iomaps;
 	u32 nr_iomaps, i;
 
-	if (len < sizeof(u32)) {
-		dprintk("%s: extent array too small: %u\n", __func__, len);
+	if (len < sizeof(u32))
 		return nfserr_bad_xdr;
-	}
 	len -= sizeof(u32);
-	if (len % PNFS_BLOCK_EXTENT_SIZE) {
-		dprintk("%s: extent array invalid: %u\n", __func__, len);
+	if (len % PNFS_BLOCK_EXTENT_SIZE)
 		return nfserr_bad_xdr;
-	}
 
 	nr_iomaps = be32_to_cpup(p++);
-	if (nr_iomaps != len / PNFS_BLOCK_EXTENT_SIZE) {
-		dprintk("%s: extent array size mismatch: %u/%u\n",
-			__func__, len, nr_iomaps);
+	if (nr_iomaps != len / PNFS_BLOCK_EXTENT_SIZE)
 		return nfserr_bad_xdr;
-	}
 
 	iomaps = kcalloc(nr_iomaps, sizeof(*iomaps), GFP_KERNEL);
-	if (!iomaps) {
-		dprintk("%s: failed to allocate extent array\n", __func__);
+	if (!iomaps)
 		return nfserr_delay;
-	}
 
 	for (i = 0; i < nr_iomaps; i++) {
 		struct pnfs_block_extent bex;
@@ -170,26 +161,18 @@ nfsd4_block_decode_layoutupdate(__be32 *
 
 		p = xdr_decode_hyper(p, &bex.foff);
 		if (bex.foff & (block_size - 1)) {
-			dprintk("%s: unaligned offset 0x%llx\n",
-				__func__, bex.foff);
 			goto fail;
 		}
 		p = xdr_decode_hyper(p, &bex.len);
 		if (bex.len & (block_size - 1)) {
-			dprintk("%s: unaligned length 0x%llx\n",
-				__func__, bex.foff);
 			goto fail;
 		}
 		p = xdr_decode_hyper(p, &bex.soff);
 		if (bex.soff & (block_size - 1)) {
-			dprintk("%s: unaligned disk offset 0x%llx\n",
-				__func__, bex.soff);
 			goto fail;
 		}
 		bex.es = be32_to_cpup(p++);
 		if (bex.es != PNFS_BLOCK_READWRITE_DATA) {
-			dprintk("%s: incorrect extent state %d\n",
-				__func__, bex.es);
 			goto fail;
 		}
 
@@ -231,38 +214,29 @@ nfsd4_scsi_decode_layoutupdate(__be32 *p
 	struct iomap *iomaps;
 	u32 nr_iomaps, expected, i;
 
-	if (len < sizeof(u32)) {
-		dprintk("%s: extent array too small: %u\n", __func__, len);
+	if (len < sizeof(u32))
 		return nfserr_bad_xdr;
-	}
 
 	nr_iomaps = be32_to_cpup(p++);
 	expected = sizeof(__be32) + nr_iomaps * PNFS_SCSI_RANGE_SIZE;
-	if (len != expected) {
-		dprintk("%s: extent array size mismatch: %u/%u\n",
-			__func__, len, expected);
+	if (len != expected)
 		return nfserr_bad_xdr;
-	}
 
 	iomaps = kcalloc(nr_iomaps, sizeof(*iomaps), GFP_KERNEL);
-	if (!iomaps) {
-		dprintk("%s: failed to allocate extent array\n", __func__);
+	if (!iomaps)
 		return nfserr_delay;
-	}
 
 	for (i = 0; i < nr_iomaps; i++) {
 		u64 val;
 
 		p = xdr_decode_hyper(p, &val);
 		if (val & (block_size - 1)) {
-			dprintk("%s: unaligned offset 0x%llx\n", __func__, val);
 			goto fail;
 		}
 		iomaps[i].offset = val;
 
 		p = xdr_decode_hyper(p, &val);
 		if (val & (block_size - 1)) {
-			dprintk("%s: unaligned length 0x%llx\n", __func__, val);
 			goto fail;
 		}
 		iomaps[i].length = val;


