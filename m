Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2192AF0E;
	Thu, 12 Dec 2024 15:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016855; cv=none; b=gRIKzjtxtcwdA2sTGtAqSdkxQP4KgS/+iRw65vaX63EkSpR2j4vpGAMGTHRe+10L7x41F1iKIWcgiL0jhvFwlVJI5hjTFQ/TsnWblFyialsuqrqU6O7/6c1+Yz1OcvElRgNrPSJ5WaLL20zHa4hgZqXqr5gZsAxFkPW23bEJsU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016855; c=relaxed/simple;
	bh=iqrJHLxF4y4KRdavClrr6I2EFNaYkqnwWfXqv98eWxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKUH4ELJsxZwe2D1x7lvmNmdYpi+vbZKIrj9V7PzD0UI7PjaFTGLD/EEgI2WkmzYEDkxrdi2uMfIW3foyGjANMYumXCRnRCxWT4L3kAsSWCBuYTmK30YK3jkCKWKmVKDiTPHhm8dGlmn5J9SfzGVESZirLNwi/TTcTW4Jttwv/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xbcsg+ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xbcsg+ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22A7C4CECE;
	Thu, 12 Dec 2024 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016854;
	bh=iqrJHLxF4y4KRdavClrr6I2EFNaYkqnwWfXqv98eWxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xbcsg+gecUGi+d4AcJF3hE1CE7trsaszzTfU1OH0fOiekvBd3qRPxBO7typRxPgnR
	 s1M5PUnt18TSxGsowugi0kuDWEKytupwx1Ea8Bbm2WHC/HAcXPewfAkbqHHQ9kt3K+
	 vZJZ+5HAtKJp3QzTSTCRZ1723yzRC2jg0rd8XvGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mac Chiang <mac.chiang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 315/466] ASoC: Intel: soc-acpi-intel-arl-match: Add rt722 and rt1320 support
Date: Thu, 12 Dec 2024 15:58:04 +0100
Message-ID: <20241212144319.228387880@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mac Chiang <mac.chiang@intel.com>

[ Upstream commit f193fb888d1da45365daa7d0ff7a964c8305d407 ]

This patch adds support for the rt722 multi-function codec and the
rt1320 amplifier in the ARL board configuration.

Link 0: RT722 codec with three endpoints: Headset, Speaker, and DMIC.
Link 2: RT1320 amplifier.

Note:
The Speaker endpoint on the RT722 codec is not used.

Signed-off-by: Mac Chiang <mac.chiang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241028072631.15536-4-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/common/soc-acpi-intel-arl-match.c   | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-arl-match.c b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
index 072b8486d0727..24d850df77ca8 100644
--- a/sound/soc/intel/common/soc-acpi-intel-arl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
@@ -44,6 +44,31 @@ static const struct snd_soc_acpi_endpoint spk_3_endpoint = {
 	.group_id = 1,
 };
 
+/*
+ * RT722 is a multi-function codec, three endpoints are created for
+ * its headset, amp and dmic functions.
+ */
+static const struct snd_soc_acpi_endpoint rt722_endpoints[] = {
+	{
+		.num = 0,
+		.aggregated = 0,
+		.group_position = 0,
+		.group_id = 0,
+	},
+	{
+		.num = 1,
+		.aggregated = 0,
+		.group_position = 0,
+		.group_id = 0,
+	},
+	{
+		.num = 2,
+		.aggregated = 0,
+		.group_position = 0,
+		.group_id = 0,
+	},
+};
+
 static const struct snd_soc_acpi_adr_device cs35l56_2_lr_adr[] = {
 	{
 		.adr = 0x00023001FA355601ull,
@@ -185,6 +210,24 @@ static const struct snd_soc_acpi_adr_device rt711_sdca_0_adr[] = {
 	}
 };
 
+static const struct snd_soc_acpi_adr_device rt722_0_single_adr[] = {
+	{
+		.adr = 0x000030025D072201ull,
+		.num_endpoints = ARRAY_SIZE(rt722_endpoints),
+		.endpoints = rt722_endpoints,
+		.name_prefix = "rt722"
+	}
+};
+
+static const struct snd_soc_acpi_adr_device rt1320_2_single_adr[] = {
+	{
+		.adr = 0x000230025D132001ull,
+		.num_endpoints = 1,
+		.endpoints = &single_endpoint,
+		.name_prefix = "rt1320-1"
+	}
+};
+
 static const struct snd_soc_acpi_link_adr arl_cs42l43_l0[] = {
 	{
 		.mask = BIT(0),
@@ -287,6 +330,20 @@ static const struct snd_soc_acpi_link_adr arl_sdca_rvp[] = {
 	{}
 };
 
+static const struct snd_soc_acpi_link_adr arl_rt722_l0_rt1320_l2[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(rt722_0_single_adr),
+		.adr_d = rt722_0_single_adr,
+	},
+	{
+		.mask = BIT(2),
+		.num_adr = ARRAY_SIZE(rt1320_2_single_adr),
+		.adr_d = rt1320_2_single_adr,
+	},
+	{}
+};
+
 static const struct snd_soc_acpi_codecs arl_essx_83x6 = {
 	.num_codecs = 3,
 	.codecs = { "ESSX8316", "ESSX8326", "ESSX8336"},
@@ -385,6 +442,12 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_arl_sdw_machines[] = {
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-arl-rt711-l0.tplg",
 	},
+	{
+		.link_mask = BIT(0) | BIT(2),
+		.links = arl_rt722_l0_rt1320_l2,
+		.drv_name = "sof_sdw",
+		.sof_tplg_filename = "sof-arl-rt722-l0_rt1320-l2.tplg",
+	},
 	{},
 };
 EXPORT_SYMBOL_GPL(snd_soc_acpi_intel_arl_sdw_machines);
-- 
2.43.0



