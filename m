Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055801;
	b=LVQ0xoPaYTZtkwkbJLUTqIz1VPa53kFJHqEAhbGw6k2P39e4AEFzaJpHnNCXUHaFsS5B
	 s6b8yNfolyKT55j/M0HoJmwfTBgl+0t9nS0NY6lMNY4iuwayvT7QmURssGOM2lwqr9IbW
	 LOW2+t9oSwN7XjKQEKZhncV0meo/iiIg07C7nYXfrywN0v9pvlEpo8gGQgU1avK386HlS
	 bwhT3AHisk4o+Ido0J20wFA2KIYfO9MJsT5269O9cg2DFUxza4OQvwEnIwiiqJ6E0EOJw
	 Bh2KKwyQP0315gM4yx/0Jotp3BObj45XgCEoKFunvE3w2S4lBnbJg3d+8HyYZfloFQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m1CSN73s5n+9taSfe4E9qG1Cs0P55dQ+GaMyQ++sdoQ=;
	b=MP52XfXuPzZCq567aNyVpaoPT+4mUZ/AqY3X+FCbV7ITWKLO7k/ry8rEin7YMpB1DMjf
	 759wTewVAqTb01tTcrER/pQbKVHqCM2v6LGt4SAegxwngZXWf2/oXoZknHScLOkkFClE1
	 izlBRAmeO4fexZfaEXZhpZB4w5REn/9CtfIDMzSWdRFf/X13O6zJ4dmamrycE/GUFJNFN
	 4SOmGGZ1EgDtv0M7ax8RaUh5XZWCoy+F8UdQsLtZgTFhSXNKZYldin2jZURCSRDSYJ4Lw
	 umjRHzzCm02SqPoDVKetwPsZDWTW/IPsQlhaxBAt5ITwe0BGffXpwJ9xjVVzx+6DL5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQJPKg+t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8BA606A32A;
	Thu, 19 Nov 2026 02:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQJPKg+t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB471F000C4;
	Thu, 19 Nov 2026 02:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055801;
	bh=m1CSN73s5n+9taSfe4E9qG1Cs0P55dQ+GaMyQ++sdoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQJPKg+tmdXhQE0drMkjrYHHQh8Pa/aW36RrTdMQ7Ux8XUzLGq7/+OT+XgqkTqk1W
	 BCYKUlp5fV+lb3BYR1p29IU3L5Yt70I115GyH/+S2SCyzXe3VfpUSMrPKyKvQo7z7L
	 XfPmlm6PsoSFWny6Jfk30hAK+oQ0WRKu3daN5j+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1760/2214] dmaengine: ste_dma40: Return IRQ_NONE when no interrupt is pending
Date: Wed, 18 Nov 2026 15:57:16 +0100
Message-ID: <20261118150121.954667514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 57753e7b4b14e..79b4d3b3a0bf3 100644
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



