Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5097C1D959B;
	Tue, 25 Mar 2025 12:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905703; cv=none; b=MN1yofEq3G2oNqNhG01nFZO+rGqbB6aT+zareAE8unTXaIgqELC1WoJaJBo361FAHUT5UHfWpTdPCgX1uI5/NQqba7cGHZuWeAHH2Cx2hF8JPdPhBwDFNFJ604zA99wAt9kHBsev4u+4iur0xX3xKM/0mSnd/0eCN89EhoF5yD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905703; c=relaxed/simple;
	bh=0vqwjhUKoK5pgdJwmOmNXDj6YxBuyRBKR+DWNSW6PQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjXfsxAerBhwN/LsiAQyH7ZnVUXpI1ZyzWWPHBoa34iaS85fAMVlqukXO1ihIw9cp7WQYcudh1B+Mqq7HcQ5e15WcsJV9CS8vso8LRZzRw5ThhVJ+CHIzhXKArH/MMe8khsdlBilzFKWw9WnvY9ODQmaNKBE7hyMNeazSXZiYjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSE+sVv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSE+sVv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7DCC4CEE4;
	Tue, 25 Mar 2025 12:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905702;
	bh=0vqwjhUKoK5pgdJwmOmNXDj6YxBuyRBKR+DWNSW6PQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSE+sVv5ywB42yusHsIY4slSmheNwCqnnALgVgZW4RyqFIRTI4sYruC+GfQ+jZDLu
	 NsPiqw36ZfH+qL6BFlSk3zaVt95MnSF7xJpyRt/F1bYxIl3BcinNVYvlGhIZJgfIwP
	 M8qpwZzEgFlnJNk4ahCnbWRK4djeILC17mE3+e4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varada Pavani <v.pavani@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.1 118/198] clk: samsung: update PLL locktime for PLL142XX used on FSD platform
Date: Tue, 25 Mar 2025 08:21:20 -0400
Message-ID: <20250325122159.750652777@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


