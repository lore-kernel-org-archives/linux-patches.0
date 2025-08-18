Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0B631E0F8;
	Mon, 18 Aug 2025 13:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523509; cv=none; b=RWke9mZxuCVOk10SV3/u50mY9Y5dKDJQ+vlX0tVLWf/EFNpt2uBpdbPIxjA7EBV3FLupVcFyeib5tuS0AG0YJ0jeq5fmBoFNBn8jA/6iPsYQ/ofx9VaIoNNXE5FExH6VQM3NKs1epTpbO18WYcOLSWcjeJV+l7VcBsubpYSKqEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523509; c=relaxed/simple;
	bh=kOSOChCC8tM5OJQERktW+HN6oZRRawpsJ+Rkj9bt1i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=be84PIBx3V39Nuj5L2yvuUYMY97W4Pxo8g9r2gRT1+fq6eSWVKuPYEhpNoyN1tSA92X0NmiJlsYZdK0LWHrv5LSuKbW8BKvNsObUPabdpKd92g1HsVEAfuQX+axxCGytlGJ27R+1Qxe36if0gnUcd+MpAKq7YCw46Iq+KwpVV4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I79Dh0s3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I79Dh0s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE832C4CEEB;
	Mon, 18 Aug 2025 13:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523509;
	bh=kOSOChCC8tM5OJQERktW+HN6oZRRawpsJ+Rkj9bt1i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I79Dh0s37tl9KRFvgfjcDbf/V04nT55yQhEXsTW0IU7ZLP4/VNCGPRT/QEchIgsAO
	 pZuem7YzqsQxsTSohiayJ/9ULDwx0BUeYkDI+TJ4/9sozioPetJgMUEm7fSVHR7SLd
	 2fm8dvars3yvVet0l5a71cxAEKXB754YNodrIJ2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GalaxySnail <me@glxys.nl>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 150/515] ALSA: hda: add MODULE_FIRMWARE for cs35l41/cs35l56
Date: Mon, 18 Aug 2025 14:42:16 +0200
Message-ID: <20250818124504.157767210@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5dc021976c79..4397630496fd 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -2060,3 +2060,5 @@ MODULE_IMPORT_NS("SND_SOC_CS_AMP_LIB");
 MODULE_AUTHOR("Lucas Tanure, Cirrus Logic Inc, <tanureal@opensource.cirrus.com>");
 MODULE_LICENSE("GPL");
 MODULE_IMPORT_NS("FW_CS_DSP");
+MODULE_FIRMWARE("cirrus/cs35l41-*.wmfw");
+MODULE_FIRMWARE("cirrus/cs35l41-*.bin");
diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index c9c8ec8d2474..7e92ad955e78 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -1178,3 +1178,7 @@ MODULE_IMPORT_NS("SND_SOC_CS_AMP_LIB");
 MODULE_AUTHOR("Richard Fitzgerald <rf@opensource.cirrus.com>");
 MODULE_AUTHOR("Simon Trimmer <simont@opensource.cirrus.com>");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("cirrus/cs35l54-*.wmfw");
+MODULE_FIRMWARE("cirrus/cs35l54-*.bin");
+MODULE_FIRMWARE("cirrus/cs35l56-*.wmfw");
+MODULE_FIRMWARE("cirrus/cs35l56-*.bin");
-- 
2.39.5



