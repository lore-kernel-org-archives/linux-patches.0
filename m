Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE34A4F4CF2;
	Thu, 17 Sep 2026 17:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667397; cv=none; b=av41S2yiXjrgUW/YoVRDozSh7DBeNhTg0mXKGOfdVDPykMKG1k5FCCCUxcgopMlvoUl0f6KyeMiMk7q1J92ArjcOpOnPf4ZnaGoyVUMBSl7qEjJr/0Qp6XikLeQiMeFXCjB4HGCTohHNJLthETwYj98tANjNFpJrIgL5cGJ/eOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667397; c=relaxed/simple;
	bh=ftvfcoRnODG5ocmrQ1pnOX0bc92mXAFQNQ42/gkelh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXMNiEDS/YCBd3K9mxWzpkNiyAHQwFZ8nEwuOygPVBeb0lj007m4Q8gneUxDpIVl3n+uMjAfclFq2iCilFDTlcvep77NPrcwYMts8fB/V0Bgkd8e3Tev3Yk3UulJxp0Dbjw4hL+i5/r+98pmQAzazHkkz8ekRfbQaLl5B0EXNWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPjnkPt4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPjnkPt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3421F000FF;
	Thu, 17 Sep 2026 17:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667396;
	bh=Nbi03LDJyxvtxA95h4LGaNJwekMtwYcXqUcc0Wfmw1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iPjnkPt4fX5aL4VzRFEADAhk/7gbCgBQr+VPqz6hx3QXwkQ8d6KOBiq9rDGIfuCqJ
	 j2BzK+vVHP+CNWSzlwjPo1azqT5gQxtRpJcCQd39BwtSc4nAQELwS2V6hhG03aSNMH
	 tIqawBqNLZpAHBJZKEvavtNQCujb2PVY5WM0IYSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0078/1102] net: dsa: realtek: rtl8365mb: add support for RTL8367SB
Date: Thu, 17 Sep 2026 16:00:21 +0100
Message-ID: <20260917151541.429727892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9621fa4052f84..755d3e9543853 100644
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



