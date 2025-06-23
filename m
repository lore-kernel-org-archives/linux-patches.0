Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6631DF98B;
	Mon, 23 Jun 2025 21:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713187; cv=none; b=Ta6AgFKekCQXZSmI/afXR+1RLXXbXkXTngpKcYDdPwS/cOYxBmRhHe5rW2FenlX5c8JrQUI+9NqkQ300V3ZzTOYgAeInXAYNDBc70Mgs0eklwB670+kgDGs11nwzpGVLo7fyqc77LSlKqbUNeIqSHoPZdGXjujlx7GPBiFBquNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713187; c=relaxed/simple;
	bh=3cbG5qoQnzCzHvtdl+5U44kRmtlAe9e08KAjpq0ZH88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7jafkTnAWXqFTXt035T9D9oELkaStykhEeMdSh0AXwA2E47njWz8Sjl9y1ci/GrE08mjZrR3bBOVzqhL1dsnUtdAOxc0Ayg0wqaTqTakCRxo0m3K9J+PkoFPB1zwXSMZQwLZWXtruLYUSTOCm8QH8x6GLVVPmLwFldxRD+gpfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJyIMO92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJyIMO92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1786BC4CEEA;
	Mon, 23 Jun 2025 21:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713187;
	bh=3cbG5qoQnzCzHvtdl+5U44kRmtlAe9e08KAjpq0ZH88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJyIMO92MShF1n2/xMlVJ6A+cYLidcNJsDgazOXMfTCAVXggxtrtglcbhibbcawQx
	 K+ZjLerdZKMNsU5SQ25lKEwDwEbKB8Ob2Xvx/sVngm7ljJnnl3KhixQt0DOCKDUTm4
	 mITUmz8ZgnSSIjUZ7C7kmEMvn1AHXCfsK7drXTCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/222] clk: rockchip: rk3036: mark ddrphy as critical
Date: Mon, 23 Jun 2025 15:08:28 +0200
Message-ID: <20250623130617.272273993@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6a46f85ad8372..4a8c72d995735 100644
--- a/drivers/clk/rockchip/clk-rk3036.c
+++ b/drivers/clk/rockchip/clk-rk3036.c
@@ -429,6 +429,7 @@ static const char *const rk3036_critical_clocks[] __initconst = {
 	"hclk_peri",
 	"pclk_peri",
 	"pclk_ddrupctl",
+	"ddrphy",
 };
 
 static void __init rk3036_clk_init(struct device_node *np)
-- 
2.39.5



