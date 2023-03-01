Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D9D847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFCAC433D2;
	Wed,  1 Mar 2023 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694219;
	bh=fML4Bsj97FBCWZenn6eZbnOIZ6XKRbVET63UOWWhLyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Or5fMyWIFVK1KyXFe2mAJCxuE873a0dgbgvlkOyKHo/DD89I5DXY6WlYzctc5hHSH
	 TmmwAx9V6dDMkDL/iwYR2gLzFEnuN9C1FDFl7RB7McZCwVCuXVS2DipZFWISSCDa5S
	 Jm0kavUZVTGi53KQqmAGxE0H8nTrqHP9OzQysRCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Zumbiehl <florz@florz.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 17/19] USB: serial: option: add support for VW/Skoda "Carstick LTE"
Date: Wed,  1 Mar 2023 19:08:46 +0100
Message-Id: <20230301180653.019361346@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
References: <20230301180652.316428563@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Zumbiehl <florz@florz.de>

commit 617c331d91077f896111044628c096802551dc66 upstream.

Add support for VW/Skoda "Carstick LTE"

D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1c9e ProdID=7605 Rev=02.00
S:  Manufacturer=USB Modem
S:  Product=USB Modem
C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)

The stick has AT command interfaces on interfaces 1, 2, and 3, and does PPP
on interface 3.

Signed-off-by: Florian Zumbiehl <florz@florz.de>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -402,6 +402,8 @@ static void option_instat_callback(struc
 #define LONGCHEER_VENDOR_ID			0x1c9e
 
 /* 4G Systems products */
+/* This one was sold as the VW and Skoda "Carstick LTE" */
+#define FOUR_G_SYSTEMS_PRODUCT_CARSTICK_LTE	0x7605
 /* This is the 4G XS Stick W14 a.k.a. Mobilcom Debitel Surf-Stick *
  * It seems to contain a Qualcomm QSC6240/6290 chipset            */
 #define FOUR_G_SYSTEMS_PRODUCT_W14		0x9603
@@ -1976,6 +1978,8 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(2) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
+	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_CARSTICK_LTE),
+	  .driver_info = RSVD(0) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
 	  .driver_info = NCTRL(0) | NCTRL(1) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W100),


