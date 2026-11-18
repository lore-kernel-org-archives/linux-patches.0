Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025548;
	b=XhXp4mRIsPkz3biAZ6PL1D9Lb/qS1kY0xLFjE0hZ2LxbQOXGnkx7fq533X9wHpPfFofh
	 UBNGHq+YaJlelJI9Lz62w/Jnblu3CsKbLUUx8INHhCOp+HRsop5PhKFJZc62+gPi6k5H1
	 zBAYU+Xr5gjBnJZ36H9KSTQeLoDDbF/7MLoI4l+MDq2i+Ghdu4XtzOS/LvKSY6vzT4E9n
	 Kx1EDrR02DKIGN0t7VOHyE6zDeFSOPnBoqIq2LOaxy/o4sFYCZ5rSVtkTaho0ehlHDm3M
	 fmMgG2qmW1RqT14yb717cwxVZ008md8N1vVovKgHCMgtPnDBB6q7YlgwhbHHnrE0YXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PRpvx0ZRxHzsn9sEjxZ3M6i+CT1DLFPpR03qR+31DPQ=;
	b=jIWejBVD1BP9Rb4bjJg+a8Ax6Zfolt6QHFmXapAaKBuzjIoELgti7y1B72wEjUlCRZzZ
	 9TES0bEjIapqAc8Mfc4YeuPhwFIfe2+3VfvPiEbuUg/Il3631ESsW0ybbSAexzhYFQZzq
	 +QriwsjsqUdt6Qa88lzk2PcU6otumuqD6WWhr0LRxzZptol1L49+X5exMN7LGydXuALlO
	 oJb+1Bc3nXW+2Xzd1D910AOtwuwAU9X9OvfpHUR1diHVN5oCQVYB1yKcYTF6rOafmfuAs
	 L50OI0jHVmoxP0sLHbVnVmSjl2wsCV8JBsoR/FL3+wQ7Bifg/8hvyD6P+1pamSYzZqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHVSC966;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4AE606A31C;
	Wed, 18 Nov 2026 18:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHVSC966
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705131F000C4;
	Wed, 18 Nov 2026 18:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025548;
	bh=PRpvx0ZRxHzsn9sEjxZ3M6i+CT1DLFPpR03qR+31DPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHVSC966Hs4xMSrxV2lI6qgvhf6qmurEOIaqTaXsg4+RIyRjCwfYyAZUqh6ykqh3E
	 CZT6QFDqVUkTAFF3hQ6cc0KDuncoeGgswU3nUj+IubJxGNwqFksdgk4mjVZFAhrQXd
	 pNmxnbxw1JfSLr4UDGZbIdoQ3/zK36O3NSmZ2+4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1119/2151] dmaengine: ste_dma40: Return IRQ_NONE when no interrupt is pending
Date: Wed, 18 Nov 2026 15:47:34 +0100
Message-ID: <20261118150202.980197922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit b96967644c524d34b2fdd2e58c31e7b36e3469e6 ]

d40_handle_interrupt() returns IRQ_HANDLED even when no terminal-count or
error status bit is pending.

IRQ_NONE is not only used to identify a device on a shared interrupt.
The generic IRQ core also counts it as unhandled for spurious IRQ
detection. DMA40 does not request this IRQ with IRQF_SHARED, so interrupt
sharing is not the purpose of this change.

If the line remains asserted without matching DMA40 status, returning
IRQ_HANDLED hides the stuck interrupt and can leave the CPU servicing it
indefinitely. Track whether any DMA40 status is pending and return IRQ_NONE
when none is present, allowing the generic IRQ core to diagnose and
eventually disable the faulty line.

DMA40 channels can be owned by other SoC cores. Their status means that
the interrupt is real, but Linux must not acknowledge it. Treat foreign
status as handled and leave its acknowledgment to the owning core, while
acknowledging and dispatching only registered Linux channels.

Fixes: 8d318a50b3d7 ("DMAENGINE: Support for ST-Ericssons DMA40 block v3")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-8-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index a1c126a3a499b..4e5907f6840fd 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1685,6 +1685,7 @@ static void dma_tasklet(struct tasklet_struct *t)
 
 static irqreturn_t d40_handle_interrupt(int irq, void *data)
 {
+	irqreturn_t handled = IRQ_NONE;
 	int i;
 	u32 idx;
 	u32 row;
@@ -1718,6 +1719,12 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 		row = chan / BITS_PER_LONG;
 		idx = chan & (BITS_PER_LONG - 1);
 
+		/*
+		 * Status for a channel owned by another core still explains
+		 * the interrupt, but only ACK Linux-owned channels below.
+		 */
+		handled = IRQ_HANDLED;
+
 		if (il[row].offset == D40_PHY_CHAN)
 			d40c = base->lookup_phy_chans[idx];
 		else
@@ -1750,7 +1757,7 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 	if (ret > 0)
 		pm_runtime_put_autosuspend(base->dev);
 
-	return IRQ_HANDLED;
+	return handled;
 }
 
 static int d40_validate_conf(struct d40_chan *d40c,
-- 
2.53.0



