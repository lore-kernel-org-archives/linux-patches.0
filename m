Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208750;
	b=to5567MsJM5w03Cn+wxIkq5Hfad9ot4vvcYsz1N1UDPwepzxGQshL00rhdeTFQTnaptp
	 dZm1FEbzUatSqLjnpdB4IlyLpAalljj9D8cKWKPcU/NOmri6IXSLFxWoWm+Bh63adml/M
	 9gVa+OqLQZcpRZu0BKRy37p7sPfeMf8O3jm7E+FImCfnMe8VZZMAQoyhU9GuGUaVowBw1
	 jQYjoZFEoHunfj2A5okHQc/jhmH9cwrvb7gvT4eYC4Oxm1++Rtz16G/IPGwCRH3j6S7HE
	 uZxdev4vHbSaFHiix4DqPUVEfRDDMy6BiKjhrUBtNl8KmlvUdOKyB0g11pRzLBNCJhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=odV6yltEwnh9uzuM3NzH2ZhD5SmfYCPz4HR+bw9GB2w=;
	b=mSbzgiq9rOrt/HNXey0gaEI0BlcOTz5GLc0Y2D4zzA+LoUi6PGyS0R8ui3QQpnoti4uV
	 tYtsRcc/EbJV/8rNhH8zW6EmEbrMbA0T0u+BhkU33cX4RamRRYd9Pru+bczlGpQ48dMRe
	 dtJOPH0V5wVDwWqcjRPJDsLxyIskFaQNA/om8WJe2y1aCbqYgcXLbVPpXNTrnIpUBOW+P
	 /rs7X1dq68P251LPlenyAH8zOja1rn3HfSI132pyBFLN9CzvdorQvs1xXi/YmoZbPEOZa
	 mPWyV/wmp3+6X1d6Mbw5AcmhtjUQrMSp8r8WnHti/ED7lKvS/Hepx8Ww1FhMjr886TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P2/putRm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B93B606A31D;
	Wed, 28 Oct 2026 17:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2/putRm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6551F01825;
	Wed, 28 Oct 2026 17:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208750;
	bh=odV6yltEwnh9uzuM3NzH2ZhD5SmfYCPz4HR+bw9GB2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2/putRmAb+c9Ab6LwUXQ9S+Z9IBNlnwWRm/GfY2FrgcBGKTSoJKiyV3lMOaFJSGr
	 XH0ZTpgqQWcEwfakXDHa3O8lg1RG6GV96hVPvamqK5YE+9O1zPedFsrPGKdwVgO+w6
	 NqwnN7KONl2ctXx3Lb9HZjegsjyT8vkzVV72YdY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 227/516] USB: serial: option: add support for SIMCom SIM8260C
Date: Wed, 28 Oct 2026 17:56:19 +0100
Message-ID: <20261028170008.883859701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

commit 35c950c9ec2c4c4d45dc9b63cfe8fca774ce33a0 upstream.

Add support for SIMCom SIM8260C (1e0e:902b).

T:  Bus=08 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=1e0e ProdID=902b Rev= 5.04
S:  Manufacturer=SIMCOM
S:  Product=SDXLEMUR-LITE-MTP _SN:120696AB
S:  SerialNumber=0123456789ABCDEF
C:* #Ifs= 8 Cfg#= 1 Atr=a0 MxPwr=896mA
A:  FirstIf#= 5 IfCount= 3 Cls=01(audio) Sub=00 Prot=20
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan_simcom
E:  Ad=88(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 0 Cls=01(audio) Sub=01 Prot=20 Driver=snd-usb-audio
I:* If#= 6 Alt= 0 #EPs= 0 Cls=01(audio) Sub=02 Prot=20 Driver=snd-usb-audio
I:  If#= 6 Alt= 1 #EPs= 1 Cls=01(audio) Sub=02 Prot=20 Driver=snd-usb-audio
E:  Ad=05(O) Atr=0d(Isoc) MxPS=  34 Ivl=1ms
I:* If#= 7 Alt= 0 #EPs= 0 Cls=01(audio) Sub=02 Prot=20 Driver=(none)
I:  If#= 7 Alt= 1 #EPs= 1 Cls=01(audio) Sub=02 Prot=20 Driver=(none)
E:  Ad=89(I) Atr=0d(Isoc) MxPS=  34 Ivl=1ms

Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2169,6 +2169,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x9003, 0xff) },	/* Simcom SIM7500/SIM7600 MBIM mode */
 	{ USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x9011, 0xff),	/* Simcom SIM7500/SIM7600 RNDIS mode */
 	  .driver_info = RSVD(7) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x902b, 0xff),
+	  .driver_info = RSVD(4) },
 	{ USB_DEVICE(0x1e0e, 0x9071),				/* Simcom SIM8230 RMNET mode */
 	  .driver_info = RSVD(3) | RSVD(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x9078, 0xff),	/* Simcom SIM8230 ECM mode */


