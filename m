Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09292222AC;
	Thu, 13 Feb 2025 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458835; cv=none; b=Qc13tQ+RGchs4TkWtUhq8GOO9asGVVBxeJNy/DDrizFVTKK0ygZkZfvC8sj+I0iMRRs6C8jvyCyQYImEj+pEMioSt5EKG6Ap3XwIgrBnsuty3yT1LO4PXEZUyYC8OW2Py9lLadjXZlYcuppxsfHYZ4RYOhSiSH1REwBpNNhOTRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458835; c=relaxed/simple;
	bh=0HoLF9Ls2xc1juR+7KnbZhCMXAOYBJusIq0q5CHCDz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFqoKGGdiwj2nbBPHFiZz8iBAnP+QmoawMIB//f6XEhsD3tqX6JqYO0vYmYxAHzzU3ynavRrlDYSKkYlt78zdp1uehCmH1rMM0yysZk7cW+t0HltecdeP6j77Cz8FubV1vcNOPjSrOR5nlN8wPDM4+b/P6F1vsLpvIs/tnGOZRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOrQhE9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOrQhE9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58E4C4CED1;
	Thu, 13 Feb 2025 15:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458835;
	bh=0HoLF9Ls2xc1juR+7KnbZhCMXAOYBJusIq0q5CHCDz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOrQhE9lcZtQoHbUaSfi3+jj3WEhL8oHNzN3vu9p/uJYoFV3tcN2FnqMm0Rw20FB5
	 0wKfKEqNBOh+MySxDMCdAy5doo0zNFodU56OE2vt5+7Tme6+lCV0j/2+mggdrtzTC4
	 3ZGJYZh272+KfYG2b2PLu36XLZrUicwPUeyY2liE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 090/443] ASoC: Intel: sof_sdw: Correct quirk for Lenovo Yoga Slim 7
Date: Thu, 13 Feb 2025 15:24:15 +0100
Message-ID: <20250213142444.083796388@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 7662f0e5d55728a009229112ec820e963ed0e21c ]

In addition to changing the DMI match to examine the product name rather
than the SKU, this adds the quirk to inform the machine driver to not
bind in the cs42l43 microphone DAI link.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241206075903.195730-5-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 5554ad4e7c787..65e55c46fb064 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -641,9 +641,10 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "380E")
+			DMI_MATCH(DMI_PRODUCT_NAME, "83HM")
 		},
-		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS),
+		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS |
+					SOC_SDW_CODEC_MIC),
 	},
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.39.5



