Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D418F45A2BC;
	Fri,  9 Oct 2026 14:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556718; cv=none; b=nxYfFKZOnyZxpR1broO0YCmqVCT3PY8vVCjL8XKQmHq3bpXZ+1sBlDPVGQDO6kfSphiTN1xa667jEvLbfzBu+TUTvuHTFbTn9W6z/H86PMehkpaUY3afFaPPClvd8t8UM7/QCZB/RvUhKKmVxbnkfcGkb8vxrKRzQ5bf5AdFgjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556718; c=relaxed/simple;
	bh=uAjlaQn/Hsj3eHt909RjAcmi20sjST7O1nOto2B7RBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joF1RH8eDWdfiJYQkaUP7Hyy72FZ2MEiyDiO95W7mFQAsL+mXMZ0yxYb3FIUGOVM5Wo07xVS/Y+L+dMvpWk71pCVbXtj+lkDZkC19Qa9YHm/MOFH/UizWEXRxVLnY6Nh9Hg6P6TgXJhpA/liEI1xgctedE9DuZ+VPes70aDy+BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bREh3F/w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bREh3F/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FBA1F000FF;
	Fri,  9 Oct 2026 14:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556717;
	bh=58x1yW3/0qzijd50MLqR/4lEQARzCQVnUB9w9oXGRpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bREh3F/wTSLYsQQDBL4lS4ScifJbhMpVESgYLFUM1efeogzClhZxsXPlSSP4r+e8B
	 RVlo13opzvKZBAeaK5dhX+zCj+VnGrXk8Kr//jcKBDerlQ+eNE2sy/K84mapl2IYoX
	 3n4Rc8uzbGhg8/RkKerRYJWfQbm4M1NEXMXwJuCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 282/403] USB: serial: option: add support for SIMCom SIM8260C
Date: Fri,  9 Oct 2026 16:10:43 +0200
Message-ID: <20261009140958.788540810@linuxfoundation.org>
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


