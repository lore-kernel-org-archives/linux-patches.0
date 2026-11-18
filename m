Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059503;
	b=ln9Vad5zDuddxD80G/GSzqol8OlUCZ4sMxrKjZMkNwpmTPPfleWnmUisUVAlqaAVLuHO
	 NjJmkMv10G4cO+Eqtmmr5ViXZHcx2YAngDsTb6NOMFTOA5DWbxHdk3ZIkgABPoJ0CbYsA
	 7oI0e7dQ6mHO4JJQSW9kAbwGo4EV55ZKXIJjzaq6stWUXxQ0ppvrEqNdLAFAxzuXMIk1K
	 M36NCj+63FIjfUFwR4zHQvOt3kYtLJba0aVl2h7jVHBKVEuKtxQnvJdTpj7T00tTvYXza
	 kDo0X+QPD9UO/+eHk5v3aSo9fCWgw+bfn5pe17/52eYQHtaWuqWbGNLtGir3pwiCq6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L7IlZHXqE4/S0++lPnr/ZSh9E+jPEJTlBlmbPLS/LoE=;
	b=4Hm3mTtCbKGjtugQ8kZ57X88QB89enU4xljdKf3XUqrSfY3qJsT/456c2HFpDg39Csi4
	 48122aCqENmRv7BCZogY1p8Jm4s6mX3sYLQxnb60aeZnPgY66bMmCVXY4Z2MhSsSJ8Wwm
	 GQ7JFe9rxoxOwbYYaV4+djWSv/qtNTTh0UjTjpA9q0lZrgq6ejpS3q0NeCADRc/JTMsDs
	 MZ3ExriBqUhj/oPr5WM2rNUeRrx3B24M7P30tugvCXeHBca/swCytRY5miv2CqMrh2SqG
	 TprjBnKHfGbo2UKckzZWQ3qfhQshmInAHG2308P2ZCrWzf3+vbFrb0O5+9Yvgv3+/jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGvancX9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26296606A320;
	Thu, 19 Nov 2026 03:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGvancX9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777C61F000C4;
	Thu, 19 Nov 2026 03:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059503;
	bh=L7IlZHXqE4/S0++lPnr/ZSh9E+jPEJTlBlmbPLS/LoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGvancX9XyV+PnBMF03glmZPD5kMldv7A/1j1QCudtpV1YEMEsNQTBBxM/W4GebOJ
	 ZQFtY7G048m9jIt9P2IZVEzNAPD9+LTZlSnCjJxO7jlIV90hgJ5C5shsm+9HdoMtei
	 c8J2Yq3hdWJK321yATtw3Tnw7+PLtp5qGLtgegII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
	Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0865/1848] dmaengine: qcom: bam_dma: Defer IRQ trigger type to device tree
Date: Wed, 18 Nov 2026 15:48:23 +0100
Message-ID: <20261118145952.691004200@linuxfoundation.org>
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
index db9359d259e24..f931f074dcdb8 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1313,7 +1313,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 		bam_channel_init(bdev, &bdev->channels[i], i);
 
 	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
-			IRQF_TRIGGER_HIGH, "bam_dma", bdev);
+			IRQF_TRIGGER_NONE, "bam_dma", bdev);
 	if (ret)
 		goto err_bam_channel_exit;
 
-- 
2.53.0



