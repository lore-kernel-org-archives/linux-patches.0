Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049166;
	b=rsQ3ZdfOGcegbovpu8sQVqfGrapUlEEd8tilX3p8NQbrE4GUsJ/mSSUTp7Qu8pNaHUXc
	 PDtygFbFnj+vUCmvX/I/fwGod9TehIEMcc2wlLCsc4tX8wdrz2EqXqGlQ4ifoGu5a03/c
	 4Ld+rsGbNQkQBHwZqE1wY16iALckfkLc1G9myT17A+tG7xzRBNhJJTqsmlmGlZgNJTLMC
	 qZT2d8QtcbJqMAetgTGRKeLlHH5h+Cy0muuXq6xOXjZ7tafFG8SM29vXyh6hIv75Oc64U
	 Kg97NWQ+3/R7gr6kPGEKUavgS4D7G/Fb4e3w0Lfu5yZzqyTrvg2E0VJs0vtxt2kP1pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rMVz9oI0GyC0ThF2UgwhIbrqgdceHdpqB2p78Ku6XUI=;
	b=e2NjJpAMFe6E14bWJBzn+eN32cSOkVrDckXY4ZeJhpNGOlQCutoXc3NVA88iIoGi6hmd
	 2WDwmKxqpE/5S2wk/TE9DtsSE6TMEgkKylUs8iwpRNGdFzYsfdWUT1yL2DoOpL3Ec6usl
	 cEaf2Wo2G6A/JECEpRvSAG0ygbrKKbbunAP2UZaylFE51YiFBPDtilKnx1VzF1FAqq2+n
	 e2XcutlH8vWvq/qjvEeB26aOqdrIRElWSxmetYIGbxSZMWyl9sgQd4gsKEjXzMXV9pswp
	 aYr27ecdWXa0F65fFdBO42KxMeQqRWpOKGtdV87wDjVmt4WFee/glcn0kP/bzVRVeZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDdQzZeC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509B8606A31C;
	Thu, 19 Nov 2026 00:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDdQzZeC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714A11F000C4;
	Thu, 19 Nov 2026 00:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049166;
	bh=rMVz9oI0GyC0ThF2UgwhIbrqgdceHdpqB2p78Ku6XUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDdQzZeCSPpY5rtHGEpNL7PSWN1lj8jpVSiOn4K6Omrrsra8Bpjeozx1nDODbqkkE
	 AIZTjajG8Gb7jTLCKQNRHgB23P20sOB3sFeUNxf//Rx+LU4hwP+d52pPONHF8wGJVx
	 oHR+KkZlV1JRQ3qVBLkq9yjuN8NOhSzxH/wXWAGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2254/2857] dmaengine: ste_dma40: Return IRQ_NONE when no interrupt is pending
Date: Wed, 18 Nov 2026 15:54:48 +0100
Message-ID: <20261118150322.602323689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index f039e1aab419b..63debc6af54e1 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1663,6 +1663,7 @@ static void dma_tasklet(struct tasklet_struct *t)
 
 static irqreturn_t d40_handle_interrupt(int irq, void *data)
 {
+	irqreturn_t handled = IRQ_NONE;
 	int i;
 	u32 idx;
 	u32 row;
@@ -1696,6 +1697,12 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
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
@@ -1728,7 +1735,7 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 	if (ret > 0)
 		pm_runtime_put_autosuspend(base->dev);
 
-	return IRQ_HANDLED;
+	return handled;
 }
 
 static int d40_validate_conf(struct d40_chan *d40c,
-- 
2.53.0



