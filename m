Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C5963B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F6FC433D2;
	Mon, 20 Feb 2023 13:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900406;
	bh=HTuqdd9OGGU6Cz+MUQeRKhOrCT3xznQCojLGmo7hxqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHsrdoKlt8XHSFCdv92SJIvsSaVSisAltQdzaRW/JfhvQC8EevCqbh1ZDNz2b+fUK
	 UP58ivPwgYTweykspA8KOYfGcyak9LpZzVlOXHU8NN0NvzKWUwEZinBWHvAWNSczlw
	 zBkl9bsHhpHGHUQSKkAQEQEQ5nLL2t6m5Zt+QLpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <wcheng@codeaurora.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/89] usb: dwc3: dwc3-qcom: Fix typo in the dwc3 vbus override API
Date: Mon, 20 Feb 2023 14:35:12 +0100
Message-Id: <20230220133553.571160976@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit 8e6cb5d27e8246d9c986ec162d066a502d2b602b ]

There was an extra character in the dwc3_qcom_vbus_override_enable()
function.  Removed the extra character.

Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210704013314.200951-2-bryan.odonoghue@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: eb320f76e31d ("usb: dwc3: qcom: enable vbus override when in OTG dr-mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 9d5320562e81..07135be83593 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -85,7 +85,7 @@ static inline void dwc3_qcom_clrbits(void __iomem *base, u32 offset, u32 val)
 	readl(base + offset);
 }
 
-static void dwc3_qcom_vbus_overrride_enable(struct dwc3_qcom *qcom, bool enable)
+static void dwc3_qcom_vbus_override_enable(struct dwc3_qcom *qcom, bool enable)
 {
 	if (enable) {
 		dwc3_qcom_setbits(qcom->qscratch_base, QSCRATCH_SS_PHY_CTRL,
@@ -106,7 +106,7 @@ static int dwc3_qcom_vbus_notifier(struct notifier_block *nb,
 	struct dwc3_qcom *qcom = container_of(nb, struct dwc3_qcom, vbus_nb);
 
 	/* enable vbus override for device mode */
-	dwc3_qcom_vbus_overrride_enable(qcom, event);
+	dwc3_qcom_vbus_override_enable(qcom, event);
 	qcom->mode = event ? USB_DR_MODE_PERIPHERAL : USB_DR_MODE_HOST;
 
 	return NOTIFY_DONE;
@@ -118,7 +118,7 @@ static int dwc3_qcom_host_notifier(struct notifier_block *nb,
 	struct dwc3_qcom *qcom = container_of(nb, struct dwc3_qcom, host_nb);
 
 	/* disable vbus override in host mode */
-	dwc3_qcom_vbus_overrride_enable(qcom, !event);
+	dwc3_qcom_vbus_override_enable(qcom, !event);
 	qcom->mode = event ? USB_DR_MODE_HOST : USB_DR_MODE_PERIPHERAL;
 
 	return NOTIFY_DONE;
@@ -513,7 +513,7 @@ static int dwc3_qcom_probe(struct platform_device *pdev)
 
 	/* enable vbus override for device mode */
 	if (qcom->mode == USB_DR_MODE_PERIPHERAL)
-		dwc3_qcom_vbus_overrride_enable(qcom, true);
+		dwc3_qcom_vbus_override_enable(qcom, true);
 
 	/* register extcon to override sw_vbus on Vbus change later */
 	ret = dwc3_qcom_register_extcon(qcom);
-- 
2.39.0



