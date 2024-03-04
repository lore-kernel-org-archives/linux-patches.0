Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7698E1F5FD;
	Mon,  4 Mar 2024 21:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587534; cv=none; b=aRhXl+1MLSTwDG1sFWW3XHUmk8N2aZBlDpY0kaZdmOHGAx1JAbtm8YjkVCzrfpkNm4baXYtf6Be3g3B6MgVSjw2ND9tGZNVstb6WibcKqbO1YaDzIyIPrXT+NWtlsx6I24CDsN0jrHqnTAHzAXAbrRrZAhXmSXLnNQ+DaYP2LnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587534; c=relaxed/simple;
	bh=tMOwshd8Etuy354m/VERsc7wZloVef9e2HkrMkkqZY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPdIulDfthKGpSPLxCTpiOQpGovsAjo43GIU1bw4Of4fnt2IJEdy/o7otH89nFPSKi+9Uzqye9mdEHuevde78DEvldbq/8zmS4dXd2GvOFiJtvDDstVR3wYJeXBFbG9kUKnd16y+WZYzl+WRKgwjxF7Y1pK2a4E6jJ7OgLNEPPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q19F4qRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q19F4qRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A066FC433F1;
	Mon,  4 Mar 2024 21:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587534;
	bh=tMOwshd8Etuy354m/VERsc7wZloVef9e2HkrMkkqZY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q19F4qRFXD1a6LqiYN7WgPrCzmJKaYan8fK8Yj0UAcuRVb+uygcSL9PGHKHt0DDOF
	 6hmX5+m8fHu7dGoG+xSFLAIueAgnaM5UBdynxuBnt/xpERFhW7DPfjCVPvKsGalXFJ
	 Kyi5JsXRg8bFCJj7j5cT91Pps/Dv/M4ilKavklVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/16] ALSA: Drop leftover snd-rtctimer stuff from Makefile
Date: Mon,  4 Mar 2024 21:23:31 +0000
Message-ID: <20240304211534.707926005@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211534.328737119@linuxfoundation.org>
References: <20240304211534.328737119@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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



