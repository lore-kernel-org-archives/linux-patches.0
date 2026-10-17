Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0693AA9F3;
	Sat, 17 Oct 2026 17:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256831; cv=none; b=jK8KsR0ou9XUPlf4wHaMceTM2+Js1HE7YUVg3EEPUs5o3Nrzs+091p9dFNkKmRoHopG7ndOQKJeT99FYvQjhrzB8BO1MVcjs/lxy6GAjenBLY9LdkW/DBfnCB+KdD9RUOKHAmP85YED57GkDSlbGfOFoP606tlfeG2jZ8a5x/sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256831; c=relaxed/simple;
	bh=un8+bviH1d7T6nM6WbTU8V2AUBlRkiL436Tse77C9lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKuu2KMts274O5CuwVBGoWY9iJHBQtD15eRQ+fLi8D79L5FeZBVkBAEFgRVYPA4Y4cQvDUSkPxUH+k4ic9uYwWPUnvattkQr1giW8DUxAjfrg9/xbWo6vNt7lRpwNR5fqPykd5v1eFQvfgPLlUqlwDHkNNTWx0UTFfGQBmabQmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtiHTgY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtiHTgY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957631F000C4;
	Sat, 17 Oct 2026 17:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256829;
	bh=jSOfBqxlCn+xltipdAljODhwgQISDiGt0sYUfFXFLAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtiHTgY4oKDINFEEVHQvyAQhbit273Cm2dRyU9j1X8yP8ZqIl1fTSmwLGPKkTqLtj
	 8X4/rq/mqC3eVc7Fq0bRQrhA3mIvLq/FGbOf6IbyHhzHNxZnfAvDQwbsPb/W8l1WBs
	 h8T8g5PFDcVCKmxwOl/JOcCBOnsw/6ni9VRSuXlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gilberto Conde <gilbertorconde@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0365/1674] net: usb: qmi_wwan: add Quectel EG120K-EA
Date: Sat, 17 Oct 2026 17:43:57 +0200
Message-ID: <20261017160440.491128254@linuxfoundation.org>
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
@@ -1093,6 +1093,7 @@ static const struct usb_device_id produc
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0122)},	/* Quectel RG650V */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x030b)},	/* Quectel EM060K/EG120K-EA */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0620)},	/* Quectel EM160R-GL */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */


