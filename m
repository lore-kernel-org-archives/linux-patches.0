Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721882628C;
	Mon, 23 Jun 2025 21:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713847; cv=none; b=uHViqG9YRA97fX9/MrF6PoiiqfUEO+ZwtMj5x99/Fgpee4HTZxNdvTdfrHAdhhWMuz+aTnHnTPgvpq+yRtRgo/ROlXDS0m7COksJBdIMTE67fnNdjgz+fSS9zXL/8d8F51d+f4s24nMUa2/cxfPJeOJezI+Ih3Tipa12ZEmAiT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713847; c=relaxed/simple;
	bh=700XKjVv8KoY2mg6I3XEKSSC6f+ehnyClkqAP24fT4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hROXgZ98OE2wr0EdM35kXPIgXklfciJPuUGOKT78m8ZA8VGWOWKdGcAJZOXWu8HreQMOk7aWdq6GPoXT4DJZJom4oa4NylUWf8BpnoGxPOB9VStuFOCjv9wjirvZPYU0ktzDAml9PpiY7n8gD20zar7OCZ2Ulr+V11dA4pvn7eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wc39ZcHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wc39ZcHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B576C4CEEA;
	Mon, 23 Jun 2025 21:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713847;
	bh=700XKjVv8KoY2mg6I3XEKSSC6f+ehnyClkqAP24fT4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wc39ZcHMiOLkSWRrsz30DHSP0P22I53+SiuOrQvLnuUnfT/bykQpTS6HsF1/rHp3S
	 VLXynmsNsXRcBybZBkLlqH0IuM13ECh4j4pX78gjFAoBQezUHilSkjbWNek/VWLs+z
	 DRi3LFE5i8Pw1ngNMN3IGRmmXDWfBHEYUZ+2oTmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 369/592] clk: rockchip: rk3036: mark ddrphy as critical
Date: Mon, 23 Jun 2025 15:05:27 +0200
Message-ID: <20250623130709.219057511@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 596a977b34a722c00245801a5774aa79cec4e81d ]

The ddrphy is supplied by the dpll, but due to the limited number of PLLs
on the rk3036, the dpll also is used for other periperhals, like the GPU.

So it happened, when the Lima driver turned off the gpu clock, this in
turn also disabled the dpll and thus the ram.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250503202532.992033-4-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3036.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/rockchip/clk-rk3036.c b/drivers/clk/rockchip/clk-rk3036.c
index d341ce0708aac..e4af3a9286379 100644
--- a/drivers/clk/rockchip/clk-rk3036.c
+++ b/drivers/clk/rockchip/clk-rk3036.c
@@ -431,6 +431,7 @@ static const char *const rk3036_critical_clocks[] __initconst = {
 	"hclk_peri",
 	"pclk_peri",
 	"pclk_ddrupctl",
+	"ddrphy",
 };
 
 static void __init rk3036_clk_init(struct device_node *np)
-- 
2.39.5



