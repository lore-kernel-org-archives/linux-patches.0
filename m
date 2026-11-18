Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055792;
	b=Q2uO0QznU6nTtnHNQpChvNNa36swju8KFOEX1xuVdFguI/jRyEgiP0QI+cBKqT64687d
	 BXVNNWAMXiGJzxoM5Obd30dHs5Jlvqd+UOHfxtxlSHePWcKJzCFI6UDw0LlJbBp3QU0KV
	 p8RW8Mwmmwj6VvoYcTnea/ScJh34BfkV659Mz5fEZdQKn0qjlO8bh48ULGasAvge//ncd
	 CEvszEal5BFTUg/FB1O/Q0MrT1exDIPpc0cBlljH/qxybdY5ltzcec/Hn7Vc6RkfZ2tAY
	 6zXANsUUg6r/EzdB2oUJFptF+xesx4cyuplBdLBU/6n3CFuvjK3hqhJ9GQnvT+85ZIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZP/rmC4BWu8w+YLpSEEdqLErAT40nxAv8x/h9C6AZBA=;
	b=vO7N5/SpR0rf6qoK2KZic8bFNQfykK8wwgiuTTtV6ACb8vKm09ha2P29lGYftpahs4ba
	 iBGk5HPLSRMkho0Lqa7WwjbmFzs1WGgE1vYAPEjUe5LphwZfqNcpH8StSKsuHJALwk1zv
	 XW6P1pMfYSdwN7ztgOF0K6WkJbawBxZAb40ym2ZQFKByIwr031mbszZVgOAUxb/T47xEx
	 1LuzCSIaj1KcHCOXk39igrohVyjuc7NrIOSBQq7A6A+Gpf7ihoHrP23vwQCafSy9DIu+w
	 7VhDE0uPVIthIb2z24j77FSa3skil1PqlF6YcyoDtuoNCcLFZqBpsrotM/Xx2O/CC9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFuDR6p3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24CE606A31C;
	Thu, 19 Nov 2026 02:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFuDR6p3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3473F1F000C4;
	Thu, 19 Nov 2026 02:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055792;
	bh=ZP/rmC4BWu8w+YLpSEEdqLErAT40nxAv8x/h9C6AZBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFuDR6p3rtoAV4vYmk9IhhhIzXEq9YBa2N0xfnepsIAY3fuh+Ng7nVKe9EQndiXDh
	 mS9pM25EuiSHUjNVJFoBmPazexh5iOmMOiX7IQc6oh+KSjBsRGlfxXaBYszUsBhk30
	 0xZFdkOFtbOmUi3DvV0gNuPSuy87D9D8/Tqh03WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1757/2214] dmaengine: ste_dma40: Check runtime PM in IRQ
Date: Wed, 18 Nov 2026 15:57:13 +0100
Message-ID: <20261118150121.846706939@linuxfoundation.org>
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
index ed7705e4efd19..363df8e15114f 100644
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



