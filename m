Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92CE1DF74E;
	Wed,  6 Nov 2024 12:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895754; cv=none; b=GkQ3E0qN/wPNiB6hDnUTgVwFnbhwReCFDHU6KnbF9R0oVs9qhzR6TL7CyjXv3wfFP0Ks7Xv8TPTSjjd2SIFVyTwRgdbdSxk7r5FcH+6wz6AMjnRm6UtIAp8oZvz5K6acvrRMXOeDdg3T/L7aPHjQCqDW0xVXRDlugSwx3ppagwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895754; c=relaxed/simple;
	bh=MvmopqHxWcSBZn3Z4hs61yfwYtLH8HGg/zcwAz+oMqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5VLYp+zHtqYbMEzFop/DQ4S4p0tnxBfSoJLkCsKZzZHUnUzhHFFrlnmUYi3uF9O++tFx0qqI4be4O1DrB/1j53qDkmXWpbG7wEDigQ4aCMs8fQw3Nmp8U54xTSyypmaELgX97zLCvWv8kle09Ak3AHFQ6tpvutK3QybhFyzus8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFnzKl3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFnzKl3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB9FC4CECD;
	Wed,  6 Nov 2024 12:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895753;
	bh=MvmopqHxWcSBZn3Z4hs61yfwYtLH8HGg/zcwAz+oMqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFnzKl3A0BEbW2irYhd9XrMLKtH42b9CrbDwEnKFUCfvpF6/gwjZY5pGmPyEm6T+1
	 3XxipTOGASLO2TmRDOANCsLNVHAs1LSRqbyb05eLIfCOMqYW+IWSxt7Vd+yZ+n70W7
	 MX9175hxxo63KxIaYRkFjdi7Pg3YaLF2rYL0MbV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Anand Moon <linux.amoon@gmail.com>,
	Jochen Sprickerhof <jochen@sprickerhof.de>,
	Felipe Balbi <felipe.balbi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 323/350] usb: dwc3: remove generic PHY calibrate() calls
Date: Wed,  6 Nov 2024 13:04:11 +0100
Message-ID: <20241106120328.721322931@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit a0a465569b45e3690be155c96fb54603d6904f41 ]

Calls to USB2 generic PHY calibrate() method has been moved to HCD core,
which now successfully handles generic PHYs and their calibration after
every HCD reset. This fixes all the timing issues related to PHY
calibration done directly from DWC3 driver: incorrect operation after
system suspend/resume or USB3.0 detection failure when XHCI-plat driver
compiled as separate module.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Anand Moon <linux.amoon@gmail.com>
Tested-by: Jochen Sprickerhof <jochen@sprickerhof.de>
Acked-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Link: https://lore.kernel.org/r/20190829053028.32438-3-m.szyprowski@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 0d410e8913f5 ("usb: dwc3: core: Stop processing of pending events if controller is halted")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 4002c6790be6e..259eeb2f6ad53 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -167,7 +167,6 @@ static void __dwc3_set_mode(struct work_struct *work)
 				otg_set_vbus(dwc->usb2_phy->otg, true);
 			phy_set_mode(dwc->usb2_generic_phy, PHY_MODE_USB_HOST);
 			phy_set_mode(dwc->usb3_generic_phy, PHY_MODE_USB_HOST);
-			phy_calibrate(dwc->usb2_generic_phy);
 		}
 		break;
 	case DWC3_GCTL_PRTCAP_DEVICE:
@@ -1178,7 +1177,6 @@ static int dwc3_core_init_mode(struct dwc3 *dwc)
 				dev_err(dev, "failed to initialize host\n");
 			return ret;
 		}
-		phy_calibrate(dwc->usb2_generic_phy);
 		break;
 	case USB_DR_MODE_OTG:
 		INIT_WORK(&dwc->drd_work, __dwc3_set_mode);
-- 
2.43.0



