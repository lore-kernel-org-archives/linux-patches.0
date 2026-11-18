Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040856;
	b=T78IYYlIaBH3tMxHToD8+HtSlT/+ZaXNWAhpAGbm4lokFAvyKRNUx+eqBfOW0MysJWNl
	 CftCQcDlY127cpzHMEMSUkM5tfmbe58YXsVtxLXZUdZVhk+NBsY3P/unWF/r7haCm/Q4U
	 xDFDONO2Ztasg2CsLX4tA/C8ztxxY4+aIw6LCtE+tHysLBX/NHg9ScwxWB8rGv/CjHcS2
	 Wly5w8nvcLH1AfEXbQfeXxhaf3p8aRxoYBko5KltrSQ50ibqITlABiBhNOl0zyk+k+lIo
	 0Y0bs5fDHWZhFv1XPOJKwvhrXzBmbjVmaPIr1Q9sVL/1l6WJolHNS+lcfxm1DIp8mlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OYCD3HcCBeOFCtZ+U3nWut6/kaX4VYYI6D+OW7PctVE=;
	b=lrRYlFXV6mqXp0mnxfrTOlQrPyJ5Mfh/PAsYMO+j7LDwy4rvjdIWo2v71hmpdZmL0Ukc
	 6qOOWTMsPPymrd0ZM3pqzUPRLfZ/ifzgZIQNxqqvhRwfubdjuXBNRNWgS+ZSAM8bSeLkG
	 hA/ibvFkQSPxignY7I5TsvT1PmWqqKqpt+CpSVe/7w8rL0W5g+CTYz66EUqJcbaLRDElu
	 I1FIJzUNMRvlX+sHS2vYOkA288NIo+7a11XObMjCY9v4ywxz+UPsT78kKXaywqpTTq6fj
	 qD4kdfcQQ1Wcc71a2oJImHaC2WU0sdDgBY4diyrM4/wECgK/3Rej1t4+adjCtW3hccg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G3yk8i9L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206F5606A325;
	Wed, 18 Nov 2026 22:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G3yk8i9L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B76B1F000C4;
	Wed, 18 Nov 2026 22:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040856;
	bh=OYCD3HcCBeOFCtZ+U3nWut6/kaX4VYYI6D+OW7PctVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3yk8i9LNMQC+q0rNaKNim22YTXKjrijz9w0P1aWS1HAhja4LEQgUB78jGSdMqyVX
	 1YL740OGUb6w6xoTYbrUbA1SI3e/+m5am1FyyPgbRM82USf3Lam3vm1k7EdWTDZHWX
	 cU7WPU5z3MNcv0PKYwlna4Yxtr5/R2nhxfS0vqPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2606/3318] dmaengine: ste_dma40: Return IRQ_NONE when no interrupt is pending
Date: Wed, 18 Nov 2026 15:53:48 +0100
Message-ID: <20261118150439.332848381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c1d909422bde9..d8d08c3259195 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1687,6 +1687,7 @@ static void dma_tasklet(struct tasklet_struct *t)
 
 static irqreturn_t d40_handle_interrupt(int irq, void *data)
 {
+	irqreturn_t handled = IRQ_NONE;
 	int i;
 	u32 idx;
 	u32 row;
@@ -1720,6 +1721,12 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
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
@@ -1752,7 +1759,7 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 	if (ret > 0)
 		pm_runtime_put_autosuspend(base->dev);
 
-	return IRQ_HANDLED;
+	return handled;
 }
 
 static int d40_validate_conf(struct d40_chan *d40c,
-- 
2.53.0



