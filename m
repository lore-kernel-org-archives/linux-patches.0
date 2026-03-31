Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE37F423A62;
	Tue, 31 Mar 2026 16:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976315; cv=none; b=l+CbcjwjQwi6qSftBTRzaszkQeeqR46gmbkfyZ7tlqF9rlgpy8mNnwk14killbE4GWFETYVujGOAqg0HArI7prqB2qKOaCTcngwSOqXYgSWFNsy6K6R8zy6HKYPi7ew48uZ/JJLOaYTb7oZAJuOs7ywwnJL8vOrcRorvGnd577U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976315; c=relaxed/simple;
	bh=GZwTe5Ejmx/IPthteoitU5d1MsjcSKZtkM2Crq1AEQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=So3+whWBQKWa49SivVTRiGm4UP71sKp/FrcMSW9/WRAMVDGDlPEbIFfOcxjnIeMPtBjV0JSjJJgx+G73p5CK4PZ00D8sY6SatixkgZE/2sIylzUC1AcrBxeG08FR2zuufZFeoaKqulHzcW5mJtLHxyty4Tevjtxpcu240mg5RQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8D5sBSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8D5sBSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6264BC19423;
	Tue, 31 Mar 2026 16:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976315;
	bh=GZwTe5Ejmx/IPthteoitU5d1MsjcSKZtkM2Crq1AEQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8D5sBSf7mJzlxC8ejIVGi/z+PQIcMR0hCnmHD0XkLHJQqd6/sXOZ30+wArNIuPga
	 KCEdaejXAtrjIb/uFdfwz0Xi+/som4X4kobUWvxYU5liJ/e48bOX3yvDGI+yVhPAfT
	 WMgOVbCGnE9PRokIMPG2xhgOTW1vnnyht7+QcZkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/309] ALSA: hda/hdmi: Add Tegra238 HDA codec device ID
Date: Tue, 31 Mar 2026 18:19:08 +0200
Message-ID: <20260331161755.143938872@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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



