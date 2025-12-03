Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCB2312810;
	Wed,  3 Dec 2025 15:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776781; cv=none; b=aBDp9rNp03gLcrkMp/e43au6BudHmuvBulMNTWIlBPB5wIk75wMw70M31315z3gf/8Uh1G6u9VsN0DtQRlRBtZxRaCFePSthO/zmwpHs64qkHnvLesYfOK/6Hjd8kUS8Pc1rXNoMAQo0P8U2ma26fGycmBOBcs14OfzTZiyuVcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776781; c=relaxed/simple;
	bh=2zFozs8evote2UG7f5R7SW6PF+EDSmwtUBVzfT/l6oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKqBmH7i2xHnQtWhNeVdjjqoYU8/iDmQ+zhKgAfVeUBO/kyuHOXcBk6qGyJaP4uIaw51a3/SoFeAkvM6eOHa9w7ikhvMNgs3e9N6UeRBAm6i9oJ639RPNBamAfxNapz1Sa1uHNQH/JM6Ol2BRkA+x47fVwDT3Aq/9NF4t3joSHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCKp9buE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCKp9buE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551FEC4CEF5;
	Wed,  3 Dec 2025 15:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776780;
	bh=2zFozs8evote2UG7f5R7SW6PF+EDSmwtUBVzfT/l6oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCKp9buEk+1c/MWtewhdt2eq06AG+/3Z3S0qsf/C49TMsk9ytQoDIDYMvx/6Kn02/
	 qGu/z4sngWJWDVjBZja/Txmu/cOHzEOYrciheEnJFusBS0HzDP7x5S/AFslTt4vmBX
	 Pv5JdVU2D5sLp80afce3tgMXiLUxljfjysmX/040=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vanillan Wang <vanillanwang@163.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 286/300] USB: serial: option: add support for Rolling RW101R-GL
Date: Wed,  3 Dec 2025 16:28:10 +0100
Message-ID: <20251203152411.219412997@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vanillan Wang <vanillanwang@163.com>

commit 523bf0a59e674b52e4b5607a2aba655fbfa20ff2 upstream.

- VID:PID 33f8:0301, RW101R-GL for laptop debug M.2 cards (with MBIM
  interface for Linux/Chrome OS)

  0x0301: mbim, pipe

T:  Bus=04 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  2 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=33f8 ProdID=0301 Rev=05.04
S:  Manufacturer=Rolling Wireless S.a.r.l.
S:  Product=Rolling RW101R-GL Module
S:  SerialNumber=3ec4efdf
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

- VID:PID 33f8:01a8, RW101R-GL for laptop debug M.2 cards (with MBIM
  interface for Linux/Chrome OS)

  0x01a8: mbim, diag, AT, ADB, pipe1, pipe2

T:  Bus=04 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  2 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=33f8 ProdID=01a8 Rev=05.04
S:  Manufacturer=Rolling Wireless S.a.r.l.
S:  Product=Rolling RW101R-GL Module
S:  SerialNumber=3ec4efdf
C:  #Ifs= 7 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 6 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
E:  Ad=05(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=88(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=89(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

- VID:PID 33f8:0302, RW101R-GL for laptop debug M.2 cards (with MBIM
  interface for Linux/Chrome OS)

  0x0302: mbim, pipe

T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  6 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=33f8 ProdID=0302 Rev=05.04
S:  Manufacturer=Rolling Wireless S.a.r.l.
S:  Product=Rolling RW101R-GL Module
S:  SerialNumber=3ec4efdf
C:  #Ifs= 3 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

- VID:PID 33f8:01a9, RW101R-GL for laptop debug M.2 cards (with MBIM
  interface for Linux/Chrome OS)

  0x01a9: mbim, diag, AT, ADB, pipe1, pipe2

T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=33f8 ProdID=01a9 Rev=05.04
S:  Manufacturer=Rolling Wireless S.a.r.l.
S:  Product=Rolling RW101R-GL Module
S:  SerialNumber=3ec4efdf
C:  #Ifs= 7 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 6 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=89(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

Signed-off-by: Vanillan Wang <vanillanwang@163.com>
Cc: stable@vger.kernel.org
[ johan: sort vendor entries, edit commit message slightly ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 5de856f65f0d..e9400727ad36 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2424,12 +2424,18 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1406, 0xff) },			/* GosunCn GM500 ECM/NCM */
 	{ USB_DEVICE(0x33f8, 0x0104),						/* Rolling RW101-GL (laptop RMNET) */
 	  .driver_info = RSVD(4) | RSVD(5) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x0115, 0xff),			/* Rolling RW135-GL (laptop MBIM) */
+	  .driver_info = RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x01a2, 0xff) },			/* Rolling RW101-GL (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x01a3, 0xff) },			/* Rolling RW101-GL (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x01a4, 0xff),			/* Rolling RW101-GL (laptop MBIM) */
 	  .driver_info = RSVD(4) },
-	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x0115, 0xff),			/* Rolling RW135-GL (laptop MBIM) */
-	  .driver_info = RSVD(5) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x01a8, 0xff),			/* Rolling RW101R-GL (laptop MBIM) */
+	  .driver_info = RSVD(4) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x01a9, 0xff),			/* Rolling RW101R-GL (laptop MBIM) */
+	  .driver_info = RSVD(4) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x0301, 0xff) },			/* Rolling RW101R-GL (laptop MBIM) */
+	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x0302, 0xff) },			/* Rolling RW101R-GL (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x0802, 0xff),			/* Rolling RW350-GL (laptop MBIM) */
 	  .driver_info = RSVD(5) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for Global */
-- 
2.52.0



