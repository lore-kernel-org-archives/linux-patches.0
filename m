Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213717;
	b=NJdP4g0anolasa+3+vNLxy1SXTJCQ7eAn/Buk95tO5JYLvaqURWm5NxRpuZeRvNSq6OX
	 gy5uig/zZniY/AFVAwYpa7I1TIbtcoJP8Xs29GoM8oNlz7TG93L11HiJpsnzz9q6LCqp0
	 rXjlHtFpsG3wBafGHFbEsBP0OtuXWk7b/nYXDX+vDVwWtDD9zVxEHxG4lVYM+DakEO0Pi
	 pf6ofLOKs96rGqOW1Gzn2V3iFxJNb8DbZcPPy0XUfSLWmuNkvutuVNb8KM3KmwRmlUPms
	 vDXDlJijZNJj2RJgzMJ5JBhu2BPVOorUvYHkkflHEh3gt4DkihHhDa4LvXTJw7rliFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V9LhXMgYehl7+4OhFu7UYTRtTp7DIcDUGwNmUJQj72k=;
	b=eUhYiqj1pk1+QjjhmALzwXVhEKka1RTd+XbMjc2ogXbfaUc/rHsMJv/Eo2dVWcRgXT7k
	 Y3pmfMKblzam+s2dBatLp7RFH1DRCCqz02ZNUOw/dH9ahcvB0HFj0vPFGk36ybSK+WoRY
	 gv4cv8kby6FVdxIakUvuxYi+yGtsRH+rCb6I891O+y+/JdDAoKXkK37XvvMaVTBAHRU8u
	 S7+yH3b+y22oQoPEonmlRDKyzGCozomxUOcLwp/c8E0kycBuyi06pi7DhDi54TZ1dglsq
	 16w7tVG3U+cEhb8zGQwuBKqnHCc/IH78OcQuiJQegLSMqLsFpmDlKeFnN1WksGFROaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CbnZJz0Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E39606A31A;
	Wed, 28 Oct 2026 18:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CbnZJz0Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EEF1F01825;
	Wed, 28 Oct 2026 18:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213716;
	bh=V9LhXMgYehl7+4OhFu7UYTRtTp7DIcDUGwNmUJQj72k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CbnZJz0ZIjCKySS9fRTzGsyn5/4Z3/Jyp8k04tvH3gftybO34DCKYxwqmDqEX2d0v
	 JcSJuF4nkw+BmacS4ij4+gOSLcDZDJenLEzYWX7Qozss84tY1EBupggbqJAq4L0hwv
	 1RvCUfP03Wbir9SlgrRpZXsqaQv6n+M2KkKNdbbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0604/1887] dmaengine: dw-edma: eDMA: Add sync read before starting the DMA transfer in remote setup
Date: Wed, 28 Oct 2026 17:45:00 +0100
Message-ID: <20261028170513.161859271@linuxfoundation.org>
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

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit bbcc1c83f343e580c3aa1f2a8593343bf7b55bba ]

The Linked list element and pointer are not stored in the same memory as
the eDMA controller register. If the doorbell register is toggled before
the full write of the linked list a race condition error will occur.
In remote setup we can only use a readl to the memory to assure the full
write has occurred.

Fixes: 7e4b8a4fbe2c ("dmaengine: Add Synopsys eDMA IP version 0 support")
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://lore.kernel.org/r/20240129-b4-feature_hdma_mainline-v7-6-8e8c1acb7a46@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-v0-core.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/dma/dw-edma/dw-edma-v0-core.c b/drivers/dma/dw-edma/dw-edma-v0-core.c
index ace8980c40d54..1fb1b4d18e261 100644
--- a/drivers/dma/dw-edma/dw-edma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-edma-v0-core.c
@@ -357,6 +357,20 @@ static void dw_edma_v0_core_write_chunk(struct dw_edma_chunk *chunk)
 	#endif /* CONFIG_64BIT */
 }
 
+static void dw_edma_v0_sync_ll_data(struct dw_edma_chunk *chunk)
+{
+	/*
+	 * In case of remote eDMA engine setup, the DW PCIe RP/EP internal
+	 * configuration registers and application memory are normally accessed
+	 * over different buses. Ensure LL-data reaches the memory before the
+	 * doorbell register is toggled by issuing the dummy-read from the remote
+	 * LL memory in a hope that the MRd TLP will return only after the
+	 * last MWr TLP is completed
+	 */
+	if (!(chunk->chan->dw->chip->flags & DW_EDMA_CHIP_LOCAL))
+		readl(chunk->ll_region.vaddr);
+}
+
 void dw_edma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
 {
 	struct dw_edma_chan *chan = chunk->chan;
@@ -429,6 +443,9 @@ void dw_edma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
 		SET_CH_32(dw, chan->dir, chan->id, llp.msb,
 			  upper_32_bits(chunk->ll_region.paddr));
 	}
+
+	dw_edma_v0_sync_ll_data(chunk);
+
 	/* Doorbell */
 	SET_RW_32(dw, chan->dir, doorbell,
 		  FIELD_PREP(EDMA_V0_DOORBELL_CH_MASK, chan->id));
-- 
2.53.0



