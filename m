Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9192B3B19BF;
	Sat, 17 Oct 2026 17:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256725; cv=none; b=h3ebVsLtxsHVBTMaRWG+QEUDmKzq31ozuix2Kwq4idB082QCRVB829A75Npt5Zrpgrs7/EakNmjt4wXxhC00vStxhktGgT6rEabE3EFchBkAmLZx8G4itx8HAo9/ndrHHfSDrVyO8PnE2B2STtLebfuQnVo9KvCiE295e4tioDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256725; c=relaxed/simple;
	bh=6FyiI9K5LSfKe/Abf98MlonYK/qATN+G8kTggeSDyPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YecnARC1fw7RLtsz9/YGgujfQdNybFbC5Ks55+Ia308jMFju9B9oDDIHRyQgUX+gvKb8CqqBKFfP9C7H1SfbMo6lGWpR0CM/Q34E4SaJsDC5+ElyiyWPpjU1pBA/wdl0p+jPJaacFi6Vulpz0YI4ylwj0Zv1OG4r226aJ90y3ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpoA4I0r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpoA4I0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59F51F000C4;
	Sat, 17 Oct 2026 17:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256724;
	bh=I0S39P9IkcgRdXqHMuyH/NiQFxdVr2GRDlMVynlIQTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IpoA4I0rtKNa8PT9ZHTidR8dTpvt7Ba+2AUWxG2FNed9x6AtYnZdw39vaJQmodSB8
	 Rl/8G8ZGhM/RGqrYe1KzuyYZXGDMuZHjCdnSrlRnXN8BmA7zWPfN4u00bkiULWWGeW
	 +JfoHzwyfZOJAZOEA3MpHBxAwpKTSWxDOUvpCYtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Lin <ian.lin@jetone.com.tw>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 0330/1674] USB: serial: option: add Compal EXC-T1 support
Date: Sat, 17 Oct 2026 17:43:22 +0200
Message-ID: <20261017160439.598919667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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


