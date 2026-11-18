Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040847;
	b=pMxatT+jbP6p64LbfXakM+k3DnPtGrUSCYyyggpwYvsrV9i55pLb3ezk8Tez6uQmT8Cr
	 zfj06wccYIVL4QDbPhaUNc+KceeLkfcMeSwF7Msw9pgYavt5xJIOua18tV9w3b7ECWg+4
	 PgCffNgm1FFaJJImWQIhfgi+fE4zA4nmuZxf3dJAGG2r+/pSTnY4n2vUayOLnnVcUrpcS
	 FgncevJXoPKbdAnoL0Ufsys8+qR66eo9+we4eGG0cuPdl/rf238bj4R0fl/9c8GXZMuvb
	 pjvHoEItlrnlduJ0fzlnziUPr5uCPTnHUaC0Pqdl0e5iA7ULd28lpXOnjINtGie2WSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+QOvP9QSUXpxqPp23Px1hwNS+RHHJ89kl/KudLptqO4=;
	b=jhtqgcy9vlrRENlMjH9CSRxfE/gOLg249dkxtLGDlniw1yGJ0TGg7Vw4kbpoWCe5PUiu
	 rAjyYPJLORFWtYT7fCnutn+iM7huPV/lyKaRAt+tAAkYCB6hWGzZDPMhUFm2A63GqdlQy
	 kqNIbsO07bXHVQ6Uv/vu+2oBuGOUc7K2pD6jK+Bl2+2tq/o5m1bGOvcSFPDDRLwzNZvUE
	 iP2S565sSBkqsZkw00BGVAR6a2krBcm4kC2nxq5e/cikWaFJ64U5OJx/HxhBMnJq2P0qT
	 kZuYLK4IvblPPD0FfuUlFrkgVAvBQUpZMRf7E6HGhKHi+jNwCOdvi8qmaHhi9bGT7sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1VEACgK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA83606A320;
	Wed, 18 Nov 2026 22:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1VEACgK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F821F000C4;
	Wed, 18 Nov 2026 22:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040847;
	bh=+QOvP9QSUXpxqPp23Px1hwNS+RHHJ89kl/KudLptqO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1VEACgKVBpm6vINYudkd+nzsS+N7CACZE0Nm8ed9VnjXB/bNdop3ddU06IpL7Z+3
	 1Xbtsb7dgPI6pE9W7HDyo3XDfcQqEb+xGNO90znORamaX57kwfEzgiZ5goVMZxb8Zk
	 d87L3sbJP1/3F5ngqpOlZb2E0BlJE1byWRoUUNlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2603/3318] dmaengine: ste_dma40: Check runtime PM in IRQ
Date: Wed, 18 Nov 2026 15:53:45 +0100
Message-ID: <20261118150439.250566361@linuxfoundation.org>
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

[ Upstream commit 12787e3f2f93f3af59769b08ee4fcb044531120b ]

d40_handle_interrupt() reads DMA40 interrupt registers unconditionally. A
spurious interrupt can arrive while the device is runtime suspended, after
dma40_runtime_suspend() has disabled the GCC clock.

Avoid touching the registers unless the device is runtime active by taking
a conditional runtime PM reference. Return IRQ_NONE when the device is
suspended, and drop the reference after handling an active interrupt.

When CONFIG_PM is disabled, pm_runtime_get_if_active() returns -EINVAL even
though the registers remain accessible. Keep handling interrupts in that
configuration and only drop the runtime PM reference when one was acquired.

Fixes: 7fb3e75e1833 ("dmaengine/ste_dma40: support pm in dma40")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260819225114.AE1511F000E9@smtp.kernel.org/
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-6-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 445ea0a56d3d1..ef441a91017f8 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1681,6 +1681,11 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 	u32 *regs = base->regs_interrupt;
 	struct d40_interrupt_lookup *il = base->gen_dmac.il;
 	u32 il_size = base->gen_dmac.il_size;
+	int ret;
+
+	ret = pm_runtime_get_if_active(base->dev);
+	if (IS_ENABLED(CONFIG_PM) && ret <= 0)
+		return IRQ_NONE;
 
 	spin_lock(&base->interrupt_lock);
 
@@ -1729,6 +1734,9 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 
 	spin_unlock(&base->interrupt_lock);
 
+	if (ret > 0)
+		pm_runtime_put_autosuspend(base->dev);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0



