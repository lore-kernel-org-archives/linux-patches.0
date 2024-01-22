Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05BC3D64;
	Tue, 23 Jan 2024 00:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969497; cv=none; b=CRWkrWrTeEqt91qCzEzQ7vUDh94ueU1ffxMJYrnEgE+j8ZfSUbbcozxaLWQ+ICsWXKaVWMdormm+1MbbWfu5hdwkmfe3Fxk6Ls6ftVLgnECDvNNGNWkoGVxIaHWRGj4OjbOz2kJb2WrCFDPgkYgIL06a6B0dr7Wu9KMhM3NWYRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969497; c=relaxed/simple;
	bh=hIf5+zNarTvwXTTVECsx0BXKuwW8TNxYqVHDIbPNW2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQMycccTtaBlacK6mVxw1n96aKnrDUgxJSjkhLamZTqbf/w4Pdin5MOdmQNN/JFcRTCYzHxo/FUs5M4+L0VbCZILFYwnCVvJgUbWX2Y6O6FEFZLpDjiZoFoT3UnNxotJkefhgHRKCX+QVE3uvKRjQjmUNaK70m3WUQ8hjZZKw5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRbIQFJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRbIQFJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36936C43390;
	Tue, 23 Jan 2024 00:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969497;
	bh=hIf5+zNarTvwXTTVECsx0BXKuwW8TNxYqVHDIbPNW2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRbIQFJoDZaSUuQ2hlpX/Z978OzJ0BQhjXWT7ep/X18whbtHm141HFlYaJp+CAzW0
	 WWYNbf3YoAvDf9q06UUllRixuIG/L3dlPuceHXeyspVFXazrE/YWnnKCgyO+Tb479H
	 UT4rovUv+iYwsMTnBbBSt604cjVRn6o04THuBfzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Curtis Malainey <cujomalainey@chromium.org>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Brent Lu <brent.lu@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 284/641] ASoC: Intel: glk_rt5682_max98357a: fix board id mismatch
Date: Mon, 22 Jan 2024 15:53:08 -0800
Message-ID: <20240122235826.781605535@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brent Lu <brent.lu@intel.com>

[ Upstream commit 486ede0df82dd74472c6f5651e38ff48f7f766c1 ]

The drv_name in enumeration table for ALC5682I-VS codec does not match
the board id string in machine driver. Modify the entry of "10EC5682"
to enumerate "RTL5682" as well and remove invalid entry.

Fixes: 88b4d77d6035 ("ASoC: Intel: glk_rt5682_max98357a: support ALC5682I-VS codec")
Reported-by: Curtis Malainey <cujomalainey@chromium.org>
Reviewed-by: Curtis Malainey <cujomalainey@chromium.org>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Brent Lu <brent.lu@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20231204214200.203100-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-glk-match.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-glk-match.c b/sound/soc/intel/common/soc-acpi-intel-glk-match.c
index 387e73100884..8911c90bbaf6 100644
--- a/sound/soc/intel/common/soc-acpi-intel-glk-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-glk-match.c
@@ -19,6 +19,11 @@ static const struct snd_soc_acpi_codecs glk_codecs = {
 	.codecs = {"MX98357A"}
 };
 
+static const struct snd_soc_acpi_codecs glk_rt5682_rt5682s_hp = {
+	.num_codecs = 2,
+	.codecs = {"10EC5682", "RTL5682"},
+};
+
 struct snd_soc_acpi_mach snd_soc_acpi_intel_glk_machines[] = {
 	{
 		.id = "INT343A",
@@ -35,20 +40,13 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_glk_machines[] = {
 		.sof_tplg_filename = "sof-glk-da7219.tplg",
 	},
 	{
-		.id = "10EC5682",
+		.comp_ids = &glk_rt5682_rt5682s_hp,
 		.drv_name = "glk_rt5682_mx98357a",
 		.fw_filename = "intel/dsp_fw_glk.bin",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &glk_codecs,
 		.sof_tplg_filename = "sof-glk-rt5682.tplg",
 	},
-	{
-		.id = "RTL5682",
-		.drv_name = "glk_rt5682_max98357a",
-		.machine_quirk = snd_soc_acpi_codec_list,
-		.quirk_data = &glk_codecs,
-		.sof_tplg_filename = "sof-glk-rt5682.tplg",
-	},
 	{
 		.id = "10134242",
 		.drv_name = "glk_cs4242_mx98357a",
-- 
2.43.0



