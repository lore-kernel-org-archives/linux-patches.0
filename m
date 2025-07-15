Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7163BBF2;
	Tue, 15 Jul 2025 13:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585356; cv=none; b=Zf9cVsO7LCnTyGE9Zk/0BnoCBBgyWqnzBl5ZcQTneL0aRn3GXseADCrs1rZ9P0lnx6Ik5P44gK2buSCJhctlk4Tm8F2ObUz836AGkDxJa7HNQtZkJQxGOF0culfClh1yUE6dhqY9LnDdbFNUWNpWt1gXOE+6TO/wcZGoVV506mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585356; c=relaxed/simple;
	bh=GCCvrUGsWqOU5aTVG7w+JZAaguCDmA6he79I48eHTs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KhTbC/CSYQ8OKT+fj1g5qCkf/nDTFtlVlJ/joHPY/G+CVpMckz0uZ3x1o7AObME+vIFGguH03RJh4Jl/liMp3o1OYTGXZg+rW1hCb+306rZPjtvb2KuFkGYRxWJLePA6Et8hZAvFM4mTE9omUA7Ux9NNMefEoyQUFMz9y0GJtSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tt4En3C5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tt4En3C5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD08C4CEE3;
	Tue, 15 Jul 2025 13:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585356;
	bh=GCCvrUGsWqOU5aTVG7w+JZAaguCDmA6he79I48eHTs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tt4En3C5lNIpR/szmkDRk9xzhCvSaBKeY4nnao5j+mQK845Bf0EUkl1sqqUYUyO+9
	 xLMqn+sn7/A25O5SCBFHXX2Ee1QR3nXNAnZyrKweXrJxUyWEL3L4P65Eva1pkmnjLl
	 BXflOyjRtXpSg8LT4f5waHnywm7gTBgBcc24b3DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/163] ASoC: Intel: soc-acpi: arl: Add match entries for new cs42l43 laptops
Date: Tue, 15 Jul 2025 15:11:18 +0200
Message-ID: <20250715130809.190033395@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit d7f671b2f566379f275c13e25a29fa7001bb278f ]

Add some new match table entries on Arrowlake for some coming cs42l43
laptops.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241206075903.195730-11-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: a7528e9beadb ("ASoC: Intel: soc-acpi: arl: Correct order of cs42l43 matches")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/common/soc-acpi-intel-arl-match.c   | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-arl-match.c b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
index d7dfb23277d09..32147dc9d2d66 100644
--- a/sound/soc/intel/common/soc-acpi-intel-arl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
@@ -147,6 +147,24 @@ static const struct snd_soc_acpi_adr_device cs35l56_3_l3_adr[] = {
 	},
 };
 
+static const struct snd_soc_acpi_adr_device cs35l56_2_r3_adr[] = {
+	{
+		.adr = 0x00023301fa355601ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_r_endpoint,
+		.name_prefix = "AMP2"
+	},
+};
+
+static const struct snd_soc_acpi_adr_device cs35l56_3_l1_adr[] = {
+	{
+		.adr = 0x00033101fa355601ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_l_endpoint,
+		.name_prefix = "AMP1"
+	},
+};
+
 static const struct snd_soc_acpi_endpoint cs42l43_endpoints[] = {
 	{ /* Jack Playback Endpoint */
 		.num = 0,
@@ -312,6 +330,25 @@ static const struct snd_soc_acpi_link_adr arl_cs42l43_l0_cs35l56_2_l23[] = {
 	{}
 };
 
+static const struct snd_soc_acpi_link_adr arl_cs42l43_l0_cs35l56_3_l23[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(cs42l43_0_adr),
+		.adr_d = cs42l43_0_adr,
+	},
+	{
+		.mask = BIT(2),
+		.num_adr = ARRAY_SIZE(cs35l56_2_r3_adr),
+		.adr_d = cs35l56_2_r3_adr,
+	},
+	{
+		.mask = BIT(3),
+		.num_adr = ARRAY_SIZE(cs35l56_3_l1_adr),
+		.adr_d = cs35l56_3_l1_adr,
+	},
+	{}
+};
+
 static const struct snd_soc_acpi_link_adr arl_rvp[] = {
 	{
 		.mask = BIT(0),
@@ -406,6 +443,12 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_arl_sdw_machines[] = {
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-arl-cs42l43-l0-cs35l56-l23.tplg",
 	},
+	{
+		.link_mask = BIT(0) | BIT(2) | BIT(3),
+		.links = arl_cs42l43_l0_cs35l56_3_l23,
+		.drv_name = "sof_sdw",
+		.sof_tplg_filename = "sof-arl-cs42l43-l0-cs35l56-l23.tplg",
+	},
 	{
 		.link_mask = BIT(0) | BIT(2),
 		.links = arl_cs42l43_l0_cs35l56_l2,
-- 
2.39.5



