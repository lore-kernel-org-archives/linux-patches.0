Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036428;
	b=gjRDhRgr6BdxKGCegTksqLQx6z7jsDO6fX1IzVFT4//nT2aWwxLx2L76KrToGocMKesL
	 zJomQSD7Ks7Vf6UlYSD7b+VOtL6eRqqCTqL//rOXSSgnqnRU/vr7kOmcHpsYHXqEltlJQ
	 +k91pxCC3aj3vrySSHNr5SyjiZAn5zzfNt0DUNBpgIChBTxwkpX3RkGdSNCbh1pdJWdK0
	 UgEunIVwBMkqLbw+TmJuLJ0lZLjR0PXiRtZVDZ10ObMPw9KIKPG/TZuA6rWlUWbBvgIm0
	 7FSIN+IAdWXHH2lkObL95P7MFOSQUd8ZbjuNQob+J0Bfm0DhzcdgW5s4QhFJ2V0En+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=okDGrJ99Li+a7l8PqcIeqrTS7Ncdox8fhM5vntp2gLw=;
	b=FAayF5taDP7Zv6LkOH1UFvxN+GshWu8xJTUE8bB0LQ1vLr6uRH2nYU2PGBQCJw3bJPq/
	 E3ZqadzjYa9837/gBAz3R2zl8aRSnsOGAle3IDpT+bYBmZ6OFiiczN7nAxLxPQUiKKyXJ
	 t/847TCk8zlHTau670lhM5cXjl3+Y3mEapl9By3V7oFd8+VSiizULhYv+mgF9Ebpnzww1
	 /Fm57jdAyT+O/uV/7hclHkjohW02v3UUA3cPzM+/LU0wtNAcukRSkr7g87wvUI/gJPtoF
	 8Ql+RWG7gjnrSn41UKD/6TaO4nZOYGkrqEp67OVOfywfUuSUS8otdkgekT56JeMQfdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WP2PazTB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543F7606A320;
	Wed, 18 Nov 2026 21:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WP2PazTB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE06A1F000C5;
	Wed, 18 Nov 2026 21:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036428;
	bh=okDGrJ99Li+a7l8PqcIeqrTS7Ncdox8fhM5vntp2gLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WP2PazTBh9ftecK8Xd1nlGLwTWOzezJRYsVlon/+N5cixzzb078k3sHXh9qsb77ZV
	 j8QXRBi3CR3FhDdcARIzyR1FhKmhWm/HedwPqkoS1xto0WyKGAiNkmG3MZrM0K7qrz
	 fjOx/FMywWTxddhDqiC893Pdv81HkQTpiRqdbeGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinhard Speyerer <rspmn@arcor.de>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1054/3318] USB: serial: option: add Rolling Wireless RN947R
Date: Wed, 18 Nov 2026 15:27:56 +0100
Message-ID: <20261118150351.553541274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b1f903fd69500..e00c967bedc89 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2511,6 +2511,10 @@ static const struct usb_device_id option_ids[] = {
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



