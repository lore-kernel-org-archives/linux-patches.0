Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374047E77B;
	Wed, 21 Feb 2024 14:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524352; cv=none; b=haqz80/OGCSW6AEv3PIUZrLLXEfOD4NG+JgNmx8FigcwvYqICJ6rj0QWehv6H65XkPl51Hgxr44zvui+3YOvNqcDQgfyWMwZIEdNH/u/4+clNsN2w+gZj3DAU8sweAGQH7HJc4IUmIXtnb0lNgcMftbNHd743UzyF1Q8Qjusr1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524352; c=relaxed/simple;
	bh=Nws2t9hVcN8KiOUz79h+H8JfO+gzTw7iZ3DaQdABNxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQEs/GHtyUqIAG/mRJ+jeDONOP583MxF5ElnNuH7iBRFUhY+F/0C9ERbVLMf8UOPnlzTTEpTntpSMtj9axhmI1fs2koIDAZYr3TCsdxfSZ/00c4OPkhaSAqJe+zamqNASkHVgyrCizMTKi9hp0b6RvXUy1D4O9tiHTEg2fXVsAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnvGKkvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnvGKkvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BF3C433F1;
	Wed, 21 Feb 2024 14:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524352;
	bh=Nws2t9hVcN8KiOUz79h+H8JfO+gzTw7iZ3DaQdABNxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnvGKkvFqj/jzopcfANcmRG3l7d4Zxfhr20YYbMqw4r1M4KHDKtG7pYWnF3U6en7l
	 ShVxJTCrRrRBlHf71NshqsjFcCHqpaJPR+K7OD7UWab4pK+F/rv0oY41UBMXiiHJeE
	 vx+4bFmT/REyGEKABgxo72zNDlOceua8cnnkvqA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/379] ALSA: hda: intel-dspcfg: add filters for ARL-S and ARL
Date: Wed, 21 Feb 2024 14:06:08 +0100
Message-ID: <20240221130000.499995364@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 7a9d6bbe8a663c817080be55d9fecf19a4a8fd8f ]

Same usual filters, SOF is required for DMIC and/or SoundWire support.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20231204212710.185976-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 48c78388c1d2..ea0a2b1d23a3 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -372,6 +372,16 @@ static const struct config_entry config_table[] = {
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = 0x7e28,
 	},
+	/* ArrowLake-S */
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = PCI_DEVICE_ID_INTEL_HDA_ARL_S,
+	},
+	/* ArrowLake */
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = PCI_DEVICE_ID_INTEL_HDA_ARL,
+	},
 #endif
 
 /* Lunar Lake */
-- 
2.43.0



