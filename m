Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E5433EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E82C433EF;
	Mon, 16 Jan 2023 15:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884764;
	bh=omcJz3QRipOw9cl59w/Uutkq8YJduFi18nsEbhohGek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6YcIKFHWikyPZOFUp86AZO7SRtwQHsBaNbMzTb4OMEOiX6P0Em+YHEES9KOofAXN
	 gBB7+BMYnFayuRkJryYSFiFbke3MlO9B2MZMIzud6LTREyQH7SXBGx2JSk32ME7LN/
	 pJ0yTDlA0vw09Vm9vBD4zxEKPwKUp+81sE4HWHfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/183] ASoC: Intel: sof-nau8825: fix module alias overflow
Date: Mon, 16 Jan 2023 16:50:26 +0100
Message-Id: <20230116154807.740997350@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3e78986a840d59dd27e636eae3f52dc11125c835 ]

The maximum name length for a platform_device_id entry is 20 characters
including the trailing NUL byte. The sof_nau8825.c file exceeds that,
which causes an obscure error message:

sound/soc/intel/boards/snd-soc-sof_nau8825.mod.c:35:45: error: illegal character encoding in string literal [-Werror,-Winvalid-source-encoding]
MODULE_ALIAS("platform:adl_max98373_nau8825<U+0018><AA>");
                                                   ^~~~
include/linux/module.h:168:49: note: expanded from macro 'MODULE_ALIAS'
                                                ^~~~~~
include/linux/module.h:165:56: note: expanded from macro 'MODULE_INFO'
                                                       ^~~~
include/linux/moduleparam.h:26:47: note: expanded from macro '__MODULE_INFO'
                = __MODULE_INFO_PREFIX __stringify(tag) "=" info

I could not figure out how to make the module handling robust enough
to handle this better, but as a quick fix, using slightly shorter
names that are still unique avoids the build issue.

Fixes: 8d0872f6239f ("ASoC: Intel: add sof-nau8825 machine driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20221221132515.2363276-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_nau8825.c              | 8 ++++----
 sound/soc/intel/common/soc-acpi-intel-adl-match.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/intel/boards/sof_nau8825.c b/sound/soc/intel/boards/sof_nau8825.c
index 27880224359d..009a41fbefa1 100644
--- a/sound/soc/intel/boards/sof_nau8825.c
+++ b/sound/soc/intel/boards/sof_nau8825.c
@@ -618,7 +618,7 @@ static const struct platform_device_id board_ids[] = {
 
 	},
 	{
-		.name = "adl_rt1019p_nau8825",
+		.name = "adl_rt1019p_8825",
 		.driver_data = (kernel_ulong_t)(SOF_NAU8825_SSP_CODEC(0) |
 					SOF_SPEAKER_AMP_PRESENT |
 					SOF_RT1019P_SPEAKER_AMP_PRESENT |
@@ -626,7 +626,7 @@ static const struct platform_device_id board_ids[] = {
 					SOF_NAU8825_NUM_HDMIDEV(4)),
 	},
 	{
-		.name = "adl_max98373_nau8825",
+		.name = "adl_max98373_8825",
 		.driver_data = (kernel_ulong_t)(SOF_NAU8825_SSP_CODEC(0) |
 					SOF_SPEAKER_AMP_PRESENT |
 					SOF_MAX98373_SPEAKER_AMP_PRESENT |
@@ -637,7 +637,7 @@ static const struct platform_device_id board_ids[] = {
 	},
 	{
 		/* The limitation of length of char array, shorten the name */
-		.name = "adl_mx98360a_nau8825",
+		.name = "adl_mx98360a_8825",
 		.driver_data = (kernel_ulong_t)(SOF_NAU8825_SSP_CODEC(0) |
 					SOF_SPEAKER_AMP_PRESENT |
 					SOF_MAX98360A_SPEAKER_AMP_PRESENT |
@@ -648,7 +648,7 @@ static const struct platform_device_id board_ids[] = {
 
 	},
 	{
-		.name = "adl_rt1015p_nau8825",
+		.name = "adl_rt1015p_8825",
 		.driver_data = (kernel_ulong_t)(SOF_NAU8825_SSP_CODEC(0) |
 					SOF_SPEAKER_AMP_PRESENT |
 					SOF_RT1015P_SPEAKER_AMP_PRESENT |
diff --git a/sound/soc/intel/common/soc-acpi-intel-adl-match.c b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
index ce4d8ec86f2c..68b4fa352354 100644
--- a/sound/soc/intel/common/soc-acpi-intel-adl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
@@ -474,21 +474,21 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_adl_machines[] = {
 	},
 	{
 		.id = "10508825",
-		.drv_name = "adl_rt1019p_nau8825",
+		.drv_name = "adl_rt1019p_8825",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &adl_rt1019p_amp,
 		.sof_tplg_filename = "sof-adl-rt1019-nau8825.tplg",
 	},
 	{
 		.id = "10508825",
-		.drv_name = "adl_max98373_nau8825",
+		.drv_name = "adl_max98373_8825",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &adl_max98373_amp,
 		.sof_tplg_filename = "sof-adl-max98373-nau8825.tplg",
 	},
 	{
 		.id = "10508825",
-		.drv_name = "adl_mx98360a_nau8825",
+		.drv_name = "adl_mx98360a_8825",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &adl_max98360a_amp,
 		.sof_tplg_filename = "sof-adl-max98360a-nau8825.tplg",
@@ -502,7 +502,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_adl_machines[] = {
 	},
 	{
 		.id = "10508825",
-		.drv_name = "adl_rt1015p_nau8825",
+		.drv_name = "adl_rt1015p_8825",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &adl_rt1015p_amp,
 		.sof_tplg_filename = "sof-adl-rt1015-nau8825.tplg",
-- 
2.35.1



