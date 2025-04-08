Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A763269D09;
	Tue,  8 Apr 2025 11:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113221; cv=none; b=m/1sKBfhY4USVO38cPKFxyKw/Z/W9oQNVjSnf9d9Hr98umBGnNqAbJbrWrGGXRYHSmmNKTlu1w2k+kSUOsJytRClyruozZU35TDuiCYQ3c9TxDnujtIWu3mknHed9QyocP/hYQ8iw0AUsmHtYk+HODikU+v2TTlGP9E0R7h2zqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113221; c=relaxed/simple;
	bh=SDDstXG72UeDgilM4vDjEHsuNrbJfwQ8nLQjERtUa/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4VxKdXe8QgRIKsSYvg1lE0lQVfMDrKR9lxY2l9Gte23gZdV9ZLewcObEid3UlxgwUD7BeMpjPi9Y0HVwW9AKyaQRtOIZhQsfEFzF1qLoE9GHZvbpiTahvSqSJ1PXqm4gTC72zkVulU9w6DpTl0gU/5M13gTklfGx6dW8GwPpkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWWOv1p5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWWOv1p5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35574C4CEEB;
	Tue,  8 Apr 2025 11:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113220;
	bh=SDDstXG72UeDgilM4vDjEHsuNrbJfwQ8nLQjERtUa/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWWOv1p5R+HusDzvTzlSoAoOqp6030bzIaSGGviYBIWq3yRpZfjJGsrxo529vjdS6
	 LK7yvcCPKoctZqAQd+wjRQorH22dS8mm3aQK/9U32xX9yihM2Q60/G0eIcF9aWBQm/
	 tE4FgRbXRZhY0y6hyzL07WWzN5Q6me8+tMzEebNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Geis <pgwipeout@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/268] clk: rockchip: rk3328: fix wrong clk_ref_usb3otg parent
Date: Tue,  8 Apr 2025 12:48:10 +0200
Message-ID: <20250408104830.626645978@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Geis <pgwipeout@gmail.com>

[ Upstream commit a9e60f1ffe1ca57d6af6a2573e2f950e76efbf5b ]

Correct the clk_ref_usb3otg parent to fix clock control for the usb3
controller on rk3328. Verified against the rk3328 trm, the rk3228h trm,
and the rk3328 usb3 phy clock map.

Fixes: fe3511ad8a1c ("clk: rockchip: add clock controller for rk3328")
Signed-off-by: Peter Geis <pgwipeout@gmail.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/20250115012628.1035928-2-pgwipeout@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3328.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3328.c b/drivers/clk/rockchip/clk-rk3328.c
index 267ab54937d3d..a3587c500de28 100644
--- a/drivers/clk/rockchip/clk-rk3328.c
+++ b/drivers/clk/rockchip/clk-rk3328.c
@@ -201,7 +201,7 @@ PNAME(mux_aclk_peri_pre_p)	= { "cpll_peri",
 				    "gpll_peri",
 				    "hdmiphy_peri" };
 PNAME(mux_ref_usb3otg_src_p)	= { "xin24m",
-				    "clk_usb3otg_ref" };
+				    "clk_ref_usb3otg_src" };
 PNAME(mux_xin24m_32k_p)		= { "xin24m",
 				    "clk_rtc32k" };
 PNAME(mux_mac2io_src_p)		= { "clk_mac2io_src",
-- 
2.39.5



