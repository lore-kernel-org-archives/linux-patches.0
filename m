Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485F63876B3;
	Fri,  4 Sep 2026 05:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498370; cv=none; b=rQvonyn6DqeevG7pNVA9pN88UdW9/APY0BT+XhY5S7dOF8IXY6LTolLiD/vi2qAEMtm7zSD6+PHQTVy5MRqrkG0AgGglRT0yxRbdBPBLQjOW3HWYfWhqEQeMQ9M58DG6n2vwT60/XgW55+mvIDXKpK61xQce4ehvtnzm1PfS3i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498370; c=relaxed/simple;
	bh=y4qH2gaNYyTZ/KCo+K2bVPgGPoq5bLQT1/GQ2t4ISV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APhGHHVXkekPOxTTCm5STtrTiY8ZZnp/6Pfi9nqJLsYBDDjU2rf793UrgH5pfbPsF8wDlfHbCUxOIaCAV3GDlndtLZoPHE9ipvLnBLb6pIorZHb8gXwT5aWyEsoJeAc7RwkIlsvtHDyGS9OFqN/9XvTyq+NllmtVvZO/hwgX5n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfXATBsv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfXATBsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36021F00A3D;
	Fri,  4 Sep 2026 05:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498369;
	bh=32wur7dPj8JROs/k5eXq7kLqx/Da6yu9ve3FAtaMHik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bfXATBsvqUxJyFDYamxongmZPUEVJwUZmh44Ks65dCWy2LL6V9B3OTMw4dZOPJGuF
	 sRkwA3sppD2c7CPeo2biQ4AbP0ka/LUEFgmpBYQlM1MAtvBjylpEA+I2LA4/MOtIjj
	 Oup3g67U5c93u/RtXwD/u2hsy1zomXoAOJ4V9XNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 008/713] ASoC: tegra: Sort MBDRC register defaults
Date: Fri,  4 Sep 2026 06:49:36 +0200
Message-ID: <20260904045804.002466683@linuxfoundation.org>
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

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit abb5bed6f48d54d3b82724a430fd462579ecd876 ]

Commit 4b05ccb17f92 ("regcache: Sort the local copy of an unsorted
reg_defaults array") exposed an issue with the Tegra MBDRC driver and
now the following warning is observed:

 tegra210-ope 2908000.processing-engine: Driver needs fixing: Unsorted
  reg_defaults, sorting the copy

This warning occurs because register defaults in the structure
tegra210_mbdrc_reg_defaults are not specified in ascending order which
is required by regmap. Fix this by sorting the register defaults
according to their address. Note that in order to do this it is
necessary to replace the macro MBDRC_FILTER_REG_DEFAULTS with a per
register macro MBDRC_FILTER_PARAM_REG_DEFAULTS.

Fixes: 7358a803c778 ("ASoC: tegra: Add Tegra210 based OPE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260821153734.158426-5-jonathanh@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_mbdrc.c | 42 ++++++++++++++++----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/sound/soc/tegra/tegra210_mbdrc.c b/sound/soc/tegra/tegra210_mbdrc.c
index f5d4a93dd6f16..1d78b4c1cc885 100644
--- a/sound/soc/tegra/tegra210_mbdrc.c
+++ b/sound/soc/tegra/tegra210_mbdrc.c
@@ -20,33 +20,33 @@
 #define MBDRC_FILTER_REG(reg, id)					    \
 	((reg) + ((id) * TEGRA210_MBDRC_FILTER_PARAM_STRIDE))
 
-#define MBDRC_FILTER_REG_DEFAULTS(id)					    \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_IIR_CFG, id), 0x00000005},	    \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_IN_ATTACK, id), 0x3e48590c},	    \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_IN_RELEASE, id), 0x08414e9f},	    \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_FAST_ATTACK, id), 0x7fffffff},    \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_IN_THRESHOLD, id), 0x06145082},   \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_OUT_THRESHOLD, id), 0x060d379b},  \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_RATIO_1ST, id), 0x0000a000},	    \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_RATIO_2ND, id), 0x00002000},	    \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_RATIO_3RD, id), 0x00000b33},	    \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_RATIO_4TH, id), 0x00000800},	    \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_RATIO_5TH, id), 0x0000019a},	    \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_MAKEUP_GAIN, id), 0x00000002},    \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_INIT_GAIN, id), 0x00066666},	    \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_GAIN_ATTACK, id), 0x00d9ba0e},    \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_GAIN_RELEASE, id), 0x3e48590c},   \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_FAST_RELEASE, id), 0x7ffff26a},   \
-	{ MBDRC_FILTER_REG(TEGRA210_MBDRC_CFG_RAM_CTRL, id), 0x4000}
+#define MBDRC_FILTER_PARAM_REG_DEFAULTS(reg, val)			    \
+	{ MBDRC_FILTER_REG(reg, 0), val},				    \
+	{ MBDRC_FILTER_REG(reg, 1), val},				    \
+	{ MBDRC_FILTER_REG(reg, 2), val}
 
 static const struct reg_default tegra210_mbdrc_reg_defaults[] = {
 	{ TEGRA210_MBDRC_CFG, 0x0030de51},
 	{ TEGRA210_MBDRC_CHANNEL_MASK, 0x00000003},
 	{ TEGRA210_MBDRC_FAST_FACTOR, 0x30000800},
 
-	MBDRC_FILTER_REG_DEFAULTS(0),
-	MBDRC_FILTER_REG_DEFAULTS(1),
-	MBDRC_FILTER_REG_DEFAULTS(2),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_IIR_CFG, 0x00000005),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_IN_ATTACK, 0x3e48590c),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_IN_RELEASE, 0x08414e9f),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_FAST_ATTACK, 0x7fffffff),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_IN_THRESHOLD, 0x06145082),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_OUT_THRESHOLD, 0x060d379b),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_RATIO_1ST, 0x0000a000),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_RATIO_2ND, 0x00002000),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_RATIO_3RD, 0x00000b33),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_RATIO_4TH, 0x00000800),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_RATIO_5TH, 0x0000019a),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_MAKEUP_GAIN, 0x00000002),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_INIT_GAIN, 0x00066666),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_GAIN_ATTACK, 0x00d9ba0e),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_GAIN_RELEASE, 0x3e48590c),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_FAST_RELEASE, 0x7ffff26a),
+	MBDRC_FILTER_PARAM_REG_DEFAULTS(TEGRA210_MBDRC_CFG_RAM_CTRL, 0x4000),
 };
 
 /* Default MBDRC parameters */
-- 
2.53.0



