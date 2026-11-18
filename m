Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038268;
	b=5WUeKbyVRz0oY7pH+7W+K7bQyq1Jm56LwOG9oQu7HUr8iMczmgUFV1Bt+rHEkCBgDeQ7
	 UIl224I6Tg8/YWO+L6Xx/hN3mqLJspAtzizKoeI10Y/c+GejTMl8xFMKXuen3+3jH06qx
	 CEDh7kPSGJpSK708pgcp/+Kljb33WMYgVSuRuHlRlvmaW0sptbtvFhBcP/oBVqn24G/KI
	 Z1tmw5emsdNz1+ku6U119rApR3GOVSufI9A8wH02uQp8DcX3eLBnriijdFIhIRFdiRRtx
	 kE+MEPurtUnvENORKOJgQXwqBQxG9H3f2KZIptWkAlGEwdniJ20Gk2j9e1QBNjSbSgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=824GjKwKEPWbumSDg4Cipg/kBC0HCULzw+FOVpYK6I0=;
	b=5dxW+69LctB1egYEdl7vvySuunqSgTxcC+oGp0e9dyWyE3aMAvyvlSF4X5RjdT+MZV2o
	 AoD5ppQusC1ELfOS0Npjp4QyBO50MQ8ZK4b3+ec3d3h6wI8lfOQ5u1xv0JuSsR85nI+ej
	 lYIDxixTOGQtYtuYoji5XkPf2WsKkL4WVHNT+T3MT+q1LUXMlOMq8V0uV/6++IDtPFvFV
	 LawUy32q+1SgKc5sjrPIM4dJQOat1YvaNguJub+hW74/HcMJwtVC6cTg0+dHanIYRUJOM
	 U41htN9aQZTKI3/ODjIOWA/TZhZnq+A5h8WfTnisFjH+lx1E0B+jfnXuLGoQfz87yWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VscCkuaF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F96606A31C;
	Wed, 18 Nov 2026 21:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VscCkuaF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E301F000C5;
	Wed, 18 Nov 2026 21:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038268;
	bh=824GjKwKEPWbumSDg4Cipg/kBC0HCULzw+FOVpYK6I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VscCkuaF5BSBxLaeghLkOTCVuatAQjSTd+1bxG+hcq4iGnqcRNeHo1AZdykY0HD1M
	 gpMMTlG4zsEIVi6HtAzmKAoPW6VuigiT6+o13cISv+s+xpwTwsS0oWYA+VI9k1VtuG
	 KNtiXfxO24imvKpWzpFFh2lDr4BoTLVAZVLytlU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
	Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1684/3318] dmaengine: qcom: bam_dma: Defer IRQ trigger type to device tree
Date: Wed, 18 Nov 2026 15:38:26 +0100
Message-ID: <20261118150412.336229990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f931e63e1884f..03638e4f505ca 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1323,7 +1323,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 		bam_channel_init(bdev, &bdev->channels[i], i);
 
 	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
-			IRQF_TRIGGER_HIGH, "bam_dma", bdev);
+			IRQF_TRIGGER_NONE, "bam_dma", bdev);
 	if (ret)
 		goto err_bam_channel_exit;
 
-- 
2.53.0



