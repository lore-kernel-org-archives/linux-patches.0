Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C683515D2;
	Fri,  4 Sep 2026 05:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498359; cv=none; b=cJr7+a9RuZm8D2IMu33Y4/E5ye4DpvW8bSCgf1XwCsVZTlHS5fmJe4V90+E1eFcU3T7ozG69BLMm/QqCRnep7XL3rj+5sYs7AfA8b9Ddn5MVIUZWSDIqsXC4TGu1HvDRT0C04ej7nQOcZSXSeuwRAjEfJQIZlW+6yNIjnAafbYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498359; c=relaxed/simple;
	bh=wV4wCUTvGOO4LzO7vXyypqviS/jKkg/+8Lp+s6f8ISc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMAL3nzfPAHgm9jPWJj33FqUTE5VzcMgkqnEfTbzaaM/ITC70DiqHs9Aarl4MsDnU0NwjSEDL/lg4t8ZD3nzO8nOSSSQVupr9Yh+VDlCq2rEA0ivwAyYfTkXty1L6gDJJzsNfQ6BFY+C0bVR7JaEvtzpocO367p10XRys5C2FR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+28Lp3s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+28Lp3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5301B1F00A3D;
	Fri,  4 Sep 2026 05:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498357;
	bh=8+B4RsSdOOTzSAlwshMX6LjQVmZ51jRJVnM1cie49X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+28Lp3s+zebYVvnp8PvDcis/VYy0yrXcjv7wpkun3n6MU0t7hmhIn9m5+VO+yI0A
	 Obc7beQxXIruK4hzduasi3lonxxZy5cYknbqCur56RwE3tWIjavYog3xZwMWFUnaBe
	 8ux2GdQz/80k9a5krcPzGRu4CEKMMqyoPeinsoRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 004/713] ASoC: tegra210_mixer: sort the register default table
Date: Fri,  4 Sep 2026 06:49:32 +0200
Message-ID: <20260904045803.916602099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit f70bc276fc7f712ff5c8e995d5050558a3198df2 ]

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

TEGRA210_MIXER_ENABLE (0x400) is the last entry of the table, after
TEGRA210_MIXER_PEAKM_RAM_CTRL (0x434), which makes it unreachable.
regcache_reg_needs_sync() then cannot compare it against its default and
reports that a sync is needed, so it is written to the device on every
regcache_sync() even when it was never touched.

Sort the table by register address.

Fixes: 05bb3d5ec64a ("ASoC: tegra: Add Tegra210 based Mixer driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805122748.13090-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/tegra/tegra210_mixer.c b/sound/soc/tegra/tegra210_mixer.c
index a69774578d69f..8eb4e54b954b1 100644
--- a/sound/soc/tegra/tegra210_mixer.c
+++ b/sound/soc/tegra/tegra210_mixer.c
@@ -57,10 +57,10 @@ static const struct reg_default tegra210_mixer_reg_defaults[] = {
 	MIXER_TX_REG_DEFAULTS(3),
 	MIXER_TX_REG_DEFAULTS(4),
 
+	{ TEGRA210_MIXER_ENABLE, 0x1 },
 	{ TEGRA210_MIXER_CG, 0x00000001},
 	{ TEGRA210_MIXER_GAIN_CFG_RAM_CTRL, 0x00004000},
 	{ TEGRA210_MIXER_PEAKM_RAM_CTRL, 0x00004000},
-	{ TEGRA210_MIXER_ENABLE, 0x1 },
 };
 
 /* Default gain parameters */
-- 
2.53.0



