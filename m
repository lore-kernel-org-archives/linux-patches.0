Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B1CFC0B;
	Wed,  5 Feb 2025 13:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763629; cv=none; b=oEwR/IV5CjWgasOxUM4ZsYwpnZ92lb6RfP82F3ZO+0ZmbpL7uTGT/d07W087W1w4e6GsSCmCbNOhoDBRU2OBjgb7+/7zWOLR+z+t5XbD6RVBlTkD3WNC3tHs2MJ7ZGz9Lkl+ER4/1x+XAqCdqIhjV2pyIDzMFjQm/pcBq5W3a4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763629; c=relaxed/simple;
	bh=pTprCUDyBfQQlRn7vVnR8ryhJqRxB97adwmSIBAYO/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udIR9I/Gs0wowy024HiIapICPSsNPDE0snIAjo7TkcP27mqNPJdk0ZtUlgs3Bk8p2nqjsWSx/xfQoiMquUCGDXJQMEs9h+mH1lCFbYNjTm39DSRzcoiF1EaU+s19KS8lpT13yerlRmRX4Ol6BUsxdzYxmdPtFzPsQ501Yw0ATlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDuE7nuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDuE7nuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E585FC4CED1;
	Wed,  5 Feb 2025 13:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763629;
	bh=pTprCUDyBfQQlRn7vVnR8ryhJqRxB97adwmSIBAYO/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDuE7nuRwL/C6B0VG9v6DZHN7yZdCvlB+xhqoMDEib+qs8bKIiES3HmZJvEDx7A3u
	 mwzIX5mfl4pSN0rIkZ+JSiN8fxhG85zTUKkiSflpyc2nktmivJToV4t/VFcz40PJvi
	 EqokhkhgP8K45DNwOLFZqvcXSWZ0/7Bfe+ZdAp4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Frank Oltmanns <frank@oltmanns.dev>,
	Stuart Gathman <stuart@gathman.org>
Subject: [PATCH 6.6 091/393] clk: sunxi-ng: a64: drop redundant CLK_PLL_VIDEO0_2X and CLK_PLL_MIPI
Date: Wed,  5 Feb 2025 14:40:10 +0100
Message-ID: <20250205134423.775963348@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit 0f368cb7ef103f284f75e962c4c89da5aa8ccec7 ]

Drop redundant CLK_PLL_VIDEO0_2X and CLK_PLL.MIPI. These are now
defined in dt-bindings/clock/sun50i-a64-ccu.h

Fixes: ca1170b69968 ("clk: sunxi-ng: a64: force select PLL_MIPI in TCON0 mux")
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Tested-by: Frank Oltmanns <frank@oltmanns.dev> # on pinephone
Tested-by: Stuart Gathman <stuart@gathman.org> # on OG pinebook
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Link: https://patch.msgid.link/20250104074035.1611136-3-anarsoul@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-a64.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-a64.h b/drivers/clk/sunxi-ng/ccu-sun50i-a64.h
index a8c11c0b4e067..dfba88a5ad0f7 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-a64.h
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-a64.h
@@ -21,7 +21,6 @@
 
 /* PLL_VIDEO0 exported for HDMI PHY */
 
-#define CLK_PLL_VIDEO0_2X		8
 #define CLK_PLL_VE			9
 #define CLK_PLL_DDR0			10
 
@@ -32,7 +31,6 @@
 #define CLK_PLL_PERIPH1_2X		14
 #define CLK_PLL_VIDEO1			15
 #define CLK_PLL_GPU			16
-#define CLK_PLL_MIPI			17
 #define CLK_PLL_HSIC			18
 #define CLK_PLL_DE			19
 #define CLK_PLL_DDR1			20
-- 
2.39.5



