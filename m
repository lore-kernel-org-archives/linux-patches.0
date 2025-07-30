Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA63E20E6;
	Wed, 30 Jul 2025 09:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868416; cv=none; b=gzFE7iTcFutHEHUKZlf0wCZWt7ex1xhx6J372vL6YLrsnu5vf9yUPeFHkTAd9dkO+htxkXMYtfacu6UFRD0G3UzvT47QhTp9J/xJV9V9RGDxbLeXvgocdzXUGwFpG0b5KqAiKVc6gklLfz7lLpH7ATYTwiC6by/Y9kdakwRrKCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868416; c=relaxed/simple;
	bh=IJvS6/ZuSuvtmMyaz24ssq1lfI4tvYJXjJk+9BNbEOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+Q+v9PykLTU65P9ixt02MwrZpL7EO6eOdSsISRQApnbRi87hhlltfqzwACY7FUCmt8zJTnRZDBGPKatHj6CDcychCXz7MZwvttLskgzle+6enqzSLk5YUnOsOgVEzV0272yi0ip0F1QqDZqIGpXSVlTRhNSRN7p22F2rw5uxpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZb+JarC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZb+JarC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5812BC4CEE7;
	Wed, 30 Jul 2025 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868415;
	bh=IJvS6/ZuSuvtmMyaz24ssq1lfI4tvYJXjJk+9BNbEOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZb+JarCry4n/uJe6aHUhmlPHZT8rRF4kwyryjBOInSRlT7t3ggZh7MG4Qh+JAZ63
	 PHobG8XP+PPnbPUtVrzb730QUlbwcFZG6dnKv1R93kHMwel9s2zftajWvuM6FcAJQw
	 REUPNDi0LnwllQP292IyGDHjmOMbjeONO/paw944=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Dadap <ddadap@nvidia.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 56/76] ALSA: hda: Add missing NVIDIA HDA codec IDs
Date: Wed, 30 Jul 2025 11:35:49 +0200
Message-ID: <20250730093229.020026940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Dadap <ddadap@nvidia.com>

commit e0a911ac86857a73182edde9e50d9b4b949b7f01 upstream.

Add codec IDs for several NVIDIA products with HDA controllers to the
snd_hda_id_hdmi[] patch table.

Signed-off-by: Daniel Dadap <ddadap@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/aF24rqwMKFWoHu12@ddadap-lakeline.nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4559,7 +4559,9 @@ HDA_CODEC_ENTRY(0x10de002e, "Tegra186 HD
 HDA_CODEC_ENTRY(0x10de002f, "Tegra194 HDMI/DP2", patch_tegra_hdmi),
 HDA_CODEC_ENTRY(0x10de0030, "Tegra194 HDMI/DP3", patch_tegra_hdmi),
 HDA_CODEC_ENTRY(0x10de0031, "Tegra234 HDMI/DP", patch_tegra234_hdmi),
+HDA_CODEC_ENTRY(0x10de0033, "SoC 33 HDMI/DP",	patch_tegra234_hdmi),
 HDA_CODEC_ENTRY(0x10de0034, "Tegra264 HDMI/DP",	patch_tegra234_hdmi),
+HDA_CODEC_ENTRY(0x10de0035, "SoC 35 HDMI/DP",	patch_tegra234_hdmi),
 HDA_CODEC_ENTRY(0x10de0040, "GPU 40 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de0041, "GPU 41 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de0042, "GPU 42 HDMI/DP",	patch_nvhdmi),
@@ -4598,15 +4600,32 @@ HDA_CODEC_ENTRY(0x10de0097, "GPU 97 HDMI
 HDA_CODEC_ENTRY(0x10de0098, "GPU 98 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de0099, "GPU 99 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de009a, "GPU 9a HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de009b, "GPU 9b HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de009c, "GPU 9c HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de009d, "GPU 9d HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de009e, "GPU 9e HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de009f, "GPU 9f HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a0, "GPU a0 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00a1, "GPU a1 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a3, "GPU a3 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a4, "GPU a4 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a5, "GPU a5 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a6, "GPU a6 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a7, "GPU a7 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00a8, "GPU a8 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00a9, "GPU a9 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00aa, "GPU aa HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00ab, "GPU ab HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00ad, "GPU ad HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00ae, "GPU ae HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00af, "GPU af HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00b0, "GPU b0 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00b1, "GPU b1 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00c0, "GPU c0 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00c1, "GPU c1 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00c3, "GPU c3 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00c4, "GPU c4 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00c5, "GPU c5 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de8001, "MCP73 HDMI",	patch_nvhdmi_2ch),
 HDA_CODEC_ENTRY(0x10de8067, "MCP67/68 HDMI",	patch_nvhdmi_2ch),
 HDA_CODEC_ENTRY(0x67663d82, "Arise 82 HDMI/DP",	patch_gf_hdmi),


