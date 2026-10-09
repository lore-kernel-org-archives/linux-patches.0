Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178D9399CE9;
	Fri,  9 Oct 2026 14:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556742; cv=none; b=WF6LAwJyrgy1jsWjTLcj943RxT5ux43h8d47M+2MAfnMwhvn9xMvpY1yzyXuaUhVbkHpIeLUbyxlbiDRh+fL8/zbyHNBSuZhzRJ7bN9hrZhRhRiUCBX7QmFxWdsMgLvjx43WfhI/6LmwpIOXO6PhdoTL8ErO3Ay2KdgviLleGvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556742; c=relaxed/simple;
	bh=8+yw9EK8THmRZSJYZAjkBFOOihgmgtksj5dpLRMMb5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AT8dGgbxGTO+aSTfk14aPygdl7uIR+BUT9J7VxuD5E+R4/Or5Pw41p3XrQkg4tk2VwAg8V2cCTXz9P1SVDnLVXp4//8OWzUPyR02zwIt6Orp8Vw4Jqg3M48z/sn9UV0cCIl3p2aKsb7Ol2z90oaZVk3XpST3KXdI3rXhAHM34Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbxJaEJi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbxJaEJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACD61F000FF;
	Fri,  9 Oct 2026 14:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556741;
	bh=weAmcgq/9jEWS9xGesUzDzAZvSYFOBGP5v9a9VAkXIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kbxJaEJi/+3LShDt4hB7b5D4rYq5iIb52GeJGzPaYdTsBABuaJxxeVq3zDG1U/8OP
	 /CloSP3iE3z6AEt0Q0hjPa9e7TGWKHOHxVrS6KhYtSaZ1QemfwHOCDw/haOL7RS0Kp
	 Q+m0u3SymlVr9o4gUO8KrRVAmEuLVWWMIA3VXPtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Lin <ian.lin@jetone.com.tw>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 286/403] USB: serial: option: add Compal EXC-T1 support
Date: Fri,  9 Oct 2026 16:10:47 +0200
Message-ID: <20261009140958.886859768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


