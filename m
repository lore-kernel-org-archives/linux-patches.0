Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0944A33B975;
	Mon, 20 Apr 2026 16:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701016; cv=none; b=XPPER+8sGsDGosmN29vFlD5pv2m9yuPUkosOSxwIcLDMrasN7VMBkf43h0mgh84kO9IRvMT/RWl31CTQJCooJNLYeFgE77MQCu7ueNPB5JMd0C64m+vOc2BL6wX4citS+/F4n0rxv61GHfoo7ka7fxgcQ62QLo6Wpr2Vj+Co6s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701016; c=relaxed/simple;
	bh=AG9zNViAmOpDyv004dEJ5VGG6Mmuf8JgUZgClR50YK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLBNnAQBN4j5mdiGTyTrgHtTKs08c/KTNH7YSH0nRr6R75/ZYY7vUkiJrVaO/MDQL/QOwz6enuHsGT/ki8CQKchqCpfP6NJ16ROch7nwmaXVmvTaH89KvgJUFt6b98xMZRhD6m1u+11myjM+KRQRUL+6h2dBmBsGAY9LDEtyVVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXbtFAVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXbtFAVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96177C19425;
	Mon, 20 Apr 2026 16:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701015;
	bh=AG9zNViAmOpDyv004dEJ5VGG6Mmuf8JgUZgClR50YK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXbtFAVj7naziYJrMnRgIRmzfdASglsvIHjkQxT9oCztl0zdkKReTqz4hxsa9ky7R
	 SXCt3iSVLyRuSdu8FQha+IBgjwI4qccSFMLZ183La2qoj7w8s4C7/guM6MtP446YG0
	 u9g8MzFOdzmV2u0kdSJPecj0u89ngeRYp3OdDzsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Syed Saba Kareem <Syed.SabaKareem@amd.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/198] ASoC: amd: acp: update DMI quirk and add ACP DMIC for Lenovo platforms
Date: Mon, 20 Apr 2026 17:41:24 +0200
Message-ID: <20260420153939.382607353@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Syed Saba Kareem <Syed.SabaKareem@amd.com>

[ Upstream commit 6b6f7263d626886a96fce6352f94dfab7a24c339 ]

Replace DMI_EXACT_MATCH with DMI_MATCH for Lenovo SKU entries (21YW,
21YX) so the quirk applies to all variants of these models, not just
exact SKU matches.

Add ASOC_SDW_ACP_DMIC flag alongside ASOC_SDW_CODEC_SPKR in driver_data
for these Lenovo platform entries, as these platforms use ACP PDM DMIC
instead of SoundWire DMIC for digital microphone support.

Fixes: 3acf517e1ae0 ("ASoC: amd: amd_sdw: add machine driver quirk for Lenovo models")
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Syed Saba Kareem <Syed.SabaKareem@amd.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260408133029.1368317-1-syed.sabakareem@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 504b700200660..2b2910b1856d5 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -99,17 +99,17 @@ static const struct dmi_system_id soc_sdw_quirk_table[] = {
 		.callback = soc_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "21YW"),
+			DMI_MATCH(DMI_PRODUCT_SKU, "21YW"),
 		},
-		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+		.driver_data = (void *)((ASOC_SDW_CODEC_SPKR) | (ASOC_SDW_ACP_DMIC)),
 	},
 	{
 		.callback = soc_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "21YX"),
+			DMI_MATCH(DMI_PRODUCT_SKU, "21YX"),
 		},
-		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+		.driver_data = (void *)((ASOC_SDW_CODEC_SPKR) | (ASOC_SDW_ACP_DMIC)),
 	},
 	{
 		.callback = soc_sdw_quirk_cb,
-- 
2.53.0



