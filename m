Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617707;
	b=C5tlRJX0wpEMiGQtxP8HOi8PK+wVPTzjvae9GpLB1x/jSqCJpDL34oViJU5NFQ29YR6t
	 /PHNFI7gaA59SoWVvUFqEe/tQBf5gKLNdUH+1BAYIh2P+g+Lq4+bk5FESuzYPtCpJIjFC
	 QIlt9TOKkG/EjQMqVTzcv75hNLlxFa0Y9x6rF1TvZtW34E//MdjvYAypBgLTkciJbO6Te
	 3FkCXu49xaVLxPoCZSA8SF92zNf2RhJYPDuMZ/jczjybeGSCG7FWbV8bLWuiIPrUsDTod
	 ty/vLOxXJexYrvKDiNC1Y8rt8UBzd81OcUiXBUmo7m2/3rLy+WiGDuW+YNnULKlXFeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=o3jQAbrFipgda4UFqfdefnc3H3jittRwlg7SBAMj9XA=;
	b=Fw0kYTSxDfuPDWBB7Uqw/i0Nd+g+uQCwH+53NsyKPo1JbqWlKNfkFq3W/81Y0Wwz/cy+
	 bYpniE2RUo/zRxUviDETAAVJCYeXxRbWGaupNxskK3c/VUW8UCFioWAGGMS6eS4+Mdfl0
	 V9ENPem6BVqo5xnYRgt+TgqVkOj++EtNLVPtIizA++mdBpNroBpOWWi9cztnggGNEEahX
	 ++OQNI4mRkFx9LqLJl9t/GLKu2/dzuuUAHyiWXYlX1gMUCNeBPku2Fl42BXhzrNvdFrGd
	 7ai3D/kWHyS/Xc3JtSMc05UHYtsrCxZK9eV4DcGgcEYojvQxu1kR5Rm8+44yHwS7ABQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MeJmyBlq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E12606A323;
	Wed, 25 Nov 2026 14:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MeJmyBlq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2DF1F000C4;
	Wed, 25 Nov 2026 14:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617706;
	bh=o3jQAbrFipgda4UFqfdefnc3H3jittRwlg7SBAMj9XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MeJmyBlqPvnufv1rAwn7DUfRkpnI+sVQdZ7yIuTMfuXJ5sMqo5jo5ZttUE6hwapPB
	 foPX2R/bO4FoabGMBkySe9D0xUjbynoI9K5ZXe2H9HvyhvpfWH1KkpMJ9mLl5T/st8
	 sJhYzfAGZSn/kpPuFMErI8Hg9IJf7+Y4FpzSXna4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0049/1005] dma-buf: keep the DMA flags in the DMABUF_DEBUG copy
Date: Wed, 25 Nov 2026 15:23:07 +0100
Message-ID: <20261125143822.889428280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit e87fd0513792a5cf90f502399faa9e19439747e6 ]

With DMABUF_DEBUG, dma_buf_map_attachment() hands the importer a copy
of the sg_table that keeps only sg_dma_address() and sg_dma_len(). The
dma_flags (SG_DMA_BUS_ADDRESS, SG_DMA_SWIOTLB) are dropped.

The flags describe the DMA side of an entry, which is the side
importers may use. Copy them as well.

This is not a bug fix. No importer reads the flags today. Their only
readers are dma-iommu, dma-direct and iommu_map_sg(), which are not
supposed to see an importer's copy at all. The warn mode added in the
next patch keeps its marker in dma_flags and lets importers that do
get there continue. They should then see the same flags as without
DMABUF_DEBUG.

Assisted-by: LLM
Fixes: 51db5336e16d ("dma-buf: improve sg_table debugging hack v4")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20261005064133.7305-2-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-buf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 4c9add51f9ef5..b3d311acb8838 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -904,6 +904,10 @@ static int dma_buf_wrap_sg_table(struct sg_table **sg_table)
 		sg_assign_page(to_sg, NULL);
 		sg_dma_address(to_sg) = sg_dma_address(from_sg);
 		sg_dma_len(to_sg) = sg_dma_len(from_sg);
+#ifdef CONFIG_NEED_SG_DMA_FLAGS
+		/* the flags describe the DMA side, e.g. SG_DMA_BUS_ADDRESS */
+		to_sg->dma_flags = from_sg->dma_flags;
+#endif
 		to_sg = sg_next(to_sg);
 	}
 
-- 
2.53.0



