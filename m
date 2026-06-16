Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E504318EDA;
	Tue, 16 Jun 2026 19:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636842; cv=none; b=uWSwStN/5ChrD+1o7VtW/VwZfRz46OzM4Gb1WiwQ+bTpcmRW4f5rMfmlyaiwyA0Ab52P1mEBz7k3DwzR4MXWfRqwvNqWk6QP0yLm1blBnFHWGSdds0nrwebGYS20aZQh/7v5QcKEKRhQEA11kV+XMQNAEKEyS7CnhTg4e3lxB/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636842; c=relaxed/simple;
	bh=ZMSeKuyau0Nhsw9Z5cfx92EW/DBRV/k7Ly4dkc84FCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjpXcqlh6sWGFdLV5eFaWfDkRjRhIstO/qVSgM2vqf3qpYG+9rPGI2+/s/fN3SftlWL0iRi1ah690Gy5snCs43bOSd1zRkHwFfGAKf+OLEYl2I1crVqgqChSTCqDzo1aZnYeYqIwf9FxKJRGE/IJ3qLfKWR0ZKackrVc3V/Kc5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yg9/UdrO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yg9/UdrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9352A1F00A3A;
	Tue, 16 Jun 2026 19:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636841;
	bh=oR5LobTnZSBAi2x+v8EU4sgoKmm3JxUJeIhagJpnaek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yg9/UdrOSC7xLd2J2z4exZqbpllxfmA2KWKqERfvxE6LxOu6YgOeUstIltxzwkXJb
	 EaMnSP246cDA8TDLc3U/xu4GJCnhjGR1bKNUbpaADWnqv8hWKXJP+ebt8wQBG5xoi0
	 lBTb5Nh38lULYfh4QIpX4X0FInTmPS9myVOpQ8OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 314/342] RDMA/umem: fix kernel-doc warnings
Date: Tue, 16 Jun 2026 20:30:10 +0530
Message-ID: <20260616145103.125594650@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 include/rdma/ib_umem.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -57,6 +57,7 @@ static inline void __rdma_umem_block_ite
 /**
  * rdma_umem_for_each_dma_block - iterate over contiguous DMA blocks of the umem
  * @umem: umem to iterate over
+ * @biter: block iterator variable
  * @pgsz: Page size to split the list into
  *
  * pgsz must be <= PAGE_SIZE or computed by ib_umem_find_best_pgsz(). The


