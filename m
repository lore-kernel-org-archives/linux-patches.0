Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DCE268C66;
	Tue,  8 Apr 2025 11:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113255; cv=none; b=bA/Cxtcjk/+EbDwRvCMtd66qqbu6FqsFl3Ng7qa67QbtTDOkuqVGfeLP/4Y9imNYNiErzIl97zm+cB8lVr4GfVEnkRMsBCBxEZfgxx2CSoHJfiklOnD1BMF90BngqwqByN3GVmwcQzmC3UD/yOq4MWzFQ+3gV5szTeXRkBhc5r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113255; c=relaxed/simple;
	bh=OXGwtP3YozQehmU9muQd7ONm7XioBPE+KMIAhpRK3BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEJC5OeL1ZagaA3+8/drDaBQe1L8bvAvwHnWOBEko3sDqbUM2bQYzVfjPB9JPWBCFUt+sbc2gOnb1ifNwCs20LCl1VK7vlJyEpcA0PojGmiCphVOHpkdklq67f4SZwg1EosBcow8ZlCTYSOls3atxGMCxZwiU3mSuuLIPVB51po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJR5hiRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJR5hiRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895CDC4CEE7;
	Tue,  8 Apr 2025 11:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113254;
	bh=OXGwtP3YozQehmU9muQd7ONm7XioBPE+KMIAhpRK3BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJR5hiRpkkr/0fPvdgKUYvBcVwzNtr4gdud4zhvBgk3RXmIl2ebTNcbgfZ+ruVO8q
	 2BD0pHnFBFU6la+yWHPDhy4FYNNtkWbPtNut7AWDN1aCZtnt8/pQmaGvuYEdXVJoBl
	 WAn0AV0Ebl5jadZ/XVquHoZpREviIaMAsHTkBv4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/268] clk: amlogic: g12a: fix mmc A peripheral clock
Date: Tue,  8 Apr 2025 12:48:22 +0200
Message-ID: <20250408104830.946085637@linuxfoundation.org>
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
index faaf33a82721d..233ce4a4c1c2f 100644
--- a/drivers/clk/meson/g12a.c
+++ b/drivers/clk/meson/g12a.c
@@ -4201,7 +4201,7 @@ static MESON_GATE(g12a_spicc_1,			HHI_GCLK_MPEG0,	14);
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



