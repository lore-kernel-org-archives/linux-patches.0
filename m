Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044965;
	b=xmwXUxCOuNIGf8P9JB7CqTiZ8kn6hr0Tm8/r9LyQDHDHB0rIa6Xp0i0zflTBx0Nt19Mt
	 Mp3U13HheeV+cFYeHyKMqou4u9gbxiIg35+qsBcmKiAYqbY1lft/RwcY3u3bMUEYmGXIN
	 5JWgBw7VgbpzCjzShMtS1m7cpH14BBpUDoe1TwWzqAVDZZnjXyLZTKCbj0Len/drW5Xmc
	 Anpc+niTszYn5+6eIVEzkFLCrx+QG5HrlwakxaZJ5AnakDAvscV0T9TjywDpauncrEy0q
	 mR7xoTanwVPLmOaDAg7yqy1Owxwk+X7Q+GIi5DUUovbdKL4pqqCb2mR0XuoWCTTWeDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SLzQZiThzC5yZECC0mq7qc5Is9CQb4EYvMd7VBwTuBc=;
	b=lJFakvW/ikoRrGf82BBXVuIaJ3i38zMZf61BQcUKtbUOycHdlCov3GD7kUpZ+xulX/Ke
	 0KQUOmh/44ATZUazS0W5mPzjVKgspDaF+3MSTL5HgBexfT5aYSTjtmb8wBBSaxSCnixhC
	 AqXciLneSv9ekzdr5mW0nKXqo63dhYM7mKjeiKCHsX+KHkpbr9xt4D5OvcSDwuttHNZCr
	 iU6ooedwCqbzdrHG2pZMIJiDCqNziU0rwWQzn7ZNd6nfIU9k7Dnju0ScnEe9p6nyELctX
	 jxxylrnfSp3hoOFXqZPQjpzuuZDeLknevEeW5wgXBhctGNw/42rUCz+FgRIztuOmNRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pEFMr3se;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89561606A32C;
	Wed, 18 Nov 2026 23:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pEFMr3se
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8F21F000C4;
	Wed, 18 Nov 2026 23:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044965;
	bh=SLzQZiThzC5yZECC0mq7qc5Is9CQb4EYvMd7VBwTuBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pEFMr3seNHzNWtZY1W6w9VhSLlJCK5JCle2nhi5MzZW4ze0+G6ESrTUD4UI4LVd5Z
	 9iQn0rGGD7StcqMyEQUNnorx7W0Womr2jAvdyrjbhMNci6pgREJnV7HrdLt/Vn0Juv
	 IBANYafSNLTRYumKdyP3YJUfokh0bYVQW0ogL0TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0755/2857] dmaengine: altera-msgdma: initialize state before requesting IRQ
Date: Wed, 18 Nov 2026 15:29:49 +0100
Message-ID: <20261118150228.736520543@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit a5f8e3471fc20567df888267885dec3eb340eb37 ]

msgdma_probe() registers the IRQ before initializing the tasklet, lock,
and descriptor lists used by the interrupt handler. A pending interrupt
can access incomplete state during probe.

Initialize the handler state before requesting the IRQ so the interrupt
path observes ready software state.

Fixes: a85c6f1b2921 ("dmaengine: Add driver for Altera / Intel mSGDMA IP core")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260830053308.2190597-1-runyu.xiao@seu.edu.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/altera-msgdma.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/altera-msgdma.c b/drivers/dma/altera-msgdma.c
index 711e3756a39a5..3632c63cce14f 100644
--- a/drivers/dma/altera-msgdma.c
+++ b/drivers/dma/altera-msgdma.c
@@ -838,11 +838,6 @@ static int msgdma_probe(struct platform_device *pdev)
 	if (mdev->irq < 0)
 		return -ENXIO;
 
-	ret = devm_request_irq(&pdev->dev, mdev->irq, msgdma_irq_handler,
-			       0, dev_name(&pdev->dev), mdev);
-	if (ret)
-		return ret;
-
 	tasklet_setup(&mdev->irq_tasklet, msgdma_tasklet);
 
 	dma_cookie_init(&mdev->dmachan);
@@ -854,6 +849,11 @@ static int msgdma_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&mdev->done_list);
 	INIT_LIST_HEAD(&mdev->free_list);
 
+	ret = devm_request_irq(&pdev->dev, mdev->irq, msgdma_irq_handler,
+			       0, dev_name(&pdev->dev), mdev);
+	if (ret)
+		return ret;
+
 	dma_dev = &mdev->dmadev;
 
 	/* Set DMA capabilities */
-- 
2.53.0



