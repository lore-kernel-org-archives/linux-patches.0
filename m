Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DE31A3178;
	Thu, 17 Apr 2025 18:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914001; cv=none; b=I0/eJCQbWBikOZVpN5P0re27hLIwoZxPXcOVlS3W2zhmh/A1SczzvfuFbJ2e7IEaTw5/ebXSNB6/EG9ZzrMmPgL8EiMyqn5Wnk3ZE0lGUz/r0+r+SYWiqRXbdfh9/+B0feGbfeE8DBOoZVehfRHxC38C7Fclp5hxxxJmA5PzHm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914001; c=relaxed/simple;
	bh=50xizTTol4AuddPe5rV6hr0Qm6M5CxtLSUeYQ4TomdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAugHJuN5Wyirgckd1Tspl9zr5ZWQ8ILBJIY4dEJ2U5UD7W7FH/6qQVpXRO8gf1TZy9m18K4qQqCJ/+/u2fxPt1c/hLVGyUjLiYQVzoFKtURajJXvu71yhf36k8Ny/iAPh18KAcjdVTcq5ueKXZHUov8LQCgFvqvI8RLFN3KBcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfghARp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfghARp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9320EC4CEE4;
	Thu, 17 Apr 2025 18:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914000;
	bh=50xizTTol4AuddPe5rV6hr0Qm6M5CxtLSUeYQ4TomdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfghARp1dME+imVJjVJtAAwjpdLxT4SL4VxDkcpdwCDfzfbnkpqB9SyfIsRhNR8Yt
	 JzivOsFCN53z8qJS8sQa5g3VdFdcWl2DidpLlSjdQ1wnhFVK09ZT4LZX/8v0lsRCZF
	 7TPAsoQMSJliVecFS7AowHgAWsdjZVhRxpwmCyTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 072/414] ASoC: amd: amd_sdw: Add quirks for Dell SKUs
Date: Thu, 17 Apr 2025 19:47:10 +0200
Message-ID: <20250417175114.336749667@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 4bb5b6f13fd83b32c8a93fbd399e7558415d1ce0 ]

This patch adds a quirk to include the codec amplifier function for Dell
SKU's listed in quirk table.

Note: In these SKU's, the RT722 codec amplifier is excluded, and an
external amplifier is used instead.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20250207062819.1527184-26-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 34 +++++++++++++++++++++++++
 sound/soc/amd/acp/soc_amd_sdw_common.h  |  1 +
 2 files changed, 35 insertions(+)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 9280cd30d19cf..a0defa5d15f73 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -28,6 +28,8 @@ static void log_quirks(struct device *dev)
 			SOC_JACK_JDSRC(soc_sdw_quirk));
 	if (soc_sdw_quirk & ASOC_SDW_ACP_DMIC)
 		dev_dbg(dev, "quirk SOC_SDW_ACP_DMIC enabled\n");
+	if (soc_sdw_quirk & ASOC_SDW_CODEC_SPKR)
+		dev_dbg(dev, "quirk ASOC_SDW_CODEC_SPKR enabled\n");
 }
 
 static int soc_sdw_quirk_cb(const struct dmi_system_id *id)
@@ -45,6 +47,38 @@ static const struct dmi_system_id soc_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)RT711_JD2,
 	},
+	{
+		.callback = soc_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0D80"),
+		},
+		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+	},
+	{
+		.callback = soc_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0D81"),
+		},
+		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+	},
+	{
+		.callback = soc_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0D82"),
+		},
+		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+	},
+	{
+		.callback = soc_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0D83"),
+		},
+		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+	},
 	{}
 };
 
diff --git a/sound/soc/amd/acp/soc_amd_sdw_common.h b/sound/soc/amd/acp/soc_amd_sdw_common.h
index b7bae107c13e4..ed5aec9c01458 100644
--- a/sound/soc/amd/acp/soc_amd_sdw_common.h
+++ b/sound/soc/amd/acp/soc_amd_sdw_common.h
@@ -22,6 +22,7 @@
 #define SOC_JACK_JDSRC(quirk)		((quirk) & GENMASK(3, 0))
 #define ASOC_SDW_FOUR_SPK		BIT(4)
 #define ASOC_SDW_ACP_DMIC		BIT(5)
+#define ASOC_SDW_CODEC_SPKR		BIT(15)
 
 #define AMD_SDW0	0
 #define AMD_SDW1	1
-- 
2.39.5



