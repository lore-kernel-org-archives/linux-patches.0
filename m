Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5811119E;
	Sat,  3 Feb 2024 04:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933855; cv=none; b=WpH/J3AlQyhcr2ss+W1ahJ4mrrNJpwBaLdOuNe6Pa63q0Y5VIxVCKwSPrkbVg92J68V4sNu+8QoAXiRFPF+BqTMiwEkffxIb0zyXHZ1x4cloJ6G/Rq25XAJOkg1f0IEiAuzAwkgfyi5BvnT8sdizZ1iWGjf8A49Qm0LXUOLFeQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933855; c=relaxed/simple;
	bh=iwkAdeoESeVr/DuLzbqB9zwq5CsljHhxlMamahf4820=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nZMNZ6EpWcJVyL2OVgIw4vSniERPsk9lBYr1ejz8j+L8owJhgJcPD4o6uK0nU1QbefBxjHv8nyYfG0W2ElcXaBSLwC0gQwou3d0RXWQXl9RDRinTug9XXAz+Wcef3zlMONRlal3XZhtI6vnO+iPqopmcnmzhW3Qwik/5vcK/tqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bIciLSCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bIciLSCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9665C43394;
	Sat,  3 Feb 2024 04:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933854;
	bh=iwkAdeoESeVr/DuLzbqB9zwq5CsljHhxlMamahf4820=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIciLSCTdIFBSLRiKHoJ+NJLlQs88b8aFQ15mAb7arT65uUEYbrwNtjTCTfdILRn5
	 zg/8dDfb0VYAQyYPtDYzz60G2+x+tqqRr0+VV6fcCBoa9KQNILrLd35FsZvJ0+hnj9
	 6fJxfGJt1aheWin+dehafLC2Vmy/T93EaFqsadC8=
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
Subject: [PATCH 6.7 186/353] ALSA: hda: intel-dspcfg: add filters for ARL-S and ARL
Date: Fri,  2 Feb 2024 20:05:04 -0800
Message-ID: <20240203035409.531595470@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 756fa0aa69bb..6a384b922e4f 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -521,6 +521,16 @@ static const struct config_entry config_table[] = {
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = PCI_DEVICE_ID_INTEL_HDA_MTL,
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



