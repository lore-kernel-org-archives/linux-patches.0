Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058150;
	b=lpN+8bJOR93DcGiuTRehiUQ3Zc7XEtkuZYWtAdZtoI61GTRmWIV+QRf42UwI8Y2MZLdw
	 v5Ih60B5EgT5KvuAZGC5kbuHwLDbL6R9rzgKCDt6hCVEe7oAjy4N3+eXGJAEq2Dyf681L
	 N1cBOzxPfMmeYj8JTAG3i6zYgUFSkRm0a7XatDtpT36VJuv/ASEeWOMxAlsehGWRqyMLj
	 P5KzdSNjkd2x8LMeH/AVHTRQK0TUFx10ePWmOQezRMD11Wuby56dBvxfy9PRh3HjQhp/+
	 2quAuVscWR1L4G0wSkMqNywNTH+ikcSRJw2/cAL0z7stiZ0CBA2EDRgRZ3vRqSIvhhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r1N5Vv6tvkEOnnY4DFdZlEsa0xcsh9Hgg88Syxb4HZM=;
	b=SgshNN77FN2kP3llcpU+US3bpEABNViG4nAkvaiWgX9Y/376kZo0ojS4GCzmOZR3+IVy
	 jmatzJ4KPXLhRvTO6EsWQJTeX7uIUrjf9pqmi1uyqIWkXHQmtG+BT2bn+KFrUeeymupt4
	 T9mBROE5TXEsmb5vwY9Sem+WGgEcc1cGA7ArtLsfet6wqBMnCeplxB83HG7Zd2pxyrlGm
	 dF8lbw7uN1lLEh25O66UMQwKUqrcqoPINiOnK9d7ArW8hV4XqrEk0AzCuZJMhD+ud3AtN
	 M85l6RvF3FoyV8hjoKyYdhLc0aagxsUHF78iS+UstDFBUCvCotjCHtLUEbezRD9Zt8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q2kr51S7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205AE606A320;
	Thu, 19 Nov 2026 03:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q2kr51S7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7061F000C4;
	Thu, 19 Nov 2026 03:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058150;
	bh=r1N5Vv6tvkEOnnY4DFdZlEsa0xcsh9Hgg88Syxb4HZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q2kr51S74QPLIBZL6pr5hHOBS9GFgqduLIAHN/dW1x9sAulEeqbZaqjD454yYQDip
	 MdemBZ+nd/v15RgyCiBJFnnDV8SuBfi5x+01ORQxYjvPyrAb8ygsLxSCu2Dacd1b7a
	 rpTuq1X/YYpmxtZI4ibGnGsG5BcFVcWRQmTOpikc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0382/1848] dmaengine: altera-msgdma: initialize state before requesting IRQ
Date: Wed, 18 Nov 2026 15:40:20 +0100
Message-ID: <20261118145929.563774876@linuxfoundation.org>
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
index 9a841ce5f0c50..f850de8a8181c 100644
--- a/drivers/dma/altera-msgdma.c
+++ b/drivers/dma/altera-msgdma.c
@@ -825,11 +825,6 @@ static int msgdma_probe(struct platform_device *pdev)
 	if (mdev->irq < 0)
 		return -ENXIO;
 
-	ret = devm_request_irq(&pdev->dev, mdev->irq, msgdma_irq_handler,
-			       0, dev_name(&pdev->dev), mdev);
-	if (ret)
-		return ret;
-
 	tasklet_setup(&mdev->irq_tasklet, msgdma_tasklet);
 
 	dma_cookie_init(&mdev->dmachan);
@@ -841,6 +836,11 @@ static int msgdma_probe(struct platform_device *pdev)
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



