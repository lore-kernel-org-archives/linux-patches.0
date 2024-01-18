Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8883222323;
	Thu, 18 Jan 2024 10:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575179; cv=none; b=TEmTo6myOEYdGfnzgMPwOaWxwKPFGrgSmmOq2bSbS8Esc5c2I2yhXw53wygplrzoE6n9PjbRzY/BiKANJaFcs9Sy4l25GL9u6ehLuG2vWeVBmajfGQttFn3ueZoONCfCSvxpQgQ3fTtDsdCZeHLPfiBgs/eE2R38x6bXtSDaeww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575179; c=relaxed/simple;
	bh=XM1BoMiYp3yKUts84hsvIUNA6qmxw+kQJrkj6mi9vu4=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=SwrBy+AyM/MF7uncy2sJcpt8OgDdCAnS6rAlnySMRiPyUKmLNyEKHqxA7yDdvUU5QpmUHzLa5Py9m4PVzhccABD92dXvaHRoCkBMUzzslMy/Se0gpWIsS4bkGLMc/eMeiQm6PX1prcSkSWG80nNmB1yBJb7BcIAEZ37ZkdqQuaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7KlZdNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7KlZdNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B83CC433F1;
	Thu, 18 Jan 2024 10:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575179;
	bh=XM1BoMiYp3yKUts84hsvIUNA6qmxw+kQJrkj6mi9vu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7KlZdNXcoTON6927eZcVIjZcyZxuY7Nu6SuQssEI9xNenorRAS9IV0VbX0+pv7sx
	 nlcVr+/dpywUWtuoXh2bcA1dWnbSOApkZ+XGj+Z97NP066V953B6dtRFhCOYQl9kYr
	 ZgHDW2E3juO2ayx0IUG1DwL6Z7u346NsyPXhoxqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/150] ASoC: Intel: skl_hda_dsp_generic: Drop HDMI routes when HDMI is not available
Date: Thu, 18 Jan 2024 11:47:42 +0100
Message-ID: <20240118104321.939823862@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 3d1dc8b1030df8ca0fdfd4905c88ee10db943bf8 ]

When the HDMI is not present due to disabled display support
we will use dummy codec and the HDMI routes will refer to non existent
DAPM widgets.

Trim the route list from the HDMI routes to be able to probe the card even
if the HDMI dais are not registered.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20231124124015.15878-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/skl_hda_dsp_generic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/boards/skl_hda_dsp_generic.c b/sound/soc/intel/boards/skl_hda_dsp_generic.c
index a06e05154ae1..70c806cc5b2e 100644
--- a/sound/soc/intel/boards/skl_hda_dsp_generic.c
+++ b/sound/soc/intel/boards/skl_hda_dsp_generic.c
@@ -154,6 +154,8 @@ static int skl_hda_fill_card_info(struct snd_soc_acpi_mach_params *mach_params)
 		card->dapm_widgets = skl_hda_widgets;
 		card->num_dapm_widgets = ARRAY_SIZE(skl_hda_widgets);
 		if (!ctx->idisp_codec) {
+			card->dapm_routes = &skl_hda_map[IDISP_ROUTE_COUNT];
+			num_route -= IDISP_ROUTE_COUNT;
 			for (i = 0; i < IDISP_DAI_COUNT; i++) {
 				skl_hda_be_dai_links[i].codecs = &asoc_dummy_dlc;
 				skl_hda_be_dai_links[i].num_codecs = 1;
-- 
2.43.0



