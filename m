Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018714;
	b=VecJSBu0LjTlRgT2MdngNzNgMnhiVn53YfuKCueWbojQYL7SkRNnoTh4fsUlp+2/UNZq
	 oMZ5f9lxLUuTv14+07ReBYi2bLTRiDCzUnkUzCsxK8tJpo05zaxK2RTaK3LCFF6r81P+A
	 TRZ4IyxVrPTAzDTOem5hUB4fOaAsAQx4tJDZwLpTAfiKnsHFlvK6fkD3Nqkb9n/djIEep
	 UADEQbhYMzTzKP0VHfvd8saUsa56zb6+oFaa2X2maLIbHIZML+jLffKlPpUHfQChdG0q5
	 0sG594lmZze2Eeg0cG6kKS8cUSlTfRbF2gzKXTQBa+aJ/TbkSsfH2H6QAeuJRZDuheQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CFjIuFCmQlHSqGflZzFkQ4YsiTMXIqmS95vUzDTODSA=;
	b=wPxunI9OycUj+iXuLaTnmc/+F3IOTKsUqSd/QCrrcN1afqSAHtusR2EADF2Beks8+Qbo
	 DZBmqitPFyka5VQ7yb3j0d3ToMmt++PZJ3Qgp6uCViToVnwCO9mkXo2eX33z9Vr9+kZZa
	 0WMOV8EilrWg8bKOA01w0uiuYPXm0bU2mcssbxl1zc5QIumAm6tMW9sE1mADQdaqAKK/P
	 XHl99/xL3x99wmdFwTcteOf113jbk5LjW584V92QhP6EpeDsUBbi+r8ExnzcKx4uKWEEc
	 PjeY6FE+xec9fgzUmzzIx/6VB8qEP9P7YATwW+o1tmS1IboAY2q0XLS9XJZB5b3wnVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8tt8spM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D5160A3807;
	Wed, 18 Nov 2026 16:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8tt8spM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B511F000C6;
	Wed, 18 Nov 2026 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018714;
	bh=CFjIuFCmQlHSqGflZzFkQ4YsiTMXIqmS95vUzDTODSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8tt8spMWe4jpiDAE/VuHBkvI9wzLwi1OMxDlY5Ll56xYO+kOTrRRPKHbfqeRlPqm
	 yfUjLkXFKHDTVW7WnICKIuLGA2MSrEdaDl67U3OM9A+Mr5PU74Dq1SFhi7/K+Kr1gl
	 F4xHql49oACyWJ6Yfds4c52O9BAJe8byoGjbLVA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1337/2651] dmaengine: ste_dma40: Check runtime PM in IRQ
Date: Wed, 18 Nov 2026 15:42:57 +0100
Message-ID: <20261118150336.146164458@linuxfoundation.org>
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
index 1dcfeabb3f363..5e9b6342c5a9e 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1807,6 +1807,11 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 	u32 *regs = base->regs_interrupt;
 	struct d40_interrupt_lookup *il = base->gen_dmac.il;
 	u32 il_size = base->gen_dmac.il_size;
+	int ret;
+
+	ret = pm_runtime_get_if_active(base->dev);
+	if (IS_ENABLED(CONFIG_PM) && ret <= 0)
+		return IRQ_NONE;
 
 	spin_lock(&base->interrupt_lock);
 
@@ -1855,6 +1860,9 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 
 	spin_unlock(&base->interrupt_lock);
 
+	if (ret > 0)
+		pm_runtime_put_autosuspend(base->dev);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0



