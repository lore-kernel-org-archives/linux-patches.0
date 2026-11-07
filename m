Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063934;
	b=5UUXLvL2L2f9Ym91ODu22WIY9crmb/wRFfcfmwPqO/s3/hDAaIjpVkLbEQd6XtMuZe8m
	 +SLKMO7+iXxd/QiFiIfdjmBI2WeTjRqZ/pBT8ULRsM1aWSZp7Z1umRNnDBi7Z5m6eAK4f
	 kEGwXXYoK/4w7FkPxHa2np06sLtz3VrV+zl28DLTTlnGK9ZN8tFCYeLEaxaCSS47Yvmgw
	 TU6/B9KSaCjKp2cRHP/jzmvcjyiHJhGDIeAH18gRogLMvz4wXjaI4f9b+oX3dHx8NBqRK
	 iDMaDBSMQGH4joYfhmQo+GSTpX5t+RpGQE1oByzjhxHKqm1TfPEku6LtxQ/TVTuh68A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a0RW0k6KcGkI01q9Iuqw7RVI4kS3Y0fIiOD2aU4QHQQ=;
	b=Q8hLz6wCWXdO6WOgG0DBk/14wzoXJE+obUoJnlZvZVc1KzQy6GEEK03Jxf2IRcxj65kq
	 00mxyfg39g3JtmZs+maOzRR8evR9SBJwrwPRhvBxhJvc2AZSahpbNT67W/9b8BImq+a5O
	 WGrCAsQMGETsqxSqnWrgJaqht/QqOPW2Iqo0+/9tpr1O+2nnR6Ri2LuOolnwaW5htwgiu
	 ASnvlaIIAveOZbkUB4HazEw7EswZboQVI0x8hZvNF4nbOSLvENStwWrcTF2nVOg5DDx20
	 qkVSoWRSo0z8vIBPR8xUWw7jPXScw9CuOO3HbeOpdjw/eM8CIAHQvUaY9E6HWlIP9pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aL0G1u+m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D54B606A335;
	Sat,  7 Nov 2026 15:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aL0G1u+m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4121F008A1;
	Sat,  7 Nov 2026 15:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063934;
	bh=a0RW0k6KcGkI01q9Iuqw7RVI4kS3Y0fIiOD2aU4QHQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aL0G1u+mVVKx/7oPimYDPiZ30VgcmEQersDRKUW28ICMVJNFozTVIVMnhcZbSWheE
	 TKgBy0yatMFUCloImfd1TB7Zon9VBvCORXLRMFcyicvIVq/j+Iphbv1siHyfwa5rxs
	 p3fhiAmxlST/hSVftvIGp6L8ju7pO3S0VsX5YFF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0088/1257] media: cx231xx-audio: drain wq_trigger before audio fini
Date: Sat,  7 Nov 2026 08:39:44 -0500
Message-ID: <20261107134941.794768801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b24ceef497e4c..af04fb104cc4e 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -581,12 +581,19 @@ static int cx231xx_audio_init(struct cx231xx *dev)
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
@@ -601,8 +608,6 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 	strscpy(card->shortname, "Cx231xx Audio", sizeof(card->shortname));
 	strscpy(card->longname, "Conexant cx231xx Audio", sizeof(card->longname));
 
-	INIT_WORK(&dev->wq_trigger, audio_trigger);
-
 	err = snd_card_register(card);
 	if (err < 0)
 		goto err_free_card;
@@ -656,8 +661,10 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 
 err_free_pkt_size:
 	kfree(adev->alt_max_pkt_size);
+	adev->alt_max_pkt_size = NULL;
 err_free_card:
 	snd_card_free(card);
+	adev->sndcard = NULL;
 
 	return err;
 }
@@ -674,6 +681,8 @@ static int cx231xx_audio_fini(struct cx231xx *dev)
 		return 0;
 	}
 
+	disable_work_sync(&dev->wq_trigger);
+
 	if (dev->adev.sndcard) {
 		snd_card_free_when_closed(dev->adev.sndcard);
 		kfree(dev->adev.alt_max_pkt_size);
-- 
2.53.0



