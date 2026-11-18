Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052747;
	b=HdlVkbNPsehXA4e/Wvu1tec/5uK4mhyR4bckbzdPQJYInH3CXn5kRsA4qG/RZ+vNKRrZ
	 iJfNUdbGMe2Ka0ZIzxZmsDBV0Vurm7YELHb/ehh3JWfanllq+ky/UegFqilawEDUY5E/r
	 yKoCKAnIDaQmg9QgrONgXRp+MsJxx9FqgfqWu9bDJCQTVU3osOe+ImpqkSbTVpbL+381N
	 vFyKt9r7Aq4AYliyWsXwi/dNnpb/MgNHXYrMUH7Nfb1vg8Ov0M6o4N+IE0X3SkmVFNx5L
	 WR8zr3wwuL7SHxRbh4y1leSKm0UQoqE4xNq8ZaQzgBbYNHB/GIl0RdX3huLl/YKdnlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4y9GgoaROOp3jpbkFX8OzsSvTg+0wbHVk6WzmMFxPjY=;
	b=wjejLC0lP9Q1PYvtzzs8/WPQZ4dOQMsmUsGX/6y0FZnRJ7OGxKLmyIpZlmHeIeQ0LII2
	 /hxKEYUvgad4x7NYssSQb7dyA8s/rSRw37QowQlBZey0AXZW2mXAbLdkzWIGjBUe07mHP
	 HOt7zHztXM5YU/altMRqEhFlEtUzg+xzZraTz8hLNPqOkTWzgZcHjj/2aYPwJL8VxdZga
	 0O/+aZV0yW0Uh+YPZFbf1KixaJsgEC5oK/0lqxbf6AODzCSAul08VayjV7WRbXkjWn9gd
	 Ju9Wd8kQTolml6EmXQOfVzMX2eeaaOfIus7y00RWBi8ZlsxVIZa2dNOwHnEoFYjaEiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AruUhVwV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633FC606A32A;
	Thu, 19 Nov 2026 01:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AruUhVwV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F5F1F000C4;
	Thu, 19 Nov 2026 01:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052747;
	bh=4y9GgoaROOp3jpbkFX8OzsSvTg+0wbHVk6WzmMFxPjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AruUhVwVo+cNKAjaJ8+3NOaXorf4YiCYqdfaskGByzYsAENWEeagut4jZFDydzmyS
	 XjeufS5HUN/hVNbew1ieX9uYOoH/jzA7GXj8eQ1/iBO0unL2zJF9Xb06yO0wRjXKtw
	 mvzpbV+bOr8aYmjfBbFJrI2kNFAuWfyZTVO1RLmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0672/2214] ALSA: compress: add missing OPEN-state gate to SET_METADATA
Date: Wed, 18 Nov 2026 15:39:08 +0100
Message-ID: <20261118150038.704868315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1ba90a87808e4..6b7e51e8f663c 100644
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



