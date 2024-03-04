Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6281446BA0;
	Mon,  4 Mar 2024 21:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588798; cv=none; b=ZkhbLElxEmPC8JfmmIKG8HSnBDsEn9eHA49VvxSOecX7HNFSVbjcRZXhjub732GayF7aiIl6jqPkiEg1a4HBjl8+JzLkDt2BWRL/GETi+C65nmiYG4PSpnYFF7SXBhRvfZ4YoTyzG956NZdnp95L7pJdHBYYh+9kuyRmH3ukPUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588798; c=relaxed/simple;
	bh=RO1AQAJVoCUEBSUiqRGY5k+J2hXvipa/o8dkd41hnu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmMEQtTrd9nfUR3LsPB0OqcuS4nuGA9T7XKDKdPyPeUY3GYb5tFo3j60crzSnjQNcS7rpHKaMA9cFoQYTBZj3YmCtI5O0tm96kfLCZb3t9rp/7HA+ebn1ECrSf+RXRihrWLUg/z7XN9TUocMhhTHA5SOGY2vNgsEN4Ugamf82Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfJRwAv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfJRwAv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94612C43394;
	Mon,  4 Mar 2024 21:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588797;
	bh=RO1AQAJVoCUEBSUiqRGY5k+J2hXvipa/o8dkd41hnu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfJRwAv8GuPpZ5ab+GiryGhFFjIrdOqYWOePe4ALRiU5xMCu95VIFlpkAKy6zN5NM
	 TKisMchhowxgpEjGFTKy0efX0dCoHa+XbjyNzV0bmn09sBFiUiagpGja790F09kkOl
	 bESUSS6tDxA2SooljPPkBT871VKovJIiH/CBwpQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/215] ALSA: Drop leftover snd-rtctimer stuff from Makefile
Date: Mon,  4 Mar 2024 21:22:09 +0000
Message-ID: <20240304211559.078257377@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2762f03d9b7bc..a7a1590b29526 100644
--- a/sound/core/Makefile
+++ b/sound/core/Makefile
@@ -30,7 +30,6 @@ snd-ctl-led-objs  := control_led.o
 snd-rawmidi-objs  := rawmidi.o
 snd-timer-objs    := timer.o
 snd-hrtimer-objs  := hrtimer.o
-snd-rtctimer-objs := rtctimer.o
 snd-hwdep-objs    := hwdep.o
 snd-seq-device-objs := seq_device.o
 
-- 
2.43.0



