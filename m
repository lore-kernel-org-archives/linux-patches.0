Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C37E33FE27
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301273; cv=none; b=rOZQKD1xShXFpPgwU3vwfVUYZIBsSr0EUlh91OIQaL+zY+jQpQEsKwM27koDMmHfatKUqMfBWhGGDQXz8fgzBMKDtc58snMjzvM3rXNatnJfo4FSL3TF0pCrzKznWYJkbAt25VeysHCC/HhCdmwRWXj9izpE8HrxbijTNxKREW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301273; c=relaxed/simple;
	bh=VZCNWqHNgDWJEFCQUtbBDKu/poUJ6/8yBHL4Wv5TY3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0c3XZqg6NYJf9O1V8Fl8lSF4RxlKxSNA7Rbnba4EbI62JL37z8jJ5sIuwFPTD/CVOXLIO0A5HynkEiKDWQ2cHAWmwBMD1V3Q93JZUE+aoPA/L1LuFQE8SGy0L383gu7Ybv180sXsU++5H9aVOrpTg/FT4Ikh+PAuo1xsggTw+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p5y3v10y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p5y3v10y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A220C19424;
	Sat, 28 Feb 2026 17:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301272;
	bh=VZCNWqHNgDWJEFCQUtbBDKu/poUJ6/8yBHL4Wv5TY3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5y3v10yAXNGXS4DsSqAL4wu0O2joblA2cLVGqiOA6Rmh4kmpr3iXJF0DTNuLl/aE
	 JmOC0zRJtN5aQ+dPB013zgRUEfJECiAE7rLvuliqT/1dBothDZS1wjWroMMAlXJfwh
	 eWYklcgiyhR0H8wu4Sz7KIurYDkb1FxuCYd636rLKCEYcp3iCmpth1ar+BNWcxFUp+
	 s11JAmNv5SrhRfMqJaOm0NjqUYgUp+E/UhoBl4PLZl7jh9Xi7neO9IeQtVt3CYE0pr
	 bQiV0stk8vE2c3bA8mKIjGYp+UUNKS8nArb35iQy2GMeH9fdN9QSh1uSXwwbOBGw3f
	 ivaKQBqF+/AOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chris Brandt <chris.brandt@renesas.com>,
	stable@kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 457/752] clk: renesas: rzg2l: Select correct div round macro
Date: Sat, 28 Feb 2026 12:42:48 -0500
Message-ID: <20260228174750.1542406-457-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chris Brandt <chris.brandt@renesas.com>

[ Upstream commit f9451374dcfdfe669ee55b58ee6c11e8638980e4 ]

Variable foutvco_rate is an unsigned long, not an unsigned long long.

Cc: stable@kernel.org
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Closes: https://lore.kernel.org/CAMuHMdVf7dSeqAhtyxDCFuCheQRzwS-8996Rr2Ntui21uiBgdA@mail.gmail.com
Fixes: dabf72b85f29 ("clk: renesas: rzg2l: Fix FOUTPOSTDIV clk")
Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251114194529.3304361-1-chris.brandt@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 9efedc62feed6..edad47ca33ec5 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -572,8 +572,8 @@ rzg2l_cpg_get_foutpostdiv_rate(struct rzg2l_pll5_param *params,
 	foutvco_rate = div_u64(mul_u32_u32(EXTAL_FREQ_IN_MEGA_HZ * MEGA,
 					   (params->pl5_intin << 24) + params->pl5_fracin),
 			       params->pl5_refdiv) >> 24;
-	foutpostdiv_rate = DIV_ROUND_CLOSEST_ULL(foutvco_rate,
-						 params->pl5_postdiv1 * params->pl5_postdiv2);
+	foutpostdiv_rate = DIV_ROUND_CLOSEST(foutvco_rate,
+					     params->pl5_postdiv1 * params->pl5_postdiv2);
 
 	return foutpostdiv_rate;
 }
-- 
2.51.0

