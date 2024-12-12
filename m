Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6404F2054F8;
	Thu, 12 Dec 2024 15:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016808; cv=none; b=dmHenvcLXgAAlx3DQ/8qO1vyrLz05P5dzDzozxCbXiQP8svN7CONYLty/rXGKqdi2SDbMt9Hon0bZDpdZoWz/1TIMc+d0sJBGpJUh+KsF60IoIlbQuvWK2h8kAL4ml9RWvq43HT46jWlG7Mo08xqkSnMAJ3QW7AbooT9tcxUFb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016808; c=relaxed/simple;
	bh=0Oej/UG6ok/KxEzZYxPzIlB4ZSr9ZIRppY5Xv0wLnmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQij6yuitg5urlkxZxDpZxJUk00sVS13TKdg2mwdwujh5wHO2VmhYSn8/CPgC5m2Vyt4SNfCQW4NEe/hAdJjqZO0JYpRbx8/p+5Rqln5pkg4/xyIcFsicSt02ASpvfNFbEpJ/Rdk/0x9eAKfBQ8kYDMIUxLv9ZkUybIVjrDT8PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnmlQOe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnmlQOe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8974FC4CECE;
	Thu, 12 Dec 2024 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016806;
	bh=0Oej/UG6ok/KxEzZYxPzIlB4ZSr9ZIRppY5Xv0wLnmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnmlQOe6nnfPGwfc+3T7+qlahxYjYKoXVWI/P15B50bm3AK0+Gik8Ajyxkt+QB8f7
	 2WEbryE86ofHxKPPUmcg4HHIEDZWuoryIkRLLwXW1CTOH4PFdHlCRpuzoOxrenixHC
	 okK/vpkZ3l0PnsYwEy+/f1qxt4/W+1wIjWBhh87k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 302/466] ASoC: Intel: sof_sdw: Add quirks for some new Lenovo laptops
Date: Thu, 12 Dec 2024 15:57:51 +0100
Message-ID: <20241212144318.710477959@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 83c062ae81e89f73e3ab85953111a8b3daaaf98e ]

Add some more sidecar amplifier quirks.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241016030344.13535-5-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index fa937cc4d8cd1..a58842a8c8a64 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -580,6 +580,30 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(SOC_SDW_CODEC_SPKR),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "3838")
+		},
+		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS),
+	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "3832")
+		},
+		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS),
+	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "380E")
+		},
+		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS),
+	},
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
@@ -589,6 +613,14 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		/* Note this quirk excludes the CODEC mic */
 		.driver_data = (void *)(SOC_SDW_CODEC_MIC),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "233B")
+		},
+		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS),
+	},
 
 	/* ArrowLake devices */
 	{
-- 
2.43.0



