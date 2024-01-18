Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C1D1B96D;
	Thu, 18 Jan 2024 10:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575262; cv=none; b=arrNsNjWLbAjW3YUoYTrfAcbZDhp9erNwXFlN/tS4WwlhXjx9C0Zi3KeO0H6C4P8bljyYkX7FY5Z96XJVCSOAEaf0fqWHQrGNTnZ4GE7Kcasfy8GlHo1t+4j5kG7Cdgif+L4jecvGmFPzxT/iWfQKSD+wxbAGyeN+brJRtaRq2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575262; c=relaxed/simple;
	bh=RhyFIglVfAEYOz+yzLMF6daThBPaEo1gff18eIofh14=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=EOnRYiCfgFiUX8Md8TMGt4t/Zz9LZ4piOVbNPv9pNhaD9MnsFaZq4eF3qsnr9eo7NXvGSxknUNSeiGgmvox7zOfBJYjbAWYpcxo5I4/7bl/7P5bikdcKqmyNcVEABk5JnBq5cDeif9C7LF35M9PTQuHTEcheRT/WVTafOQ18AjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8xvBDZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8xvBDZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55194C433F1;
	Thu, 18 Jan 2024 10:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575262;
	bh=RhyFIglVfAEYOz+yzLMF6daThBPaEo1gff18eIofh14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8xvBDZTB+DIDOnyDdjya7TqN5DtpouKLPSk29LovIeUrmtULAQlZf/ckp4W7qEd1
	 1Ljucm3Z4qkTzhaZJlEfJD7/0VHuWwiiRjfNARpojFUVEpk33InGQnnZacuC2lwIjo
	 oix5uA0KBBvm7bKZWQ/JOl4H4fW2sIpvyRFikzOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weihao Li <cn.liweihao@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/150] clk: rockchip: rk3128: Fix HCLK_OTG gate register
Date: Thu, 18 Jan 2024 11:48:12 +0100
Message-ID: <20240118104323.211524427@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 22e752236030..75071e0cd321 100644
--- a/drivers/clk/rockchip/clk-rk3128.c
+++ b/drivers/clk/rockchip/clk-rk3128.c
@@ -484,7 +484,7 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
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



