Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2BC5452B5;
	Thu, 17 Sep 2026 16:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661192; cv=none; b=FQZw7GZY0e9qg7nZnNEPzKJD0YOUKkP1/ftx0XwJdu/yeXPQEKCdkHK9p+DUBCeM7FNwWgEzvTS72NQECttJ6QYNhlpd5ctQME7GifKZ3QRCt8hivXawBxorjzqbjMx3hfHHO+lwfJp9WZsF4o/S84XMzHQ1wzOq8Dg/VZLxSFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661192; c=relaxed/simple;
	bh=SscEX0NdfVG5HnESI5+ktOiPhrqA6OItOSZ4RLfQaNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZ9Q0oy1UeBGUV5Xi5FEGHrY/xp+WyJDD5wUfuWgIDQaotuTFkwMXlsjcMpPyCg0zOaC1LbcR8tyzx2CKcF81WHde2TEaIqYxoqh349OslGgVPYYDGrRwcKXjeEOK4+AjQpAelqdChh1BqOTgJxpKI1X6n55h0GxB1cTwO3SjwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bd0XdxvD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bd0XdxvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBB11F000FF;
	Thu, 17 Sep 2026 16:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661191;
	bh=95xQyJhH6MQwMVR4AvQqeGncWCOMWZ7mFjUQe4xr7NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bd0XdxvDNmaxtcqGiulsAtvaZdS1UpCQ7Ws/S6nY739CxkLKpCTTs5nsBp7Om+mYE
	 p0fR/gkqsTi/60nBTFykWmfsKzhA7ncKdK6Arxz0x3Atm+sQF35JS/xFBWVJJbbJQb
	 nIWQ0TEe7gLQhlx7UZi+GxyI9XeeaasB59VJqQwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0112/1250] net: dsa: realtek: rtl8365mb: add support for RTL8367SB
Date: Thu, 17 Sep 2026 15:58:27 +0100
Message-ID: <20260917151555.046915445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mieczyslaw Nalewaj <namiltd@yahoo.com>

[ Upstream commit 28702a215c96917d85558ad6309a57ab224808c0 ]

Add chip info entry for the Realtek RTL8367SB switch. This device has
chip ID 0x6367 and version 0x0010. It exposes two external interfaces:
port 6 supports MII, TMII, RMII, RGMII, SGMII and HSGMII, while port 7
supports MII, TMII, RMII and RGMII. Use the existing 8365MB-VC jam table
for initialization.

Reviewed-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Signed-off-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Link: https://patch.msgid.link/3c6d822b-0e85-4173-86ba-2badb140bbf1@yahoo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index e10a789e22022..c806a24dcd031 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -544,6 +544,20 @@ static const struct rtl8365mb_chip_info rtl8365mb_chip_infos[] = {
 		.jam_table = rtl8365mb_init_jam_8365mb_vc,
 		.jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
 	},
+	{
+		.name = "RTL8367SB",
+		.chip_id = 0x6367,
+		.chip_ver = 0x0010,
+		.extints = {
+			{ 6, 1, PHY_INTF(MII) | PHY_INTF(TMII) |
+				PHY_INTF(RMII) | PHY_INTF(RGMII) |
+				PHY_INTF(SGMII) | PHY_INTF(HSGMII) },
+			{ 7, 2, PHY_INTF(MII) | PHY_INTF(TMII) |
+				PHY_INTF(RMII) | PHY_INTF(RGMII) },
+		},
+		.jam_table = rtl8365mb_init_jam_8365mb_vc,
+		.jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
+	},
 	{
 		.name = "RTL8367RB-VB",
 		.chip_id = 0x6367,
-- 
2.53.0



