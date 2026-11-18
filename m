Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031065;
	b=A8zwn+1iOcQBnXBT6pKnfK2mp9TM3zBPzjzb92f/NOdEeCG6wSt5a4/vqnXjiIuFe0IC
	 leo0tpYCjpcBxXfrRVTzQyfnQdIlu5pKTqMDd7fgOGdLxNrFnliwo5KyHXD+Iiv6XK264
	 8k/xfrt4y9nhvhmJFVfMmDX3FI2LPF/9D5DKrGsGELqFrMnG1YIpTvd/U8uPXmXwyd2un
	 jrZFts7up1SUnnpfpxLU4Oq2oTKaSy6248rvzokiyopUyYIv3LvRIf3AJugcHbvNb2+a/
	 V0vlUfHa+5pkEoWIqFcwKcD5ad4aYwDfWoIxtduoo823vXIxXYGYWLY3eEVrRpN409g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K6rK6zxEptEB3VqPSU7rwFpyYy0M6FKlJpf+Kp/FzVo=;
	b=D3ubKI0g/Swzj0qZ+XD9i2yM+1+BtPCqan7voLXe/BXYloUDg52uKt2ge87gKsKT/Xsy
	 35pKbZ8sX8u2xS35BiZSR98JSQN5ibTRTJ4tkhTFa2CUeTUqUwB+9tW+X4MQ1pGlwG86R
	 TYpnq0KWKdfTCGmhYGT9BXDnh2bmiwJNjUH7+xfLX5PdA4/MFjYn/5uXcE4GMOe3PrzHh
	 XgdaAwhykAqbOTJfLSJLK2nBzLFgMHROEeRNumSpwo/+W4+t5vmA9FAMy97yb9iFb1VIg
	 B2THEbYkCgoauyI/XKdXKZxtmCX48bcIRwZtcTaXHYMHOsDOTV365Q6+w+igp06/FUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zgx+5xr0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658F0606A320;
	Wed, 18 Nov 2026 19:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zgx+5xr0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70291F000C4;
	Wed, 18 Nov 2026 19:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031065;
	bh=K6rK6zxEptEB3VqPSU7rwFpyYy0M6FKlJpf+Kp/FzVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zgx+5xr00RKC0IzIExl7aDZG8I9K7CB8slk6l0KUxvLbhPojutnqkAmps2PghUvul
	 KBA+ydXUzKbWaJi+42MKnhDtRGETG5HSe77UoG1ai5WWRdHz2d+fWkDLp09TDgWEyw
	 kVdN67tp3Bn++l5NM2dUzJsnSwpyAY0XNwphK6rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0884/1756] dmaengine: ste_dma40: Return IRQ_NONE when no interrupt is pending
Date: Wed, 18 Nov 2026 15:50:11 +0100
Message-ID: <20261118150044.746490756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



