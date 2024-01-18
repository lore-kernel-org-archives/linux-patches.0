Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CB023776;
	Thu, 18 Jan 2024 10:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575563; cv=none; b=eolPr5bU3xARDCGMSrTB4Htsb9oT/96gILxIVFpcsxUd2Wwaz/m3nb0cP3oZRFlpg0ptN4FjOOw+heT86acY14YohZz4F2njMBCYLTW60eyq6EUpnj8sU9aFqOHk85JO6ZH0xuJKeAItxCxSVhfhE2ClZkqtubaW/jJE44rvQE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575563; c=relaxed/simple;
	bh=E8JC7GkiJh+NEa+dX43VfFK3bpI2Fo1jiWoKJs3JjOU=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=GzZq0ZVtB3vcfkd2kYn/0m5V/umKHDiNifoDUmO8lUAvc8i3HTolA3DfMMCpCiJTxVbEhWiJdD0ozz1DC6+YEW3P+hcEEGA6kqcSxCdKOR2YPqjNHUmailOuF30vQY+obzlZI2JeeCHk7oAr31Ncf8JBg3Kz3fn0MoLv4Mw15vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRela6ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRela6ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CCDC433C7;
	Thu, 18 Jan 2024 10:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575563;
	bh=E8JC7GkiJh+NEa+dX43VfFK3bpI2Fo1jiWoKJs3JjOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRela6ad8Z+UaIJ6ocVVehDOIPkVsvmmWbZB6yN5qLAOGqsFd66BORyo/wkmbHjjn
	 DQAlINRvFZ55/Y0n4sj3cgi2oMGSbwplo6AeIYvlmV/UeyctsQQeuSpbXhNsSuOYc9
	 EIHwNOay4BraPAGcJR4dcTmLancQDCuZwT0FKFpo=
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
Subject: [PATCH 6.1 026/100] ASoC: Intel: skl_hda_dsp_generic: Drop HDMI routes when HDMI is not available
Date: Thu, 18 Jan 2024 11:48:34 +0100
Message-ID: <20240118104312.053613682@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 879ebba52832..463ffb85121d 100644
--- a/sound/soc/intel/boards/skl_hda_dsp_generic.c
+++ b/sound/soc/intel/boards/skl_hda_dsp_generic.c
@@ -157,6 +157,8 @@ static int skl_hda_fill_card_info(struct snd_soc_acpi_mach_params *mach_params)
 		card->dapm_widgets = skl_hda_widgets;
 		card->num_dapm_widgets = ARRAY_SIZE(skl_hda_widgets);
 		if (!ctx->idisp_codec) {
+			card->dapm_routes = &skl_hda_map[IDISP_ROUTE_COUNT];
+			num_route -= IDISP_ROUTE_COUNT;
 			for (i = 0; i < IDISP_DAI_COUNT; i++) {
 				skl_hda_be_dai_links[i].codecs = dummy_codec;
 				skl_hda_be_dai_links[i].num_codecs =
-- 
2.43.0



