Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2BE38BF8B
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 14:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768487700; cv=none; b=uJ6+6CsRYZgh1gXYI2xlQhF05ikV+/jP9rJayS5nJjgQJdXRE6ikgcb404LpJd159Lhg2vUedhtORNjT0SUx8xZuul1z/7jxVSCuhDGoRF87zAcJ4PwsmqAEyWwXU8vgNPUnvTEHTv8HVZIxOPk14m1s4z8qD7QHqtaXVglQHv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768487700; c=relaxed/simple;
	bh=pCpr72s0piDZZaQtfAtugNkjepV1eY9OrHp1zWNx8VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loy794NLJFYgncNh0KWUaXzUqAXC8iinjQYCOSU8pYOEFDdF3gTePInaDBHfv4nX4fRFRgho9O7mSlzrYr2mmzQO1T9h7Cb5p+hR10CbamTYToNt7339YHfWIVwOi2BjlfvLVIqhGR7GCLUhD2PqZpfUY1t/c7Z8H4XDEjJn8wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PXZ2ynC5; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PXZ2ynC5"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42fbc305552so824018f8f.0
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 06:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768487695; x=1769092495; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=39uSH1zSkowDoJAVIUrasi1FVBStSL6sFcC0lrMPa1Y=;
        b=PXZ2ynC5GXKiJ6v9+ktTtsqQb9xRHWFNIC7yL8P69ReP/dEATfNc+O3v0PipHbK6vU
         3SgjJQ1dRMcYl+ukUNvZ6ugoxHHS11gQejtDET3CcZoDktgMBmDQFKgOATrBeF5pMAPF
         OsWF8MY88kKHDUhS57q0VmUQOsJb4d/VErVBpr6ufVFqf5gPeVNZXk4O431INNZpmdPL
         80IMOwJbIVkLnTmba+2jvprVwJvP0LyO8+TpxInrtfrBPZcyBc4WYET6ZmZJE2zDJxMJ
         XReZLST15yjSQ6EIJSwdvFMOpa7+2EDSAZtnKXnAaxSjs3yNBPJd169Atxq5Dx4Y0NKt
         fi4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768487695; x=1769092495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=39uSH1zSkowDoJAVIUrasi1FVBStSL6sFcC0lrMPa1Y=;
        b=FWGfWv2yFYhRenFpZNwTwrQrVavIAqcIC7PitvPRRS+kusVnIhvgf7j37MnWGwobaJ
         lmgLhpOama2417fTbMHqSBkVER3jYjO/s0zfPhC9eyQzXkUKkv3qY2361eAsHB34huHt
         EW6v+dOt+VnUNBBhzaCC2F/R3MY6XDJ5VgFYpfY+yVdUxTJq4WpEKoNLlvZN+ve/x0hj
         HU6FyrQo9N+b4ZFxvgNOhMd9Kfov6Yj6iMToBYfVTofhpYfS9RZbo8N2/E1zAfj+wMlj
         +fzj7hEItMMt1rwt5SOVyVfszHOVAOhqIQriesixHx6oKOkFgPwc7LQ3GDM7h7+dwPdm
         7G9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVHsPvyDvA86rsGAM98bGSWJ/SxZB6nAtIKAdF6WUebWdlR4qM7zPKOeTn4grishkTUWa+GJRZw@lists.linux.dev
X-Gm-Message-State: AOJu0YyJzVWktgIxzJ464NTg0CS7gA8RIKEG9JPbdDiw7Ba12awDwqMk
	QN2I0aCalgfxWo/poPGLLAAotJ9bJS09zxH0wNB/5hqSOAbQksmO/HYI
X-Gm-Gg: AY/fxX4AoTlhUW9JaLUQD08RS50c2zpB3bj88lOZhR6x34dar3YiMEAyrVlulJQHZdk
	kk+YIVo/hUK6QZM/cIXBydRDyn8IeQ11Tyz98VGAofXJx+k4TVgdNFit1h4f3fbGUxbxBZtFlgl
	tTti2nk+Un6qaC+OwA/0cZ9vZW8lbmueDW9fpnQA/22BFIh3dQU4Tn894QDqlak7R11eNh/ahUx
	U2HoBZHN6/5xsSynSXWxf5gaujOWO7d/CBohVSjFS2Uyfu0Au3g+1v3hR/rYnh9CqNW4fZ74bsM
	sxmwvYs1lU085X2ASBGWWulI+gw0Dop4rSgHJXsfnWPKcYfcfZFYv/i3o/+kjUNaMDzwGPzRPAR
	AxwR+8MhE8WHQ4vV2gy8LGQxcYPUO8K92kt3y5EdUZTqad1cYqXeTcJMXRaS8YWgukRyKYO37wY
	LOmaslEFuJwj64QX4wNQ==
