Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD7320AF67;
	Wed, 19 Mar 2025 14:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395248; cv=none; b=i96xqP7On7m2oQtLaiYCFR8Nz5MUnMnEMf6nAQigBrVjV8sFI1OlnRr8k5xWnWDqfwj7DxssWgvZHl7JIpFDyo+LsS2++vqFaCUSWaRWsEKx3rGwc9N4qhE3LYzsgzubD+vUYx1IQlzrmWWd00Mk6xGd/JECiMAd5JjNQ6XvVIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395248; c=relaxed/simple;
	bh=htYRCph1yTMM2kbjwLDJbXY8t2GXmlfhRykAzF3C7IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlIn4PSgjixApW7SbXWvUEe+VmIzSFuLHx6bFkaOtHXl136fzWOUViOZBoyG81ie8H0BBzEWitgwSN2mO6Br0vAieFtRx1u8WculAcGOBTyGgOP0RK1spBTSS57vOhCc0h1hKVkht4Z0S/0MmszDe8UH0/lUmsrDXQq0mBSPzE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNPy5Z9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNPy5Z9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE576C4CEE8;
	Wed, 19 Mar 2025 14:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395248;
	bh=htYRCph1yTMM2kbjwLDJbXY8t2GXmlfhRykAzF3C7IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNPy5Z9Ss1od7WVjqftKt7RvwMdOIpfzhGaszS8slhwP1JNB3Ver6TMPuxqmW67XY
	 q54BgX+p1MR9T8RbSgqLsHW0kwT+XsoQiYQXzq0sVyCrQAT6S9MOfjfrkymuLG6SOz
	 uNDHVpHbUfRHIGpOO14yTAntPbokwFWlsk9t7e2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varada Pavani <v.pavani@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.6 129/166] clk: samsung: update PLL locktime for PLL142XX used on FSD platform
Date: Wed, 19 Mar 2025 07:31:40 -0700
Message-ID: <20250319143023.508785062@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


