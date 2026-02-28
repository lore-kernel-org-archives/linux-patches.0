Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FC5340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301035; cv=none; b=qHoUkkLh9j9o39yYUQ3TAXoq4hj+drsBsDEA/C0mVtfMJp2hU1FqrxmO1+jfSPoQ/xX7NCIYcOseEIVQRByYzq//H9Sk0ShmADu247MKi3cqGBcJKy7rOKTDdrELUHkzcnMN8t03BaHYaFGUV+RR9rgzTqZkJOAePtfVXZuHfSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301035; c=relaxed/simple;
	bh=pT8x8zLiJMqCIFt8/Tq8tXTiE8oYOB5XkIngBKSYPcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQGCtCz9K6Lf3PsXXzJb2TwIQa4KlfVG+ThJI52ZbV85OayscOY9+JF1CzrofxsvBeUi8RLcNu6lUmVxWaTM9G92/IKPHqnFqaCMHYgA5rb92LuRFNMzSm8nOEa9/eqnuH6WtzGN1gRJyS/BhBx/jkIZ9KgTwpxjzjrRzdVP5Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTE1FVx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTE1FVx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE94C19423;
	Sat, 28 Feb 2026 17:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301035;
	bh=pT8x8zLiJMqCIFt8/Tq8tXTiE8oYOB5XkIngBKSYPcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTE1FVx4W7pt9EVTYpRMkkM46i32Tl+R5BCPaW0Q4AxAY7u/NiNdWFXziroEbNgyR
	 7wfub7Ez0Bux/y0Gx/aKIrWi8iBrFuS/exdsSWBhkYkJnXJYoK3NH9JYE1XSSi9Ld8
	 TqzqslS/o/dD9xYFEWeo7MWzgw2Ngt/iDDjkgURTz93sa5bcF/p3gjUbH1DzOwM09l
	 Uy1EAoph5jCjub8BXUUzc+6RMm1Yi496N3j9fPS/bCEmXyjjkrZ25LC9MMaDGtfwo7
	 oLFladaZOprqrinw+3/XiNe3y5jakZGNOI4wTR9poomiEol4ihhkar40ffBM7zXTrD
	 m+JMZ2RnPrPMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 173/752] ASoC: soc-acpi-intel-arl-match: change rt722 amp endpoint to aggregated
Date: Sat, 28 Feb 2026 12:38:04 -0500
Message-ID: <20260228174750.1542406-173-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 08c09899960118ffb01417242e659eb6cc067d6a ]

rt722 is aggregated with rt1320 amp in arl_rt722_l0_rt1320_l2 and it is
the only audio configuration in the ARL platform. Set .aggregated = 1 to
represent the fact and avoid unexpected issue.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20260119091749.1752088-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/common/soc-acpi-intel-arl-match.c   | 23 +++++++++----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-arl-match.c b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
index 6bf7a6250ddc3..c952f7d2b2c0e 100644
--- a/sound/soc/intel/common/soc-acpi-intel-arl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
@@ -45,23 +45,22 @@ static const struct snd_soc_acpi_endpoint spk_3_endpoint = {
 	.group_id = 1,
 };
 
-/*
- * RT722 is a multi-function codec, three endpoints are created for
- * its headset, amp and dmic functions.
- */
-static const struct snd_soc_acpi_endpoint rt722_endpoints[] = {
+static const struct snd_soc_acpi_endpoint jack_amp_g1_dmic_endpoints[] = {
+	/* Jack Endpoint */
 	{
 		.num = 0,
 		.aggregated = 0,
 		.group_position = 0,
 		.group_id = 0,
 	},
+	/* Amp Endpoint, work as spk_l_endpoint */
 	{
 		.num = 1,
-		.aggregated = 0,
+		.aggregated = 1,
 		.group_position = 0,
-		.group_id = 0,
+		.group_id = 1,
 	},
+	/* DMIC Endpoint */
 	{
 		.num = 2,
 		.aggregated = 0,
@@ -229,11 +228,11 @@ static const struct snd_soc_acpi_adr_device rt711_sdca_0_adr[] = {
 	}
 };
 
-static const struct snd_soc_acpi_adr_device rt722_0_single_adr[] = {
+static const struct snd_soc_acpi_adr_device rt722_0_agg_adr[] = {
 	{
 		.adr = 0x000030025D072201ull,
-		.num_endpoints = ARRAY_SIZE(rt722_endpoints),
-		.endpoints = rt722_endpoints,
+		.num_endpoints = ARRAY_SIZE(jack_amp_g1_dmic_endpoints),
+		.endpoints = jack_amp_g1_dmic_endpoints,
 		.name_prefix = "rt722"
 	}
 };
@@ -394,8 +393,8 @@ static const struct snd_soc_acpi_link_adr arl_rt711_l0_rt1316_l3[] = {
 static const struct snd_soc_acpi_link_adr arl_rt722_l0_rt1320_l2[] = {
 	{
 		.mask = BIT(0),
-		.num_adr = ARRAY_SIZE(rt722_0_single_adr),
-		.adr_d = rt722_0_single_adr,
+		.num_adr = ARRAY_SIZE(rt722_0_agg_adr),
+		.adr_d = rt722_0_agg_adr,
 	},
 	{
 		.mask = BIT(2),
-- 
2.51.0

