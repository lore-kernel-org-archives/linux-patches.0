Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057412376D;
	Thu, 18 Jan 2024 11:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575607; cv=none; b=LQj6F0RcE4teu33ahHN5XpTQAwTXOTWxduPswuJQU3qeN8Ws+pgMNF7ud/nx1n6II0OVBveMNBB/8h2EBiEvV+VxJdK6cukVdV28IPXui2QcOVeYUP2QcCfmuB3FF5+Ws47WBsMWkDLMuM+OIt8tDrlCwF8GdnryWW40AagjJQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575607; c=relaxed/simple;
	bh=doFIR4smwfV9exCE+kah6+rl1XKXBMTe8eOZbqHYqF0=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=lHe3Qi5mchOQQpggDWVmzo5ti8oIFQUZEunroeev/BOAE8hHiHB6/kbbvKNJrzWOgYvb2D1FPM7e2LNCKFva2GEk4VgsYTsYzvaxeG6XDm8lSuYSuCEeG72K1NCwcIfC2Mml9ws9BmPRerIk9EmiKXTgxk0E9YIVXXedm9mSz1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7s2gdL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7s2gdL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3F2C43394;
	Thu, 18 Jan 2024 11:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575606;
	bh=doFIR4smwfV9exCE+kah6+rl1XKXBMTe8eOZbqHYqF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7s2gdL29xLYwjCXLfMSbqfrwSgoXNWWoBagxlrglvgvE9OqQv/EnGfIYQjMVRVum
	 PXG1QdP6SVwQ3E6FgveDeHSMNo0P1QfWWOJXsbecmp6SqlT49s33KlInVTsXwqaqCU
	 US9bWXuskTcN9GT0Y8sTHzdC4VcxYqqMgBfXGt3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/100] clk: rockchip: rk3568: Add PLL rate for 292.5MHz
Date: Thu, 18 Jan 2024 11:48:50 +0100
Message-ID: <20240118104312.739821201@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit 1af27671f62ce919f1fb76082ed81f71cb090989 ]

Add support for a PLL rate of 292.5MHz so that the Powkiddy RGB30 panel
can run at a requested 60hz (59.96, close enough).

I have confirmed this rate fits with all the constraints
listed in the TRM for the VPLL (as an integer PLL) in Part 1 "Chapter
2 Clock & Reset Unit (CRU)."

Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://lore.kernel.org/r/20231018153357.343142-2-macroalpha82@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3568.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/rockchip/clk-rk3568.c b/drivers/clk/rockchip/clk-rk3568.c
index 2f54f630c8b6..1ffb755feea4 100644
--- a/drivers/clk/rockchip/clk-rk3568.c
+++ b/drivers/clk/rockchip/clk-rk3568.c
@@ -72,6 +72,7 @@ static struct rockchip_pll_rate_table rk3568_pll_rates[] = {
 	RK3036_PLL_RATE(408000000, 1, 68, 2, 2, 1, 0),
 	RK3036_PLL_RATE(312000000, 1, 78, 6, 1, 1, 0),
 	RK3036_PLL_RATE(297000000, 2, 99, 4, 1, 1, 0),
+	RK3036_PLL_RATE(292500000, 1, 195, 4, 4, 1, 0),
 	RK3036_PLL_RATE(241500000, 2, 161, 4, 2, 1, 0),
 	RK3036_PLL_RATE(216000000, 1, 72, 4, 2, 1, 0),
 	RK3036_PLL_RATE(200000000, 1, 100, 3, 4, 1, 0),
-- 
2.43.0



