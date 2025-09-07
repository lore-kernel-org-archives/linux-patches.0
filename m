Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D7C1E1C1A;
	Sun,  7 Sep 2025 20:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276915; cv=none; b=G0mv2ADcBIhgSYI0slsrf6zD3pUGehsFcQp6puw/afng/QmHZHSRxGmEMUmC38Hb0seE3KVNgxagFiV0ekMwljwdGhYeHIipIf55FICMJQ4PfTex79Bvtiia0OHqEUL3Ew/mZB1G+uWYXo/6oc66zs10e6S9DndSZx6Lr68F6/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276915; c=relaxed/simple;
	bh=WH4A/M/iloJL+JcnV9o7oiPprvU3XgAuVEUOBe54m2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nTmNrMshxVoQ5hMQ5plpHxPgYV01Cl8WuiStax4S0k0qf3nlfJK3P8ytlV3NYZyNvgdglZNH8jJoS3uPQuuSBcD2NKIl+Kpz0i3bMzJfdTGVDDyW73/4PQHojkQejt0XAEe4UJVTJRB91yyE6K+zk+ttSFMr7bdbSxUEDsB+reo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqRWEHn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqRWEHn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71114C4CEF0;
	Sun,  7 Sep 2025 20:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276914;
	bh=WH4A/M/iloJL+JcnV9o7oiPprvU3XgAuVEUOBe54m2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqRWEHn7Qq7EGYI9Pe1sFrYJMwh42Ov3v/Y4jHW+ctmiZVB2gFskKFujU/NGcwrwf
	 22s87pXaSKjyFTqHkr5qwTJDl0Hzx3wneXthn/OQp+QIFYMCoMwY8uC9QJn62N/Hge
	 j89u5Pz7zIJm62mb8t6ujFVSrzSQM3FPteNEIrZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Porcedda <fabio.porcedda@gmail.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/175] net: usb: qmi_wwan: add Telit Cinterion FN990A w/audio composition
Date: Sun,  7 Sep 2025 21:57:03 +0200
Message-ID: <20250907195615.536592114@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Porcedda <fabio.porcedda@gmail.com>

[ Upstream commit 61aaca8b89fb98be58b8df19f01181bb983cccff ]

Add the following Telit Cinterion FN990A w/audio composition:

0x1077: tty (diag) + adb + rmnet + audio + tty (AT/NMEA) + tty (AT) +
tty (AT) + tty (AT)
T:  Bus=01 Lev=01 Prnt=01 Port=09 Cnt=01 Dev#=  8 Spd=480 MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1bc7 ProdID=1077 Rev=05.04
S:  Manufacturer=Telit Wireless Solutions
S:  Product=FN990
S:  SerialNumber=67e04c35
C:  #Ifs=10 Cfg#= 1 Atr=e0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 3 Alt= 0 #EPs= 0 Cls=01(audio) Sub=01 Prot=20 Driver=snd-usb-audio
I:  If#= 4 Alt= 1 #EPs= 1 Cls=01(audio) Sub=02 Prot=20 Driver=snd-usb-audio
E:  Ad=03(O) Atr=0d(Isoc) MxPS=  68 Ivl=1ms
I:  If#= 5 Alt= 1 #EPs= 1 Cls=01(audio) Sub=02 Prot=20 Driver=snd-usb-audio
E:  Ad=84(I) Atr=0d(Isoc) MxPS=  68 Ivl=1ms
I:  If#= 6 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 7 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=88(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 8 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8a(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 9 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8b(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8c(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

Cc: stable@vger.kernel.org
Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index efab1127e0187..f04da733240c0 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1364,6 +1364,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1057, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990A */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1077, 2)},	/* Telit FN990A w/audio */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1080, 2)}, /* Telit FE990A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x10a0, 0)}, /* Telit FN920C04 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x10a4, 0)}, /* Telit FN920C04 */
-- 
2.50.1



