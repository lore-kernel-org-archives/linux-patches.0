Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21C747AF43;
	Tue, 16 Jun 2026 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630230; cv=none; b=TA+e9qhR7s5IW8a9sPUnAfaOcdQoi3UzgvBGfQ2IhCPyttbze1huehzsJvRV9qpKAbe+Bx8wpurjuN9RHh44OihwKheDzGwre7bg3TxNKPB0bGquH/+935QlV1knhFe1lDYO9tm5f8uIhLVYyP8vr42DQTlq+QUOFmop/j9Oo74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630230; c=relaxed/simple;
	bh=6D7TnaJG9IOs/wEwklVWZzRndRVJ2nFjTZahwybsjs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkTk4kVPKMRd5FvfPsVogpZFlIgGUbxSgAh3vOpe3n2S5iBX4yAKwgN542w7vJiYDaWJVAugrDAEijz0InNWvv1LNb9NZxvEyXGqa9+OY6vERLR7y15si0kbZtgHx+920KvkTbDN71ZQSZ1JAtkCve7CQKTnrMS8GAa9osOVUTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZKcMpUN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZKcMpUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C968E1F000E9;
	Tue, 16 Jun 2026 17:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630228;
	bh=BS/L4jxbfMbGF4VwhGPh42uPx35PT699kS8EAQ2AeUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZKcMpUNhHILT0qhSpMWep4qFgiCSwMq4tNgT+WrAWqEz1uFKJsvN45Lea41dzLyG
	 p3l41EbiEIXFx7KBkauJL0qkxztPMde+GEJvQGWFI+o1CIgE/N3Xqk/Eqw5NpNbfdM
	 6cRfFxnZZPY7edRn4zTklSrUr+OmJlCUbI7B+hKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 435/452] RDMA/umem: fix kernel-doc warnings
Date: Tue, 16 Jun 2026 20:31:02 +0530
Message-ID: <20260616145139.482640304@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -89,6 +89,7 @@ static inline bool __rdma_umem_block_ite
 /**
  * rdma_umem_for_each_dma_block - iterate over contiguous DMA blocks of the umem
  * @umem: umem to iterate over
+ * @biter: block iterator variable
  * @pgsz: Page size to split the list into
  *
  * pgsz must be <= PAGE_SIZE or computed by ib_umem_find_best_pgsz(). The
@@ -116,7 +117,7 @@ unsigned long ib_umem_find_best_pgsz(str
  * ib_umem_find_best_pgoff - Find best HW page size
  *
  * @umem: umem struct
- * @pgsz_bitmap bitmap of HW supported page sizes
+ * @pgsz_bitmap: bitmap of HW supported page sizes
  * @pgoff_bitmask: Mask of bits that can be represented with an offset
  *
  * This is very similar to ib_umem_find_best_pgsz() except instead of accepting
@@ -129,6 +130,9 @@ unsigned long ib_umem_find_best_pgsz(str
  *
  * If the pgoff_bitmask requires either alignment in the low bit or an
  * unavailable page size for the high bits, this function returns 0.
+ *
+ * Returns: best HW page size for the parameters or 0 if none available
+ *   for the given parameters.
  */
 static inline unsigned long ib_umem_find_best_pgoff(struct ib_umem *umem,
 						    unsigned long pgsz_bitmap,


