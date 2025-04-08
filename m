Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78592690F9;
	Tue,  8 Apr 2025 11:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112732; cv=none; b=egsRxSIq5TtjM5iHl/OITpkoy2mSjsilJcD62FDwMnlb5nT1PqsjwvJo7dDcrW8mDJV1g2P3AVVRc79Ty1N+jZgxk7OUXHTUk4KV0iWfiF8olcXXZV27T1OiY3cPwuwmbnEwUSo2Js5Ki7zODJEiZoxVW+NEV8T1JRQQK4C6dqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112732; c=relaxed/simple;
	bh=7iwW+MSj660PVIFLxix5OLUARcorjqZgPeSftqztwB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXUtI3hxZUvEQbs/n3G3Hd6FaotNnGSzIFqISfKcx2SS9iB0r8HY5Ih7Q8Ls7BVGxqP9LkgPc9euETFea+S8z2qOYsUHOeJE9biiG3PwcbGmwacBEamg2JBB5de+xJNOqQQmni99/CCRMR2u1XeEZ9N3P56BJy8+pjXQOod/EtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uw7O8esX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uw7O8esX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96D2C4CEE7;
	Tue,  8 Apr 2025 11:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112732;
	bh=7iwW+MSj660PVIFLxix5OLUARcorjqZgPeSftqztwB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uw7O8esXHOT/xWcGV6mS803ieCryfKbsd28mUaEA0o3fNg6k+CPT5sWA2Gr01r0uT
	 AaFVHJNzPZVUWhilxIk08MlfJ5kWeAxg75aXE8SnHPCt0EzgiYKUtevpdtw3xo2HOZ
	 /MeN0+BC7lBc6/YZhGijh5gTY8b3BMh4wxkIR00A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Geis <pgwipeout@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/279] clk: rockchip: rk3328: fix wrong clk_ref_usb3otg parent
Date: Tue,  8 Apr 2025 12:49:21 +0200
Message-ID: <20250408104831.133521231@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



