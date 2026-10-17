Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E133A48E4;
	Sat, 17 Oct 2026 17:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256719; cv=none; b=si4D6nzhmZ+ovVLzRIBtbw/4h/oGePtzYlClYK8Xoplzs75GXOAkGriitMQZ4kxTwT/H6moFos2ArMQB6dGoAHSRbEb/BbiL9rJH3ai3ptzZXAKNhDHwzinJ2/jwlnTOHSURqwY4dENcyq2QVZp8n86WWQQx+5OzQzHFJTzY/es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256719; c=relaxed/simple;
	bh=gUTr3iwWzdYGPZkgvHVJR96RbDz6xzBOgoIo1xlbuTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEuLPlmHZPWn1ysgVnzDFxpmh+cKNG+rogrQLMoIROWLb8WOmMz38alpqcA4kalyI3hTQ/3q39cuSkMlpNI2GOj4vbj/MvR1cZ2seGrOGwvlbLLozuaTFVdVjeQrtLLC+UyigH24n3DoA1EHHHWgYA63dm33coDk1ZTF5cB7fzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIM6f4Rn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIM6f4Rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCDB1F000C4;
	Sat, 17 Oct 2026 17:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256718;
	bh=BYYjADU+k/h5590hBEUsHBzBKeMNlBQfvIcOZPr08o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIM6f4Rn0LjMamj67IINxGFOWIAK315dZolAFu2LTf4N1BtkELSCQdUGPTooN3hgt
	 teoEmpli9GlZSm6mUdSV6K5rv5uv1lAys8lNNMbPe1tzhN6g3ZXdkHlHYIjIyIu7Lz
	 t6jPQWRzixDZQn4Kfo8ilxNUWjzWNt9UIWzrK4yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Lin <jisayme@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 0328/1674] USB: serial: option: add Compal EXM-G1x support
Date: Sat, 17 Oct 2026 17:43:20 +0200
Message-ID: <20261017160439.548539798@linuxfoundation.org>
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

From: Ian Lin <jisayme@gmail.com>

commit 7f11480cda081de78a05d8c97073df66326b50b3 upstream.

The Compal EXM-G1x is a Qualcomm SDX12-based LTE modem. Add support for
its vendor-specific serial interfaces with protocols 0x30, 0x40, and
0x60.

Relevant output from usb-devices:

T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  4 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=04b7 ProdID=8217 Rev=05.04
S:  Manufacturer=COMPAL
S:  Product=EXM-G1x
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#= 4 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 8 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan

Tested on a Compal EXM-G1x modem.

Assisted-by: Codex:GPT-5
Signed-off-by: Ian Lin <jisayme@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2434,6 +2434,9 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe167, 0xff),                     /* Foxconn T99W640 MBIM */
 	  .driver_info = RSVD(3) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x30) },	/* Compal EXM-G1x */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x60) },
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 (IOT version) */
 	  .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
 	{ USB_DEVICE(0x1782, 0x4d10) },						/* Fibocom L610 (AT mode) */


