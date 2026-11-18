Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061250;
	b=HOuhemuIiW9mXgSVNmlYAIPjPEGvELN2flta7ZERL7zN7U4DW8Zq4E09BpK3HWbTjkvl
	 pg7W5KhWZDYVtczaegqRXGSlb7cqYHxctFC2AnEDhC/wNj/n5cEuA64Omtl8uKZnKVGhX
	 GsuJkths8eX08sseB9AbFmriDmy5TviV8C/pftEaGHE5yQpW6DeR8d459G8TlOdJysKH7
	 oeUUVtwNT4tMxWTILl9U7o2dJ6wBh57O3Ngtt51qaGNceJMjVf+EtmS4bYaXbr9kD/pNo
	 OMp44DkyBDAtXuunqy4shTuwbAUVUe9GEPNvIIWqUb82M65kDB4Ldi3YYiLSPlQzc6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qM4zQ4Q2AtznGm/gn22/RR9F7xA6TCK4c4P1/jHpuZQ=;
	b=JttQQjFcGc4VAr/v9r3Ue+zD8B11ZMW/gRUIhHqi9WiOqa7i2aCNBf0iDD6jWDDwRtwG
	 Hu31O3hAjcMJNZrn++rnrKTGmKr92qZpzNjMFkUVwYfOnhlHVeZHap1mfBJlPI6cX3rjq
	 NioEc/Yy9PjgfF0kY4Api2yqfuaq8o+ncl8m1THAh7AbGpfFm8VQ3c3NOps6xj/WBA+tF
	 vke3CRerrP4pEcL17A44sVHPy5lf+5ilG6TYps98HCoZFDGbW/YNsUFORI5fm+SzSPdLZ
	 B2SHwUyFfX1hTAxM13fYpsHQL5r+03EjX7qz7vyO0Zb285EUqpHPnouM4jHAkRT1KQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1MQp4m4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C7660A2606;
	Thu, 19 Nov 2026 04:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1MQp4m4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F761F000C4;
	Thu, 19 Nov 2026 04:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061249;
	bh=qM4zQ4Q2AtznGm/gn22/RR9F7xA6TCK4c4P1/jHpuZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1MQp4m4DW3G5vxYgQjQLVQLR4ppkw/rtDyzuO7cvBo0X/xDDDyeI+eLrkrJGWbyE
	 VsImCO7PGY3+V3GS1I0FD1Xo4b/vwqsl/rOuiajfHYTnUonaF/9OSoG1k1FkMSRDbO
	 Yl/GBNW8W/R3eDFq1hwcEug4DY3nunupYmuVX7fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1485/1848] dmaengine: ste_dma40: Check runtime PM in IRQ
Date: Wed, 18 Nov 2026 15:58:43 +0100
Message-ID: <20261118150021.421521988@linuxfoundation.org>
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
index 1cf711dbbb873..9e1cdcc1552da 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1658,6 +1658,11 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 	u32 *regs = base->regs_interrupt;
 	struct d40_interrupt_lookup *il = base->gen_dmac.il;
 	u32 il_size = base->gen_dmac.il_size;
+	int ret;
+
+	ret = pm_runtime_get_if_active(base->dev);
+	if (IS_ENABLED(CONFIG_PM) && ret <= 0)
+		return IRQ_NONE;
 
 	spin_lock_irqsave(&base->interrupt_lock, flags);
 
@@ -1706,6 +1711,9 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 
 	spin_unlock_irqrestore(&base->interrupt_lock, flags);
 
+	if (ret > 0)
+		pm_runtime_put_autosuspend(base->dev);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0



