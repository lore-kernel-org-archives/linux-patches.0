Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC25A2F39
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118C5C433D2;
	Tue,  7 Feb 2023 13:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775507;
	bh=VABBjr9mrARkZ+fI/Xk9Qj9ilYzC4AM3ssk59QkQYgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBPD/CW83kAaFwTeLdXQKY9zdhDidSH9yKifeN7Sqir1ztwmFN+Ij/KVyvLiCnc9n
	 vHySfAiWcI08Y3m0qSG4eZMPp+4y8Jn2clY6wuj0swahKYNXQFmmzHWsoe+DiSONA7
	 JlfSPq9OpkOGctWIskQRRShkkhaxyE6MORWwNL68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/120] usb: dwc3: qcom: enable vbus override when in OTG dr-mode
Date: Tue,  7 Feb 2023 13:57:14 +0100
Message-Id: <20230207125621.437706711@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit eb320f76e31dc835b9f57f04af1a2353b13bb7d8 ]

With vbus override enabled when in OTG dr_mode, Host<->Peripheral
switch now works on SM8550, otherwise the DWC3 seems to be stuck
in Host mode only.

Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230123-topic-sm8550-upstream-dwc3-qcom-otg-v2-1-2d400e598463@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index ec1de6f6c290..28bc7480acf3 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -836,7 +836,7 @@ static int dwc3_qcom_probe(struct platform_device *pdev)
 	qcom->mode = usb_get_dr_mode(&qcom->dwc3->dev);
 
 	/* enable vbus override for device mode */
-	if (qcom->mode == USB_DR_MODE_PERIPHERAL)
+	if (qcom->mode != USB_DR_MODE_HOST)
 		dwc3_qcom_vbus_override_enable(qcom, true);
 
 	/* register extcon to override sw_vbus on Vbus change later */
-- 
2.39.0



