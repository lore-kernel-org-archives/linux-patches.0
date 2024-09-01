Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E2733987;
	Sun,  1 Sep 2024 16:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208001; cv=none; b=Vsy5TKpS4SYAkoaZTXlyI8aGnnV5teTawOf5TEXGQL4/dv1RvxtNKutKCAkYiequF9awiWIhPYphOhoBEt2qqGN9U3h0u+cl8K5NP+RRhvYAAlRZ/o8/7WW33NMQDgkKxat5xcG8T2OGfrCtBMk4WZ7duh9Dv/4wr9/3o3woDdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208001; c=relaxed/simple;
	bh=9TjyFAvUnlgTyoe4avufSvrRPwItTX+oi2Ew42v9+ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7+6y6jDkA9sazyTTCnJyumu5xSkUlYrJKM1dyGhNGSdfL+g/GVr/YmxMHIfpjUKTMD8AVG80I8VvcxJaTZRI80IDwSbiUzlEbs8okTTaQlkCQDYwqHR9NAZJkdtU8ZQKMOC5B+b1qC83bP/XR6FB7PcDAc8Y6i1WKG1BXEQ7ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+do/nF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+do/nF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16977C4CEC3;
	Sun,  1 Sep 2024 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208001;
	bh=9TjyFAvUnlgTyoe4avufSvrRPwItTX+oi2Ew42v9+ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+do/nF4alyQuSl1Tbc7mFBEWAbO2IpqYig6im0T7fxZ0kgddCYC/weXWF5r4nxYv
	 UW+ok6G0Ct4Alb0knmR0f5kkZx6oDg0Ty/Z6NnrkqNPAmA2VFl6YLxiJlvnlnj7swJ
	 eaOvRVIXH9VQ2He5gcy2FCAJYh2f81cXvAIDtpV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 44/93] phy: fsl-imx8mq-usb: fix tuning parameter name
Date: Sun,  1 Sep 2024 18:16:31 +0200
Message-ID: <20240901160809.021071750@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit ce52c2532299c7ccfd34a52db8d071e890a78c59 upstream.

According to fsl,imx8mq-usb-phy.yaml, this tuning parameter should be
fsl,phy-pcs-tx-deemph-3p5db-attenuation-db.

Fixes: 63c85ad0cd81 ("phy: fsl-imx8mp-usb: add support for phy tuning")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20240801124642.1152838-1-xu.yang_2@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
index 0b9a59d5b8f0..adc6394626ce 100644
--- a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
+++ b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
@@ -176,7 +176,7 @@ static void imx8m_get_phy_tuning_data(struct imx8mq_usb_phy *imx_phy)
 		imx_phy->comp_dis_tune =
 			phy_comp_dis_tune_from_property(imx_phy->comp_dis_tune);
 
-	if (device_property_read_u32(dev, "fsl,pcs-tx-deemph-3p5db-attenuation-db",
+	if (device_property_read_u32(dev, "fsl,phy-pcs-tx-deemph-3p5db-attenuation-db",
 				     &imx_phy->pcs_tx_deemph_3p5db))
 		imx_phy->pcs_tx_deemph_3p5db = PHY_TUNE_DEFAULT;
 	else
-- 
2.46.0



