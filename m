Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061258;
	b=zhx+iptswiOMvydsN4PO4CDemeBP8RgkdhDPadsG8UJFwK9Rv2uum0Tv/zyfQDqLJy2C
	 k7Dm10c+/tvXFNyy+/RLgSlkd/+BP+8JtzWYvcyvcg9NeFYoApmU0WBuLyzO68RtfAPIA
	 +mniGYkmWoAfFUsspGl5ruzY+BjOWaT5n8lemXyzBWlnoXGT/UJjrBzw0Vlg18K++G7ds
	 W1YxCVEq/6mScROkIUtT14Bqzwh1ImbJWSflQZ09KOkVmTlQF1+7MA/8COJh3/eQ03W3+
	 ZAWq3Wm2Jm9f8rZzYNstEfaA1bPxl5z2PINrw/zpe9Y9lEIicyp+84tyA8mfv+/zENw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dZB8UJZd0AqKB8tLL10oVbXkno3topx3a58dCOPgSdo=;
	b=2PzBIB0RBt45q7aE8sVrkFErHUVGcLSbDmjKBUsc950VlBH6EAVEN76xxuXKKBlMci6b
	 hAvdvKAPoLpR6EWNfPV2HSfjj9+XC2/w/6rcaSNPiqoz9l4xwQ2/uDENXNk/5/5o9II0V
	 AunJUItnoZYOzaH2qJy9uxZdOHXTZcn6GfoiIJxFNMub6x7VNLdqJ0PfL5ZBvfSrkyIbf
	 4mXksAhT1LD1En8Or/o4W0TD6zARJMn2fXGW76SfHMDIRGn+fFtdSrS+QCN5k3lSjo9WK
	 IZl01OgNo4HrmLoCpwuvf7Mt7B0Dune/R9DA62AjwVbQj7wHT79v1piq0mhm0Zu4ZmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NEAfirrR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5345160A2607;
	Thu, 19 Nov 2026 04:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NEAfirrR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619E21F000C4;
	Thu, 19 Nov 2026 04:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061257;
	bh=dZB8UJZd0AqKB8tLL10oVbXkno3topx3a58dCOPgSdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NEAfirrRoCDAH9YYY+m9FQhqAjJs0Uks/a5qc4fd+dy+NWAIIFqvZAVJ4/ESCbQv4
	 LPFbe8w0BrjbAbXJ3cdsH0LGnhhlKTq6Hb6Gmk5uNjwFklfDEl6zZitfj0U5LBImZt
	 Dud5h3NKnvI7+TeNQa9YFrnTKVBboI8JaFyfhcHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1488/1848] dmaengine: ste_dma40: Return IRQ_NONE when no interrupt is pending
Date: Wed, 18 Nov 2026 15:58:46 +0100
Message-ID: <20261118150021.535050037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ac152421d5907..d5bb481b0f6f0 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1663,6 +1663,7 @@ static void dma_tasklet(struct tasklet_struct *t)
 
 static irqreturn_t d40_handle_interrupt(int irq, void *data)
 {
+	irqreturn_t handled = IRQ_NONE;
 	int i;
 	u32 idx;
 	u32 row;
@@ -1697,6 +1698,12 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
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
@@ -1729,7 +1736,7 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 	if (ret > 0)
 		pm_runtime_put_autosuspend(base->dev);
 
-	return IRQ_HANDLED;
+	return handled;
 }
 
 static int d40_validate_conf(struct d40_chan *d40c,
-- 
2.53.0



