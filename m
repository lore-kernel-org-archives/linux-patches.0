Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D295A2BB1B;
	Fri, 15 Nov 2024 06:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653998; cv=none; b=hW76ekpvyoJEFNgaZjdiYz4cljFe324lqzZ8G9pF4iGbOZLHSFCvHCfPIOrMSobiBAN1w40KCQywkvKnI/9aBLFA5sisb1Vc6MD+5XaqRm+bjiKyyyftElU40sJ4/y7c0RwlcrO81xxy4PsqirvCFCQxDGy7apKBZVNJIklfKFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653998; c=relaxed/simple;
	bh=Jq9pKsroPDUzDi9gArQJIfDICgoODdMZHKzL3tX+KwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2FBZqqE1c9iWm/PDvynPgGo5xHgBvMa/XIHThmgcztDjjZ0p06TEhS2/nI6IR4K3b/lf2VXA8gdHXtorGndBXkCiYE1XSx1/BoT7YJpJgtoC/oKooVGlamVOySo5ZU74rgARiNLVYlE8xxOrg7o5NPYp0pD1vtRgx/uUZAnNyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v59IiV5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v59IiV5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABBCC4CECF;
	Fri, 15 Nov 2024 06:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653998;
	bh=Jq9pKsroPDUzDi9gArQJIfDICgoODdMZHKzL3tX+KwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v59IiV5QxBFwK0oFe1mGI8m41cpYZoOllwzHPDrFge1A+4lZXUAoLxML4Lqno4rG+
	 8mI7FJEsqwtGmet1sYRNmhSnJv6A3TSWbG6fO6H3gpIanyqTUtVnydI5DZRRk/Nbnm
	 JQSU9lNDV+rTQHaL+Vh4Kg2a+JqIqOiNu4bn8eSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinhard Speyerer <rspmn@arcor.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/22] net: usb: qmi_wwan: add Fibocom FG132 0x0112 composition
Date: Fri, 15 Nov 2024 07:39:01 +0100
Message-ID: <20241115063721.726126883@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinhard Speyerer <rspmn@arcor.de>

[ Upstream commit 64761c980cbf71fb7a532a8c7299907ea972a88c ]

Add Fibocom FG132 0x0112 composition:

T:  Bus=03 Lev=02 Prnt=06 Port=01 Cnt=02 Dev#= 10 Spd=12   MxCh= 0
D:  Ver= 2.01 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2cb7 ProdID=0112 Rev= 5.15
S:  Manufacturer=Fibocom Wireless Inc.
S:  Product=Fibocom Module
S:  SerialNumber=xxxxxxxx
C:* #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=86(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>

Link: https://patch.msgid.link/ZxLKp5YZDy-OM0-e@arcor.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 71ee7a3c3f5b8..74e3ba53f5b44 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1421,6 +1421,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2c7c, 0x0296, 4)},	/* Quectel BG96 */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x030e, 4)},	/* Quectel EM05GV2 */
 	{QMI_QUIRK_SET_DTR(0x2cb7, 0x0104, 4)},	/* Fibocom NL678 series */
+	{QMI_QUIRK_SET_DTR(0x2cb7, 0x0112, 0)},	/* Fibocom FG132 */
 	{QMI_FIXED_INTF(0x0489, 0xe0b4, 0)},	/* Foxconn T77W968 LTE */
 	{QMI_FIXED_INTF(0x0489, 0xe0b5, 0)},	/* Foxconn T77W968 LTE with eSIM support*/
 	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},    /* Cellient MPL200 (rebranded Qualcomm 05c6:9025) */
-- 
2.43.0



