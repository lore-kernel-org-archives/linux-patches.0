Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063955;
	b=xmozNwDC1aIg56d0+69PP2U1CTMTMgvNvPW5EtJ5e5nF8Nf1B9dP5zHJTH4P2sV2vjIG
	 3jEZXLBB4IvOkUdgOGQHyZNovVW0KxM3lJVHgD7+Om2WlDG6KF9R9njXyCiv4rVNIMmzs
	 YjbwvQzLLA2+8E3kx1Lh4UdfvcjTzw4R/8VHD8vIEZWczDqBHqKCC+gniqBAPSf5bRGlf
	 q3E8LQfwdA49Nb1aM5eRTNPlSTx2IpdLJ6SIprN4zN4HoGL5kJBkoFjObGdVNil5uuMKH
	 C/omhl6jOoLIXw58DURhjl8eJ+jjOABZUvrvZe54Ux2MWuQQTuVpw8LOpBKeOFi5cjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mbr7nzieq95pMgSXGsxfFNGgpKySEgengTRH1CI7g7w=;
	b=cmiyVYekeJiImCU2SYLPxb3BGOPTy18qv2VfhxTvJ1LtjmvsoqVUOZMt7xiwdD7tpi/+
	 5jq0PN4LiuO1XtVbUU59/TWRlDHCpw6IdXwMTDBiIC3cMWbVTOw9aDs+ruq+Z/PSDbzh7
	 p7rusWeajpRhg5FqYhNJKjjXn/5Y87m3Fvc4YeYmhZnfeeXQXSn5qB1tFgPKeu17mjHWH
	 aCHWDD8Uw12J5ySFB7hFm04qDhuSeQEypXf9H86rZQ3drdbL9ngNzffmBWbIJcDktdhiE
	 0ZDfzXrR6nAOAvibfDnQk056iFxvqx+yEa4pYKrCOf9GYnQo6VOiV1mf1VbzPov3eUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xrxg9lQG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DB76082BFF;
	Sat,  7 Nov 2026 15:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xrxg9lQG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993491F008A6;
	Sat,  7 Nov 2026 15:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063954;
	bh=mbr7nzieq95pMgSXGsxfFNGgpKySEgengTRH1CI7g7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xrxg9lQGZwZE7ZPA9KqrSlH1P1hdwukOwx1Q53Amf8J56VX4gPZmua+FvQcEF8639
	 1p2TAuq6Ea+PV+34iVULg/uqGc2x3ye9uJ4jC1aG50b41FO+P2vbudwLqKo8IJ3cbK
	 MV/wv1x3XqUPfMuo3wzjheHNUVMEMknMjeaGEJ+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0127/1257] dmaengine: altera-msgdma: initialize state before requesting IRQ
Date: Sat,  7 Nov 2026 08:40:23 -0500
Message-ID: <20261107134942.833288058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index e23e5b441a24e..412f4bce1d4aa 100644
--- a/drivers/dma/altera-msgdma.c
+++ b/drivers/dma/altera-msgdma.c
@@ -847,11 +847,6 @@ static int msgdma_probe(struct platform_device *pdev)
 	if (mdev->irq < 0)
 		return -ENXIO;
 
-	ret = devm_request_irq(&pdev->dev, mdev->irq, msgdma_irq_handler,
-			       0, dev_name(&pdev->dev), mdev);
-	if (ret)
-		return ret;
-
 	tasklet_setup(&mdev->irq_tasklet, msgdma_tasklet);
 
 	dma_cookie_init(&mdev->dmachan);
@@ -863,6 +858,11 @@ static int msgdma_probe(struct platform_device *pdev)
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



