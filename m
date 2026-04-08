Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624D02494F0;
	Wed,  8 Apr 2026 18:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672649; cv=none; b=H0RX9AHhNIqM0MmtLAajDEF3RCWv9L0O8ssHRK2UCRMHAvVuKiSfrQPg6KABumD2U1msuY7LkISbcGiPbzULbg8EBNgobW0ztJ9OUrk7e6FkCTMINv+Z7Fq0XvM834C2/bfDHgS0/+PV/hihFCO0WUaPPA24FYiglNJD3ezB7nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672649; c=relaxed/simple;
	bh=pmdPxpQqPg3gfJ/Tqgy2jrntMMkjPsS3ySF7B6ufW3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSe7zaSGaVEDgamO8zv0Gr3QqClkitUHUKYv/NbJRDHhqi56C7yE7zMtltMeotjrbFBUZnOU8fxB8H8ReFUkxHuu2q6YTOYly44XQglEOFJAVnuyDZJiH0fRyipjW4ny+7ZU3TbewFfzFjb6vClwUEkUmwsZoRvfu63TLNcl8ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQeeU9j5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQeeU9j5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7B1C19421;
	Wed,  8 Apr 2026 18:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672649;
	bh=pmdPxpQqPg3gfJ/Tqgy2jrntMMkjPsS3ySF7B6ufW3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQeeU9j58mgM20eHoQS9vM2D/L5gZ4takiYO3LOD+EPzIyja6Dc+qhXRjNkBIRek6
	 a7jysAcGr2NgZr+A+fH0UeuXdhYk6jtpjhqMu7/KZQxHa0OJIU90Ko7evVjlRi4JHo
	 h6gPFw4ejqtzR7SDCnYSXO9qiKKsv5XzzmFtixqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wanquan Zhong <wanquan.zhong@fibocom.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 088/160] USB: serial: option: add support for Rolling Wireless RW135R-GL
Date: Wed,  8 Apr 2026 20:02:55 +0200
Message-ID: <20260408175916.480808706@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Wanquan Zhong <wanquan.zhong@fibocom.com>

commit 01e8d0f742222f1e68f48180d5480097adf7ae9f upstream.

Add VID/PID 33f8:1003 for the Rolling Wireless RW135R-GL M.2 module,
which is used in laptop debug cards with MBIM interface for
Linux/Chrome OS. The device supports mbim, pipe functionalities.

Here are the outputs of usb-devices:
T:  Bus=04 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  2 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=33f8 ProdID=1003 Rev=05.15
S:  Manufacturer=Rolling Wireless S.a.r.l.
S:  Product=Rolling RW135R-GL Module
S:  SerialNumber=12345678
C:  #Ifs= 3 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

Signed-off-by: Wanquan Zhong <wanquan.zhong@fibocom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2464,6 +2464,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x0302, 0xff) },			/* Rolling RW101R-GL (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x0802, 0xff),			/* Rolling RW350-GL (laptop MBIM) */
 	  .driver_info = RSVD(5) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x1003, 0xff) },			/* Rolling RW135R-GL (laptop MBIM) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for Global */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0x00, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0xff, 0x40) },


