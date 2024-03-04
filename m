Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC847B3DE;
	Mon,  4 Mar 2024 21:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588014; cv=none; b=SA4FYPseJ1pryynM4NH2SEqk+6JQOZ2bbrbPuLJNJwFw/n+N2f4L3RoB39L6lGEzdoG8mXyPp6FjGYeTBEAultlFjJ1cx+DNLcttj8FgbYy5kAbzXtilMffUaqouRjUcIB2iQcFonzlH4Rz5eM/8PIZ/Wgrgc7AX/jAeGTk2PCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588014; c=relaxed/simple;
	bh=YvggHiq0HSmmm8IXZlNAgtlwV7JxtMC/13yZ51v+H3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6N0OzEJFzC3lJFfuH2ViYUkL2GlzgRQgaVubT2zb7eMFN67+FWLeq+Yqs3Q+f9Upw6GKeYbtqBmcIqmgTf0hDyfkBZjCoTWC6N4I56WGLbntpPDE3X9skg5ZV/JUegnavRWFXpWLadHEu92l81CZKv0HBOgQd0Gt2hbG2MqlpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yX+N5AOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yX+N5AOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313AAC433C7;
	Mon,  4 Mar 2024 21:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588013;
	bh=YvggHiq0HSmmm8IXZlNAgtlwV7JxtMC/13yZ51v+H3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yX+N5AOrF1nqdHpVDS7ercQHSRDLSpTaJBnxdm487KicyCTa4IjKHFgSZge3DuoOZ
	 ZobSAPf+Ho9b/PBCVdDNIicIh/8LAAyAMKZ5rB2WHQNcUe4b65hMLCmr3sGBZA7vuQ
	 vQOJbz7Su9D20wVmt4GGzs5SdjI4JtkuQx9/hbPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/25] ALSA: Drop leftover snd-rtctimer stuff from Makefile
Date: Mon,  4 Mar 2024 21:23:50 +0000
Message-ID: <20240304211536.221082904@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211535.741936181@linuxfoundation.org>
References: <20240304211535.741936181@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4df49712eb54141be00a9312547436d55677f092 ]

We forgot to remove the line for snd-rtctimer from Makefile while
dropping the functionality.  Get rid of the stale line.

Fixes: 34ce71a96dcb ("ALSA: timer: remove legacy rtctimer")
Link: https://lore.kernel.org/r/20240221092156.28695-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/core/Makefile b/sound/core/Makefile
index d123587c0fd8f..bc04acf4a45ce 100644
--- a/sound/core/Makefile
+++ b/sound/core/Makefile
@@ -32,7 +32,6 @@ snd-pcm-dmaengine-objs := pcm_dmaengine.o
 snd-rawmidi-objs  := rawmidi.o
 snd-timer-objs    := timer.o
 snd-hrtimer-objs  := hrtimer.o
-snd-rtctimer-objs := rtctimer.o
 snd-hwdep-objs    := hwdep.o
 snd-seq-device-objs := seq_device.o
 
-- 
2.43.0



