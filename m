Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27481C6AB;
	Mon,  4 Mar 2024 21:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589355; cv=none; b=iBGIVIfQ17UCIsHHcIoqRboGkg0Ndfl6vrFCN3/sQixXojU/oMoDazkhHRl7Pn7e8V93xs4XuhpMTnktkdrG+va0Zwh78/Gg8dfm6Po9WMwrt5c+n9mVritlPkPc5fn2AXInViCGFjVeUHO94QwidwGKHotKFPtxtx5fi3miImU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589355; c=relaxed/simple;
	bh=NDqMre9N3vu2arFuGOHGR/L8zUGNWlK4cF0tDwk5fO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pd91UvMC6IfAkgIlnCZ4g64cSvvFT5H9zL14cpid6QE6QSU5tuvKldKy3eeuHNn9uMP8Dznut9hfEvrPxP1wvOXLyO5kRQwOmq60IXG4pDJJl0jp16oFg0HJsiXCQI511nJ3OQ8jo5Q5oJXAdSCL/2mEXF8FVUTRiaGndfyY5oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOuCsZTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOuCsZTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46759C433C7;
	Mon,  4 Mar 2024 21:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589355;
	bh=NDqMre9N3vu2arFuGOHGR/L8zUGNWlK4cF0tDwk5fO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOuCsZTWwLvhyoJjOuIdzaYe6rQy5yvnLYdW9xkj/XrbXRTSsgnj+3pyLnQjeNoxf
	 ZEpPRDcnxl56jdlhMXjdchRTvqbSUoJ1jx1W4ZuMna+ZPWJ059V/LObS5XaKDqCBPc
	 aFTe+lKR/qiiBmzSzWHaklQmfS2TbM37kdauOwuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 43/84] ALSA: Drop leftover snd-rtctimer stuff from Makefile
Date: Mon,  4 Mar 2024 21:24:16 +0000
Message-ID: <20240304211543.772030714@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 79e1407cd0de7..7da92e0383e1c 100644
--- a/sound/core/Makefile
+++ b/sound/core/Makefile
@@ -33,7 +33,6 @@ snd-ctl-led-objs  := control_led.o
 snd-rawmidi-objs  := rawmidi.o
 snd-timer-objs    := timer.o
 snd-hrtimer-objs  := hrtimer.o
-snd-rtctimer-objs := rtctimer.o
 snd-hwdep-objs    := hwdep.o
 snd-seq-device-objs := seq_device.o
 
-- 
2.43.0



