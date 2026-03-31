Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99B041324B;
	Tue, 31 Mar 2026 16:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974809; cv=none; b=BfIjvK36kbplCmN807Q/dHnjAwWANtgVA7l36N8w3RiBd4oib1WsbSmiKKNNdh39r+YT7itpeE6Gj315LOyPAjXimqWs/rZLKgpPiZoA3HodAPSQ2K1bDusp/jJ07kCtpts5SV+g7BalWqiSuCpGaGwvr4DLYcB0mo3TT3yt+8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974809; c=relaxed/simple;
	bh=ZbmzaMU0Bs/kkuf4br/+IXftPZOGc46lKBwlOy1si2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfB0AMNWbbHEBuqy0PUSfQOWcoNBV0/mybv7IKu3qOAs9Z2x9+4JvS75D4ONgVSkwMeSwLqXSPCnh6IgDQlOPjVW34vSUHXaBbt2tssP3RUQcgqFnohk80t9Cj/03xkzZ52e92YAeZW9mV7kcJ7lfedevAcDzoEXFMKyl4yBbDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCe5Z4Ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCe5Z4Ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC73C19423;
	Tue, 31 Mar 2026 16:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974809;
	bh=ZbmzaMU0Bs/kkuf4br/+IXftPZOGc46lKBwlOy1si2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCe5Z4Ue7CDjrlSBW810CxL39NJ7BPbInlHG3vMIYkS5OmXbU5wXwLrNCbI376gTF
	 wFvKeFh9hHBSNRsbzIHt0gNaFf/i3TvTruXpvQq5tZ6BkU/UlLQJLBoEw/bEFRo0ER
	 57E9zJzJL/lgzXR74WQ96+rIjUxa0suuuUSuawqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 051/342] ALSA: hda/hdmi: Add Tegra238 HDA codec device ID
Date: Tue, 31 Mar 2026 18:18:04 +0200
Message-ID: <20260331161800.778246494@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sheetal <sheetal@nvidia.com>

[ Upstream commit 5f4338e5633dc034a81000b2516a78cfb51c601d ]

Add Tegra238 HDA codec device in hda_device_id list.

Signed-off-by: Sheetal <sheetal@nvidia.com>
Link: https://patch.msgid.link/20260302084217.3135982-1-sheetal@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/hdmi/tegrahdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/hdmi/tegrahdmi.c b/sound/hda/codecs/hdmi/tegrahdmi.c
index 5f6fe31aa2028..ebb6410a48313 100644
--- a/sound/hda/codecs/hdmi/tegrahdmi.c
+++ b/sound/hda/codecs/hdmi/tegrahdmi.c
@@ -299,6 +299,7 @@ static const struct hda_device_id snd_hda_id_tegrahdmi[] = {
 	HDA_CODEC_ID_MODEL(0x10de002f, "Tegra194 HDMI/DP2",	MODEL_TEGRA),
 	HDA_CODEC_ID_MODEL(0x10de0030, "Tegra194 HDMI/DP3",	MODEL_TEGRA),
 	HDA_CODEC_ID_MODEL(0x10de0031, "Tegra234 HDMI/DP",	MODEL_TEGRA234),
+	HDA_CODEC_ID_MODEL(0x10de0032, "Tegra238 HDMI/DP",	MODEL_TEGRA234),
 	HDA_CODEC_ID_MODEL(0x10de0033, "SoC 33 HDMI/DP",	MODEL_TEGRA234),
 	HDA_CODEC_ID_MODEL(0x10de0034, "Tegra264 HDMI/DP",	MODEL_TEGRA234),
 	HDA_CODEC_ID_MODEL(0x10de0035, "SoC 35 HDMI/DP",	MODEL_TEGRA234),
-- 
2.51.0



