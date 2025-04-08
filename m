Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68DC1B87CF;
	Tue,  8 Apr 2025 12:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116454; cv=none; b=tkzrl9i7IdlXRcqpuhTFD6GZ9x7qHAhxxuaB6y6Va4FO3Vhzd8ivfmf0pkx13/czxNkQn7W/DQxijzv8TmX3BpeUhth5VURsWIEv1lDKVw4Td5E9qlXgdTF7DNmoXJJdyZv4BrpyjrPEw+x+5lRbq1vVbRPmKLJi7K/UVEWjsX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116454; c=relaxed/simple;
	bh=M+CVrh/ccRR6ADaqHX7uWvl2eS32t3QmLiJVWxsv5yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtUqWfX7JLj90uiQ01jiThKkz787f9YOx0+iggSdMl/ayvOX2g6Bi8pfs6xPCsDK53C0PBbAniY92MwZyOMiQl4pNF+4DOm2LNIQhuIAz/L+E6B/a4+9frX2LT6OoHXpUVZVkfIGdJMQZtkNyFiJshz1nqHsq4CxZOwhRa0hFIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URVORyoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URVORyoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2D3C4CEEE;
	Tue,  8 Apr 2025 12:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116453;
	bh=M+CVrh/ccRR6ADaqHX7uWvl2eS32t3QmLiJVWxsv5yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URVORyoA5GDsfbjkCvaGfMhK9pbxmo51xco6ZqfyayJPo2RlmRma7v51whNUetkuR
	 YlaKErktungnDd4mZ34ahzzSBnCcOW7e+7may9WmoAsshxoMrqGeBR5ig/zoohZcLS
	 PMkHaDhmGp+T0L1p76cCNifowTf73BYqyEpaJfaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/423] clk: amlogic: g12a: fix mmc A peripheral clock
Date: Tue,  8 Apr 2025 12:47:53 +0200
Message-ID: <20250408104849.153738762@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 0079e77c08de692cb20b38e408365c830a44b1ef ]

The bit index of the peripheral clock for mmc A is wrong
This was probably not a problem for mmc A as the peripheral is likely left
enabled by the bootloader.

No issues has been reported so far but it could be a problem, most likely
some form of conflict between the ethernet and mmc A clock, breaking
ethernet on init.

Use the value provided by the documentation for mmc A before this
becomes an actual problem.

Fixes: 085a4ea93d54 ("clk: meson: g12a: add peripheral clock controller")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241213-amlogic-clk-g12a-mmca-fix-v1-1-5af421f58b64@baylibre.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/g12a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/meson/g12a.c b/drivers/clk/meson/g12a.c
index 06929e1940ef1..4f92b83965d5a 100644
--- a/drivers/clk/meson/g12a.c
+++ b/drivers/clk/meson/g12a.c
@@ -4329,7 +4329,7 @@ static MESON_GATE(g12a_spicc_1,			HHI_GCLK_MPEG0,	14);
 static MESON_GATE(g12a_hiu_reg,			HHI_GCLK_MPEG0,	19);
 static MESON_GATE(g12a_mipi_dsi_phy,		HHI_GCLK_MPEG0,	20);
 static MESON_GATE(g12a_assist_misc,		HHI_GCLK_MPEG0,	23);
-static MESON_GATE(g12a_emmc_a,			HHI_GCLK_MPEG0,	4);
+static MESON_GATE(g12a_emmc_a,			HHI_GCLK_MPEG0,	24);
 static MESON_GATE(g12a_emmc_b,			HHI_GCLK_MPEG0,	25);
 static MESON_GATE(g12a_emmc_c,			HHI_GCLK_MPEG0,	26);
 static MESON_GATE(g12a_audio_codec,		HHI_GCLK_MPEG0,	28);
-- 
2.39.5



