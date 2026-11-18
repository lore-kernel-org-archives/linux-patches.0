Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018720;
	b=AOyn9ZNi59mOanesPQpUMh7Z5hXJCoqCRthhIkB7ymXnRPUzGrdveqllx4YQMs9mLW6M
	 wSUWy6OALE2UySQ8eY4p8ITPUNoKxaUzzTeSsJCCRn1FplUtlLQ4cy0z9xZZzQVtJJCcI
	 MS0gWllDAh1WBvHuhR2Wct4GcThtES8taFbPTGdZwEv0CXwTd4E48NRD1wre/tonznFXC
	 k3QxObZdSKXhMBcuDCVpYRMegBdPJOxsOZFTMEVHovGRW6GqNHJPBCnD35TEvcYEIQYU0
	 vUGVmt2dKWw4/OmTk07XEFxZO6jDvXgu2XwK/dhGgpX6ixoSg5zeS2SD5m1GMnxnPKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mLtRED0xoMY0S/7S2qos+y7ytb6dq+FIPnfDuRFe2tw=;
	b=bF51TItmEo2DPIQLbXhq0enLmYDzS5zVWDaDiP1TxiF7IXd4y4rjmrxBcZv1B0w73Dre
	 /NzQBN5U2FwxaWiyrSNCaabF5GU1T0BPu8X04cu0SihEHaHgQ6RCFFgufr9ZCrY0B3V1W
	 lYLCLSUPbRGpDllgd2vXjA1m8raahE57WqCIoM88HAaRb6tHhx+4fFqiE+yyGpnHzCzHs
	 0lLjJ/IP3/CLJxzPHGIGe6WV7KJsTxAzdTO5bXkBQvBytHp1ZkmPhwwz654VsLMLSCgNe
	 9ssrX+PqGj+Wt6PTVEShVbSh+qMtqgSoCUx2oacWvHMyy9aXHhAclXrl9jf9xkwT9gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZpD6tshZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5852E606A336;
	Wed, 18 Nov 2026 16:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZpD6tshZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B661F000C5;
	Wed, 18 Nov 2026 16:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018720;
	bh=mLtRED0xoMY0S/7S2qos+y7ytb6dq+FIPnfDuRFe2tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZpD6tshZnM3i4ERZ30crYVCyYfjWtJc40fHdrn7HmmqGzyj1aSiutEuU1KxM47M91
	 A5Gvz8v6N/9Eqb2iJwkjtm0xUYAEUgnffmkC6tvCjZ79DP4pKUNFVl1w/fNlM+z1y9
	 oCuGgZEtylb9Z1P25650pVbfsbOdO6/niUfShk/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1339/2651] dmaengine: ste_dma40: Return IRQ_NONE when no interrupt is pending
Date: Wed, 18 Nov 2026 15:42:59 +0100
Message-ID: <20261118150336.222970570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 80780f76dff05..86efe2149be9c 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1816,6 +1816,7 @@ static void dma_tasklet(struct tasklet_struct *t)
 
 static irqreturn_t d40_handle_interrupt(int irq, void *data)
 {
+	irqreturn_t handled = IRQ_NONE;
 	int i;
 	u32 idx;
 	u32 row;
@@ -1849,6 +1850,12 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
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
@@ -1881,7 +1888,7 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 	if (ret > 0)
 		pm_runtime_put_autosuspend(base->dev);
 
-	return IRQ_HANDLED;
+	return handled;
 }
 
 static int d40_validate_conf(struct d40_chan *d40c,
-- 
2.53.0



