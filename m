Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061926;
	b=Z1w0S7Far6oTTm4272Tl4p6/FM+323zvIRv/sujvPJb4TVSZq2wJD6giXbx+FHr6gucX
	 /isS2vRi2YKmFeRreXLRktfE5TnYaXy/06PMn9XOHM82w1Q8NPJt920JxM2OiVCH9mC8r
	 x3UQWQMXsdSMCEoM90627ZqVMZUypYtqIxNfqoHZLztVNZ092GSPAajR1BmZ6RNS2/XHU
	 g32L/qJrsCcUML1TYbUiJRVNU98xLqYuHIkDYb0/5mBRXk/esL9HfhHjRlkaDvDqn8DRK
	 SA718FLm+XWahw2INofe1em7oxNCXDSwk/YYX+LZA2kAzRKjKcAeUDLD6rYu24FuoIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b7f8dbk/Gn8rV5DUYtpluZd5hmtggbX11uMChwkEw0M=;
	b=meg461AusQh6XoywEEpcBEEXWZmUvyPBnUPBjgg0LvtPrQJ5YooDehAm9rLFh8c6FTTK
	 p7XEF1cMPa55XdMii7qCRzw6GSoBX2gnuw9jmR9UYUNnm8/S311PLLy9b03UCY0LKtLM0
	 0iGHbWtHgho3oo7aGrsOO/aCghh8gxH9EDIly0NUf2HzFM/FCec64ZyrYeniEQSFbkV3u
	 aaK6JM3344rv8ZL7d3V8Jw6FVSv4AElunjSFNFvCkLnoOnZLxN35joalrcDpVAJ7Rsxfo
	 bzvk1MKQ3k82u0vayDvlU+UuOYY0lb/bOYVzDSNV9bsp86h84CVbZKr9b2T09lKif+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l2erldss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DC9606A326;
	Sat,  7 Nov 2026 14:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l2erldss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A051F0089F;
	Sat,  7 Nov 2026 14:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061925;
	bh=b7f8dbk/Gn8rV5DUYtpluZd5hmtggbX11uMChwkEw0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2erldssavWEcfrMdUeaHXJ/PJjxxqxIsAbtnG8unMik8u1YaRGrhXGbLER597nJw
	 3cdREW7wdkpasWaNLVQJJmMrL7IFeP73+ZU1QcTlHvoCFhvh89k/3FVE0uT5KmP959
	 QChJb2svu1cr/dGE6hdUOBPWxqezeKOzya9UtMnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0931/1536] media: cx231xx-audio: drain wq_trigger before audio fini
Date: Sat,  7 Nov 2026 08:49:07 -0500
Message-ID: <20261107135023.796513471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit a691c54986412e1fa87f036d2577d5a78a75e658 ]

audio_trigger() is deferred work (dev->wq_trigger) armed from
snd_cx231xx_capture_trigger() on every PCM START/STOP; it dereferences
dev->adev state and may free the URBs via cx231xx_isoc_audio_deinit().
cx231xx_audio_fini() tore down that state without draining wq_trigger,
so work armed before or racing fini ran against freed state.

Use disable_work_sync() in fini to drain the work and prevent further
queueing.  Initialize the work, lock and stream_started counter at the
top of cx231xx_audio_init(), before any fallible allocation, and clear
the partially-built audio state on its error path, so fini is safe even
if a later step fails.

This issue was found by an in-house static analysis tool.

Fixes: 61b04cb24a12 ("[media] cx231xx-audio: fix some locking issues")
Cc: stable@vger.kernel.org # v6.10+
Link: https://lore.kernel.org/r/8c7e1294-b906-4636-890c-b64d03b0e1d0@kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/cx231xx/cx231xx-audio.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index 9c71b32552df3..1179cb0334f4d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -576,12 +576,19 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 	dev_dbg(dev->dev,
 		"probing for cx231xx non standard usbaudio\n");
 
+	/*
+	 * Extension init errors are ignored by the cx231xx core, so fini()
+	 * must be safe even if initialization fails part way through.
+	 */
+	spin_lock_init(&adev->slock);
+	INIT_WORK(&dev->wq_trigger, audio_trigger);
+	atomic_set(&dev->stream_started, 0);
+
 	err = snd_card_new(dev->dev, index[devnr], "Cx231xx Audio",
 			   THIS_MODULE, 0, &card);
 	if (err < 0)
 		return err;
 
-	spin_lock_init(&adev->slock);
 	err = snd_pcm_new(card, "Cx231xx Audio", 0, 0, 1, &pcm);
 	if (err < 0)
 		goto err_free_card;
@@ -596,8 +603,6 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 	strscpy(card->shortname, "Cx231xx Audio", sizeof(card->shortname));
 	strscpy(card->longname, "Conexant cx231xx Audio", sizeof(card->longname));
 
-	INIT_WORK(&dev->wq_trigger, audio_trigger);
-
 	err = snd_card_register(card);
 	if (err < 0)
 		goto err_free_card;
@@ -651,8 +656,10 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 
 err_free_pkt_size:
 	kfree(adev->alt_max_pkt_size);
+	adev->alt_max_pkt_size = NULL;
 err_free_card:
 	snd_card_free(card);
+	adev->sndcard = NULL;
 
 	return err;
 }
@@ -669,6 +676,8 @@ static int cx231xx_audio_fini(struct cx231xx *dev)
 		return 0;
 	}
 
+	disable_work_sync(&dev->wq_trigger);
+
 	if (dev->adev.sndcard) {
 		snd_card_free_when_closed(dev->adev.sndcard);
 		kfree(dev->adev.alt_max_pkt_size);
-- 
2.53.0



