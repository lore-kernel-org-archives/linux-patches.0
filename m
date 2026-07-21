Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC16635DA40;
	Tue, 21 Jul 2026 19:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662395; cv=none; b=G3dzwulP5nk/2lQMt8JRZihavZsNse4WwcJFzs0ct7V9ylmZuSvIz8BsLSts9nd/8plTLeXbdmMbW2GmQKlRQbOVS2R6JoiM98+REY9gSfXfFwco6/mn+koex8mHRBhXPiMvJd2V0fP85+WuOc527IyBTeOitmy3rxPAjR3XdPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662395; c=relaxed/simple;
	bh=kdylwqstnYCeZGiMIIoS8U6R2sRDWCQugk+deGcjusI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQRKlab942pV5o9f0FmZPigkTXkaYSA8BJlaTX/yeUF2iK8CuomcSptowXFKZ4h5gQNr+KBh7ACgW0jmKMfxsoMQlZArGTtifSLJ9/kwzpGXFYS3ViAHMUHPdqBLVEr8LFiFXrLqe90kVybEyzvB98790j4w/ju+nHZiJaOXNBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfsFR5Jd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfsFR5Jd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9421F00A3D;
	Tue, 21 Jul 2026 19:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662393;
	bh=fEqn4ecNS8J0eSQG+Rd2i8OJQEHAz4kBoTn+W4FRwrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfsFR5JdMSb8hlllpPNgiypmSB2tPLtQb5IMoSuYeN6SLd0mGWTI8hMUbkWsf6Akv
	 N1jtUm7HyFhSf+WsnM0DSFvxNq2IiYV88TOlySXuZveVNHzgEiv/AuoFS3/k09C7BQ
	 I5lbQNgxMaXRH/syBnrM0aLdvnAzcw068a0XiZhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mihai Sain <mihai.sain@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0429/1276] clk: at91: sam9x7: Fix gmac_gclk clock definition
Date: Tue, 21 Jul 2026 17:14:32 +0200
Message-ID: <20260721152455.703970275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Mihai Sain <mihai.sain@microchip.com>

[ Upstream commit b6f6ebb0fb57ae6da622fb8fd4ebdc9ba1ae5756 ]

According to the datasheet (see link section), table 12.1, instance ID 24
is used for the GMAC generic clock, while instance ID 67 is reserved. Add
the correct gmac_gclk entry at ID 24, aligned with the SoC clock layout,
and remove the old misplaced entry at ID 67.

Link: https://ww1.microchip.com/downloads/aemDocuments/documents/MPU32/ProductDocuments/DataSheets/SAM9X75-SIP-Series-Data-Sheet-DS60001827.pdf
Fixes: 33013b43e271 ("clk: at91: sam9x7: add sam9x7 pmc driver")
Signed-off-by: Mihai Sain <mihai.sain@microchip.com>
Link: https://lore.kernel.org/r/20260309075329.1528-4-mihai.sain@microchip.com
[claudiu.beznea: massaged the patch description]
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/sam9x7.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/clk/at91/sam9x7.c b/drivers/clk/at91/sam9x7.c
index 740f52906f6b43..7255bcf952a7af 100644
--- a/drivers/clk/at91/sam9x7.c
+++ b/drivers/clk/at91/sam9x7.c
@@ -564,6 +564,15 @@ static const struct {
 		.pp_chg_id = INT_MIN,
 	},
 
+	{
+		.n = "gmac_gclk",
+		.id = 24,
+		.pp = { "audiopll_divpmcck", "plla_div2pmcck", },
+		.pp_mux_table = { 6, 8, },
+		.pp_count = 2,
+		.pp_chg_id = INT_MIN,
+	},
+
 	{
 		.n = "lcd_gclk",
 		.id = 25,
@@ -697,15 +706,6 @@ static const struct {
 		.pp_count = 1,
 		.pp_chg_id = INT_MIN,
 	},
-
-	{
-		.n = "gmac_gclk",
-		.id = 67,
-		.pp = { "audiopll_divpmcck", "plla_div2pmcck", },
-		.pp_mux_table = { 6, 8, },
-		.pp_count = 2,
-		.pp_chg_id = INT_MIN,
-	},
 };
 
 static void __init sam9x7_pmc_setup(struct device_node *np)
-- 
2.53.0



