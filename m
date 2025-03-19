Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0403421576C;
	Wed, 19 Mar 2025 14:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395077; cv=none; b=e0136270/PX/o3F23wyH935yPvNjuItivwFTuIVl5i06gO21NL1m0p0AHMjJzK1aG3nLwNv2gSyBbuZG1aQVe8nCGbfxzbKZ2AedhNjRuRmzGROiIqkJzunj7VQuctIgNNp5vzs5Mcqyd5o4nGHqtTD4MgaL3BkjBeNLRCxFmrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395077; c=relaxed/simple;
	bh=L8zRLnMhj0Tdusquce4UyjqU65OQCVatozPq6pomLWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXwm9nWw54+aZcHQymnn8Dn3Cs3bFwaapbDYwzs9deMn5JTdTBnH8oqB573nrJZ4vKJ3bLloCbW4SYq2OdrWu/7aVg2ea3wn0Mo0+6OeHyssNMpgifDWULidOin1CT9hRZtu7CCZpFSY5qV2mPd3eIB1U3S7CeZVMrCufWIlhqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=noe6FZT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="noe6FZT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9C6C4CEE4;
	Wed, 19 Mar 2025 14:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395076;
	bh=L8zRLnMhj0Tdusquce4UyjqU65OQCVatozPq6pomLWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=noe6FZT4hNlOSsTA+MMBP2l7GnlEffkRgn4KzgmgadHRTLAL7hO3vufl0vGj8uEOq
	 McTbSmBsujenj7NBT2pZ8lswfAsHPloFQConiIHKCQldxHZZ0YLV67b/0xiB7Q+hh8
	 dVXWy8mh09CLNC03MR6g7zkWLqrdV6ArogKEHxnA=
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
Subject: [PATCH 6.12 116/231] ALSA: hda: hda-intel: add Panther Lake-H support
Date: Wed, 19 Mar 2025 07:30:09 -0700
Message-ID: <20250319143029.711183598@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit d7e2447a4d51de5c3c03e3b7892898e98ddd9769 ]

Add Intel PTL-H audio Device ID.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250210081730.22916-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index ea52bc7370a58..cb9925948175f 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2508,6 +2508,8 @@ static const struct pci_device_id azx_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, HDA_ARL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE) },
 	/* Panther Lake */
 	{ PCI_DEVICE_DATA(INTEL, HDA_PTL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_LNL) },
+	/* Panther Lake-H */
+	{ PCI_DEVICE_DATA(INTEL, HDA_PTL_H, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_LNL) },
 	/* Apollolake (Broxton-P) */
 	{ PCI_DEVICE_DATA(INTEL, HDA_APL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_BROXTON) },
 	/* Gemini-Lake */
-- 
2.39.5



