Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2F4151988;
	Wed,  5 Feb 2025 14:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766069; cv=none; b=LJNe08jgDVnxxnl+Lo3VElY0djczPZhGyrB1NQzS5l3Dl4j8FeTPMBY2ulE/xqtcDU/SnboiSeELUiKD/83Lr/99HJyrqEDxNvEQrRSLW5USwFHppekPPAx75LSrH2O1cL8ShWiwFMsXNdbowFuHyf5ZJo8Jtb1hrAnRmjcpjfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766069; c=relaxed/simple;
	bh=We8lhZThnmZcTGA/spk+gdOWJdszcNCQKmwv5r14D2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmmKF4QBBHb46GA3fcEPAlyudSI7Lf8x/ggEYulD9aMbx3bGjaESru6ty5nEtfdqzj55IQeaDanLwJAK7FPmXxm368X4ITKV6WSijJIleKcFruo9xIheVwEQsbRis9TclKW3R3hqHZidw8bWZznm6NjCZYEJCrcI4nnr/VcEHY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVOApIow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVOApIow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244B5C4CED1;
	Wed,  5 Feb 2025 14:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766069;
	bh=We8lhZThnmZcTGA/spk+gdOWJdszcNCQKmwv5r14D2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVOApIowMF+nG8SEO/58LzbbgLArQdeytBnVZHXBnIkG1WBJqBUEaOqrXPrk+vvIO
	 2JSA+Nr9L28Naw/0MyN6IlDbZ+iz7aiTgGgWw3SzHtw6HR9ZE0wpiBoA2KMZRS5wTB
	 C3isuYR48oUiBWGrSSX0Rr8rHFxSzjBHT58Dxz0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 284/590] ASoC: Intel: sof_sdw: Fix DMI match for Lenovo 83JX, 83MC and 83NM
Date: Wed,  5 Feb 2025 14:40:39 +0100
Message-ID: <20250205134506.143971595@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 17615e4216115a0454e0f2007267a006231dcb7d ]

Update the DMI match for a Lenovo laptop to a new DMI identifier.

This laptop ships with a different DMI identifier to what was expected
and now has three match entries. It also has the DMICs connected to the
host rather than the cs42l43 codec.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Fixes: 83c062ae81e8 ("ASoC: Intel: sof_sdw: Add quirks for some new Lenovo laptops")
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250102123335.256698-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 9350a1ea146b0..9f2dc24d44cb5 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -586,9 +586,9 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "3838")
+			DMI_MATCH(DMI_PRODUCT_NAME, "83JX")
 		},
-		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS),
+		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS | SOC_SDW_CODEC_MIC),
 	},
 	{
 		.callback = sof_sdw_quirk_cb,
@@ -598,6 +598,21 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS | SOC_SDW_CODEC_MIC),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83MC")
+		},
+		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS | SOC_SDW_CODEC_MIC),
+	},	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83NM")
+		},
+		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS | SOC_SDW_CODEC_MIC),
+	},
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
-- 
2.39.5



