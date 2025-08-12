Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4477E2F5E;
	Tue, 12 Aug 2025 18:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022615; cv=none; b=i7/7Xkh0vZT1rzE96s5HBhA9XrnEzIVgTanB3LEaFg3rt7FUnarvg3o1dg6LRZAOJl2gLSzelYvASZiW/u56pF+Dp/8F+HqiLw1eiuavta30gSK82A46b4+ax3ykK3XctV3qgwcJ3gv4YaZDYZ1CGUXt9UyAIB4K9k5Fs+KmKTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022615; c=relaxed/simple;
	bh=fWVFWZwb3lQwvV2oqX8rZ3ddouDjf5vsRbjlfXOWk88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLZd9e0Dj3C1/Ca5UTURob8qJVZeehfA5B3uVeXVfufbOK+a23omSBROBp1prGgpZ7qkxeHFWzMnKsLslhZ0iR4xJDPdPzIJNjVFSYD2eDzcSZpAgP2uKjSTwMPscSlD5PvRazfUEO1r+yrTAjJkacLskyhJ/DQMXajqKqs69xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnY7QBma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnY7QBma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5B9C4CEF0;
	Tue, 12 Aug 2025 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022615;
	bh=fWVFWZwb3lQwvV2oqX8rZ3ddouDjf5vsRbjlfXOWk88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YnY7QBmaWGol+1QvwuEbj3ac3JEc2+1EZrY4agNre9634E49MnZMWZzzPcC6l07gt
	 WEppc4JBUupny9z/ttVRCz0F5Dw6jgBjVE1+bib7aoS41Kcre0E2Td2uaw6gmDPzVv
	 nILgUyAAbWyTis5//9rVJFl420Wm0HGtPXk7Q4ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Vilchez <Patrice.Vilchez@microchip.com>,
	Varshini Rajendran <varshini.rajendran@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 206/369] clk: at91: sam9x7: update pll clk ranges
Date: Tue, 12 Aug 2025 19:28:23 +0200
Message-ID: <20250812173022.516042051@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Varshini Rajendran <varshini.rajendran@microchip.com>

[ Upstream commit c7f7ddbd27d55fa552a7269b7bae539adc2a3d46 ]

Update the min, max ranges of the PLL clocks according to the latest
datasheet to be coherent in the driver. This patch solves the issues in
configuring the clocks related to peripherals with the desired frequency
within the range.

Fixes: 33013b43e271 ("clk: at91: sam9x7: add sam9x7 pmc driver")
Suggested-by: Patrice Vilchez <Patrice.Vilchez@microchip.com>
Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
Link: https://lore.kernel.org/r/20250714093512.29944-1-varshini.rajendran@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/sam9x7.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/at91/sam9x7.c b/drivers/clk/at91/sam9x7.c
index cbb8b220f16b..ffab32b047a0 100644
--- a/drivers/clk/at91/sam9x7.c
+++ b/drivers/clk/at91/sam9x7.c
@@ -61,44 +61,44 @@ static const struct clk_master_layout sam9x7_master_layout = {
 
 /* Fractional PLL core output range. */
 static const struct clk_range plla_core_outputs[] = {
-	{ .min = 375000000, .max = 1600000000 },
+	{ .min = 800000000, .max = 1600000000 },
 };
 
 static const struct clk_range upll_core_outputs[] = {
-	{ .min = 600000000, .max = 1200000000 },
+	{ .min = 600000000, .max = 960000000 },
 };
 
 static const struct clk_range lvdspll_core_outputs[] = {
-	{ .min = 400000000, .max = 800000000 },
+	{ .min = 600000000, .max = 1200000000 },
 };
 
 static const struct clk_range audiopll_core_outputs[] = {
-	{ .min = 400000000, .max = 800000000 },
+	{ .min = 600000000, .max = 1200000000 },
 };
 
 static const struct clk_range plladiv2_core_outputs[] = {
-	{ .min = 375000000, .max = 1600000000 },
+	{ .min = 800000000, .max = 1600000000 },
 };
 
 /* Fractional PLL output range. */
 static const struct clk_range plla_outputs[] = {
-	{ .min = 732421, .max = 800000000 },
+	{ .min = 400000000, .max = 800000000 },
 };
 
 static const struct clk_range upll_outputs[] = {
-	{ .min = 300000000, .max = 600000000 },
+	{ .min = 300000000, .max = 480000000 },
 };
 
 static const struct clk_range lvdspll_outputs[] = {
-	{ .min = 10000000, .max = 800000000 },
+	{ .min = 175000000, .max = 550000000 },
 };
 
 static const struct clk_range audiopll_outputs[] = {
-	{ .min = 10000000, .max = 800000000 },
+	{ .min = 0, .max = 300000000 },
 };
 
 static const struct clk_range plladiv2_outputs[] = {
-	{ .min = 366210, .max = 400000000 },
+	{ .min = 200000000, .max = 400000000 },
 };
 
 /* PLL characteristics. */
-- 
2.39.5



