Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE24A1779BD;
	Fri, 27 Sep 2024 12:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439939; cv=none; b=em1jXYDum1IxxsNfQrVOVNpQz1sgWsNyobYFmyGrbMbRvrQiDZGGUdQYSbHuZe5wQzC7HU5swuMfewOoWGZ1pdCrgXcbssiLW8liJ/NGaZu4p+KRP8d2VqCMFoC5abTu2EXMuxJG8JkqU0a9Loinkfbhhi4LRBr4AVx+Sq1oVBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439939; c=relaxed/simple;
	bh=sgTNo7H25mH36HuzCf1vTkqeR2RGjWFC5BTH6Q5+hOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gOXD7/SpMnD8jNAdH+KptcgCe7vU5ULzwkrG9aIyfi3vpPRemzugYJP1zLkdZs/gUKnRujcvVvJcpQOFPcZLNuWWrVWEfJdyuz5CaNESv40Rq6nRPbURcyTh2q8buKd5BTRgBPh2QV7YoyMUwoaAwMySY72y4VEkEWYLICsK1jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFZ0wDYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFZ0wDYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B996C4CEC4;
	Fri, 27 Sep 2024 12:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439938;
	bh=sgTNo7H25mH36HuzCf1vTkqeR2RGjWFC5BTH6Q5+hOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFZ0wDYPz8FQ5aOSe+kpSKnHvY/qVIVod0D51Owv+egA9JKYm2Qd9pDqI+oCXkFjt
	 48BPOY8W+3dYm/ctNhNJ92EtYphQ24HNwCuMkLtFN+VQtAo4SkmUQdHZ0+22fRZKCN
	 OQl2aHuQa0YjNeywO8UJlpN0gJWHZVz/Ec3EGn/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 29/54] ALSA: hda: add HDMI codec ID for Intel PTL
Date: Fri, 27 Sep 2024 14:23:21 +0200
Message-ID: <20240927121720.902913504@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit e9481d9b83f8d9b3251aa428b02d8eba89d839ff ]

Add HDMI codec ID for Intel Panther Lake platform.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20240830072458.110831-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 82c0d3a3327ab..f030700cd60d7 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4646,6 +4646,7 @@ HDA_CODEC_ENTRY(0x8086281c, "Alderlake-P HDMI", patch_i915_adlp_hdmi),
 HDA_CODEC_ENTRY(0x8086281d, "Meteor Lake HDMI",	patch_i915_adlp_hdmi),
 HDA_CODEC_ENTRY(0x8086281f, "Raptor Lake P HDMI",	patch_i915_adlp_hdmi),
 HDA_CODEC_ENTRY(0x80862820, "Lunar Lake HDMI",	patch_i915_adlp_hdmi),
+HDA_CODEC_ENTRY(0x80862822, "Panther Lake HDMI",	patch_i915_adlp_hdmi),
 HDA_CODEC_ENTRY(0x80862880, "CedarTrail HDMI",	patch_generic_hdmi),
 HDA_CODEC_ENTRY(0x80862882, "Valleyview2 HDMI",	patch_i915_byt_hdmi),
 HDA_CODEC_ENTRY(0x80862883, "Braswell HDMI",	patch_i915_byt_hdmi),
-- 
2.43.0



