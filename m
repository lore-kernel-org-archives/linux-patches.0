Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B001335BA7;
	Mon, 18 Aug 2025 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525120; cv=none; b=nkONAlxd4DuRW9WNIAhDEZ78dyQXj/sRaLjQbGQy1EQG7u5Bg4Sp7SbZuJxNESco5gspqhr3nUrnmyKBf3sNt/KTCM1d443g0+hV71xaXqaCbMqjkOvs4LXHoiHla04Ry1cvUWjvE6WYPjSDi0g3uwB4eDPYJRmFwRYsVmxsG44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525120; c=relaxed/simple;
	bh=gLSkRiMgEqStu03dKxTQ6d17A5IZSAJcW8s9UVuR9Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SggYDkQ40vEM+ANLyaQkaUNZEDlXC1XLZOP8+hDG3kWMbaNouc+pblhCDyvVQofhZRrxegpiJFkMSFQpipd/pI2eqVpsvkYMHr1Z+CgjAPsFnLYu5E4oGP9kvmRqu4JGARKlscDq/hGcBqeVuQXTlgEU037m0c46pJHQaRtw/eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSlqmIdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSlqmIdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E67C4CEEB;
	Mon, 18 Aug 2025 13:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525120;
	bh=gLSkRiMgEqStu03dKxTQ6d17A5IZSAJcW8s9UVuR9Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSlqmIdosID5I7TKD+fcGbX1AsJIOSDgcM2QlFfRoFn1YAsWHFCWZsIP0q2IfrwWd
	 ZCxJjywXcMeArh315HxuQ7RCfia5R80d+gBDB56RVk1WCcHsWPT3UmmQmMKByxY7oB
	 oXIgU3KuyIJyKwIdphMu6rMkR8XbxLhytQRDfGq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GalaxySnail <me@glxys.nl>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 163/570] ALSA: hda: add MODULE_FIRMWARE for cs35l41/cs35l56
Date: Mon, 18 Aug 2025 14:42:30 +0200
Message-ID: <20250818124512.085596549@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: GalaxySnail <me@glxys.nl>

[ Upstream commit 6eda9429501508196001845998bb8c73307d311a ]

add firmware information in the .modinfo section, so that userspace
tools can find out firmware required by cs35l41/cs35l56 kernel module

Signed-off-by: GalaxySnail <me@glxys.nl>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20250624101716.2365302-2-me@glxys.nl
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda.c | 2 ++
 sound/pci/hda/cs35l56_hda.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/sound/pci/hda/cs35l41_hda.c b/sound/pci/hda/cs35l41_hda.c
index d5bc81099d0d..17cdce91fdbf 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -2085,3 +2085,5 @@ MODULE_IMPORT_NS("SND_SOC_CS_AMP_LIB");
 MODULE_AUTHOR("Lucas Tanure, Cirrus Logic Inc, <tanureal@opensource.cirrus.com>");
 MODULE_LICENSE("GPL");
 MODULE_IMPORT_NS("FW_CS_DSP");
+MODULE_FIRMWARE("cirrus/cs35l41-*.wmfw");
+MODULE_FIRMWARE("cirrus/cs35l41-*.bin");
diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 886c53184fec..f48077f5ca45 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -1176,3 +1176,7 @@ MODULE_IMPORT_NS("SND_SOC_CS_AMP_LIB");
 MODULE_AUTHOR("Richard Fitzgerald <rf@opensource.cirrus.com>");
 MODULE_AUTHOR("Simon Trimmer <simont@opensource.cirrus.com>");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("cirrus/cs35l54-*.wmfw");
+MODULE_FIRMWARE("cirrus/cs35l54-*.bin");
+MODULE_FIRMWARE("cirrus/cs35l56-*.wmfw");
+MODULE_FIRMWARE("cirrus/cs35l56-*.bin");
-- 
2.39.5



