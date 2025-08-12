Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B8121ABD0;
	Tue, 12 Aug 2025 19:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026286; cv=none; b=BCZIm4uN8j0UL6A0wIlQdiG1mF0TsNwdLSWPicIQwExUA5P9Ksuo1FOKK7DTs3ioe97YQD/Y3kM51xWM+qs0/knTvmCw0zvalx0Qm6A5HXU6qNy+loF5fBsglft7+QrWnAoNJpJ0Pq8Vy0UT6Kfo5FK0cH4pC0XH93JZKrHtuDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026286; c=relaxed/simple;
	bh=lGKkIO4fbUkv4HUSQNlfzoRl9rPoMSYHXVlsVrNxuNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fidM17gN16B9Nl9idOMi7VAoKBNCkXLaHvGLyE8XYYH7KPFoDg5rfQHAT4ceIAGccZ3P2oBvHr/vVn03h/uY3Fo4ouulLbYlqEzZIe6QVgNNO2lIKcIBf0h6hOrDqR3kTb76Lc+U2AfboOyy8IGfZGTyHHsjkEafIIPWE6x1gkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5gzRwt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5gzRwt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DEAC4CEF0;
	Tue, 12 Aug 2025 19:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026286;
	bh=lGKkIO4fbUkv4HUSQNlfzoRl9rPoMSYHXVlsVrNxuNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5gzRwt/hG5fb8Ip2mH2IjMwhIbSHv6W/J9lKM+nH4zVqFGWZ0tW02tbxIH7QBiPT
	 WDa4c7nhfDRU1JODaPni9qXQnrQZTrzYodyFlWWiU7F7xhsYLkWO73Z6e+vfgkkgvW
	 6sAJ9CQwJcWxFPcmZdGE9TD1GG9vV9puLZumiwNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Vilchez <Patrice.Vilchez@microchip.com>,
	Varshini Rajendran <varshini.rajendran@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 291/480] clk: at91: sam9x7: update pll clk ranges
Date: Tue, 12 Aug 2025 19:48:19 +0200
Message-ID: <20250812174409.434121877@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



