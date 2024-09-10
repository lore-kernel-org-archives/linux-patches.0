Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDEB19066E;
	Tue, 10 Sep 2024 10:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964795; cv=none; b=uo13MjYq6CJm9vQgDXxKMumOaj5NhAuxLwwhQ+D1fNdSm/mDOLQ9/tq+RoFGXAir46h9/+DZWuzK+ujqqLeH8Ec6j0p5vvt/oZ2RmtJikVqHTeKDRu6Q583wlbadasIf/GnuO9mey3HIq2BHW3D87eR8WPWi2F5Zi5DJmVsHIMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964795; c=relaxed/simple;
	bh=JuQSNz79RuNag2FzGFKQuDVNIxUPBqBsPPhFbYzlxRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS2VsjIlZUgc3s7/GE3ftJjpm9qZNJiB9uvF7HXLqSXuR8xYeXVkTSLrt1c68rOM2GaC8y+sfzN19OPJn0813FyUi7T64eULN/LjaFnqzQsyT69o9aupO7lk2uhm9vGFRkicsWn1MyEHhtdi50vfDRwXAKZK2jXGZ2OCvT32pdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7tsPKir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7tsPKir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30695C4CEC3;
	Tue, 10 Sep 2024 10:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964794;
	bh=JuQSNz79RuNag2FzGFKQuDVNIxUPBqBsPPhFbYzlxRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7tsPKirJoyKm/GzPdlDBaJm8HYKYNgcFwjlQu9DsFussUwSW2rddXxU5Z/JEci27
	 qOM9s8LhC8ILkCEZPK9iRv5U1cHYOJVqvGuxSEqyIYaIi5Mk0OEYehGIcR2nUZBkeS
	 k+QN43XaRPrAbHAgKgHh/yuWHQmaw9mssSy2szpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZHANG Yuntian <yt@radxa.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/186] net: usb: qmi_wwan: add MeiG Smart SRM825L
Date: Tue, 10 Sep 2024 11:31:41 +0200
Message-ID: <20240910092554.917125576@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZHANG Yuntian <yt@radxa.com>

[ Upstream commit 1ca645a2f74a4290527ae27130c8611391b07dbf ]

Add support for MeiG Smart SRM825L which is based on Qualcomm 315 chip.

T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=2dee ProdID=4d22 Rev= 4.14
S:  Manufacturer=MEIG
S:  Product=LTE-A Module
S:  SerialNumber=6f345e48
C:* #Ifs= 6 Cfg#= 1 Atr=80 MxPwr=896mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=05(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=88(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=89(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms

Signed-off-by: ZHANG Yuntian <yt@radxa.com>
Link: https://patch.msgid.link/D1EB81385E405DFE+20240803074656.567061-1-yt@radxa.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 47cc54a64b56d..0a1ab8c30a003 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1365,6 +1365,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},    /* Cellient MPL200 (rebranded Qualcomm 05c6:9025) */
 	{QMI_QUIRK_SET_DTR(0x1546, 0x1342, 4)},	/* u-blox LARA-L6 */
 	{QMI_QUIRK_SET_DTR(0x33f8, 0x0104, 4)}, /* Rolling RW101 RMNET */
+	{QMI_FIXED_INTF(0x2dee, 0x4d22, 5)},    /* MeiG Smart SRM825L */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
2.43.0



