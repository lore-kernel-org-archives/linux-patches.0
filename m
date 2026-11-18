Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025539;
	b=KaTNfOWRFwF6SNChiuGmBi9IMRK+WOQAZxzkQhqEVJfsqk7QSbGmwvpceA9kO5yyBcDi
	 zXnsAn6UhEtHrSzUtTLbbkrWyuqdJebs3iL6linH8LyUejnaYxqSxUvJBTShu0Zam4uNs
	 8SEMM6v6s1bKMpmr081wG6UnQ+BywJhPfkMOjTuzoAKi3s+R6sGZLakkDJYAlcoc3wEJH
	 jUfuRVjrmkcSE/w+O7QIqpfWMeVGUw1NzYN+7qKFqOxPzpOCVuyVOqzjmhngMy6df9Sgy
	 2c3Gwnr12nc4hhTddxNG1/6T2dne5ZWpxBbscciqxsaiP+avP1BUNeLoFDnLOmkHqsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+aowncxlHnX+d7tfo4Y4OwfUPemaZ5SKWEPef2MIMEQ=;
	b=sPYM+SUzgAcEhgeaaJ3HRWPlTjzobAQ4xQu48wH0u8T/R7rg1PzZie+Qc/I6LgZI5/K7
	 IwNFT87Nz0qOMqjhEfWxCXGsqfISgaRgLXcl0ol6Kxe/on2TfeKqhLExe/CjBF80ipged
	 ih75XnkA7Dnf5nACDrW4k8A99VmvcZfmlGUFwXZjYmQhu8JQ6Iv5+rNw3gmGBciyLKQEB
	 DodAkTOazHclqX4c/rm3c1RtzP7NZgZ5B4fmZlUTWYfwI5XCC7DOUbtBCeB9d7CH3rCa/
	 mF8KNKthJpc/sJqmt3MW0CFmqFvFUyywelrFT1KHqePj2egtp0G6QNFZYAbRbDS2eDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G6MzHh63;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78612606A325;
	Wed, 18 Nov 2026 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G6MzHh63
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4241F000C4;
	Wed, 18 Nov 2026 18:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025539;
	bh=+aowncxlHnX+d7tfo4Y4OwfUPemaZ5SKWEPef2MIMEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6MzHh63KdkBXahN8zLO7/x/Ct5sAK2d9syyi8oXKxe0w9lfCJYrIssm8G5mOeSvg
	 8MshFgJNw2pQgoILoeHMEakxVmojyw9nBGzAEJjgUY9c7eRZtsFg3u8RCgfwaz/30k
	 xMQIWWKWxoFBQ0QiQ/7ggq3pElfBKTWMYru5+FTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1116/2151] dmaengine: ste_dma40: Check runtime PM in IRQ
Date: Wed, 18 Nov 2026 15:47:31 +0100
Message-ID: <20261118150202.874259730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 08d1c2197ded5..df373c5b6b9f2 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1679,6 +1679,11 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 	u32 *regs = base->regs_interrupt;
 	struct d40_interrupt_lookup *il = base->gen_dmac.il;
 	u32 il_size = base->gen_dmac.il_size;
+	int ret;
+
+	ret = pm_runtime_get_if_active(base->dev);
+	if (IS_ENABLED(CONFIG_PM) && ret <= 0)
+		return IRQ_NONE;
 
 	spin_lock(&base->interrupt_lock);
 
@@ -1727,6 +1732,9 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 
 	spin_unlock(&base->interrupt_lock);
 
+	if (ret > 0)
+		pm_runtime_put_autosuspend(base->dev);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0



