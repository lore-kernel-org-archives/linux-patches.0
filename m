Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F703A3E60;
	Wed, 20 May 2026 16:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295428; cv=none; b=ikPD8nNNyXkZYuOCHxXnhaaRANPFMfgHEGRnuxRmA4oHrTfhIn1Azrh5Ij8hcTdgxUX7sc9K6E/tj91oqiupE6jFFTUKxGK5W1vmehkf+bldJa3J7sFz98+JlG4K+rgIC1TQpLDTHeN47pofHIe5viDtJT5MGeB4wTwrrWEHwIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295428; c=relaxed/simple;
	bh=LsxqDPxdhjN+eoMTKOyJtkB39/CLFE8p8ASpwtxbi3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofqGKx4t04IK17RQHvZiIIQmhr2WeerSH1qbOalXE+GXNaGo6QkCC86Zodwz8annt3wE6OIBl591iJAK5mIfC0MlCao3BuJC29Qqzvmqk7pSVUNQwqNf5v9031aY/ID1OO0qSj9DPmr3qWobx9cpx58k9GPy8HFcZxYC30jRXe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgFLeT54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgFLeT54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9150E1F000E9;
	Wed, 20 May 2026 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295427;
	bh=j6YU1Jq1LRj/KD80piUVwiKXT9W3vgKA7VutpCJGSW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgFLeT54jHwkS79nQeqhKMO4E6jaraH08y4GD7aI+b7TPj51uzAjZC/wk3swhltR4
	 F9Oqy66X2NcuzWGxQKeyzGVb3t+iiiVJbgGxzQwHLhum2XzL9ky8KMhTDUnuJ6xn9H
	 SM41SA2Z0/d6E/DKGdKLwspSzWFap04mOuFDT7ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	songxiebing <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0414/1146] ALSA: usb-audio: qcom: Fix incorrect type in enable_audio_stream
Date: Wed, 20 May 2026 18:11:04 +0200
Message-ID: <20260520162157.567467626@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: songxiebing <songxiebing@kylinos.cn>

[ Upstream commit 292286b2d229fb732421429b027d38ac3f969383 ]

Fix sparse warning:
sound/usb/qcom/qc_audio_offload.c:943:27: sparse: incorrect type in argument 2
expected unsigned int val but got snd_pcm_format_t.

Explicitly cast pcm_format to unsigned int for snd_mask_leave().

Fixes: 326bbc348298 ("ALSA: usb-audio: qcom: Introduce QC USB SND offloading support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604062109.Oxi8JjWW-lkp@intel.com/
Signed-off-by: songxiebing <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260408083311.774173-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/qcom/qc_audio_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/qcom/qc_audio_offload.c b/sound/usb/qcom/qc_audio_offload.c
index 2ac813d57f4f5..5f993b88448c7 100644
--- a/sound/usb/qcom/qc_audio_offload.c
+++ b/sound/usb/qcom/qc_audio_offload.c
@@ -948,7 +948,7 @@ static int enable_audio_stream(struct snd_usb_substream *subs,
 	_snd_pcm_hw_params_any(&params);
 
 	m = hw_param_mask(&params, SNDRV_PCM_HW_PARAM_FORMAT);
-	snd_mask_leave(m, pcm_format);
+	snd_mask_leave(m, (__force unsigned int)pcm_format);
 
 	i = hw_param_interval(&params, SNDRV_PCM_HW_PARAM_CHANNELS);
 	snd_interval_setinteger(i);
-- 
2.53.0



