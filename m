Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213022;
	b=o3AosZUBZQ9/1xW3sHFJwwfd9G55TOqdQ0Vp4AY+nKs4Fw7fk0yddJ6aV00gAUwLK1SN
	 sWBNF8d8m8wvkT73bMIimgAgR8Q9uPSh/QgG6RV+Bb+QfMqw3Rg4Yj075DqkRn+41BXQk
	 yHKSZnG2a1+QOj6zEI6iscCB9mSd4DNtjsGaEGIRU+y5Jb3I7AhJZDoJtiInaipNBQr6f
	 xV0rzWIJViGYYUxfX/rJItr6hibDzdJ1D6KewO6ZfKLcumU+dQDSZ015NoF6+H4ecmzNI
	 8MKkOYB/cPcpDSHudpVGWfwldYHHPcGiK1/phi7vOxnpVJyJo0ByfaXZjcoHGtY+reA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zfDYxVB6aLwmkiAyApkw/ANORxscoR33EdB574wKdB4=;
	b=5KNFCm++2i1bkgXRKjKQ4aWCNIz6bulp2McdUxdY1asuD8wYRln17CVKicKSQGQV76NJ
	 9p5Vd3TSLBBlfhd3tZXuDQuJjltl9JjKTALwzAZ2rI1uKU0mhxfA262MbKNN/Lwy+fesF
	 3021nzOQ7U0kTKRxRd9cy3GwSx5YOJTDw/54sRpVxba+A67Re4nrw+K2jy7klVNwXCAez
	 ghkP30iU3RkouCr+3SAf5acol6kSCgUJihIrZyAdA2WOR/A2uWElAY4eJSUtYyg8gt+db
	 jmcZKqyNRCVRBSAjracL/RxH/hmCsJQs77NHkH+ASh+7WIktEABZX0Bojr1Arb8/9vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y0Vikq6r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0160606A31D;
	Wed, 28 Oct 2026 18:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y0Vikq6r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC461F01825;
	Wed, 28 Oct 2026 18:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213021;
	bh=zfDYxVB6aLwmkiAyApkw/ANORxscoR33EdB574wKdB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0Vikq6r2Is9RZlNTDvEy5T0RskkCnTpRdK2oHFgYz/u1DLIhDLyVCZT0yPT5spPj
	 uN+VteWZo5py84elZJ5pjYsobKLLSfXsBg0M1wesYYNLNo3bMS4rNRkDHCTV0CPIGa
	 16XnMkfVB3KTZPBqY1uGISDU60lWQuSzvZDcHxGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gilberto Conde <gilbertorconde@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0360/1887] net: usb: qmi_wwan: add Quectel EG120K-EA
Date: Wed, 28 Oct 2026 17:40:56 +0100
Message-ID: <20261028170507.425035153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gilberto Conde <gilbertorconde@gmail.com>

commit 0f2fd31f63c65c409bd336af3a42d478a9207c1f upstream.

Add support for the Quectel EG120K-EA LTE Cat.12 module (USB ID
2c7c:030b). Its QMI interface (interface 4) uses class/subclass/protocol
ff/ff/ff like the other recent Quectel modules, so match it the same way.

The product ID is shared with the EM060K, which the option driver
already knows and uses to claim the serial interfaces. Without a
qmi_wwan entry the data interface is left unbound.

Tested on a GL.iNet GL-X2000, where the module is soldered down and
enumerates at SuperSpeed: cdc-wdm0 and wwan0 appear and ModemManager
brings up a data session.

T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=5000 MxCh= 0
D:  Ver= 3.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=2c7c ProdID=030b Rev= 5.04
S:  Manufacturer=Quectel
S:  Product=EG120K-EA
S:  SerialNumber=45546267
C:* #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=896mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
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
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=88(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#=12 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=70 Driver=(none)
E:  Ad=89(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms

Signed-off-by: Gilberto Conde <gilbertorconde@gmail.com>
Link: https://patch.msgid.link/20260921093426.2870266-1-gilbertorconde@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1092,6 +1092,7 @@ static const struct usb_device_id produc
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0122)},	/* Quectel RG650V */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x030b)},	/* Quectel EM060K/EG120K-EA */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0620)},	/* Quectel EM160R-GL */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */


