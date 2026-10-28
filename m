Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211061;
	b=i1MHB9xbElipmJddA7ej26815NiHy+I+/hPUH44G4dwQxirRqHJVwNhu55UYM0X/oXlB
	 Ftx5GCCdGAbff52uCCwzLfkbqbJc5BsNN7ylYcP/+si6NcIJB0YWlaUmZV413E1XlmcfR
	 VFKqyBvLjppSOzFq8csrus3Yj+vWLelzsZQLmDMAc6puQes25ZDUWxOwlGWo5OwS4fnO1
	 zXO3DgFj2u8o7krIlYCofH4WLbpVyxx8xQAg8kcmCK4WQKlfAoctAuZ2OqmP8kmrVZazc
	 JGYZFRPLCZrAjT8LESUEMwVJfYQEZMYZ2RgegflV0Z2vQDvcRNDv0xralTxtHYeWRoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5yFu2x+iST67jTnUKZt7sOvIBTmt89v6CMhfA+hpnzM=;
	b=BU9cHaC6iHMAGo71ZikL0bHgtRnQVdfL2U5keUEk/W4prlVLWLPYToaLBujL9+gbO8rJ
	 HsyY3RibsjE5mF1P7YjHynGMU2xzprptWTXOQm0Lb9WAdR5/70AzjJPcZKlkx1IhT4z8N
	 mWsPlEz1/mocNmHGA7EwWKtrHc4tNvNTOurVBeNi9EJ6XkT7LUvIKAJEoIU2i3Uy+b83f
	 +7iGvuNZ79kEV9+dyQvAvBMFJrT8vQ6Bss26l8q1Nwrtyx8s72jiTXxvahCxpC9Majn0u
	 aw7b9fctn1//NYqgEBuDd9aKRjWGQ0HcmlvuKrp1L1kc6PO15OUFNtCH+d74qB6AySw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JuLKb29S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1873D606A32E;
	Wed, 28 Oct 2026 18:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JuLKb29S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896551F01828;
	Wed, 28 Oct 2026 18:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211060;
	bh=5yFu2x+iST67jTnUKZt7sOvIBTmt89v6CMhfA+hpnzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JuLKb29S8WcA4Y7AWzhWkZjXJF98IJFG1DYzeg8zW1iQi9JsPraQ5H0+EZYd9Cu+o
	 avl1/lxDtUsQhPm71fMfYtb1V472c4h/gDqmIvKa/QVOZFKF1/i/vZkk2Vd87lA1jv
	 d/B8xBpppfOzoK1ddoLEP0C0xs/Z77XApaJ7WTcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 245/571] USB: serial: option: add support for SIMCom SIM8260C
Date: Wed, 28 Oct 2026 17:56:32 +0100
Message-ID: <20261028170013.819359879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


