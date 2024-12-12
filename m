Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873312135C1;
	Thu, 12 Dec 2024 15:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017492; cv=none; b=NCHSgGmn2sLoZ9zf+xk/TA22sR2uQHdmOWXSB84pGKmOs3ZoYnNWlTbals2QNEVtoYSlhDD6cLlZZPrp5hugyuUzwK5T6aB18TD1OBD9ZOjwcrc1SMFA1It9wfeeSIOecoMwep5tueo7lEnwHJBR+tet5DznwqYj+UE3+RY2S+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017492; c=relaxed/simple;
	bh=Wtu8BM/nJM7bqQN9zw5kYg/sRul6k/rp1CrZHzezaDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p016VfoNHbi98pC4CLCPjeTbvhiL+QejQqm9TTvcCeEL6FVXjxNzAZ4thOxCApxq8YEQk61OarCaw16JkIYnMDExtR80TFfSg/xsQT5RTCT+hPwTvwXmVWNJQUlfkHI5ORwNmLAgteP0+t0SOF+iWSpONaNiyvKcLdNoGgevhy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXxvBRCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXxvBRCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5ACCC4CECE;
	Thu, 12 Dec 2024 15:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017492;
	bh=Wtu8BM/nJM7bqQN9zw5kYg/sRul6k/rp1CrZHzezaDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXxvBRCe3y8P0TvZNhnBO7gDwMZpZcbHZcdxcM8zeSa2fiXH7IsRQuWqgSTVJAWaP
	 YJWHxC3Zl/uG2E9TmLXEaDQ3NyW6xpDYYm+aJH1csMpmt+xpDDsMync9zjmS3zOCey
	 zj3YWpJNkRDZMXZf4GZrIhBnFstKIlMAeYa7yIA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Jackson <andy@xylanta.com>,
	Ken Aitchison <ken@xylanta.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/356] can: gs_usb: add VID/PID for Xylanta SAINT3 product family
Date: Thu, 12 Dec 2024 15:55:24 +0100
Message-ID: <20241212144244.829796198@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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
index 95b0fdb602c8f..ed59451f03cdd 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -40,6 +40,9 @@
 #define USB_ABE_CANDEBUGGER_FD_VENDOR_ID 0x16d0
 #define USB_ABE_CANDEBUGGER_FD_PRODUCT_ID 0x10b8
 
+#define USB_XYLANTA_SAINT3_VENDOR_ID 0x16d0
+#define USB_XYLANTA_SAINT3_PRODUCT_ID 0x0f30
+
 #define GS_USB_ENDPOINT_IN 1
 #define GS_USB_ENDPOINT_OUT 2
 
@@ -1530,6 +1533,8 @@ static const struct usb_device_id gs_usb_table[] = {
 				      USB_CES_CANEXT_FD_PRODUCT_ID, 0) },
 	{ USB_DEVICE_INTERFACE_NUMBER(USB_ABE_CANDEBUGGER_FD_VENDOR_ID,
 				      USB_ABE_CANDEBUGGER_FD_PRODUCT_ID, 0) },
+	{ USB_DEVICE_INTERFACE_NUMBER(USB_XYLANTA_SAINT3_VENDOR_ID,
+				      USB_XYLANTA_SAINT3_PRODUCT_ID, 0) },
 	{} /* Terminating entry */
 };
 
-- 
2.43.0



