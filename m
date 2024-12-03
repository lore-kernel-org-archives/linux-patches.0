Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150FA1F7567;
	Tue,  3 Dec 2024 15:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241361; cv=none; b=nOz5LvqHWgN+DwvH3omomWxe/8CMLvg3/P2lY1ev5SdaUn1HoSebXn9Y4e+KvFqeLdgjPAsbNyxV1gS09v4wq/nFHdgiRK4q0/D/m5SaFQsKJZe96ZlHlgShlkO8fKtoiRsHjHRjbUenodqVcm8R4NDCjqNgBYvVv6liyOBcwrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241361; c=relaxed/simple;
	bh=DaXlJaiDubjdFEQHxoXXWg1zC3YokFMhjmX13vWnalI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTiEuYVdvoCOi7lz4na5nJQG9RgEv8P8lHbgeRCNY3f7zyLrywlAxSGc57BuYsi+TPJEW3zucz9eQ6kU3S8U0fjc53CxXSqXObj/Tegp3w+fh07+978wojKdZRrITspvvARP2rk3//zyFIxgdtUEOdUgbnZuQetItzyhWjZKVns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOQ2MCBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOQ2MCBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D08EC4CECF;
	Tue,  3 Dec 2024 15:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241360;
	bh=DaXlJaiDubjdFEQHxoXXWg1zC3YokFMhjmX13vWnalI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOQ2MCBHgsVWMag9niF+TUjC21/NAKfzDlS3n5k6wYJr2HCwPNdchSxfbuMRM6bBw
	 0OiA+VgOZWPPvbLsuxVJUGBxflfCekDQdiVdz0xPruYgKPhb/7zntZTZwlmlTk+wGw
	 O2muEctRUHsSjzrf0vb9qxqLrmOoEiPDdPiICbDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hien Huynh <hien.huynh.px@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 398/826] clk: renesas: rzg2l: Fix FOUTPOSTDIV clk
Date: Tue,  3 Dec 2024 15:42:05 +0100
Message-ID: <20241203144759.286419497@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit dabf72b85f298970e86891b5218459c17b57b26a ]

While computing foutpostdiv_rate, the value of params->pl5_fracin
is discarded, which results in the wrong refresh rate. Fix the formula
for computing foutpostdiv_rate.

Fixes: 1561380ee72f ("clk: renesas: rzg2l: Add FOUTPOSTDIV clk support")
Signed-off-by: Hien Huynh <hien.huynh.px@renesas.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20241024134236.315289-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 88bf39e8c79c8..b43b763dfe186 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -548,7 +548,7 @@ static unsigned long
 rzg2l_cpg_get_foutpostdiv_rate(struct rzg2l_pll5_param *params,
 			       unsigned long rate)
 {
-	unsigned long foutpostdiv_rate;
+	unsigned long foutpostdiv_rate, foutvco_rate;
 
 	params->pl5_intin = rate / MEGA;
 	params->pl5_fracin = div_u64(((u64)rate % MEGA) << 24, MEGA);
@@ -557,10 +557,11 @@ rzg2l_cpg_get_foutpostdiv_rate(struct rzg2l_pll5_param *params,
 	params->pl5_postdiv2 = 1;
 	params->pl5_spread = 0x16;
 
-	foutpostdiv_rate =
-		EXTAL_FREQ_IN_MEGA_HZ * MEGA / params->pl5_refdiv *
-		((((params->pl5_intin << 24) + params->pl5_fracin)) >> 24) /
-		(params->pl5_postdiv1 * params->pl5_postdiv2);
+	foutvco_rate = div_u64(mul_u32_u32(EXTAL_FREQ_IN_MEGA_HZ * MEGA,
+					   (params->pl5_intin << 24) + params->pl5_fracin),
+			       params->pl5_refdiv) >> 24;
+	foutpostdiv_rate = DIV_ROUND_CLOSEST_ULL(foutvco_rate,
+						 params->pl5_postdiv1 * params->pl5_postdiv2);
 
 	return foutpostdiv_rate;
 }
-- 
2.43.0



