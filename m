Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88CB1775C
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2693AC433C7;
	Wed,  9 Aug 2023 11:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580189;
	bh=y2X+6Ws0RSAnwqIEIVnYHSMjoQ/u0fwlQxWXNh1VjCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOh9cCXtGKaz/bZWYRNLqRdAdRL8VeT3FeVE6mYdCMmkKFHFfLVybjKdwQfSqb+Mj
	 /JMdBO7URQ+ufnJ8pYwvW4SuS9IcMwivEgErJpVhAgLEDOfYIu6zOzOXRkgVk/BN5+
	 HWEBdbSKAqhSgpPYL2UOkj268L3HIJziCAAZp8lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohsen Tahmasebi <moh53n@moh53n.ir>,
	Mostafa Ghofrani <mostafaghrr@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 259/323] USB: serial: option: add Quectel EC200A module support
Date: Wed,  9 Aug 2023 12:41:37 +0200
Message-ID: <20230809103709.931481264@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mohsen Tahmasebi <moh53n@moh53n.ir>

commit 857ea9005806e2a458016880278f98715873e977 upstream.

Add Quectel EC200A "DIAG, AT, MODEM":

0x6005: ECM / RNDIS + DIAG + AT + MODEM

T:  Bus=01 Lev=01 Prnt=02 Port=05 Cnt=01 Dev#=  8 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2c7c ProdID=6005 Rev=03.18
S:  Manufacturer=Android
S:  Product=Android
S:  SerialNumber=0000
C:  #Ifs= 5 Cfg#= 1 Atr=e0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=06 Prot=00 Driver=cdc_ether
E:  Ad=87(I) Atr=03(Int.) MxPS=  64 Ivl=4096ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_ether
E:  Ad=0c(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=0b(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=89(I) Atr=03(Int.) MxPS=  64 Ivl=4096ms
I:  If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=0a(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=88(I) Atr=03(Int.) MxPS=  64 Ivl=4096ms

Signed-off-by: Mohsen Tahmasebi <moh53n@moh53n.ir>
Tested-by: Mostafa Ghofrani <mostafaghrr@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -269,6 +269,7 @@ static void option_instat_callback(struc
 #define QUECTEL_PRODUCT_RM520N			0x0801
 #define QUECTEL_PRODUCT_EC200U			0x0901
 #define QUECTEL_PRODUCT_EC200S_CN		0x6002
+#define QUECTEL_PRODUCT_EC200A			0x6005
 #define QUECTEL_PRODUCT_EM061K_LWW		0x6008
 #define QUECTEL_PRODUCT_EM061K_LCN		0x6009
 #define QUECTEL_PRODUCT_EC200T			0x6026
@@ -1229,6 +1230,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, 0x0900, 0xff, 0, 0), /* RM500U-CN */
 	  .driver_info = ZLP },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200A, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200U, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200S_CN, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200T, 0xff, 0, 0) },


