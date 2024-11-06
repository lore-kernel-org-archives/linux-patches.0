Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C44F1DEFF5;
	Wed,  6 Nov 2024 12:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895036; cv=none; b=FsTwM9wNO9fjRYLsyI27VO2bGTIkpTovTgGfJoGhK/7FVL7Z2Wfqq02kW9TsUAXcEJEGlF3LSbwGz6onFOeMAOrethdAGRTQvBsmBNyTjWWX1woOmmyYNKteTxibhC725NhjaNxcPaFg3BT3rvNINeCv6nXnq+LS3azYwu/rasU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895036; c=relaxed/simple;
	bh=1V0iJwsAKZXnpuTVGWT0fgrQHx6bHcsbkhKFuP95MFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcMSzOqsqu//4DFSMqXXsJskmxj+7Ux56LqQXULvGPYGK9mwfGIHEBw5zB0WE3c4upiotjaYshDkmqgjYzw9KcHUqwPf1jOvFF61MMIe5tFzI1/kwQe/UFpx7VXgxe9mipXEwETZ2kJDljrebPCPci3eqQCeAQuthpfiCantSQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKrOGZm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKrOGZm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BF4C4CED2;
	Wed,  6 Nov 2024 12:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895036;
	bh=1V0iJwsAKZXnpuTVGWT0fgrQHx6bHcsbkhKFuP95MFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKrOGZm6PoCiqgXt4IpsEikIwC1F8ZNggMOZfah+DEVMTuaaLCRCwLx2sKZscbIms
	 QDpzjNX8qSAE35CVjDVztv6+a/bRwHY9k6G7hlc3Hm6BjIMUTEwLUOtrnJn9ZHUcgp
	 gIEOmFqMY12gVcqwRJ7rd+DzX2M1gYPKQ+uc/Iwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 082/350] clk: rockchip: Set parent rate for DCLK_VOP clock on RK3228
Date: Wed,  6 Nov 2024 13:00:10 +0100
Message-ID: <20241106120322.923445387@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 1d34b9757523c1ad547bd6d040381f62d74a3189 ]

Similar to DCLK_LCDC on RK3328, the DCLK_VOP on RK3228 is typically
parented by the hdmiphy clk and it is expected that the DCLK_VOP and
hdmiphy clk rate are kept in sync.

Use CLK_SET_RATE_PARENT and CLK_SET_RATE_NO_REPARENT flags, same as used
on RK3328, to make full use of all possible supported display modes.

Fixes: 0a9d4ac08ebc ("clk: rockchip: set the clock ids for RK3228 VOP")
Fixes: 307a2e9ac524 ("clk: rockchip: add clock controller for rk3228")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240615170417.3134517-3-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3228.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3228.c b/drivers/clk/rockchip/clk-rk3228.c
index 8d11d76e1db7c..811f0d43ee90b 100644
--- a/drivers/clk/rockchip/clk-rk3228.c
+++ b/drivers/clk/rockchip/clk-rk3228.c
@@ -415,7 +415,7 @@ static struct rockchip_clk_branch rk3228_clk_branches[] __initdata = {
 			RK2928_CLKSEL_CON(29), 0, 3, DFLAGS),
 	DIV(0, "sclk_vop_pre", "sclk_vop_src", 0,
 			RK2928_CLKSEL_CON(27), 8, 8, DFLAGS),
-	MUX(DCLK_VOP, "dclk_vop", mux_dclk_vop_p, 0,
+	MUX(DCLK_VOP, "dclk_vop", mux_dclk_vop_p, CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
 			RK2928_CLKSEL_CON(27), 1, 1, MFLAGS),
 
 	FACTOR(0, "xin12m", "xin24m", 0, 1, 2),
-- 
2.43.0



