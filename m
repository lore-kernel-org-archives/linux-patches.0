Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045636;
	b=H4qXxtEH6YUA+mve3hqdhIvZBaQZn56Ibz0WyhRgOshHu6UxW4Jx1WzE8iPOb2B7YpZe
	 QWtc3qXRVaDPWhLiVAoT3Uh/l1aMow4/75Vmmn6DEHMgSj0mpOdhRaf3vOBNxw79j7uq/
	 kPTPRwHRLvnUdBSMmzFXdoARiahVqAXmduUjPz3dijoJ6qtsVl1Fz8lO//tdjR7CYLW5z
	 Ygbm65dE0Khs+QGevagroyBqoJUJczDWRLtnRnqcsTE0zDfRJeVPQaoX8Q9GFKosvNt2+
	 GHjZKV6DvPPd23mdZDlTmqVfJNsFTHxebhcWh4ntpOPEbi6o2vFjjGxjDZ7zCmoi9Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E0GO7monrCbyIHq+XOxFkBBAyY0hR5H8Pujb2LFPaEU=;
	b=WbRbK/UkhMSWtWeI27wrtABgH7O2wkptSezKOzIheY/tkugSKwQECWMCuGcoYEl3eZun
	 r1axrdNbqmPB+oih+JB/nFj6wjXRGWGZJ0aG8i+TRQY7xKsnUIcUGfxSwXyje5NO1PIMN
	 QnQrkdhCGCOs6Rp4LN/SiBJBIZEvDTVg62vLMo7uFOlOnQEn5rd4HUuYhUHHnthVTNdE/
	 AE99/R35VsDf1FSR7+yOOk3k0mPTlniPSochcLVRvCVkj4bJa+/7MEge7CCHhlXX6IPNh
	 bERSdo7Ej4e2TvJ9BCunwNwFyH2ts/vUzy+I2CpcnCL03jTwekdrUyMDhwjCXUcw6mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GIn2l63X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3C4606A31C;
	Wed, 18 Nov 2026 23:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GIn2l63X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A884C1F000C4;
	Wed, 18 Nov 2026 23:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045636;
	bh=E0GO7monrCbyIHq+XOxFkBBAyY0hR5H8Pujb2LFPaEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIn2l63XL5O/1mzNPAMcT07KFRXMBc49PaPnHm9QpdylF0jcwRzhiJ+kDL+W7Fij4
	 X0214gExJ11fP9JVR2iJUMbHj5yaSGIHjnNHwEiYXCiSpflzKJycgFQWUtsUgzor3r
	 KRFBwoeHNS76JefM8Os0B6eWR6ymVC7LLVtDT5iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0995/2857] ALSA: compress: add missing OPEN-state gate to SET_METADATA
Date: Wed, 18 Nov 2026 15:33:49 +0100
Message-ID: <20261118150237.429944263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 931f5714b7921290cd1a4742e185aeeae7270ee6 ]

snd_compr_set_metadata() calls stream->ops->set_metadata() straight
after copy_from_user(), without ever checking runtime->state, even
though the function's own comment says a parameter change should only
be allowed once the stream has left the OPEN state. Every other
metadata/param entry point in this file (SET_PARAMS, WRITE, ...)
enforces that gate.

A codec driver's set_metadata callback can assume SET_PARAMS has
already run and initialised its private state; calling it while the
stream is still OPEN can operate on that uninitialised state.

Add the OPEN-state check the existing comment already documents.

Fixes: 9727b490e543 ("ALSA: compress: add support for gapless playback")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Link: https://patch.msgid.link/20261019144533.30665-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index f1140a6bc996d..e961d79f076bb 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -674,6 +674,9 @@ snd_compr_set_metadata(struct snd_compr_stream *stream, unsigned long arg)
 	* we should allow parameter change only when stream has been
 	* opened not in other cases
 	*/
+	if (stream->runtime->state == SNDRV_PCM_STATE_OPEN)
+		return -EBADFD;
+
 	if (copy_from_user(&metadata, (void __user *)arg, sizeof(metadata)))
 		return -EFAULT;
 
-- 
2.53.0



