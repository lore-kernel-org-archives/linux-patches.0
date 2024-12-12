Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36CA215773;
	Thu, 12 Dec 2024 15:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016034; cv=none; b=l00C9GVCa4/KeP9RQ2dLZ9+bH4h5M7DOf4k+/lQVbkGTiHSBCsk+dmyzrkxvKHUALoS26Hh/nxPCG5bFs97yCSAmwauVUYiYy4rImmrIkw25zv0tulWFdV54YDuhAW/gmZuPNTee0kdmLimm9BnfwotzKrb+NUQv1Z9OBwaaCR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016034; c=relaxed/simple;
	bh=BRKd7JFQtDk+RGaKdymorSuonRdtVBBMM8fmDk1mWzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSB5afl9rg3YV2asl+CrBmKcfrUoY6m40mdGNCLX32t8KczHGIiVRVgxee2DsD+LYd5Qduf6tjl4Iw7ePBhZD+saf55UBXBcmvuIVAvDEf1Y2//qIx+eUA483JIzTkhfVyarh+VLwUZ2m30eHMu9xTvuVNmXU9RODXdboRDP+eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGe4SLqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGe4SLqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC382C4CECE;
	Thu, 12 Dec 2024 15:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016034;
	bh=BRKd7JFQtDk+RGaKdymorSuonRdtVBBMM8fmDk1mWzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGe4SLqvthasAE7QANnbi5GG+6hM7iEh6Kma7mMUrti3eaL8BBoytF9bEy02IqhIZ
	 z7b0fT+NjFxtMvyUo352uukL6aAE27S+QSQtnW95Wi1h3r6jLl/1+Nu0UjNvBNST/U
	 IyuOnacXXwSvg886FcqHeeYR+y2qExrh1xaOcsf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/466] scatterlist: fix incorrect func name in kernel-doc
Date: Thu, 12 Dec 2024 15:54:42 +0100
Message-ID: <20241212144311.282883742@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit d89c8ec0546184267cb211b579514ebaf8916100 ]

Fix a kernel-doc warning by making the kernel-doc function description
match the function name:

include/linux/scatterlist.h:323: warning: expecting prototype for sg_unmark_bus_address(). Prototype was for sg_dma_unmark_bus_address() instead

Link: https://lkml.kernel.org/r/20241130022406.537973-1-rdunlap@infradead.org
Fixes: 42399301203e ("lib/scatterlist: add flag for indicating P2PDMA segments in an SGL")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/scatterlist.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index e61d164622db4..1bad36e3e4ef1 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -313,7 +313,7 @@ static inline void sg_dma_mark_bus_address(struct scatterlist *sg)
 }
 
 /**
- * sg_unmark_bus_address - Unmark the scatterlist entry as a bus address
+ * sg_dma_unmark_bus_address - Unmark the scatterlist entry as a bus address
  * @sg:		 SG entry
  *
  * Description:
-- 
2.43.0



