Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680482ED87F;
	Tue, 22 Jul 2025 14:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193242; cv=none; b=p4vhgyPxgcnWUHrQ2PWdZ26sAMnxC/KGU6+5LtOMd9F8lnAnBobyc65A/wfc6YgLNrnsZOd9v5WPGxqTvjLAo0+Y3YcVNvsZDRHz2STqJrRgtS9abRFnUUbB9PNhTdl6BYNX5fMS+GmAVtXp/9gaOh+eFUqMg1hnOF8YHk3n3GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193242; c=relaxed/simple;
	bh=lgjJnXeJzrI9MGz3ZBNT+YT7q6cfz8QAs3W8rH/Y+T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjmU2xCgjqvFIIQFmFUVfA739ecLwLfL6iNvn9+YOCB9fZdMqD//TwCP0AjctQvcITTu1BJ9EsGneNUn2GXJnRWysCSwx8fe/JcrwZLXfdm02LOzrTrmjad36PaFhaOVFigE0CTYo01v3a0q4JEFQuuckw4OSWx36u20qPf+Lvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1eLesLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1eLesLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C68AC4CEEB;
	Tue, 22 Jul 2025 14:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193241;
	bh=lgjJnXeJzrI9MGz3ZBNT+YT7q6cfz8QAs3W8rH/Y+T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1eLesLRrlChx65dtSQWGb8Zxbt3a7gLv8QxfVSfY+SdKoOlywkVAolwtKLGu9mz4
	 KKArAT2EtLGvuiv0LdWvXpXPDPM63LklBWrRIO/VxsPGtYwzJdQLBR54UMRLdd1aX7
	 agnw4WQ/R5zKb+X2aJFQ8RkOKvF5lmOLBKCRkeaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slark Xiao <slark_xiao@163.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.15 005/187] USB: serial: option: add Foxconn T99W640
Date: Tue, 22 Jul 2025 15:42:55 +0200
Message-ID: <20250722134345.959639060@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slark Xiao <slark_xiao@163.com>

commit 08f49cdb71f3759368fded4dbc9dde35a404ec2b upstream.

T99W640 is designed based on Qualconn SDX72 chip. There are 3
serial ports to be enumerated: Diag, NMEA and AT.

Test evidence as below:
T:  Bus=04 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=0489 ProdID=e167 Rev=05.15
S:  Manufacturer=QCOM
S:  Product=SDXPINNL USB WWAN Adapter
S:  SerialNumber=cc1f1d92
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=82(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 3 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=85(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=88(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms

0&1: MBIM, 2:Modem, 3:GNSS(non-serial port), 4: NMEA, 5:Diag

Signed-off-by: Slark Xiao <slark_xiao@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2346,6 +2346,8 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe145, 0xff),			/* Foxconn T99W651 RNDIS */
 	  .driver_info = RSVD(5) | RSVD(6) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe167, 0xff),                     /* Foxconn T99W640 MBIM */
+	  .driver_info = RSVD(3) },
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 (IOT version) */
 	  .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
 	{ USB_DEVICE(0x1782, 0x4d10) },						/* Fibocom L610 (AT mode) */


