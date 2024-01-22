Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B34129A91;
	Tue, 23 Jan 2024 00:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968724; cv=none; b=W19u2mmG2G99J3VxJY9cOokDQhzYWbHisckzjyKegZX2B91XNyyaDr4NvFAOo5Gli8n12IXrJbYB7ygHcxi1Qhq1K0ZavbQeTVqwrAK5tqaJMlm1NQIB6ffGRLzWGreBsVDKAOAUxmv0DPyW5+pgeqy8JEWw7A96uSaS4lEVa8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968724; c=relaxed/simple;
	bh=Kc4ifM/IXpdIXaCSJe6rL24ScM8QJIbLCaDaL0KYEVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltIAEc4obcaDjpLC/3LQoPGuzMpkUa/wsw6SAkfv/JWnODAzAxUZeuTvFhRsVvXT7hFhsShHbTrjJtS1Weog1a6b4V/cI2zvkamlkd6nY+j+KlDSFNT8sntEVCu7WeBHfqoGIs4YzD3hpDIODtkpQXFXdYxRWEr4IqfDgS6GaI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMbj09xu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMbj09xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA7CC433C7;
	Tue, 23 Jan 2024 00:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968724;
	bh=Kc4ifM/IXpdIXaCSJe6rL24ScM8QJIbLCaDaL0KYEVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMbj09xuUPrDd99Eon5ufUWdLXTMiQaWZY/ow6wl6zqZMv9Lw3JQHVEJHyn2CHFkA
	 2iNX+sVsksXV307CqKTSI3EwElNEkj/zStcmAlMeTl+GKqzNiMEtuWuXEH0sXfthfX
	 078LtQa+8TpiZl0At09T+0Pftw26auDqU6GbcgQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weihao Li <cn.liweihao@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/194] clk: rockchip: rk3128: Fix HCLK_OTG gate register
Date: Mon, 22 Jan 2024 15:55:46 -0800
Message-ID: <20240122235719.902387282@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weihao Li <cn.liweihao@gmail.com>

[ Upstream commit c6c5a5580dcb6631aa6369dabe12ef3ce784d1d2 ]

The HCLK_OTG gate control is in CRU_CLKGATE5_CON, not CRU_CLKGATE3_CON.

Signed-off-by: Weihao Li <cn.liweihao@gmail.com>
Link: https://lore.kernel.org/r/20231031111816.8777-1-cn.liweihao@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3128.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3128.c b/drivers/clk/rockchip/clk-rk3128.c
index 4b1122e98e16..ddfe1c402e80 100644
--- a/drivers/clk/rockchip/clk-rk3128.c
+++ b/drivers/clk/rockchip/clk-rk3128.c
@@ -489,7 +489,7 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
 	GATE(HCLK_I2S_2CH, "hclk_i2s_2ch", "hclk_peri", 0, RK2928_CLKGATE_CON(7), 2, GFLAGS),
 	GATE(0, "hclk_usb_peri", "hclk_peri", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(9), 13, GFLAGS),
 	GATE(HCLK_HOST2, "hclk_host2", "hclk_peri", 0, RK2928_CLKGATE_CON(7), 3, GFLAGS),
-	GATE(HCLK_OTG, "hclk_otg", "hclk_peri", 0, RK2928_CLKGATE_CON(3), 13, GFLAGS),
+	GATE(HCLK_OTG, "hclk_otg", "hclk_peri", 0, RK2928_CLKGATE_CON(5), 13, GFLAGS),
 	GATE(0, "hclk_peri_ahb", "hclk_peri", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(9), 14, GFLAGS),
 	GATE(HCLK_SPDIF, "hclk_spdif", "hclk_peri", 0, RK2928_CLKGATE_CON(10), 9, GFLAGS),
 	GATE(HCLK_TSP, "hclk_tsp", "hclk_peri", 0, RK2928_CLKGATE_CON(10), 12, GFLAGS),
-- 
2.43.0



