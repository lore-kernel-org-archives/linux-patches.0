Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064584;
	b=eyyII5CuAUoSqS3RqwOZ+gL4MWdxLy3AaX2rVbIkiEkZ9Zwe2CfErFuqGyV7YYJbpVNS
	 5rLcAk6tR94gqiJ6EF6nuVZ9lFDPcfgAwVwDEGlsZRLgNPuy0HICLZ2oOpxFp/OTvFTL7
	 PbJ+DBc0Bdi+7+VfEgdL1t5P5RoLE1+YfYrHRN8yHjJ/mZw1L+/s75+YItpuSrb21oqBH
	 3PlsrxEvuTT3RfAiOCpqnrNlcEOxkXXg8fs+wJLsffMnZohFAKewdu5C4C1adtqf0EAb/
	 gXJGmY20HkHl9kBskPGMVh8huv33yQgJ4sWEZp66Kww5qqM/1vGTlkAg3AVz++NHJWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t8bPbqW4ntpHqson6gL8sKByIFVpr2FW3OctwodbdvE=;
	b=4iR3pe6/wFibLwrIeH9XLdyVQccVxa3EDTbzvFE6Lwezem2f5oLwlqedbBcfmUOUQDTk
	 i00+a1Itr+bJLpMHHZuMoPs6BfgaIgTlz6q7jpESL4tUIpY+bUDZ+ET+8ti/LG81jw/Vs
	 CwaK10aQS9zHvBj766iT6q+TSdEVkSXXzFSXeU0e6YELZNquw2yY9pLp+t92Nwk89SbUN
	 f/DWmckkTDZlGvSyM1UrO3YHNDRCEl+/V2E8YJrn0dD4Y6GzB1xUMmQF51HzB3UrSTTBh
	 JxkZ+4oMJwgve4f+ds6yKL+K2zSHXDxZPOLWMPYYLg8stw8ivlyHzKdDYeVogaifb4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLtLzMrW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72390606A9C3;
	Sat,  7 Nov 2026 15:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLtLzMrW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215671F0089F;
	Sat,  7 Nov 2026 15:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064584;
	bh=t8bPbqW4ntpHqson6gL8sKByIFVpr2FW3OctwodbdvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLtLzMrWfqYynN7RvE6CmfoTWfh4A9Jbkiy5BqkDVMAtx34S476eP2fmWHA5VFT69
	 2RMzKQSQyn1AATQ9Ll4hKq3EJmWBhhDvuluyR7NCC3rzdofX0s+tdSZ7ByaH+yOSA0
	 yjRLrv4O2AOZl7X+L1jScZsxarIab5ElsOmlMCLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinhard Speyerer <rspmn@arcor.de>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0602/1257] USB: serial: option: add Rolling Wireless RN947R
Date: Sat,  7 Nov 2026 08:48:18 -0500
Message-ID: <20261107134955.944223460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinhard Speyerer <rspmn@arcor.de>

[ Upstream commit 931aad81f3f2d26276fff6b7bda6793267a65725 ]

Add Rolling Wireless RN947R 0x9300 compositions:

Standard mode: DIAG + ADB + NMEA + MODEM + RMNET + QDSS + ADPL

T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=02 Dev#=  6 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=33f8 ProdID=9300 Rev= 0.00
S:  Manufacturer=Rolling Wireless
S:  Product=RN947R
S:  SerialNumber=xxxxxxxxxxx
C:* #Ifs= 7 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=usbfs
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=86(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 8 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=88(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#=21 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=70 Driver=(none)
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#=22 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=80 Driver=(none)
E:  Ad=8a(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

QDL mode:

T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=02 Dev#= 12 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=33f8 ProdID=9300 Rev= 0.00
S:  Manufacturer=Rolling Wireless
S:  Product=RN947R
S:  SerialNumber=xxxxxxxxxxx
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=  2mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=10 Driver=option
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/option.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 828b1be3fee2d..dc8f459ca3995 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2510,6 +2510,10 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x1003, 0xff),			/* Rolling RW135R-GL (laptop MBIM) */
 	  .driver_info = RSVD(5) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x33f8, 0x9300, 0xff, 0xff, 0x30) },	/* Rolling RN947R */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x33f8, 0x9300, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x33f8, 0x9300, 0xff, 0xff, 0x10),
+	  .driver_info = ZLP },
 	{ USB_DEVICE_INTERFACE_CLASS(0x3466, 0x3301, 0xff) },			/* TDTECH MT5710-CN */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for Global */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0x00, 0x40) },
-- 
2.53.0



