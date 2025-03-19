Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FF91B2194;
	Wed, 19 Mar 2025 14:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395075; cv=none; b=WMMr9JJFmbb0njNcVFhyZchXJp0BhlA82ItKXD7f4XRZMDkqQlB5wcCFQ80oa7vIgDT8YU/HlYC3dKvu7Jl11a30QTBin1MQn3gbfmcJv4xZhLrnwgyDVZ+gRye/Ubd+f/gnnF8K2xf0D1vdKz5Uy8ki4INi7Nq6abldUIuQJ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395075; c=relaxed/simple;
	bh=epNXuh4+ihME+kXhGoSJXaaBeEBfc5LsBFApvCW6gc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vgb6twu74kMjwNgfTi2wgavInvnb3qGZcUYsCG1DJ2yJCePseDX2/OY7c8SEgSnTqcwJCQUnsP35LL4fMClKjCJ38Du98dplaOC83o5QjyvWw9aEl1NBjxNYI67l3A8M6UzJRvcX4q+gO3OXmrXzt6TZgcRjcyYr3Lmdv2FGqWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CZqCIta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CZqCIta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE96C4CEE4;
	Wed, 19 Mar 2025 14:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395075;
	bh=epNXuh4+ihME+kXhGoSJXaaBeEBfc5LsBFApvCW6gc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CZqCItawOUwbcwaGgk+9f9JjT5/tMdMfZZFbiBRDkb5uwAVEmqp9qaPDuZU3Ty4p
	 RaArgJ2nXmjglEW8Ptc4kavZMOoXIqD7A1SlDf55/h0kaPrkZJ18/YMoGILbQ8RYRz
	 gLz7XSenjcx01sH6qpzBBXTpOaNIWOODZuTrwUqc=
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
Subject: [PATCH 6.12 114/231] ALSA: hda: intel-dsp-config: Add PTL-H support
Date: Wed, 19 Mar 2025 07:30:07 -0700
Message-ID: <20250319143029.661568158@linuxfoundation.org>
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
index 9f849e05ce79f..34825b2f3b108 100644
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



