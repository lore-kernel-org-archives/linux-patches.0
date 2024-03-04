Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA5C1C687;
	Mon,  4 Mar 2024 21:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588141; cv=none; b=PM1r38JVnDSOW8sywzPArGJ9utG89IUJbjry5EL3EaDDGifebsB2SSsOnY2dpxtAsELA79y6SV2FYhQuSenxueIhpbQ9D960WJooa/60yfDmgcBGybPjT2xEbCSfmTxYbvOwMGDYu0wQqwWcPIkGFPQq5rvfBG1XwKP9nyJMBeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588141; c=relaxed/simple;
	bh=GYKB/ZilNHiVZMQNV2DCvK+H6/9wR6cE1t2T3Nja6/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aF1CBibOikDVBURciI4hPfx4jJaMrs4cVLQMoywsHj6Ny6djf2cVZu/nhqvmpzZaTeEQ/GDwVLhnHGgpQPnGd0vSOhDIbR2KlqSnZ7DSh5jZ5YOoJ42VaL15QerUYXVmazTcyMJgMOLA8x1zw1m3qAtvVi+XDz/QiePUlshFXT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTbxASr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTbxASr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBE0C433F1;
	Mon,  4 Mar 2024 21:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588141;
	bh=GYKB/ZilNHiVZMQNV2DCvK+H6/9wR6cE1t2T3Nja6/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTbxASr+WHYdBr2NjYwb5xiJ89ujY/vx/Gj0Gy/9FXyO7vPvdzF9PbnKLGr1qg/Fe
	 in/Ejw1yLetmqLYa7qwPS/drO//ASSLZn2O4KHF9RwYysRJvF/0IN2oPWgLUl4pDjK
	 BcGyT5Bw9mwA9Cjs+H0yvtlArctgtJLlFk2t5U+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/42] ALSA: Drop leftover snd-rtctimer stuff from Makefile
Date: Mon,  4 Mar 2024 21:23:46 +0000
Message-ID: <20240304211538.278884067@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



