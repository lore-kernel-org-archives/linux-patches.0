Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE364315A;
	Sun,  7 Sep 2025 20:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277420; cv=none; b=riFmUzFdlNucgLKkvNdaacuv2Q0XMtZVl1PtobEQIpVkRo0oCtlzopv4U5183O5g/cZZpgik2//ZTAJY4zt7tXZxpMmw9l7mB3sMBTWlY7a+dhWBrBp3pCNev6XcZJXWCnEXTLX4w9MXX3DW2DWN0dMPR0wdMgL4+vwcWG01nrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277420; c=relaxed/simple;
	bh=0LAy0ou1BL0j+bde1EZ8sUm9bhxUnPTXgh/zs7Q6/4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSv549u907/CRZhIW7Z3AlH9+I6jS6QIoykJjOGeGoNMrbtCS/K+joDUt1DJp6uYb4ttIDojaGVKjj7FPPCD26uPDfRrnVNW+LHPXhMDI5B5Ui2kxc5pnxreEJTtE2Ucr4ip8OFRGqt6QuNu6+wckXBvSfGR1OBMhy9O0pAHHaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znMviweb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znMviweb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C625CC4CEF0;
	Sun,  7 Sep 2025 20:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277420;
	bh=0LAy0ou1BL0j+bde1EZ8sUm9bhxUnPTXgh/zs7Q6/4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znMviwebdLPJqNQFrb2E0D1s6KV1v9akVxuiOGcd/vHZRrsDzlu9ikaY0ijtIenPE
	 HFIApwVJMTi3TJc1gWlzD/D76Rd9+PXLF0ulWyV2zbf+AKx9Ckza0tjNNyX8mZoHOu
	 QPwhruoUzeeA6PC58QrnQpLCs6rl9tSVvWhaqFZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 010/183] cdc_ncm: Flag Intel OEM version of Fibocom L850-GL as WWAN
Date: Sun,  7 Sep 2025 21:57:17 +0200
Message-ID: <20250907195616.039742639@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 4a73a36cb704813f588af13d9842d0ba5a185758 ]

This lets NetworkManager/ModemManager know that this is a modem and
needs to be connected first.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Link: https://patch.msgid.link/20250814154214.250103-1-lkundrak@v3.sk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index ea0e5e276cd6d..5d123df0a866b 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -2087,6 +2087,13 @@ static const struct usb_device_id cdc_devs[] = {
 	  .driver_info = (unsigned long)&wwan_info,
 	},
 
+	/* Intel modem (label from OEM reads Fibocom L850-GL) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x8087, 0x095a,
+		USB_CLASS_COMM,
+		USB_CDC_SUBCLASS_NCM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&wwan_info,
+	},
+
 	/* DisplayLink docking stations */
 	{ .match_flags = USB_DEVICE_ID_MATCH_INT_INFO
 		| USB_DEVICE_ID_MATCH_VENDOR,
-- 
2.50.1



