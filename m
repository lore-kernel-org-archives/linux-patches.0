Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C7E35E549;
	Tue, 13 Oct 2026 12:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895289; cv=none; b=BMaq5CTWuWFebNlNy8vT34/HAnXMPw9p9nz/5I5LTtB9fFjBnHMdQtp6kX20mYe66nZbkd6CX3qEurir0HZkC71eaZ3EEF9YDaW9kXhY8QKMFnEpY6Ox2SqnLaPXt2CZwaORdt6X9e+0SC2klDpCxWfrwvaGIJVHlBn5s5UmAfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895289; c=relaxed/simple;
	bh=8WAQzNi2noABnak4q+6SxawoGZOa+U5EMirVvz3BJzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUxA1D/Y3UKS79RCVNqxplg/ZWe3Ys/hSNTZnbi7oHsVRdHJLqCgbxI9PRHZHKQmJBPIAm5hvGWNjYRh47NH+Ckz4WvXL935kZeWk8xaoZvlS9HEBL+kmaRFCrK/SH6SSsQMX/PNp+nhDhxP0GJ8eZvHz4RPo55GFRnico3rgFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmaU27tp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmaU27tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF501F000FF;
	Tue, 13 Oct 2026 12:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895288;
	bh=XiK+R5CW6BzbEEIpOeQv3BMXZVCqRwc1EZQjRw1Uqas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmaU27tpThzpPzj2ZACzoYKJPdKRJdBjPDzx/NIswkF/ZKFgPnAKqBpJrEcZjSL/M
	 Wa00aQwHQj3UrDHIMbnZ5qEti5zqFpg7dPdegXqfld4qa1hXksIvFAuofU6pmsH1gw
	 48J1E5Py0m+3ACUcwAMDON3iOKAMNbJtmchavi9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Lin <jisayme@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 222/497] USB: serial: option: add Compal EXM-G1x support
Date: Tue, 13 Oct 2026 13:36:29 +0200
Message-ID: <20261013112913.162558806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


