Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053761;
	b=P5CMr011nAixCvl85ZfBLytIICyQzBQIe8BcsCWi1TH3iR6Hf09JxahHb28zPsNT8tM8
	 SnTCb3uX979vzaZZC9x6Ryc0eqGqf8nArbIopS3o4+aJm+kC2/CQhWsmqyE5efp+UvRgt
	 5EnP/ogNAAAgfonp/yhc56FSofDIY/n6BEQjyNoq3FytZuneIsDjfqc4f8cwSZ32CoFcy
	 RkwnrvJUr/2QF8aIrRkueT5VgHzB1LbMDdi6PhB0JEF+zIVN9jj45TSwDdzjuDp5H01Fi
	 RXvHkKPtBBr13Ki94lFhhQ9lLwvJCRYPeECb9FCOKVR5RL0kzALW0T2sKMcgqD5wtcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=scC2rqSOkjPD1HMAMSOoqasm1SGZ3gmg3pb5xsLStMo=;
	b=WCSdKHQjnEsIS2QRQSv5eakX/IcoeMerqIuA9fQecDY47yPvV9FyQVfOPmF0joTlwqsp
	 sXq+Ud726iU/ld+Eehz0QcRYZtRFndGbs3m+2K34UOhfC+GypX3ftepMOPz5s43yN7CZZ
	 2YE+ltv7fFO4L72QKy78gHSgkmm3JBe/gEJuth9bMJiJ2N/hxGMIpOKctwwoKXT5opIAC
	 N9fpDibKZB4BRKEwndQCjRS/eXgn+4xLwiaK8tjRrEjzxKRReu7fijdL39HD3LZ9XcSx3
	 yA3a+zCvMwx47v772n4Q3z0La2R6z+VbEsKUgkbw9D+moAtndSB38IHrCRRu59L0Bfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u0RkL6BT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA7F606A31C;
	Thu, 19 Nov 2026 02:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u0RkL6BT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E3D1F000C4;
	Thu, 19 Nov 2026 02:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053761;
	bh=scC2rqSOkjPD1HMAMSOoqasm1SGZ3gmg3pb5xsLStMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0RkL6BTAW+/xA2NJpFssGEvDOtAsI6plPNDIXz13TH2pQkV+uooHuVPKq6zK7R9e
	 Xu+krdBPeA+85Pot1cgd/kjkx4n40K2Gq9qMUDQYx0odYywQFdgeZcMjhB1B8hKjI5
	 OioIMJMTWq5agRfMekFWAFS/zUgPXXLJydZDviO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
	Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1034/2214] dmaengine: qcom: bam_dma: Defer IRQ trigger type to device tree
Date: Wed, 18 Nov 2026 15:45:10 +0100
Message-ID: <20261118150053.737834321@linuxfoundation.org>
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

From: Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>

[ Upstream commit 3cee6f79553202d7d3954555560ac38d719344b8 ]

The driver hardcodes IRQF_TRIGGER_HIGH when registering the BAM
interrupt, which overrides the trigger type specified in the device
tree. On Qualcomm Shikra SoC, the A2 BAM signals an edge interrupt
to the apps processor; registering it as level-high causes the
interrupt to not fire, resulting in missed DMA completions.

Use IRQF_TRIGGER_NONE instead, which causes the kernel to use the
trigger type already configured by platform_get_irq() when it parsed
the device tree interrupts property. This makes the driver
platform-agnostic.

Fixes: e7c0fe2a5c84 ("dmaengine: add Qualcomm BAM dma driver")
Co-developed-by: Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>
Signed-off-by: Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>
Signed-off-by: Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260717-qcom-bam-dma-irq-trigger-v1-1-6405eac86f00@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 82eed160cfa7 ("dmaengine: qcom: bam_dma: free interrupt before the clock in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/qcom/bam_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 51c9e7c6b2abe..91a0669881c9c 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1301,7 +1301,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 		bam_channel_init(bdev, &bdev->channels[i], i);
 
 	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
-			IRQF_TRIGGER_HIGH, "bam_dma", bdev);
+			IRQF_TRIGGER_NONE, "bam_dma", bdev);
 	if (ret)
 		goto err_bam_channel_exit;
 
-- 
2.53.0



