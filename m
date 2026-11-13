Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585906;
	b=kgiR2HJlm3IK3elGvSV51pzhmLDt1/xkuWL6tawMT5i4jOFJNRocuyGzMQcfvqTNDOtR
	 BSDm5MDsbMtc6ZDraI4i3eiMzm3k2TvvTEgofpNQJ7MNYMWTYIZ34GvZFm0WOsMeJsr4N
	 44UgtBqjKdSg2Kvi5ZEN5nzJ0dGhC2oSoX8u14cQZkPoT45GfnoL8dFttjMb9iLeFcAa+
	 9zHtTmme+XkD59dpA5Og/2HooohQ3katecxs+QU5qOkNl5YrsjGgFkQNQUZ9arHKiBres
	 k7A2Y3dTlj/azhRoVWDZnBslQoWaHrDesY/9JNY0Yxz3PGJwGQriJXkrvey9Tr1BZow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aSXUa8BH2glKsSv9Q8yueZq62fcquIB/QEwyIUjKhng=;
	b=3z+fGXcNV3mgw1FVmYnXnfK9aG2GtPEAj3Fs4rQvDjTJFgXW/U/ZjfwSIFJPfs72wPib
	 ibTI/CnRFJLoQJ/XToKhLlIoI/2zKYUgCzayz6vxZijb/f5LE6ugmSdkwXjij+bqp4Vnc
	 jlJ05Ich5wrsvYmsx5tAb6Dgx2QRsqmugsL7ut2Rl1z16o+XiBouCjWm5YLWPQ9Giuvia
	 BO968ZEiamFtEEu3UQPJf2WF5fD7alOdzDDm/JdGKSKV8SjxfAsvwiu6Oq35RKbng9Gw0
	 8ItFxEmwEX0i3gdK6CMorHRECQ3/i0DbZDkrs4wMB0SuaW7dezGGNXUsDf2uULo0lDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rznFege6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6F06076217;
	Fri, 13 Nov 2026 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rznFege6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB72B1F000CB;
	Fri, 13 Nov 2026 16:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585906;
	bh=aSXUa8BH2glKsSv9Q8yueZq62fcquIB/QEwyIUjKhng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rznFege6ttZ954Mb6BP8b4udtqG9lqEWeZelqaYqKG8ktmfwaBeczKDbEh6bcd0FG
	 4WEwFo8o3akh1ESQXTspa5ZliwAmiJ40F4oijhXJ5PuFv2FrH+Y25wt8RZ+cMOnPV0
	 NYbyyzAk5MPDJF6+MSDnYy73u03Wm8gJFWWoMUkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
	Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 471/507] dmaengine: qcom: bam_dma: Defer IRQ trigger type to device tree
Date: Fri, 13 Nov 2026 10:52:55 -0500
Message-ID: <20261113153812.757449028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 05a3b1f9e0c23..94cb957d4b187 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1333,7 +1333,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 		bam_channel_init(bdev, &bdev->channels[i], i);
 
 	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
-			IRQF_TRIGGER_HIGH, "bam_dma", bdev);
+			IRQF_TRIGGER_NONE, "bam_dma", bdev);
 	if (ret)
 		goto err_bam_channel_exit;
 
-- 
2.53.0



