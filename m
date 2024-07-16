Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEE6D53B;
	Tue, 16 Jul 2024 15:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144221; cv=none; b=ON92fJKL53SyrKPziNb2D/jcTJmme7YkrDHTO5/mBbs9lIppk2Mde5/FBqCFds8JYLcXO4/fZ/QSKodDA5kPO5ukA0qVCkY0LfGXS+QiBEYxHSxkNpq3u2LHz82ek6avyhR7kq8gcxjxQPvRFetbMJ/EcnKR13zzMfrTWUHRIcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144221; c=relaxed/simple;
	bh=yLK0qy/EikpCQ01tw5nnqaBvc9XoQiaizFcRveelWAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEKyExNH75URgOWAzqdmjbp6mQY+mdFq0QomUO+s1sRojp+Y+44qTPHmCYRm2b6caJ9PLpc5+dARitHdA0gzrO52D8EpsAzdPWOR4iNq2HRKErdnjy+QKhy5FDDgoZkORpaYFCp4IlGNQ3xiwdqpdmL3avNQUABru86LMNIvNRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05tRYE3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05tRYE3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F28C116B1;
	Tue, 16 Jul 2024 15:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144221;
	bh=yLK0qy/EikpCQ01tw5nnqaBvc9XoQiaizFcRveelWAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=05tRYE3TdU2WkxwDLy1jCQrOqQYcPNMKxB5ZRgtEfYxYGYNAnKxZBGcYwmIiX1UVv
	 jj7JcQlT2TURubsaj3Y6auybnwXiIMe9723Ccamyb2/2m9i6s+u8mmE903m7HXc0in
	 /blmzrCxQhgoqxgBrKuMhyMIoMBNoz3wkVfuCayc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 49/66] USB: serial: option: add Telit generic core-dump composition
Date: Tue, 16 Jul 2024 17:31:24 +0200
Message-ID: <20240716152740.038049792@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

commit 4298e400dbdbf259549d69c349e060652ad53611 upstream.

Add the following core-dump composition, used in different Telit modems:

0x9000: tty (sahara)
T:  Bus=03 Lev=01 Prnt=03 Port=07 Cnt=01 Dev#= 41 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1bc7 ProdID=9000 Rev=00.00
S:  Manufacturer=Telit Cinterion
S:  Product=FN990-dump
S:  SerialNumber=e815bdde
C:  #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=2mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=10 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1433,6 +1433,8 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x701b, 0xff),	/* Telit LE910R1 (ECM) */
 	  .driver_info = NCTRL(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x9000, 0xff),	/* Telit generic core-dump device */
+	  .driver_info = NCTRL(0) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9010),				/* Telit SBL FN980 flashing device */
 	  .driver_info = NCTRL(0) | ZLP },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9200),				/* Telit LE910S1 flashing device */


