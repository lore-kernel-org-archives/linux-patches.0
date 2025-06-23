Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919103FD4;
	Mon, 23 Jun 2025 21:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715294; cv=none; b=QHs0cD922nQUX02u5sUVgr4uEIw7a7fMfA4k9jHDUEkiLtFPnxi0q1ZRbCbxAHXpi5MzyW3KT5UeB4xvYdYBDPA/q4aIDgSjauMpYOc4K+/+QkSbvEju0x0tQP7VnnMzO1eaFu9c8cFFZuaaHdfMwBcZ/cLpcy9v9sZFyqXeCyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715294; c=relaxed/simple;
	bh=vxTG93/JxqrfO8hIodKpnM/p8JxJfULyJKSrVZOFpr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPYG26vM1xu9UG1sLoc1eZC314D8jv6/DGnybTBm1xNfvHXqRLtCU8zSRJ7wxVKUe+57GEiakWmCZiHOsm0VxZ6ghnIMN/M1OVuYL/7KBh/oiwA3ael0OeI5DWGKJ2M9UA0eFvv+467YtBtczKi03+eUZAgmyvFhGR4wXvgb7BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dbzo6oNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dbzo6oNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F082C4CEEA;
	Mon, 23 Jun 2025 21:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715294;
	bh=vxTG93/JxqrfO8hIodKpnM/p8JxJfULyJKSrVZOFpr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dbzo6oNG4+l/l7+7kS6E/TOBBB7Oc/P3qRNcux0DOmfvHCgJ1/8gOJqj4bBkc9dr0
	 2hrnce9wFCU0dn0YsS7Fg8JtOweude6iuq5CsTO0LV14Dd6BS5VlSvGUk0eF++pWtA
	 a2NqQQu5PcsJSfYUtG5qfGNtE/icA+tXfJ0sspa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/355] clk: rockchip: rk3036: mark ddrphy as critical
Date: Mon, 23 Jun 2025 15:07:47 +0200
Message-ID: <20250623130634.751430900@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



