Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD553D1CCA;
	Tue, 21 Jul 2026 18:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657003; cv=none; b=cx3e1253aD+GY5CJWB5eNDqQfZIA/5UpE889GEXsmOJnCiXyTCdUmOyvW4l1etZTnhafYGHRCnar5tzGHcKCpCtnRSpLVhtxm6LIy//Cb0VX0PFpUBiDXk1W89bzV8f5XkBP7LBgNLlQJaLdt6AnQU3yvaSG7PJ64rUE4MIdFAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657003; c=relaxed/simple;
	bh=B1/nubmE6PAolc3DHUughWRrDRo71b4o7NGCyFHpqfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCinJcOx1SwrEYlQ+jKoA3dHphQ2bzjb+F5nHG6qG4xSKt+6xJzoHOSsQ28r94lHzdK6hFN4HIXftkATb19Ch3s1HyK5jBTQ4bLNC3D/mJX0rYxg3LgjEg5l+tJ8fa9Skprhr1N9BEMqg7ZtF+29ccq2vFHd1aAHTdK3OOiUweM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsxewkYx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsxewkYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BFC1F000E9;
	Tue, 21 Jul 2026 18:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657002;
	bh=6OlCpPDj2Q5MqvqkD8KBfpPv6xmWJcvduU6wpONRIng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsxewkYxqSDgAYi9ba88KNrvDm704FzWSMgqbEwBR47UZDgTvbK6RRZPNAkkfHf/a
	 woYq10GVfxK9HCMWataiAdUGd+2PalTfNuOfp1cDKTPly3jV3LcdlH8njSHFqDpsWT
	 8cq7gVumh7HFms5V1ybF4TMgRRXc8Kow6q0+q4bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mihai Sain <mihai.sain@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0598/1611] clk: at91: sam9x7: Fix gmac_gclk clock definition
Date: Tue, 21 Jul 2026 17:11:54 +0200
Message-ID: <20260721152528.836200665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 89868a0aeaba93..6b330c3e6bca84 100644
--- a/drivers/clk/at91/sam9x7.c
+++ b/drivers/clk/at91/sam9x7.c
@@ -569,6 +569,15 @@ static const struct {
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
@@ -702,15 +711,6 @@ static const struct {
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



