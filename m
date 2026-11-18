Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049157;
	b=c/O2SorTDlsXHQryfbIP94BNcDHsMpvMULemHXvtZhryn0+nKMpnwNUJHm1v9WsyqLVl
	 huWgqaMtnevRVGzV6Fd0N90pckmimDcO2XnzIdC165zRJZJd3crbDp2iRKbazTa0gz8Pf
	 vRG/9O0xB3C845Po6XR8HzddHAfFg7fBAhu4iiUWQ2A+95pL1fjnBkXlIxLZWNaGOxf06
	 OXlT0MWd+cok46HygEmwZG+u50tC466RH5rnFlrp44OCKANUDYH7gAWDTsVCG44PcKSZr
	 MzNXN1iF2QFf8I3adHom2opnizfhbPjPFe20hTlYBPlTvipWdEhLPJunoexEUkARoZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wRgiv+j6XqJRGtTkFchBQaDAGFKzQBl6tBaN2tQJwy4=;
	b=CGx9uuMqNsznBkr5rT9DAO090797ow/2byDIpKY4g2+pFXYhTrGmZ3HGiUzPtdsJHUA3
	 RH1DyRx7ClgWz+aHUeKPusP6p4UQxc8hULW6a7dXhIjx5aqzM5veST8tngwCAvI/hP+v+
	 ZZ2nDibjboZtCkO7qgh1tL56NH2npJee5dtEsX7oBm2czWMpOsM801d6i0NNYEQVRUBdu
	 CK9hHDo1Jgurc8Fw/nKlFwf8p4lOIKOywYxYNXVPsBEL8WDGyJLd4zlHYu+HnazYIl60J
	 JZRknxzoIV+u1AXB8w5nn8FqbHka+SuJLJoT7nWuBYqnFFeImCWfhTWTaq2hLft3nEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eYqEMEbv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23B9606A320;
	Thu, 19 Nov 2026 00:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eYqEMEbv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E738D1F000C4;
	Thu, 19 Nov 2026 00:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049157;
	bh=wRgiv+j6XqJRGtTkFchBQaDAGFKzQBl6tBaN2tQJwy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eYqEMEbvVcsijnE/iv2bY4W8QiDGAMUSSolRqJFoAJnnvn2roXsBg/OdVqslRY1+O
	 jrN9nHKaUus1V0D3bjYezSznjg0IaQwPgpUF5D36YqAPigpmmLwjGIejbBxtT2kJBY
	 rgCGJVJ93b69+v3B699QR9x2Bmzk0AX4LD4493M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2251/2857] dmaengine: ste_dma40: Check runtime PM in IRQ
Date: Wed, 18 Nov 2026 15:54:45 +0100
Message-ID: <20261118150322.491295349@linuxfoundation.org>
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
index fda07f42ea62b..894aceac6cec5 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1657,6 +1657,11 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 	u32 *regs = base->regs_interrupt;
 	struct d40_interrupt_lookup *il = base->gen_dmac.il;
 	u32 il_size = base->gen_dmac.il_size;
+	int ret;
+
+	ret = pm_runtime_get_if_active(base->dev);
+	if (IS_ENABLED(CONFIG_PM) && ret <= 0)
+		return IRQ_NONE;
 
 	spin_lock(&base->interrupt_lock);
 
@@ -1705,6 +1710,9 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 
 	spin_unlock(&base->interrupt_lock);
 
+	if (ret > 0)
+		pm_runtime_put_autosuspend(base->dev);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0



