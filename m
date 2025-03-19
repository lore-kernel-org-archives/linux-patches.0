Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A302C1B2194;
	Wed, 19 Mar 2025 14:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394906; cv=none; b=KC/8+A7GhKgFpPZB4mY31EyOyRMCpEIcIdKd3kl+AgyQaoet+3nnFNYNGhwZ1xIeND80Ka3rRL2sijdT8hxlsjixMQz840lBYY8+xOcH6tNUv9be4g7iDR6P7dldLkc6VksdQ44vp8QI+ADEpMaPCGmW7CjlC8OzT6ZdYQxFRUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394906; c=relaxed/simple;
	bh=gPfkyqpGGkqTv/rBovPI0E7QTf9kTbvfLO/Plp34ZoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGIitrggWAhLmeXfHisP0oRUFygDY20NlfTRNgcueia6WLJVTlIqyrA0JMWeVX2jP+GKvemNKvRXERhzpFf6YOEcaJuKoHaaf2YonKAApsY+ZLMDyN0yIfY8o2x0vVPo7Y1AikW6jeqgXiVd7gt8eS5WJc83cQgII4H4MOA43YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mgCqmMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mgCqmMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C1FC4CEE4;
	Wed, 19 Mar 2025 14:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394906;
	bh=gPfkyqpGGkqTv/rBovPI0E7QTf9kTbvfLO/Plp34ZoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mgCqmMNLm8FqYQcmZ5HB0YRb6JPYnt8q4/h9qJUxc7sKxhxXwfkjLb/zLxqXPzTV
	 LgFsagfpabFyKpETrMJbbbeV2YRHT+COHzK61LHDGY2nEa3I+S9hHeXsftOXu6uDLF
	 gsPN1geG/c6+NuJsNMOx5wQnG0Hkxm10Uk9/atKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 118/241] ALSA: hda: intel-dsp-config: Add PTL-H support
Date: Wed, 19 Mar 2025 07:29:48 -0700
Message-ID: <20250319143030.640368235@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 214e6be2d91d5d58f28d3a37630480077a1aafbd ]

Use same recipes as PTL for PTL-H.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250210081730.22916-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index f564ec7af1940..ce3ae2cba6607 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -539,6 +539,11 @@ static const struct config_entry config_table[] = {
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = PCI_DEVICE_ID_INTEL_HDA_PTL,
 	},
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = PCI_DEVICE_ID_INTEL_HDA_PTL_H,
+	},
+
 #endif
 
 };
-- 
2.39.5



