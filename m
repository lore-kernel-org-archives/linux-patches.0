Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208762;
	b=LaZWuNg34QiHjOZmMYdkiI5Lk0I81dUZOJIp88wu5dwgZwxER5phrHZSNdFwMiziLvAs
	 YR1ah596KiVVB0uPiKda9RMVngecgUKw1XHjiwubf4nVc85PGXSJ7wGr2HPeeIZ/wk9IE
	 0B2MMdRzrX7JEy8fAysGaMY49sakIEX9xdzIA0z+N845qp+QeQaj/Il6/RT0e5/n7mqOg
	 tfWcnk32pwDPRNMAJ9+WgpNkR2o7pbtMvvtikXoh5MWRXGBpvil2gcFsLP879wQeEd0hf
	 YV6SbQ8nqmQEDOsvCVu3+0qjYCf/apilHvfzS6PVWbfMQN33LyhTFicLxhb67VfpxPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BT4sNdNTk9zwN4tuecDY2xVxw3N8yVpV01IMKAmeaf4=;
	b=IfxuM8gEgSCKWbWmTZCFTNllGdKUR/eg6E4WxVwTQnxP7eFEQU2p6rN94yV30aGolGY4
	 TmTsm4vYzh6IOSWdY0u9Cs5ibgOtosIirE0DLBqjS1MiNsh8tD7s5embA41tBzqcs/3xX
	 uGvxfinN0v9pkH7VRMlTZOxbyE829H0/M/T0yQWpSknOk0q4uY+Z3MezxUZAMoHwL50rB
	 8YcTFpb0lYjLokN09vDyOU5S33fe0pp5bl4bbbp0opBB6ucLY3WlXQh6cXw6EZ3i3wT6r
	 wKdZT2IZojPVvYIc//hbO7rFPQdANkaWC1mMGCbQxZtY5E41aOcrXl4nmZ5HmmKJhUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsFwQHNi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3007606A31A;
	Wed, 28 Oct 2026 17:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsFwQHNi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134861F01825;
	Wed, 28 Oct 2026 17:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208761;
	bh=BT4sNdNTk9zwN4tuecDY2xVxw3N8yVpV01IMKAmeaf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TsFwQHNiyMUIjpFPU07YIHZs7fgCnEbb8eacrDS+edxXVy5fT0Wz3CKDqmIgQACSh
	 ZKoy2CgyAwDDyBxFIFcyO4MRxmerAap3nu3ajcCTAjMRmn0Btdw5NuTtEBl6TqVTpR
	 YINjZlN9ZER71bGyi53uxowiO/J5dIRN7pi2NoQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Lin <ian.lin@jetone.com.tw>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 231/516] USB: serial: option: add Compal EXC-T1 support
Date: Wed, 28 Oct 2026 17:56:23 +0100
Message-ID: <20261028170008.977684701@linuxfoundation.org>
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

From: Ian Lin <ian.lin@jetone.com.tw>

commit b51faf3f2e307f114854bbe6d495f03cd5370686 upstream.

The Compal EXC-T1 is a Qualcomm MDM9207-based LTE modem which reports
"EXC-x1" as its USB product string. It exposes diagnostic, modem, AT,
and NMEA ports as vendor-specific interfaces with subclass 0x10 and
protocols 0x01 through 0x04.

Add exact interface matches for these four ports, leaving the ff/ff/ff
interface unbound.

Relevant output from usb-devices:

T:  Bus=03 Lev=02 Prnt=03 Port=03 Cnt=01 Dev#=  6 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=04b7 ProdID=4d22 Rev=03.18
S:  Manufacturer=CEI
S:  Product=EXC-x1
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=10 Prot=01 Driver=option
I:  If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=10 Prot=02 Driver=option
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=10 Prot=03 Driver=option
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=10 Prot=04 Driver=option
I:  If#= 4 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=10 Prot=05 Driver=qmi_wwan

Tested on a Compal EXC-T1 modem using an Ubuntu kernel build. The four
serial interfaces bound to option and exposed ttyUSB3 through ttyUSB6.

Assisted-by: Codex:GPT-5
Signed-off-by: Ian Lin <ian.lin@jetone.com.tw>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2437,6 +2437,10 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe167, 0xff),                     /* Foxconn T99W640 MBIM */
 	  .driver_info = RSVD(3) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x4d22, 0xff, 0x10, 0x01) },	/* Compal EXC-T1 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x4d22, 0xff, 0x10, 0x02) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x4d22, 0xff, 0x10, 0x03) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x4d22, 0xff, 0x10, 0x04) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x30) },	/* Compal EXM-G1x */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x60) },


