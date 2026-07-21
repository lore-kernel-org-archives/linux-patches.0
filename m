Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6CD46C4DD;
	Tue, 21 Jul 2026 18:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660292; cv=none; b=OuzaOmWFkCeQ00z70Bi5YdYQM4v9X1oWxxF8qR6W7u3LWcFeypopp23QOVU84Pwj3UcwkoJCpPl1W8450r0hjUY7aC/NSFQtM6BqzGgpO5oFvBVdE6W+uOB9M9OIJ1S9jA5BQgBx7tFF4qPtE9t3y7T52YukCpSScCu28Gqp3+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660292; c=relaxed/simple;
	bh=Lhx8JUMe6aQrpkBpC7eDwwez7TMgyQ2rZ9nJHSmkSfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxeupZ6hAqgwli+r26qs+3gI82250kgRc6mQcLLC982b1TS4m4LEi3TVToBwLdS0Y5sjFGDKvCVK5pfI6BcsmCoKlLuTrkYHG/SCcjzrHBXxdMTDnsXo5Z/0jPRJo7NnaF+NXhpCv3khtlbkjJnkAVxWuX24bBjNb+ufeasrzQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zx3hsk3S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zx3hsk3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C582C1F000E9;
	Tue, 21 Jul 2026 18:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660290;
	bh=LgLNdwME5xW7+YflJeKzvS7rsvJHq3L5kXp+FI63GKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zx3hsk3Sha6mC7h7FrKZ+f5w24UFp6oUM67ej+bABbV7CQJadUiDKe0Oia3PCPIJS
	 wHeqAsUjqFedtOvAHGiBD+EZmF2s5vk0+/52MqgJmUq87ERPLfH0VdWRJwWT0JxntZ
	 5N0ol0392JOfhHdd5bOUNPzFN+l0u2cyfYW8QtOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mihai Sain <mihai.sain@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0871/2077] clk: at91: sam9x7: Fix gmac_gclk clock definition
Date: Tue, 21 Jul 2026 17:09:04 +0200
Message-ID: <20260721152613.336714530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



