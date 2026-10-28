Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212925;
	b=oqNDzfzYT/HiMa/a01GkzhqP9ZNLvbB+6YcCo0KEFnLjFrZid9z3v5LyXHqzqyc8g2hA
	 fuBvbYfmOo5OQPyA82HUHHMnW28IhGgRdeRsh4yF2DXbVQvLWrTuH3DRDeAB52LKztDH6
	 IOof7YrlrN6hhlsqifeqwBlkSROz5A5Ck4PTNEstOVwcfIrbOOa8EH+eB7S0c77ebG9Sm
	 GAcQ7PWlEbrmudbbkF/2g1pxNmDv/aqxRO3fjUrXaNs/SK+KGnJagDWrSPKDma0mcWG9B
	 1XifGvGc16dgGlL7O0spMECboPRnHJ0pzVJYAkb88L60sgQk2C+w3Wofr7kZhlg1XEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rpvC6D+ziRcO9k5iLmNtDSBiTNqDp9sa/ZQw20WhFYI=;
	b=Ze2VqgzmogqdyvK9LtOszNnPyOFt42vGkPjM56AzbUuDJNnD6fjrJ/FbZFPK+6Beyq+Z
	 KjcBijM5yxuCQkxfDADnBZF7Yq4GD7k9entv2XG4Fa6G0Rnq3VJ4N1sqNFY0mknotMS80
	 VHppRnXTgu8yWjlFnCEjuMNq8XObhEvwn3lDweF6HGxEHhXlgd74O0MCK4xFEgdUhblyD
	 xv8N8uCF7SLQFPCuFzt486V9PHkjQGmcYoxmJlFGdtVZSWHSa6YNOBnil1qVRzibtw2d6
	 ZIGTzloUr4JQZcHwV8swlr79i8sXIEbG5HAwc77Pbq255QnpPPHO9WMG1uNkTIc9lcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKXJSJak;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1C3606A31A;
	Wed, 28 Oct 2026 18:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKXJSJak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C958A1F01825;
	Wed, 28 Oct 2026 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212925;
	bh=rpvC6D+ziRcO9k5iLmNtDSBiTNqDp9sa/ZQw20WhFYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKXJSJakvENoOekC2beaZSWgl2tLH3O8s16r+dqwIBX7OO8josWsJV10jh0IDUqPZ
	 tf0ZDkFrmcdT+rlHbJRgRWJjehVw4FDaIkSuOZ4epx4QmkmzTzVQ0A7kSuU8xv7u1U
	 h4JPETACIkGUPKdyVhcFbS4SttV/qiWO7RQbaHBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0324/1887] USB: serial: option: add support for SIMCom SIM8260C
Date: Wed, 28 Oct 2026 17:40:20 +0100
Message-ID: <20261028170506.605529907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


