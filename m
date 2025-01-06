Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042FB1514F6;
	Mon,  6 Jan 2025 15:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178597; cv=none; b=iGGhWwbe6c4ZpqmGoXKFQ52h8z8MKWTVslUwo1jiPdZBl6DJjIJ/5DfRpnYULDAVldvaE+UiOGf97+yhxD6RL0DyTWiw0ZZiBEMUEBrNB0D7XT4l0TqOF+Vd+spYVULb5WB/AayGkuAazcgu1jy0QrPwK4DgvNmyokvdtYbwpeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178597; c=relaxed/simple;
	bh=EZmzJEUQSfE2cnWht/1CE133B4QuWK88YcfFS2XQHTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJu1CX6O6BXBGJPPzeG/PlMEMq2HqqYreBL2Tuq2zCGKZR2OGh9vf6ktq8FjI7On9habSBCEYET1yk49+qXHaBWx+EqRl4kZlQYMxywLLiKKe0epNlW1jaKZZViIHJEO2WbvkZw5KFfcME5haOh2YPaVkwWyYt1NHGUbEM2WxIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+vPAa1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+vPAa1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF5FC4CED2;
	Mon,  6 Jan 2025 15:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178596;
	bh=EZmzJEUQSfE2cnWht/1CE133B4QuWK88YcfFS2XQHTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+vPAa1foLsnm2mX+DmZj1AsNhrGPvWwNc0Q5pP32u1YfYJWkumGsJEPxTjl2WlR5
	 mUYkvZ85jmMRLT/IwqBUhKTA891HvJ5aUtrAmH4O8Dd2OfOjCXynLP3gG4xextvZtL
	 Fnf/gnt36Ck41SlXLpRR6Ixu/qgR0JG1bAqWo/Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mank Wang <mank.wang@netprisma.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 030/168] USB: serial: option: add Netprisma LCUK54 modules for WWAN Ready
Date: Mon,  6 Jan 2025 16:15:38 +0100
Message-ID: <20250106151139.601186465@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mank Wang <mank.wang@netprisma.com>

commit aa954ae08262bb5cd6ab18dd56a0b58c1315db8b upstream.

LCUK54-WRD's pid/vid
0x3731/0x010a
0x3731/0x010c

LCUK54-WWD's pid/vid
0x3731/0x010b
0x3731/0x010d

Above products use the exact same interface layout and option
driver:
MBIM + GNSS + DIAG + NMEA + AT + QDSS + DPL

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  5 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=3731 ProdID=0101 Rev= 5.04
S:  Manufacturer=NetPrisma
S:  Product=LCUK54-WRD
S:  SerialNumber=feeba631
C:* #Ifs= 8 Cfg#= 1 Atr=a0 MxPwr=500mA
A:  FirstIf#= 0 IfCount= 2 Cls=02(comm.) Sub=0e Prot=00
I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:* If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=8e(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:* If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 6 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=70 Driver=(none)
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 7 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=80 Driver=(none)
E:  Ad=8f(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Mank Wang <mank.wang@netprisma.com>
[ johan: use lower case hex notation ]
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2377,6 +2377,18 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0116, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for Golbal EDU */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0116, 0xff, 0x00, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0116, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x010a, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WRD for WWAN Ready */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x010a, 0xff, 0x00, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x010a, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x010b, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for WWAN Ready */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x010b, 0xff, 0x00, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x010b, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x010c, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WRD for WWAN Ready */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x010c, 0xff, 0x00, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x010c, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x010d, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for WWAN Ready */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x010d, 0xff, 0x00, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x010d, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(OPPO_VENDOR_ID, OPPO_PRODUCT_R11, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0xff, 0x40) },


