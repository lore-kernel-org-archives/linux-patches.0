Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F94F19DF4A;
	Mon, 23 Jun 2025 22:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716179; cv=none; b=RJxdpAb4TUsL/RawvPrYfLj+VVtmzGy+938ddHNSsrP463jNA8ZtcbMzLYpHiPB4L8nIFNQpnNJKsuD9guJbNQwSGLPpHBVrhVPMRk/Df3UoHd/+C2ExWy8GHTB7RM6sqjMHMKhh2hVhO3w0gahl1B3tOHR83q+Plo9LS7qEZgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716179; c=relaxed/simple;
	bh=Fb2RXm5Qc9fHZ6ie+zsWg6VWClRu9tXbXHu5nirJ1Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFxy4cnhyvK5FL4pkLseaiAYdZK88QLvo+Dlk4ZV1tJ6bvo0o3pVKnQXoYuD9bFTmXruVIEBaAx/VmtdjslGTUskovzzad70kj+mhaCxJx5O5n3l89pZ9phkUpcLehb5KvtmDqUAWXpy+vs5/R5/E4/qYPrqbb2xE1V4RKFTpUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3nBTNmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3nBTNmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FE8C4CEEA;
	Mon, 23 Jun 2025 22:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716179;
	bh=Fb2RXm5Qc9fHZ6ie+zsWg6VWClRu9tXbXHu5nirJ1Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3nBTNmQw5BjvD4HmOyainLx+y4aTUYJ8ciN6HLHlfx5ulPGyusOuvn3ZC/wWbxFf
	 ZtQVjYJ/cn269gdpbwYl9RYZggl5aIfh4V44l2Gv/4WtKv8IfJAWw7yhkCQ48ju5IV
	 IS1w7Zwipn6DuDnRkR72BSXOmd95bzCRRx59xzf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/414] clk: rockchip: rk3036: mark ddrphy as critical
Date: Mon, 23 Jun 2025 15:06:15 +0200
Message-ID: <20250623130647.990744515@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