X-Received: by 2002:a5d:64c5:0:b0:431:808:2d3d with SMTP id ffacd0b85a97d-4342c54873dmr8198009f8f.32.1768487694847;
        Thu, 15 Jan 2026 06:34:54 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-434af64a666sm6209442f8f.6.2026.01.15.06.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 06:34:54 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: bradynorander@gmail.com,
	cezary.rojewski@intel.com,
	kai.vehmanen@linux.intel.com,
	patches@lists.linux.dev,
	peter.ujfalusi@linux.intel.com,
	ranjani.sridharan@linux.intel.com,
	rf@opensource.cirrus.com,
	sashal@kernel.org,
	stable@vger.kernel.org,
	tiwai@suse.de
Subject: [PATCH 6.12.y] ALSA: hda: intel-dsp-config: Prefer legacy driver as fallback
Date: Thu, 15 Jan 2026 17:34:51 +0300
Message-ID: <20260115143451.628160-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2026011237-stage-cognitive-53c0@gregkh>
References: <2026011237-stage-cognitive-53c0@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 161a0c617ab172bbcda7ce61803addeb2124dbff ]

When config table entries don't match with the device to be probed,
currently we fall back to SND_INTEL_DSP_DRIVER_ANY, which means to
allow any drivers to bind with it.

This was set so with the assumption (or hope) that all controller
drivers should cover the devices generally, but in practice, this
caused a problem as reported recently.  Namely, when a specific
kconfig for SOF isn't set for the modern Intel chips like Alderlake,
a wrong driver (AVS) got probed and failed.  This is because we have
entries like:

 #if IS_ENABLED(CONFIG_SND_SOC_SOF_ALDERLAKE)
 /* Alder Lake / Raptor Lake */
        {
                .flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
                .device = PCI_DEVICE_ID_INTEL_HDA_ADL_S,
        },
 ....
 #endif

so this entry is effective only when CONFIG_SND_SOC_SOF_ALDERLAKE is
set.  If not set, there is no matching entry, hence it returns
SND_INTEL_DSP_DRIVER_ANY as fallback.  OTOH, if the kconfig is set, it
explicitly falls back to SND_INTEL_DSP_DRIVER_LEGACY when no DMIC or
SoundWire is found -- that was the working scenario.  That being said,
the current setup may be broken for modern Intel chips that are
supposed to work with either SOF or legacy driver when the
corresponding kconfig were missing.

For addressing the problem above, this patch changes the fallback
driver to the legacy driver, i.e. return SND_INTEL_DSP_DRIVER_LEGACY
type as much as possible.  When CONFIG_SND_HDA_INTEL is also disabled,
the fallback is set to SND_INTEL_DSP_DRIVER_ANY type, just to be sure.

Reported-by: Askar Safin <safinaskar@gmail.com>
Closes: https://lore.kernel.org/all/20251014034156.4480-1-safinaskar@gmail.com/
Tested-by: Askar Safin <safinaskar@gmail.com>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251210131553.184404-1-tiwai@suse.de
Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 sound/hda/intel-dsp-config.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 34825b2f3b10..3246705ddb19 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -676,7 +676,8 @@ int snd_intel_dsp_driver_probe(struct pci_dev *pci)
 	/* find the configuration for the specific device */
 	cfg = snd_intel_dsp_find_config(pci, config_table, ARRAY_SIZE(config_table));
 	if (!cfg)
-		return SND_INTEL_DSP_DRIVER_ANY;
+		return IS_ENABLED(CONFIG_SND_HDA_INTEL) ?
+			SND_INTEL_DSP_DRIVER_LEGACY : SND_INTEL_DSP_DRIVER_ANY;
 
 	if (cfg->flags & FLAG_SOF) {
 		if (cfg->flags & FLAG_SOF_ONLY_IF_SOUNDWIRE &&

base-commit: 39cb076c7dc7e44e3cab5c82ffda16a550ed8436
-- 
2.47.3

