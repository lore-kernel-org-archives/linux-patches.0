Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAEA5349AA;
	Wed, 30 Sep 2026 17:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790701; cv=none; b=NNUb9ljabE4Y2Qx9O4Kcqs56G27Mz8bs0yI5uXqhG8NIzs1BGP+6qJw1/QdchMntNI8j26/6GtwD/prNlFVM2T4/A30vXro86c9yI41o0FZJ98VnMf/svMgTcrtq/uh2c/2SYFa4toA5knw7Y4LIDbvbSs+pEyVl8oWyLOJYG+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790701; c=relaxed/simple;
	bh=KvO8fIS+5vFX7++TPteCNVVMpA/TTtxp5ChNCA5qfVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKCJr57jIuosftJqUdqS15RU5bP48mXLQtQJRom6bjE/Cz74m/xYrVWSofLhA8N3fsgb+6/omIwq/GaFmHDim7JtkAqNR0P27WWyPkH/uyGHiG+v9iVT/dNlfehXiryuk2NgkvAg2hKEjCoZP7edWFQQOLpifPK+EoXp5Cv6vIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twowyMzv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twowyMzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14BC1F000FF;
	Wed, 30 Sep 2026 17:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790699;
	bh=CZtMM1NSgUhhQuP35WP2kipC5MQ26jDIq2D9I+13aUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=twowyMzvlaaGueZy8nH76DlRoHr9vLiwyMyYfrRINJgDHojK5k6wW0VJh+/THIiuG
	 vXedS/sBcByO+GE+SbWtJmRasDj/l5zvsErOFWTcCHFIfmWwTNKz+2E8NTl/um1q8J
	 j5mHYHRZZNEjMrPQW1CkN2fevBeHvetc1W1TPTTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Volckaert <janvolck@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/752] net: usb: qmi_wwan: add MeiG SRM813Q
Date: Wed, 30 Sep 2026 17:18:34 +0200
Message-ID: <20260930152359.106110038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Volckaert <janvolck@gmail.com>

[ Upstream commit 9758c11fc6c138a79a28a5659feeaa3abde7aa6a ]

Add support for the Qualcomm Technology Snapdragon X35-based MeiG SRM813Q
module.

The module can be put in different modes via AT commands
to enable/disable GPS functionality:

MODEM - PPP mode(2dee:4d63): AT+SER=1,1

If#= 0: RMNET
If#= 1: DIAG/ADB
If#= 2: MODEM
If#= 3: AT

P:  Vendor=2dee ProdID=4d63 Rev=05.15
S:  Manufacturer=MEIG
S:  Product=LTE-A Module
S:  SerialNumber=1bd51f0e
C:  #Ifs= 4 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

NMEA mode(2dee:4d64): AT+SER=51,1

If#= 0: RMNET
If#= 1: DIAG/ADB
If#= 2: NMEA
If#= 3: AT

P:  Vendor=2dee ProdID=4d64 Rev=05.15
S:  Manufacturer=MEIG
S:  Product=LTE-A Module
S:  SerialNumber=1bd51f0e
C:  #Ifs= 4 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

Signed-off-by: Jan Volckaert <janvolck@gmail.com>
Link: https://patch.msgid.link/20260517153237.55995-2-janvolck@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 5fe3f405491b8..3f9ebf20fe7e4 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1445,6 +1445,8 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1546, 0x1342, 4)},	/* u-blox LARA-L6 */
 	{QMI_QUIRK_SET_DTR(0x33f8, 0x0104, 4)}, /* Rolling RW101 RMNET */
 	{QMI_FIXED_INTF(0x2dee, 0x4d22, 5)},    /* MeiG Smart SRM825L */
+	{QMI_QUIRK_SET_DTR(0x2dee, 0x4d63, 0)}, /* MeiG SRM813Q w/ Modem(PPP) */
+	{QMI_QUIRK_SET_DTR(0x2dee, 0x4d64, 0)}, /* MeiG SRM813Q w/ NMEA */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
2.53.0



