Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BECD2F745E;
	Tue, 16 Jun 2026 16:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627862; cv=none; b=NYuvuMHVdQ4/JNmrii/QlWDruZ7vKum3Nrm/gpug5UgY/FVlpXM0jJYnLL26Ge3aCcfTdSz0iaPf0HRM2j1WbrUW0KsPnbomPYD2lGxV0EeaFOt/Cjvy90yuCJKUipJc9ZnEEa8ezu9uBmNI2MUNPYT+XoS3y6CKJkHUwyOMSr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627862; c=relaxed/simple;
	bh=2P2Loo3nnTjsA4i1pHx9XIYwrwwNqWYjfzwXN9rFs7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cR7RTpqxB6xRL4sIk+jVSBQSv6uQII+X8DbETADQMIwYiuy7It4///6GahUsIQ4MDDcQTcvrFH4RKZ1w23DBGEYT5GffBNwsNdHGUb2bX7WJGAMce2HChn6k/B6OYic8mdsDEoOZ5b9xnEF3yfTP7ZuPlrqxZ7nnTiIw+UyEPBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EC/ahIA9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EC/ahIA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871E41F000E9;
	Tue, 16 Jun 2026 16:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627861;
	bh=7FYIqr9DS1mEZQXYnmzI4Y2o5H9JGSN+g1wIlILrW/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EC/ahIA9LEzRR9+yZedZ+flodQPSEMv2ig9GYmrPdCXXUFpZtlmvPbHwcqZwMjJHy
	 m54/AxAcuMDM8QFhqr2KHLgWQf25Ebhc+y49gRzhLaLch3RXN3iZuLJVp2tzA2a8J7
	 l6JJXK9KMRgiEylH7brO4HWahzmrZnof1xSPes48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 240/261] RDMA/umem: fix kernel-doc warnings
Date: Tue, 16 Jun 2026 20:31:18 +0530
Message-ID: <20260616145056.194692260@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit ff46d1392750444fab5ae5a0194764ffdc4ac0d2 ]

Add or correct kernel-doc comments to eliminate warnings:

Warning: include/rdma/ib_umem.h:104 function parameter 'biter' not
 described in 'rdma_umem_for_each_dma_block'
Warning: include/rdma/ib_umem.h:140 function parameter 'pgsz_bitmap' not
 described in 'ib_umem_find_best_pgoff'
Warning: include/rdma/ib_umem.h:141 No description found for return
 value of 'ib_umem_find_best_pgoff'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260224003120.3173892-1-rdunlap@infradead.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 15fe76e23615 ("RDMA/umem: Fix truncation for block sizes >= 4G")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/rdma/ib_umem.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -90,6 +90,7 @@ static inline bool __rdma_umem_block_ite
 /**
  * rdma_umem_for_each_dma_block - iterate over contiguous DMA blocks of the umem
  * @umem: umem to iterate over
+ * @biter: block iterator variable
  * @pgsz: Page size to split the list into
  *
  * pgsz must be <= PAGE_SIZE or computed by ib_umem_find_best_pgsz(). The
@@ -117,7 +118,7 @@ unsigned long ib_umem_find_best_pgsz(str
  * ib_umem_find_best_pgoff - Find best HW page size
  *
  * @umem: umem struct
- * @pgsz_bitmap bitmap of HW supported page sizes
+ * @pgsz_bitmap: bitmap of HW supported page sizes
  * @pgoff_bitmask: Mask of bits that can be represented with an offset
  *
  * This is very similar to ib_umem_find_best_pgsz() except instead of accepting
@@ -130,6 +131,9 @@ unsigned long ib_umem_find_best_pgsz(str
  *
  * If the pgoff_bitmask requires either alignment in the low bit or an
  * unavailable page size for the high bits, this function returns 0.
+ *
+ * Returns: best HW page size for the parameters or 0 if none available
+ *   for the given parameters.
  */
 static inline unsigned long ib_umem_find_best_pgoff(struct ib_umem *umem,
 						    unsigned long pgsz_bitmap,


