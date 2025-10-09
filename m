Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF66719E967;
	Thu,  9 Oct 2025 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025488; cv=none; b=Dl/Oc5X+kWL8RGNzLNs12BFpRprsjM/tnJOXlWhKFbD/MD9BvGUi4AZHlDjw2dIHL/nJ9SOuri6BxFnOsTdD3HYf8HKHA8gLjS1Ya2QHlQeUfTfu3U5m3Udp0npyqOMP2o/oqyFuOZuBmwJFrCxEA0CDL2ty/ixH9CKeWQRyAtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025488; c=relaxed/simple;
	bh=DNGfhm0XaVVUKEFebIL+L4Bwd9i/abg9+v3J11622lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BiCng9xjN4wbf49faYW1f6hAyqm9kfdatYjmbp+Rvgr33D1IfLt1NLcKtVzvm8EpLlExzIr/utn0CDGaOqDhUGriwgHYJwIs+W5KGf1TiZ/bz6Ui75CwT7KKvDLhpr8P6eUFkL9AO9s13vyP7WCxnZ8wcuWkDQGNzsXDcbwuuEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrCa38+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrCa38+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA10AC4CEF7;
	Thu,  9 Oct 2025 15:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025488;
	bh=DNGfhm0XaVVUKEFebIL+L4Bwd9i/abg9+v3J11622lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrCa38+nQqdB9UudIreopWPRJtn28ks8mZvLz/7alCcoGMdnvMHC61dqUCl/Qsvnv
	 kBy3iuCIyqo6gOsepFwMt7MfluQP1NmIWDp3/VavYMFnKcGfim1Kkr63ZkeJ1Pv+Qr
	 f/Pe7/oM4JMrzDNI8NIIP63bzDZrdI71L9nQFXw15BfCXouiCPP/SKqixUcJ+KzXqr
	 aWn/B8ouqmES3iPDFEunze71/9FAXEydkW0RQw2VUy3yLl/GZKFD/hH0Ea0NB4b9y4
	 TA4c5ndUhUQG36E1D2T762sQXaUjXEONKTQ97gD8SgesnoiSoWn0jkRZBAR48t3sAe
	 242UNhpDQX8VQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-6.12] soc: sunxi: sram: add entry for a523
Date: Thu,  9 Oct 2025 11:54:37 -0400
Message-ID: <20251009155752.773732-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 30849ab484f7397c9902082c7567ca4cd4eb03d3 ]

The A523 has two Ethernet controllers. So in the system controller
address space, there are two registers for Ethernet clock delays,
one for each controller.

Add a new entry for the A523 system controller that allows access to
the second register.

Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20250908181059.1785605-4-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this should go to stable; without it the second GMAC on A523
cannot program its clock-delay register.

- The A523 DT already instantiates the system-control syscon with an
  A523-specific compatible and wires GMAC0 (with GMAC1 expected next) to
  that syscon (`arch/arm64/boot/dts/allwinner/sun55i-a523.dtsi:423` and
  `arch/arm64/boot/dts/allwinner/sun55i-a523.dtsi:543`). Because the
  current driver falls back to the A64 variant,
  `sunxi_sram_regmap_accessible_reg()` only exposes a single EMAC clock
  register (`drivers/soc/sunxi/sunxi_sram.c:325`), so any attempt to use
  the second EMAC clock register at 0x34 is blocked, which makes the
  second Ethernet controller unusable on this SoC.
- The patch adds a dedicated A523 variant with `.num_emac_clocks = 2`
  and wires it into the OF match table
  (`drivers/soc/sunxi/sunxi_sram.c:313` and
  `drivers/soc/sunxi/sunxi_sram.c:438` after the change). This is the
  minimal change required to expose the second register; no other SoCs
  are affected and no behaviour changes for existing users.
- Risk is very low: the change only enlarges the allowed register window
  for the A523 system controller and mirrors the existing H616 handling.
  Without it, backporting forthcoming GMAC1 enablement (or any
  downstream board DT that already uses it) will continue to fail, so
  carrying this fix in stable keeps A523 Ethernet support from
  regressing.

Next step if you pick it up: merge alongside the GMAC1 enablement so the
second port works end-to-end.

 drivers/soc/sunxi/sunxi_sram.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/soc/sunxi/sunxi_sram.c b/drivers/soc/sunxi/sunxi_sram.c
index 2781a091a6a64..16144a0a0d371 100644
--- a/drivers/soc/sunxi/sunxi_sram.c
+++ b/drivers/soc/sunxi/sunxi_sram.c
@@ -310,6 +310,10 @@ static const struct sunxi_sramc_variant sun50i_h616_sramc_variant = {
 	.has_ths_offset = true,
 };
 
+static const struct sunxi_sramc_variant sun55i_a523_sramc_variant = {
+	.num_emac_clocks = 2,
+};
+
 #define SUNXI_SRAM_THS_OFFSET_REG	0x0
 #define SUNXI_SRAM_EMAC_CLOCK_REG	0x30
 #define SUNXI_SYS_LDO_CTRL_REG		0x150
@@ -430,6 +434,10 @@ static const struct of_device_id sunxi_sram_dt_match[] = {
 		.compatible = "allwinner,sun50i-h616-system-control",
 		.data = &sun50i_h616_sramc_variant,
 	},
+	{
+		.compatible = "allwinner,sun55i-a523-system-control",
+		.data = &sun55i_a523_sramc_variant,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, sunxi_sram_dt_match);
-- 
2.51.0

