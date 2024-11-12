Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DE0210184;
	Tue, 12 Nov 2024 10:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407481; cv=none; b=m3eeh6PLp9GRAT8Ury8AL6n611TaiVoiK9qW6VkazwwJlq8gkqxp9Rh3P4DiuBU/yFk4VFKYdGLZc5UH27Lv9IOX8MGCy+Qq0uFOtlMdizsVRP2TE9zShtutx4E4eKUNqh1ETVdlh8L99l8/3kBA7/3wd2yZZDT0BbChUodo3pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407481; c=relaxed/simple;
	bh=IASFF7H0SSH7n5RL1qvnwM46YOnDXFVMC+3CIugJO4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daEr20XVkGT0YzrTQSQ/2pe2AWbNIzrsn+FQz/0AO8tZCM4E6Fg0s1jXrOZlGbTuSskldXnaOO0khB1OyYIT5JG2Ank7nK4q2x6pQcjgrF/UEHAzqBeqxJ3ZP9tBZVRa/4hdAW00HxtYiWItaYDsaQZRnHwAFScEFIN/6PwhTIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EprGS/dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EprGS/dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36ADBC4CECD;
	Tue, 12 Nov 2024 10:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407481;
	bh=IASFF7H0SSH7n5RL1qvnwM46YOnDXFVMC+3CIugJO4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EprGS/dngOI4rFtF/UqZsV9SicTPcPFxes3Zcb81La5fW6Z8cZHJ1FvgwTnpMcZBp
	 lP6jTsVSN6YjjAdbJyRKZEQTdRpm7ULpsNlBM9PKIqrnZea/o7Kd0rwUaZ09J7BHEN
	 4Iw1TbQ8zSGrWNyyRieM8DrLZDkdtPZTECRMSeyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinhard Speyerer <rspmn@arcor.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 89/98] USB: serial: option: add Fibocom FG132 0x0112 composition
Date: Tue, 12 Nov 2024 11:21:44 +0100
Message-ID: <20241112101847.639148005@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinhard Speyerer <rspmn@arcor.de>

commit 393c74ccbd847bacf18865a01b422586fc7341cf upstream.

Add Fibocom FG132 0x0112 composition:

T:  Bus=03 Lev=02 Prnt=06 Port=01 Cnt=02 Dev#= 10 Spd=12   MxCh= 0
D:  Ver= 2.01 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2cb7 ProdID=0112 Rev= 5.15
S:  Manufacturer=Fibocom Wireless Inc.
S:  Product=Fibocom Module
S:  SerialNumber=xxxxxxxx
C:* #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=86(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2320,6 +2320,9 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0xff, 0x30) },	/* Fibocom FG150 Diag */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0, 0) },		/* Fibocom FG150 AT */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0111, 0xff) },			/* Fibocom FM160 (MBIM mode) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x0112, 0xff, 0xff, 0x30) },	/* Fibocom FG132 Diag */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x0112, 0xff, 0xff, 0x40) },	/* Fibocom FG132 AT */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x0112, 0xff, 0, 0) },		/* Fibocom FG132 NMEA */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0115, 0xff),			/* Fibocom FM135 (laptop MBIM) */
 	  .driver_info = RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a0, 0xff) },			/* Fibocom NL668-AM/NL652-EU (laptop MBIM) */


