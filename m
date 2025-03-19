Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AFD1DE4C6;
	Wed, 19 Mar 2025 14:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394963; cv=none; b=qrTmsuydyfkbDuRZ/5bIojBbYQM0ZfrD5/2L9NZcJHpr7GZGyS+ybWEYFdIqKkLrHSYB+INCfOgNE9/4LLiFd6LxplnCh+nZC9Ns0WbMhr7XJHRPDJvCcrvsWXMYrTc6ZUmKNjW/9sK+5rd3ovwPNLXpRSHu4fzlrc3/RfxtUjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394963; c=relaxed/simple;
	bh=wpe5hGobUC+cb16WM2qKJAuVQkhVr0i90qkoSKdZg2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrPpeCScmyj+mfsWy/3a3G8ZDxbVtWC1F5wjEa1KKKYuIw5v8GtQ0SczgMLSJeiIO5/WTtmeLVhY8j0MyYS2xjXMrk3aaRIB8qVp2R4E7o+PTBW37PXvJYgf2KtFC6uI3wgrbdzK1I5n0/IZpkB0bK5B6a7zRP05Cppc16tnxO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3f3QjtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3f3QjtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7D2C4CEE4;
	Wed, 19 Mar 2025 14:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394962;
	bh=wpe5hGobUC+cb16WM2qKJAuVQkhVr0i90qkoSKdZg2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3f3QjtJ4D1w6VqRRlqg7oZz44bs8KdSXHt9ss+B4SMvT+nuSXG2PgHfYyoDYlIG1
	 OttjbUliQjy3XPpweLZEw+VzIAGlo3g3+5a2t+EeOG1DrnEuhElvTjL97uLvXssjMb
	 DkP/LW0swHlSZ8LAMuoySJh1S1mwy6MChUKruYfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varada Pavani <v.pavani@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.13 191/241] clk: samsung: update PLL locktime for PLL142XX used on FSD platform
Date: Wed, 19 Mar 2025 07:31:01 -0700
Message-ID: <20250319143032.447775433@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Varada Pavani <v.pavani@samsung.com>

commit 53517a70873c7a91675f7244768aad5006cc45de upstream.

Currently PLL142XX locktime is 270. As per spec, it should be 150. Hence
update PLL142XX controller locktime to 150.

Cc: stable@vger.kernel.org
Fixes: 4f346005aaed ("clk: samsung: fsd: Add initial clock support")
Signed-off-by: Varada Pavani <v.pavani@samsung.com>
Link: https://lore.kernel.org/r/20250225131918.50925-3-v.pavani@samsung.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/samsung/clk-pll.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -206,6 +206,7 @@ static const struct clk_ops samsung_pll3
  */
 /* Maximum lock time can be 270 * PDIV cycles */
 #define PLL35XX_LOCK_FACTOR	(270)
+#define PLL142XX_LOCK_FACTOR	(150)
 
 #define PLL35XX_MDIV_MASK       (0x3FF)
 #define PLL35XX_PDIV_MASK       (0x3F)
@@ -272,7 +273,11 @@ static int samsung_pll35xx_set_rate(stru
 	}
 
 	/* Set PLL lock time. */
-	writel_relaxed(rate->pdiv * PLL35XX_LOCK_FACTOR,
+	if (pll->type == pll_142xx)
+		writel_relaxed(rate->pdiv * PLL142XX_LOCK_FACTOR,
+			pll->lock_reg);
+	else
+		writel_relaxed(rate->pdiv * PLL35XX_LOCK_FACTOR,
 			pll->lock_reg);
 
 	/* Change PLL PMS values */


