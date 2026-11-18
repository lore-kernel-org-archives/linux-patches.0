Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034384;
	b=rTl4yjnfGvdgvwlv9OU3X1C7CB4H9CfA5Mfxb9x7BaGWAzb4g6CsgzOqB5FMfFG1x8oF
	 2EZJUfW9tfnJnIb/ptCBwzyTLzWT92QNZH50oRD26/z3xbt52dnRkVjeUGCd7U4Hk4/aX
	 kQQuo26fTDJiPkNsOUmOigtp3r3rPDEnHrBiZAXHd/uzPL8UUHJhKoI2C4di4zcPYcRjx
	 6MDvfEO6BK9CfB4s3rMrCZmRxAvGFZd+Fh4Xdz/LsxcpAp6SnYsZsrTsDrDKuFov+fA29
	 7MFJL+k1Od58VP80kYLvkKfimASB6Lgos0tYuWT2rJiBh2HIJTt2rR2nwFnm83QYh2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ObhqwkxX7J2yLMIchZyWZ8yTicRYcqwlxkh9oBlwozg=;
	b=STu0SY7pvnDR4wDkDWp3orAjNzr/BRLJR+LG0q7w5YxACvDm5T/6/kx2LUkRn5XaC0UN
	 NmWfpFtGlx0+mcdhUa/stAR2FJX7X0ZpA0Kj7P+9XkzxUUTRP4gP2G3uU0Dv5/Vqvz9mH
	 wqPKKa2f0j/EBa2+zHcLmJE+fG5Wa7qahBLxd2hhSZy9MNks4JwjyfsZ1ksqmVjsgv1c+
	 /6nzRT8/TgvknrWo8aNeHhT0be9gTBVZoQL2w2wju1ubPCLoPTjcUz1Mvtv6PAy55uJFd
	 /B2UFiFNfP9MJNoS6bLjlrIUoA0siT7d3aEE1ywnA8ZNMqnZIvO839N984VIT/l3MfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rPFqLZFi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DCA606A31C;
	Wed, 18 Nov 2026 20:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rPFqLZFi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E540C1F000C4;
	Wed, 18 Nov 2026 20:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034384;
	bh=ObhqwkxX7J2yLMIchZyWZ8yTicRYcqwlxkh9oBlwozg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPFqLZFi2KaRPd17lDkIeod/L+yh7CDoAuyYK7HU8XPPj7SWa7b06/4Pu/zrUWHad
	 I/w9iDnhE9Ubh39YAGSLD1XZFrG3YU8UJmcfzJfaabF/fwBnjeUjzqqeqaIPWE1kxo
	 qBBxsxHpUeejqyvAtzeQi2G6P12OU4e0Rktd5XjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinhard Speyerer <rspmn@arcor.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0350/3318] net: usb: qmi_wwan: add Rolling Wireless RN947R
Date: Wed, 18 Nov 2026 15:16:12 +0100
Message-ID: <20261118150326.558817652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 95f3b3fa3aecf..585ff61e3db57 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1457,6 +1457,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1546, 0x1312, 4)},	/* u-blox LARA-R6 01B */
 	{QMI_QUIRK_SET_DTR(0x1546, 0x1342, 4)},	/* u-blox LARA-L6 */
 	{QMI_QUIRK_SET_DTR(0x33f8, 0x0104, 4)}, /* Rolling RW101 RMNET */
+	{QMI_QUIRK_SET_DTR(0x33f8, 0x9300, 8)}, /* Rolling RN947R RMNET */
 	{QMI_FIXED_INTF(0x2dee, 0x4d22, 5)},    /* MeiG Smart SRM825L */
 	{QMI_QUIRK_SET_DTR(0x2dee, 0x4d63, 0)}, /* MeiG SRM813Q w/ Modem(PPP) */
 	{QMI_QUIRK_SET_DTR(0x2dee, 0x4d64, 0)}, /* MeiG SRM813Q w/ NMEA */
-- 
2.53.0



