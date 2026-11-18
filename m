Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031057;
	b=DxxHO8fJsjebkNqtewpwTq96I7r3ZhZXBhC0KZC2+k0qLS+1prvwjblctM8Cpx9APFp0
	 d1Q2Kt2lYSSJQUsTW6SouGYac326uquVnd1IlXDC7u3xnUW8U4f+jKp70RRv0OgIywzqE
	 hw7NAGnbeNx0NDOSPXjcFXnu7Z4KqGfxDqXWkktER+4pXmxJPUdu9tHntjl3s5PfExoou
	 c3fzM7lnBSiAi5VBA7UJCpamklZVKVoZOc4nxfo7YewlatOGmAyviAEULq2zaM6IoNRUc
	 zNPt0+gqO8FuPNqBiudWddAUex49dfthn6bwydXzl332/bftJlMIiFLn/EsTBnLkBNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mk4xhPq/j4SuTCyK2layM5pOBrbOqL/jXcEWMfhmhqw=;
	b=XEJcNrQqshSylTp3t++rTeWz3mQ1c8C0eG8puFDrv4mxwz91ejp4XeUpU38ZaSBXTdpl
	 8XxD3Hxi0PeHp9g1KHzbhEc+1X0pX7l/82EN6SQ8Ow4ORIsZo2rBpB0wyYVhm98y4Ckka
	 5LbFr6c4Z+9G1lT+y74IWyda3ISslNAdz3DEB5vyJ7p4qr0Ak7X0nvWyPvrqpOReCn0Tm
	 kgu55DIZwjloSxwkgLQ+ePdB0nMDn2uZa5J5Roq28JipnDZ/QSnpeoOxW41uahuAAUkdW
	 9C/5GeH0kMuX2P/ArRaKhWIMEXLL1+c6htOAKLyTXW2Glze+/TS8UuzcjU/q7KWGW8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qILt/Ncz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0287606A31C;
	Wed, 18 Nov 2026 19:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qILt/Ncz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416C51F000C4;
	Wed, 18 Nov 2026 19:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031056;
	bh=mk4xhPq/j4SuTCyK2layM5pOBrbOqL/jXcEWMfhmhqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qILt/Ncz5HnkY7rIH4vyjeKxaV55w8/1HiucxmolZK9VbpGQzSMpRFVdgPuCyTnIR
	 2WztMM6zTuYWlV9bZiNSnhf+MB/ogCON9kV9zVoShUq034ibq3E6D6I601Kj22HvbC
	 XOsqziVmlGVS653eBy9GnRpIZqly/LugUm2ki3/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0881/1756] dmaengine: ste_dma40: Check runtime PM in IRQ
Date: Wed, 18 Nov 2026 15:50:08 +0100
Message-ID: <20261118150044.581600974@linuxfoundation.org>
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



