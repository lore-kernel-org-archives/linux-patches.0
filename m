Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8157C2222B2;
	Mon, 23 Jun 2025 22:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717382; cv=none; b=rv7/GYfYAqEckfalb/1FYoZ8La8FiVx8aO/qqUpOY6B+YBeAP6AUKRMm0xp9aZ/8Rxo/b2wIWB1wpMTsjVpTg0UL2b1pmZR5Q5xWb/96xKHIjYiIS4LYcfov34KSz//KN+0Eqhe+fRbE6GundUqmkRkSyRxKiVnRWcvThSWwVOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717382; c=relaxed/simple;
	bh=Yr9LqxRSj9nHuwNvd80g5/mM94TYI1ugxFQwUeqJiuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoFckY7vEc5y0toY64AiB90fdCKZDjEdiUMByQMXrqKj4KOq40yaKbkPQBfcWEszBvdlvjDSja9AkEFNd1x+g+Z6x0CD/4M8nNIoVhUArttvT4IX+++6pJH0adTYmO+JMqUXhKjQ6pxE/MALv3XJ9WfJOEgD5cyI+UO7N2SvBjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJINi+J9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJINi+J9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16505C4CEEA;
	Mon, 23 Jun 2025 22:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717382;
	bh=Yr9LqxRSj9nHuwNvd80g5/mM94TYI1ugxFQwUeqJiuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJINi+J9LVy2PpxIA3Ecya1l0toxq2zAXWkiUmXbWxaOHVR8VNGDTm1sYqJfJOgRk
	 W8S0m61vNBzWiMbpnGvmj9ZkJT1wyOol3EDHDtKm9QHSx/dZtMpH0NaYf9rZ2nt66V
	 4jgX5akhzYnKVnj7qIIToWtoUJtw3Ozivg3Iil2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 415/508] clk: rockchip: rk3036: mark ddrphy as critical
Date: Mon, 23 Jun 2025 15:07:40 +0200
Message-ID: <20250623130655.421272753@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d644bc155ec6e..f5f27535087a3 100644
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



