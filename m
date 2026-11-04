Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831106;
	b=wl1HdPEUtyPAnhRXjZ+Yv84OEz5UP0aUNMPFxTW8348HVbRM8gsrBFMj4VcOYIrDtrTi
	 Xtbj2VmXosI27RhTTltIPBGKD41PXruXa56JWrJybh0RAOY8j35cA05W8dqs6ANPi3d89
	 owL8vGG24n/O/24uukwgzFaA73DfEp9Jn28Xv2MTfEk19PmNtD+2umyl8WjD9wAD7hUh2
	 zWYiqgUD5WuEVDW2oT9ulBll61YAKWFGNm9eOA2ucKl9PJSyShGePha6IBP563smzOAX0
	 Khqt41C7nTrTb2hS+G8sergKSeI31Sqrn3IPbpjc0ZmC7iB5t+0Duh1QmN8HHU2yEtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n80S2yiE5VeyhRKYdXztH500aMIEnX9yYmQk6njYxKg=;
	b=wmGsv/mF4v1N2wgPswmA1Szx2VxR5xYSKAof2MHXfXI5dOqkcql/nF0iJHJigMemPKeD
	 yTu2fOxP3FfwfM6TQ1cmpP1QqkOiCHxnlIsGdbm0dzcdyXif18lQNA8Z36HI+FwTAbuQf
	 djgdCHh4ZyWNho+0RcV4Ru0FUQKjet6kWVpiGozlTRlVXxYEP6jM5XC6hFrYYQsDBL8lJ
	 Ei7XkX2lTVIW/ubDViYRx9XiykGEos5aS7O2Xdjv037J4fQ5VhV/TRPFhnZynFdiUdAMJ
	 MTabKeDkdkMYqo3R+MmAwpC57l62CnQnl72oN/N4oIaFwhtA/RIRvgAqrIby6xczEqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWapy7JT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128EF606B2D8;
	Wed,  4 Nov 2026 22:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWapy7JT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06CE1F000C1;
	Wed,  4 Nov 2026 22:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831105;
	bh=n80S2yiE5VeyhRKYdXztH500aMIEnX9yYmQk6njYxKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWapy7JTwfO2IBtkqOnfsDi77n+DyXsNTyuTR6tJRjE8oZeli4kbHluKftKg5uBWL
	 RvgsI1x8pdlwW0hXDAIHwGuue1mUuKs6utBDZUFz/u/NqIxyDpc1nzDrv9aaRpjwg1
	 adIHDe6IxoXwGCeP7gU5zCkMoMWoFK6jAj5s1Erg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinhard Speyerer <rspmn@arcor.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0503/1005] net: usb: qmi_wwan: add Rolling Wireless RN947R
Date: Wed,  4 Nov 2026 16:03:56 -0500
Message-ID: <20261104211058.030719798@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinhard Speyerer <rspmn@arcor.de>

[ Upstream commit 7375d38364a9aa66fb31716bcefef38aecad75d8 ]

Add Rolling Wireless RN947R 0x9300 composition:

DIAG + ADB + NMEA + MODEM + RMNET + QDSS + ADPL

T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=02 Dev#=  6 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=33f8 ProdID=9300 Rev= 0.00
S:  Manufacturer=Rolling Wireless
S:  Product=RN947R
S:  SerialNumber=xxxxxxxxxxx
C:* #Ifs= 7 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=usbfs
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=86(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 8 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=88(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#=21 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=70 Driver=(none)
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#=22 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=80 Driver=(none)
E:  Ad=8a(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Link: https://patch.msgid.link/arZzuOOvLUZtdOlv@arcor.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index aa66a30e56cdc..85d2daae805fd 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1453,6 +1453,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1546, 0x1312, 4)},	/* u-blox LARA-R6 01B */
 	{QMI_QUIRK_SET_DTR(0x1546, 0x1342, 4)},	/* u-blox LARA-L6 */
 	{QMI_QUIRK_SET_DTR(0x33f8, 0x0104, 4)}, /* Rolling RW101 RMNET */
+	{QMI_QUIRK_SET_DTR(0x33f8, 0x9300, 8)}, /* Rolling RN947R RMNET */
 	{QMI_FIXED_INTF(0x2dee, 0x4d22, 5)},    /* MeiG Smart SRM825L */
 	{QMI_QUIRK_SET_DTR(0x2dee, 0x4d63, 0)}, /* MeiG SRM813Q w/ Modem(PPP) */
 	{QMI_QUIRK_SET_DTR(0x2dee, 0x4d64, 0)}, /* MeiG SRM813Q w/ NMEA */
-- 
2.53.0



