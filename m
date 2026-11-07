Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061962;
	b=xPEvVcmunw8ZoJSVXesJpbWYAuRDb83yYPYaGEruoBgWIntHHuvckDpsJWzso/LMgOtl
	 zgjmBsdWU8xDdX0UtOHeR15xckH7B9Y7Faf9PccdFjLtjFTW7WHsIP9AbCP6/cGlBzda8
	 and9ktMnj2yKVo7z4vvVHX9bayn5eh1e5gOIRp2EFOOvoqF6P9wTRQ0oeddNZmD247p8O
	 5HYcpVwF2aHfWL2KfwdjfBnrDhhxyGxrH2cnx5i7mUiIUvU25gMB/eTiVBkjtOCo9sRIJ
	 R0txCP2uRQsFdH9hKylEz2eVzF/5w93cHlsHx4QiSIxB/qd+PraqySJXxIPgrFoD70A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F2Qby3c5SjFXfgKdZb++wGMR9Hv5qhSY07FjsEdec0U=;
	b=HOFHnSdDokrAX/KjRjOs71ESLuvlZ3iMIA1b85frl3cdCoDn+mu0XhL/UW5q/PDqK155
	 Yi9Y1Q5KWShQRS7D4XUQMZMVlsG3B0ERkRKXxoXXnZ3WewXYGNHyZjLwSi5bRWGBR2UrG
	 dCNaD+el8fpfO2Wnc5FbmxD/JIGjgtOTDqu1V/Saf4cBGIGJ8C3aeb7UtDOMfDXYNjfiX
	 /zwZSsy99PaxT6uqjvqci2TDdTeTN+jTc+Js2zlxVK0U8Hqs8ram6iE9mBBpEhuuBLXiG
	 7nUptQh4IKV1wnXaElf0mYJu9afcrF4GOHTyrAAJ1HG1yxVvB5vHeWb5RS4dv1BsS7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MJq6tGsR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3A8606A335;
	Sat,  7 Nov 2026 14:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MJq6tGsR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0581F0089F;
	Sat,  7 Nov 2026 14:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061962;
	bh=F2Qby3c5SjFXfgKdZb++wGMR9Hv5qhSY07FjsEdec0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJq6tGsRcyt181Xtslm/3i49s//KZOCbeT53EifF8nNB+lQuaSamQ2ePXsHGmWh9u
	 ERw7Zp10pb0nVF1DEIUIubYp6bGyMOcDOtJ0k9eavlYpxSLozs0N+ZhYB4SECkWVzW
	 y3mUxzar9slUYM8RMQ+ZSTJeUJIj2BD7fdEQJKPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0960/1536] dmaengine: altera-msgdma: initialize state before requesting IRQ
Date: Sat,  7 Nov 2026 08:49:36 -0500
Message-ID: <20261107135024.614950720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 5b1be7162b432..7cd736a96d521 100644
--- a/drivers/dma/altera-msgdma.c
+++ b/drivers/dma/altera-msgdma.c
@@ -849,11 +849,6 @@ static int msgdma_probe(struct platform_device *pdev)
 	if (mdev->irq < 0)
 		return -ENXIO;
 
-	ret = devm_request_irq(&pdev->dev, mdev->irq, msgdma_irq_handler,
-			       0, dev_name(&pdev->dev), mdev);
-	if (ret)
-		return ret;
-
 	tasklet_setup(&mdev->irq_tasklet, msgdma_tasklet);
 
 	dma_cookie_init(&mdev->dmachan);
@@ -865,6 +860,11 @@ static int msgdma_probe(struct platform_device *pdev)
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



