Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E801494DF;
	Wed,  5 Feb 2025 14:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764702; cv=none; b=OUP28oiYtQknFcSJpKdogEgxsAN3eI3YcASaH5p8eF/T1lPxYhYIkaYw/6rqse5VgLgjjr+3HegAfVqg/7BFggJ16jaVt9E2J0CiCGIYrcZfdblGVyJbgjtyGDB8Sv67QhJIxhPkLTAz3JCeAHbIsQGwL+sc0LjuG8CjLC0PoS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764702; c=relaxed/simple;
	bh=5S5lL0Sx1x+NzaP6ELQVjxlcVr/rVjF+fVgra/2sG/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkqkHNhUAXFX+YnKJ7WHqL1obb+7NWk9aiMqX3ByfhJqRxtbMpOPVmT3oLaPF0wJhLN+eVJIxNMTd+DaXvzvmPD6ab+hFo6Jtgp3Eq9yB9PBtqIT+ODG97cwsn8eI6wpcxqqbB317XmGwXOYYfTfDJ7E0qPa54XwwFl1Ox3kOxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSNxa9CH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSNxa9CH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85391C4CED1;
	Wed,  5 Feb 2025 14:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764699;
	bh=5S5lL0Sx1x+NzaP6ELQVjxlcVr/rVjF+fVgra/2sG/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSNxa9CHWwvlrHUHGowYj4e57BLT4bb7ivFfVVVqL/7ji4gI4or0yh1cEulNjc06Y
	 rbc2h7xcIl87MZwFAalY/rIXLOcEJnDVu2diY32P+eun3xP0+fBc3ddfT9sWbF1kce
	 ZYuvkPXJ6Pd9o9xlbY6o1ig7sTw2IVwbd5HS8SwQ=
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
Subject: [PATCH 6.12 131/590] clk: sunxi-ng: a64: drop redundant CLK_PLL_VIDEO0_2X and CLK_PLL_MIPI
Date: Wed,  5 Feb 2025 14:38:06 +0100
Message-ID: <20250205134500.276764477@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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



