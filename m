Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211155;
	b=4IhIKN03y4vCXyxLIi8eAMN+XmW1VgPhzlR79/5iFUQAHzn5L+GRjuE5xwKEZDvo+Zsx
	 2Vmmgq9ZHeuN1bqWjuSqepNJNY16OoMdks6mboaAToOVOKfJmUY7LoAtyxFXlsqBNcnq5
	 JaQEPXpok1o6dq6YrEznbyl7GaqRpV0t+Lu+/wVZ3ddaUAIcme2Zj3DxqQx+Y4hnNGIBv
	 m3F9FVlKwa6FoeDqCKgc+kdzoIRg3t0dI0dLowkzkmUL1H6UbjfpI0SJnHkW73qrxTPj9
	 ixVIEd99eTX3N63VHjGDMm5WxJfT4ZqQciCm07zCCHQkv0yU8HEgxL1yDowSLXwwJ9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X34jXuwzmScdOch9IBHHyhgIW+cpcJrzLa56T2IB9gs=;
	b=KvKS2VphezZ5jyy01alkG/Pni1kVqw9VNR1t4PsT4mkQR2PrhT6pcejcda5FMvuglQd4
	 uWrUYZ/YKNiInY+j9TwSbcAqt7fJ83qSeULFcMwhvQdAd0dnY4H4/ndviwvqIZCM75otT
	 NqjToIe1MNqrH6B0JF6CGJ6GaX11XRU8O/WcY0kNGN8Ap17n0DI0wvDhHSf0lLvj50Gok
	 kAYV7Zg15A9S/dcYo7Het4IQuCQu3+sUz8YgdPCVufp1D3H9dzUoos/snC3Z2LxkuHOB3
	 mVNw8mb6lQvGuGlhPv9xa3aB3JhBsGN5tkb+1yehJp/ltqJpPzxoE9zGrWHg+CTsMiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bDCV4qVc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A307160A260B;
	Wed, 28 Oct 2026 18:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bDCV4qVc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E121F01825;
	Wed, 28 Oct 2026 18:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211154;
	bh=X34jXuwzmScdOch9IBHHyhgIW+cpcJrzLa56T2IB9gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bDCV4qVcYpPJDF1x42Q7t+wWCxy8LRPqrfwl8/uCipgc2k2YS456l3X3P3tnjHDpR
	 qOCL4Npu0O5ejo8OY4B0qsQWT+WkszKFdd7vdoEOvfgoT0Gm8P1Clfa2R//xwBdH0F
	 cLWbQ48G2XDjGeClWsnf6C4yQN43qmbnsA6QJ2aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gilberto Conde <gilbertorconde@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 279/571] net: usb: qmi_wwan: add Quectel EG120K-EA
Date: Wed, 28 Oct 2026 17:57:06 +0100
Message-ID: <20261028170014.623700072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1090,6 +1090,7 @@ static const struct usb_device_id produc
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0122)},	/* Quectel RG650V */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x030b)},	/* Quectel EM060K/EG120K-EA */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0620)},	/* Quectel EM160R-GL */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */


