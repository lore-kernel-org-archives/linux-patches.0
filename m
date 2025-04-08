Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35148268FDE;
	Tue,  8 Apr 2025 12:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114033; cv=none; b=tFeK0YnM/jgLsOqNeFQOyobBIWdhzMNRFCtArThmYfHlJ/JJ6SmJYM/nAP2QIh/rnoY8QHWhesqaaXJcdEy9/wxGslwr3HRdVNkGZLV72jY+z7OHz2PCZV8pYu9GYPAnDOdU5g3XKqE4WdswHWsRCufk5pN09qtCFohz4e2LA9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114033; c=relaxed/simple;
	bh=EWU9vSTexpJTBYI0Uyw8w5FlOYYq8mykP0SuyCk0FU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfXEsGb0Q9D7K+F9yVAitblSKc/AiUDbteviDzHaqZcC7zRdO9PbD6921Lwrd5E+G/Gzf1LUpo3+r4P7P4SeftpsR6FsMD7PaSXVrcvT8IgnIRYsphEHeaQIeSRfQ/uhzd/6R61GUEUlksvJ0Cnb75cUk3Z3Zk59m5oHBgmYAgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jD7FgTVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jD7FgTVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F8DC4CEE5;
	Tue,  8 Apr 2025 12:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114033;
	bh=EWU9vSTexpJTBYI0Uyw8w5FlOYYq8mykP0SuyCk0FU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jD7FgTVos7NNfVw5DYycAH/37G8dd8VYVq8R5xALTaLAurO7xh7I9lFVIHR1J6VJ7
	 pXpVui+wDbFmkELKhL1Hu/qJP0rWh1DW/S2kKkQnrowJ36QYqSuEAnu1DHbJC4aqnF
	 YPY8kgg+RYsrPWqKCFUIN2GdfX02CuLaWoVmvhCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/154] clk: amlogic: g12a: fix mmc A peripheral clock
Date: Tue,  8 Apr 2025 12:50:50 +0200
Message-ID: <20250408104818.833990690@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9bf1744657e6b..4400e73d4c930 100644
--- a/drivers/clk/meson/g12a.c
+++ b/drivers/clk/meson/g12a.c
@@ -3910,7 +3910,7 @@ static MESON_GATE(g12a_spicc_1,			HHI_GCLK_MPEG0,	14);
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



