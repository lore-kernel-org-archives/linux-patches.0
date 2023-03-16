Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC3EAD4E
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 23:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8CEC433D2;
	Thu, 16 Mar 2023 23:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679008280;
	bh=C9SeBZKe1J8xGwKJwJ0+m/gRU/FcXNA39c4C2EpsCw8=;
	h=From:To:Cc:Subject:Date:From;
	b=OIrdVdMwEVXSwXTPd21TxEKgha2ZmkPifPbVOKWq0vHWhgoKeTOOKrJXdZuoDqQ4O
	 oXIsFDAXi2htZFn1dF9N7kzpSE4HO3lPPWV6mtpoY4qvz2jm8DJ5PgrCz+LfJqFaC5
	 kbkKHIlSsSBMkn+gquyrt9DG6slo8FbvL/3ty5ImUHzRzX/9Zg0F5lJIF2KVNMVJzy
	 8bWxRg9fp2O8SALmvzlz/g2+MUF/x4Hd1Wp772uueEHMJUlvdcE9f3nx/1ST38l6Ky
	 R12nTpgd3BAKGVlZuKSveJPmA2kBUmmoSQCNrwwLL2xJRzRQYyy4VrKdmTfMzCXe59
	 SOAYTvKtxSGSQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>
Subject: [PATCH] clk: mediatek: Ensure fhctl code is available for COMMON_CLK_MT6795
Date: Thu, 16 Mar 2023 16:11:18 -0700
Message-Id: <20230316231118.2579242-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Without this select we get linker errors when linking
clk-mt6795-apmixedsys

arm-linux-gnueabi-ld: drivers/clk/mediatek/clk-mt6795-apmixedsys.o: in function `clk_mt6795_apmixed_remove':
clk-mt6795-apmixedsys.c:(.text+0x34): undefined reference to `mtk_clk_unregister_pllfhs'
arm-linux-gnueabi-ld: drivers/clk/mediatek/clk-mt6795-apmixedsys.o: in function `clk_mt6795_apmixed_probe':
clk-mt6795-apmixedsys.c:(.text+0x98): undefined reference to `fhctl_parse_dt'
arm-linux-gnueabi-ld: clk-mt6795-apmixedsys.c:(.text+0xb8): undefined reference to `mtk_clk_register_pllfhs'
arm-linux-gnueabi-ld: clk-mt6795-apmixedsys.c:(.text+0x1c4): undefined reference to `mtk_clk_unregister_pllfhs'

Fixes: f222a1baec5f ("clk: mediatek: mt6795: Add support for frequency hopping through FHCTL")
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/mediatek/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/mediatek/Kconfig b/drivers/clk/mediatek/Kconfig
index 7a12aefb1d0b..c707c6fe45a3 100644
--- a/drivers/clk/mediatek/Kconfig
+++ b/drivers/clk/mediatek/Kconfig
@@ -270,6 +270,7 @@ config COMMON_CLK_MT6795
 	tristate "Clock driver for MediaTek MT6795"
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	select COMMON_CLK_MEDIATEK
+	select COMMON_CLK_MEDIATEK_FHCTL
 	default ARCH_MEDIATEK
 	help
 	  This driver supports MediaTek MT6795 basic clocks and clocks
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

