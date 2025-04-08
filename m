Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A05D2690FA;
	Tue,  8 Apr 2025 11:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110068; cv=none; b=Hmr1ybQypKJQ7OBP3lxPmuQhtdBGSVdzJ2E2ELLJSTRFj17Rx77OAA7F8z/XiGfuXx1RAbu4dyViqi2ztU+HZ5FhRwI9r3cLZTxrqnqdfDGQLUI2e1KsoXsjQen0+TCN9N1hQ7k3wBej93oYGbaTGJWRx1px3uqbz6vOHftj2ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110068; c=relaxed/simple;
	bh=dlfVboFDPzpWtf7J7jeUJ2SEK8NEeZ6rG71C7S7sPi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhQ6ht59sJXoFyK6U8mzKN/5vs+/jEw1fitUZvXzki+/U95HtPKUSRJeIgz0MLDH2C7N+f9e6mvoTBWSPpisnAa2aBkW3e/gAEJSrV+MnypScQpdq52y2kSRckCAueTibxUSe98+KWeAnymv39zX6u/jZMndqeAtEd5+d6POJt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aw36KHDc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aw36KHDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD164C4CEE5;
	Tue,  8 Apr 2025 11:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110068;
	bh=dlfVboFDPzpWtf7J7jeUJ2SEK8NEeZ6rG71C7S7sPi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aw36KHDcrzOrUpNnePVurfl22ZJdsbijvRcuR971hTlYsNNccIQRHWaOlmhZi8VJE
	 jkIzffW+GnklGGweAhxhnV3MNv3+/6QRySOiTpR3aHz2gbUGE0tZP8DPqwsAYE0iIT
	 brJTELFGJltZ8Eu/Pm0ouxhom42AUDtWp/RytIUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/227] clk: amlogic: g12a: fix mmc A peripheral clock
Date: Tue,  8 Apr 2025 12:48:53 +0200
Message-ID: <20250408104824.965847381@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 870cac6dd0453..3280b7410a13f 100644
--- a/drivers/clk/meson/g12a.c
+++ b/drivers/clk/meson/g12a.c
@@ -4136,7 +4136,7 @@ static MESON_GATE(g12a_spicc_1,			HHI_GCLK_MPEG0,	14);
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



