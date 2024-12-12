Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8A1226545;
	Thu, 12 Dec 2024 16:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020612; cv=none; b=YEKf9xpctN1Dph3Yz48M9Hlo4gX20z/3fu5L25Vm+OaOWw56c24dfsFMPB4Wlk0ynsNVcp1jDKwnh7AeFBsoh1j0DIYZgET5nDeZenz5kU8qLU7+aFz95N5TOY5KDu1dqSIvnCBSS8HeZJnnXt8J5fNSIPm1ICY57BUCVVxDxNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020612; c=relaxed/simple;
	bh=c4kvDavTnGq5DdOxHJVl2pf5vq8NtoXV1lp/Lfg/riA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwttQJgLDJAKfM18R33Fw0xSg3/VAlsHG5hc44gCnfHkriKcFwx/Yc9XstiuXT5uPcs5dNT2jvC2EZ29vkKAglPSZKqOEyf7D+e9uiBXVaf6Jmk50twdikAxhbFMlSFY7Jys2fG03Gq+WKXk8v99Vk/cn3Zqq2skaR1U5octQbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gtk/UQkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gtk/UQkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA9CC4CECE;
	Thu, 12 Dec 2024 16:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020612;
	bh=c4kvDavTnGq5DdOxHJVl2pf5vq8NtoXV1lp/Lfg/riA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gtk/UQkAdI76zne5sCqCeuhMRvD16a46LWnbTcvi/b+a+ccTZbCAYblpweIoS2x28
	 JtCCYPzBTaoE05+wv+fjjTN3hMSW+MWy2J8VSeJBbRTCdHAAQr4pHY3BHlhQHEaVV4
	 MP+Etqch9rX7ZBfifC8WbUuy2cG/3n2ijGkn8rIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Jackson <andy@xylanta.com>,
	Ken Aitchison <ken@xylanta.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 513/772] can: gs_usb: add VID/PID for Xylanta SAINT3 product family
Date: Thu, 12 Dec 2024 15:57:38 +0100
Message-ID: <20241212144411.152172679@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 69e2326a21ef409d6c709cb990565331727b9f27 ]

Add support for the Xylanta SAINT3 product family.

Cc: Andy Jackson <andy@xylanta.com>
Cc: Ken Aitchison <ken@xylanta.com>
Tested-by: Andy Jackson <andy@xylanta.com>
Link: https://lore.kernel.org/all/20240625140353.769373-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 889b2ae9139a ("can: gs_usb: add usb endpoint address detection at driver probe step")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 257e5f10ff1be..6dd4665c82900 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -38,6 +38,9 @@
 #define USB_ABE_CANDEBUGGER_FD_VENDOR_ID 0x16d0
 #define USB_ABE_CANDEBUGGER_FD_PRODUCT_ID 0x10b8
 
+#define USB_XYLANTA_SAINT3_VENDOR_ID 0x16d0
+#define USB_XYLANTA_SAINT3_PRODUCT_ID 0x0f30
+
 #define GS_USB_ENDPOINT_IN 1
 #define GS_USB_ENDPOINT_OUT 2
 
@@ -1448,6 +1451,8 @@ static const struct usb_device_id gs_usb_table[] = {
 				      USB_CES_CANEXT_FD_PRODUCT_ID, 0) },
 	{ USB_DEVICE_INTERFACE_NUMBER(USB_ABE_CANDEBUGGER_FD_VENDOR_ID,
 				      USB_ABE_CANDEBUGGER_FD_PRODUCT_ID, 0) },
+	{ USB_DEVICE_INTERFACE_NUMBER(USB_XYLANTA_SAINT3_VENDOR_ID,
+				      USB_XYLANTA_SAINT3_PRODUCT_ID, 0) },
 	{} /* Terminating entry */
 };
 
-- 
2.43.0



