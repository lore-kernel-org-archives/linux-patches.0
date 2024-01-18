Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0031424B25;
	Thu, 18 Jan 2024 11:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575610; cv=none; b=GsRxzQK4/aeK2056zF+i66RAQEeN5214HZ5sjyoQqZth9E5Yitmc35XTd4fp/v8q7XV0YHnCVEoUzTMPnBg/qH8ClsM7VqAz0nKaTe2gPhrJnBTjA8kboj18br7Ih7KtbBVGJXW9Ag8lR7XKIPd/DYI7np2G7sL/hEw18hh9Psc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575610; c=relaxed/simple;
	bh=REVHN3hJPK55EWCfcjbTzPXz8hixOqflTVH/BrezkS8=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=lmLeVoMb2nr2MvL8C12I5NUdAXtUQQaxI+sCM1DvQiDKRj/ly3mCeiNY+DFQj/WUxzYJxmpGCbC63TrxrInu6VV1eu1Pc6m4tFiK9cEoIkmdeJKE3IR8bSJKq8wMJcuh6T3LgmcMX+2VH6z+NLbwgxZazpP6pSCQ7f6v6tGK1lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8y+cvTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8y+cvTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E04C433A6;
	Thu, 18 Jan 2024 11:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575609;
	bh=REVHN3hJPK55EWCfcjbTzPXz8hixOqflTVH/BrezkS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8y+cvTR8I1TkPTx0hHINFNl1CVFAz9Jerc13HXw9uwHXBphCjKROP/gbVdgIA/ME
	 oSrJY/ljvKkfG/nxjVycdkfH+4m1+OlJZlbN3jz/3LNIau70wl/VdW3JN3MgTm3v5/
	 /wL7OwYx4rrOxZUiRwgaE8oZXkduwVZj7jhWJ4UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weihao Li <cn.liweihao@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/100] clk: rockchip: rk3128: Fix HCLK_OTG gate register
Date: Thu, 18 Jan 2024 11:48:51 +0100
Message-ID: <20240118104312.788748012@linuxfoundation.org>
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
index aa53797dbfc1..7782785a86e6 100644
--- a/drivers/clk/rockchip/clk-rk3128.c
+++ b/drivers/clk/rockchip/clk-rk3128.c
@@ -490,7 +490,7 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
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



