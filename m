Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065054;
	b=IrR9Rhw5SETEv4PDgSOk1/9WHFROnGBxn/zpMT0EVa/qI7DbKG/Akd9I3Nkho6oP8mDk
	 gWLijh0QI9LWY2VRJJAqr16/dQVEKsbC0szvP54LEnY9PYty6FA/ace9nySuqT/4JXk4W
	 z2qIVUZAaquEcRTHz4sv1+XO98g+8kj6cnmCo8wGCfTf4G9iVGVr5xFL6NgwR+ASBKr/1
	 CAjzF6ayP8cPm+nAOWVddNRDGI2U1yUFKRUtd6YQgBrVSiBsv02MWJgsz1KStRGEJS0XX
	 xnEJ6GaaQ9ToCl0P70eHMpszXTkUJ84Iiy7v3GEFJo06OlROveRnxLndH7OI0IteJtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/SFPNKpcD6W3Z62yXoq5/2WYN8sdJOEsaLuWwYt0V8E=;
	b=HT0XjimaaI58oieGfhnRUttvuakzMSTV4dpp4M6HRa1p360Cg2DLKUQghoJpCGAiDrFH
	 WzjliPwx1sJZSoIQtNffWSEAPVPOQgp+NzkQWTI999IO5/IioQFenBXYzYa0UFtYCOpZh
	 nJo+nHIde5t1TFABzgpXoVhz/2KC7AzINmxNukNejf0QVXQLN4/dpzddKQKnSoLsQmJOE
	 C0w7b1lDEKzXK6wikGpA1txolJlflAXYmIRLcP/y3E3Xl7XlQakWTYdXUUCdI4AmSEV4p
	 is/KwPRVyhOW9sNqSttOxseAgjUbQOb31P9KUpE0gP4RuTN/ba2eIMHDBc14uV7+vyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDwuLsJI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E174606A33A;
	Sat,  7 Nov 2026 15:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDwuLsJI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7631F0089F;
	Sat,  7 Nov 2026 15:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065053;
	bh=/SFPNKpcD6W3Z62yXoq5/2WYN8sdJOEsaLuWwYt0V8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDwuLsJI7WoW87BuWCKKmSTK1/zbzlNb+4DhKT+GOCIhJRzRbswXf9u0HojmIkJIy
	 Lbs7cLTed5hXy4dqBDKs1JABh4+orrPplrAHLJt7XSNBPUBMXAjiKVJdlATV/4N26m
	 6WZD5NAzM9ESf9j5Z5t/cZGfFCAzl9LQhtu4iBt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0902/1257] ALSA: compress: add missing OPEN-state gate to SET_METADATA
Date: Sat,  7 Nov 2026 08:53:18 -0500
Message-ID: <20261107135004.246178719@linuxfoundation.org>
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
index 6edd1375a867a..ce806ca875d3a 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -761,6 +761,9 @@ snd_compr_set_metadata(struct snd_compr_stream *stream, unsigned long arg)
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



