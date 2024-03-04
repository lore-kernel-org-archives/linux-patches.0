Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5628F58;
	Mon,  4 Mar 2024 21:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588276; cv=none; b=SGYi1u/We/bITdmIkVqN1uaaZ/JL93j8dxBXuatAgxSrykRK3JsbCsMl/gpSz5l9+BZqcsFcASrtUHlq48WK42ZjzgBjZaG4t51IE09HQDzj/XbwYXDdywhyp8BLCD7qMM3AQRnju7a9spcRi7AmZWiL4sOqMT7ZpbpDvkANHzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588276; c=relaxed/simple;
	bh=PuPGujcXVY5oh4f6V2e/PNCxigiOhdu5/5ikG1dvEQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKkmltYIc9Kvrf8h4Whv150AOIK9KS4BSlzakjeyIct+pvrGlAqEUVrlLzXVCOqDg9JnwjKbxgBoljYkLfO97nQ7Atwtzq/EIjTHzaapwUtxsLz7ygux2pRb5Qn1e8F3JiaXhj1lCQFhlWkKpNYqH6GcDwCtUyFq9Q7Ic1YNvSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQmGzhCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQmGzhCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D04C433C7;
	Mon,  4 Mar 2024 21:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588276;
	bh=PuPGujcXVY5oh4f6V2e/PNCxigiOhdu5/5ikG1dvEQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQmGzhCD9Uv/7WHJwAob/1KuTPaMqxFlhYVpWMeg2AxXNL9dME9d2AHFD7fOeeq+T
	 ft1ln7dUe4qgFSURtq/ikK0CtDvDTFBxVCyu78plIT79LK01qdJyotb6BigRqOnUWh
	 Ee3kn2JJerU2wBC9K9MKklARZW7H+0Qr7VJIdA2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/143] ALSA: Drop leftover snd-rtctimer stuff from Makefile
Date: Mon,  4 Mar 2024 21:22:45 +0000
Message-ID: <20240304211551.371955869@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a6b444ee28326..f6526b3371375 100644
--- a/sound/core/Makefile
+++ b/sound/core/Makefile
@@ -32,7 +32,6 @@ snd-ump-objs      := ump.o
 snd-ump-$(CONFIG_SND_UMP_LEGACY_RAWMIDI) += ump_convert.o
 snd-timer-objs    := timer.o
 snd-hrtimer-objs  := hrtimer.o
-snd-rtctimer-objs := rtctimer.o
 snd-hwdep-objs    := hwdep.o
 snd-seq-device-objs := seq_device.o
 
-- 
2.43.0



