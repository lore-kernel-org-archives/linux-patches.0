Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9ED1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 14:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBE2C4339E;
	Mon, 20 Mar 2023 14:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324287;
	bh=RYEgoQfy5g2obq3M1OeoK2adxxmexkLppMESHV9PtqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gY/PtiKZbzww4GV88lr2T649mmQ9r/A7X01xOvFP2qH36eBudQaoIFgAetNff6mL2
	 zuapJFNs8Ufep1Ou/rwkk6RAzS0SMQF5FeKGogradwa8kubIzSRSSOB8it6TJVu9MZ
	 WwKOaQBHDTCAW5/fSmhrxGptAGJOlCS+RqenPZTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Riku Voipio <riku.voipio@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>,
	linux-clk@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/36] clk: HI655X: select REGMAP instead of depending on it
Date: Mon, 20 Mar 2023 15:54:29 +0100
Message-Id: <20230320145424.339190661@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 0ffad67784a097beccf34d297ddd1b0773b3b8a3 ]

REGMAP is a hidden (not user visible) symbol. Users cannot set it
directly thru "make *config", so drivers should select it instead of
depending on it if they need it.

Consistently using "select" or "depends on" can also help reduce
Kconfig circular dependency issues.

Therefore, change the use of "depends on REGMAP" to "select REGMAP".

Fixes: 3a49afb84ca0 ("clk: enable hi655x common clk automatically")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Riku Voipio <riku.voipio@linaro.org>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: linux-clk@vger.kernel.org
Link: https://lore.kernel.org/r/20230226053953.4681-3-rdunlap@infradead.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 292056bbb30e9..ffe81449ce246 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -63,7 +63,7 @@ config COMMON_CLK_RK808
 config COMMON_CLK_HI655X
 	tristate "Clock driver for Hi655x" if EXPERT
 	depends on (MFD_HI655X_PMIC || COMPILE_TEST)
-	depends on REGMAP
+	select REGMAP
 	default MFD_HI655X_PMIC
 	---help---
 	  This driver supports the hi655x PMIC clock. This
-- 
2.39.2



