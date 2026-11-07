Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063520;
	b=qQHR4k3bQHayeQyPB6yQea/bNtQfb34o8clQFo4GMQtvRH7SpxTt/e1IGFyCSI9XlKD8
	 vnZ/eCMGV2jPwykI2PnkY/1IdbxxK0J0EPJhw8cCrTF8CopcDpF3sVrAeQUZ2YYmsCC2S
	 d9SN/jjDXaRyI4Tubnu1vBQKk3Go65XsFjZbtj98ZZ8sTJ4YayQmbkInDh/N5vWq8wWxy
	 fLhNjGo6GpqTeeLH+ORjBqBGT8kv5pQXBT4OjwMnHRo5dwjMQaX1lC4JWOdHgdo9IZOtb
	 xzs9gxU79lXN5cZauL+7NaTpwFQrbWind9mB1u2k2NSGPAox6O+5uvRqW0AKDoIV92Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fmwgi84p0mFKYw/5Mt3j7SRrW8N26uCTs+/DGNGZq7g=;
	b=UKG9upFC7MXgGw0BoPIxHmsZSRv5TjPWJeyMZh1tPxoxb2FnUj3LI4dv/zCeccaDBVf4
	 tArTpZrLO5DbiAs8Sz7kvpRSW0BzxCGdmVKbbFIYtSUVeKLd5AqsbU2KDffuf6qvn5U4C
	 e5BFETOLF58jnsS1/OYjisIvsZGbQHWb3g5GldMv5cgJKf53Cx5U7R7eM0uV+neWWb0Q/
	 s9nhnSO5shMB1L0tw+LiDTa1RwFFB81YRIiAazoGFktH2mdCdLwDa0hhXb2T6UxEju5eU
	 T/MjgqZ9gwRgsUv6f4IG4YMAu/PaEaIjqSk7heetO73oOk2sOUEhij640T2OnVhcwiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IDHYVDVH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1B7606B8BD;
	Sat,  7 Nov 2026 14:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IDHYVDVH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C32C1F008A4;
	Sat,  7 Nov 2026 14:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063520;
	bh=Fmwgi84p0mFKYw/5Mt3j7SRrW8N26uCTs+/DGNGZq7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IDHYVDVHGA8wPj4jWkN3FWQdTF4zEhJVnMxFkfwGWDybqrj09kgSMiuEy3eZI6RAF
	 iMHgWrMLXhyBIK57m92HUg8SEJZHHmXx4iuO63FS8ZtdYJaQl39/bT9j511soBgNoe
	 h1umD7eq6sGEfvcGFFvyYd2hp2A7YQgwOrdbpm58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 661/869] ALSA: compress: add missing OPEN-state gate to SET_METADATA
Date: Sat,  7 Nov 2026 08:55:43 -0500
Message-ID: <20261107134915.590200862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b707bdbb97069..1bf943b189cd0 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -748,6 +748,9 @@ snd_compr_set_metadata(struct snd_compr_stream *stream, unsigned long arg)
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



