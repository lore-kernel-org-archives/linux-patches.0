Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1196151988;
	Wed,  5 Feb 2025 14:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766258; cv=none; b=VGCFCSKUNTVfSJT02ZuCOMsJS+y1iUoB+uDmvb9yK3n8QvK717w5niKnwblbMI4neHi6sChDSc29S2UxnkcLcfpdOCWoSexyA1xxSQrYVbWiVCdhxKBRH/qr9+4BjN0XORsAcF2KNMz+eQd78i/2DHMctNJgcpXcwA0S76q/Xs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766258; c=relaxed/simple;
	bh=lOEpi+h9skJQQ+ua8Wa2VTtLTFOcSOZWtkPOwUN0KdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JHqt+BMKO1pkpVs/FIvMd+oa1HpaRVFFWPwos4wDZWYyulx+DuZK9p1AiH4HQEa27l2mf7EuKpX8qVt9XJAfrP5lSN32B5AKunGotvyPdrx+aM6AT8hu2HdeoDsIz9pqHPKARCpkDsK3cZUKMwgbJwFLlPX5/K3AnDxqcRr40/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gJJ2SrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gJJ2SrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD71C4CED1;
	Wed,  5 Feb 2025 14:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766258;
	bh=lOEpi+h9skJQQ+ua8Wa2VTtLTFOcSOZWtkPOwUN0KdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gJJ2SrRrN6j9Ajk7ywKTzvuAhviALGWdF6QPChkuw3irMzDoynq/3fwW45iaa1rV
	 BYuGJiAfIxjI9/ZSwgvilK5y88Mn2M022mUVfJcD7iYEwPoZn/1wPNr+xOBkevtUKt
	 2A9GR1vcP8f/gkbAkaY/1ye3eU0ojLFX6jJU/RZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 257/623] ASoC: Intel: sof_sdw: correct mach_params->dmic_num
Date: Wed,  5 Feb 2025 14:39:59 +0100
Message-ID: <20250205134506.062652792@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 4ab80a2961c75562ffbac1f80de151a978c31659 ]

mach_params->dmic_num will be used to set the cfg-mics value of
card->components string which should be the dmic channels. However
dmic_num is dmic link number and could be set due to the SOC_SDW_PCH_DMIC
quirk. Set mach_params->dmic_num to the default value if the dmic link
is created due to the SOC_SDW_PCH_DMIC quirk.

Fixes: 7db9f6361170 ("ASoC: Intel: sof_sdw: overwrite mach_params->dmic_num")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20241206075903.195730-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index c9f9c9b0de9b6..46f1c2d368dee 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -22,6 +22,8 @@ static int quirk_override = -1;
 module_param_named(quirk, quirk_override, int, 0444);
 MODULE_PARM_DESC(quirk, "Board-specific quirk override");
 
+#define DMIC_DEFAULT_CHANNELS 2
+
 static void log_quirks(struct device *dev)
 {
 	if (SOC_SDW_JACK_JDSRC(sof_sdw_quirk))
@@ -1127,17 +1129,19 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 		hdmi_num = SOF_PRE_TGL_HDMI_COUNT;
 
 	/* enable dmic01 & dmic16k */
-	if (sof_sdw_quirk & SOC_SDW_PCH_DMIC || mach_params->dmic_num) {
-		if (ctx->ignore_internal_dmic)
-			dev_warn(dev, "Ignoring PCH DMIC\n");
-		else
-			dmic_num = 2;
+	if (ctx->ignore_internal_dmic) {
+		dev_warn(dev, "Ignoring internal DMIC\n");
+		mach_params->dmic_num = 0;
+	} else if (mach_params->dmic_num) {
+		dmic_num = 2;
+	} else if (sof_sdw_quirk & SOC_SDW_PCH_DMIC) {
+		dmic_num = 2;
+		/*
+		 * mach_params->dmic_num will be used to set the cfg-mics value of
+		 * card->components string. Set it to the default value.
+		 */
+		mach_params->dmic_num = DMIC_DEFAULT_CHANNELS;
 	}
-	/*
-	 * mach_params->dmic_num will be used to set the cfg-mics value of card->components
-	 * string. Overwrite it to the actual number of PCH DMICs used in the device.
-	 */
-	mach_params->dmic_num = dmic_num;
 
 	if (sof_sdw_quirk & SOF_SSP_BT_OFFLOAD_PRESENT)
 		bt_num = 1;
-- 
2.39.5



