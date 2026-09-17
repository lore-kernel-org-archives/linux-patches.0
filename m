Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B6959C97F;
	Thu, 17 Sep 2026 16:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661222; cv=none; b=SfLXfYNNlALvVuJp9ns6+ytQsf0xUKo1zz7pg7QmPEq4NMeE5hprkQazMPFyTkYuWWAJuA6ioHY3Q5XOBC6WiqHnA9jc+Tz8hcCeUKOiGztPfRxMnHDLF3c202+D7yLb7ft+GTUXhQjM+nR5c5Y0ccN7FFeoJ2MVkR6YBQpvQFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661222; c=relaxed/simple;
	bh=qsVUNYiHzQu3vlzjNYIO4exiNewtVnTsy+Q/hDhEV7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tm5MVY0aRYA9RpAW6o12swwE7rRxohxQWB53ruViKnLDLFcKTC3daivsFybxyHaNyGR0RnhCyVJkIgiMUv1upohM17sw5kFo1zeZnDF0/uY8pERGqoN6WF8X7RQTG25ED6Q6YVeoUWgdkLUGEAQsAaajLMYl2f91WxYfVirCQt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDZvjfnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDZvjfnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC2C1F0089C;
	Thu, 17 Sep 2026 16:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661220;
	bh=bhufxlEcjh4i+D1kZjV/PCDXNn//kl68BRq1OD25jno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDZvjfnUg6uMHc8P5Uo1aFY1jfHH1Hn6YytjueG6OIR7crvTmNXQmkzcM3NY2F392
	 1siRiUC96Ubhyr3876CRxwm872xBTKLVPpOMUipFDQyZeNCFv+dpqpnv2Lr3WrlaAC
	 v1o8HU62ZE7mzipQwn3KeRZsJ8AYSn2d04+7Ijec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0084/1250] phy: qcom: m31-eusb2: Make USB repeater optional
Date: Thu, 17 Sep 2026 15:57:59 +0100
Message-ID: <20260917151554.255644059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wesley Cheng <wesley.cheng@oss.qualcomm.com>

[ Upstream commit a62bfbcf2db4ae6eb7a544a40b1075a81784ea41 ]

A repeater is not required for the PHY to function. On systems with
multiple PHY instances connected to a multi-port controller, some PHYs
may be unconnected. All PHYs must still probe successfully even without
attached repeaters, otherwise the controller probe fails.

So make it optional.

Signed-off-by: Wesley Cheng <wesley.cheng@oss.qualcomm.com>
[abel.vesa@oss.qualcomm.com: commit re-worded to reflect actual reason]
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260302-phy-qcom-m31-eusb2-make-repeater-optional-v2-1-dbf714c72056@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-m31-eusb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c b/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
index 9434bd22ef32d..275df38256de3 100644
--- a/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
+++ b/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
@@ -285,7 +285,7 @@ static int m31eusb2_phy_probe(struct platform_device *pdev)
 
 	phy_set_drvdata(phy->phy, phy);
 
-	phy->repeater = devm_of_phy_get_by_index(dev, dev->of_node, 0);
+	phy->repeater = devm_phy_optional_get(dev, NULL);
 	if (IS_ERR(phy->repeater))
 		return dev_err_probe(dev, PTR_ERR(phy->repeater),
 				     "failed to get repeater\n");
-- 
2.53.0



