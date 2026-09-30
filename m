Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A41B379EDA;
	Wed, 30 Sep 2026 16:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784116; cv=none; b=KWAT/1fpiL3TZbSKMEG7w58LdgV1v0hJCa4qFVnx1+Jh3TYS6wTCHy1rXHoinGTME4b9m6S0BPdPyQXn9g6ADUBNUlMFzsrLiyXvDOX+Pk5RU3EScpbfOpxZvXbm+gHt6gU3GW1ocF/a2oqquLbrvt4K0R9CKd3ePjSGiEIH8ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784116; c=relaxed/simple;
	bh=+ULBmw3pD90wjqI1L6Z2E0WDqqTHM4/4hWPHC0jppKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRO8HiJ7Ut9ZYPC23McVZvnSdGqkgSXf36b2lRcN/uesOSjhKYOVwoyIsc0MhWz3r82mJi0tmEYE9ERAgYPijUZ29q0+CdXjI2fbK/F46MEBtwsx30E5QwTK70TZp8l/eo8e7Apk/t8AEZcmNOs7wzyn/agh3ErcPAV1zSuAAb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPiAvUm5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPiAvUm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70FB1F00893;
	Wed, 30 Sep 2026 16:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784111;
	bh=g94CEvBADAerSQDrwzHIci64XzVoh3CK8W7yUIXEJU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPiAvUm5Rcc8EqiXFjC7NL7JhpGp0rzycdSSdsNGzB+epX8Uapi75BisAGwEJV7V7
	 AWyLJwv4NDneTBrHSgCcNSCXaPyNsgl09920wqVKJQrH7WYf3LPIgoKw4ag3c+3mCX
	 i02zX4uV3ZWJgDXPaN/tNKQ3Vs+jUSqiTyKFTqiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/982] net: dsa: realtek: rtl8365mb: add support for RTL8367SB
Date: Wed, 30 Sep 2026 17:12:56 +0200
Message-ID: <20260930152417.659076929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 97673ccb7ac79..f622e724e01f6 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -539,6 +539,20 @@ static const struct rtl8365mb_chip_info rtl8365mb_chip_infos[] = {
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



