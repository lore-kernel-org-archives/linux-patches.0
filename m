Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036735;
	b=XuOr5ucC8As2anN639s7W5Yalk5p3GzfxektzrgyZThIdygBvdyyQ2VrUpe89ryeAV+m
	 ydWigpFFyfmAP6j/yRloePu1/daD7529Z0Ned9uKS9ErMCUTXNs9pGzxp+J/9XR/YrS5Z
	 h5lD8DbJFCmobWv0AihmDp5moiJobj/vL5a4xRFq5GVF/FKar85Fp9UstzGfHilA5UzCb
	 4dtg2XVrd3Bec6J5iqn1JG9DcbA8GphXoiBXjq6FbMP3RUnGuXCyhX6sjj3J6czS/NRlE
	 yEQWutNNdP2IX+/tGoHV60NOxnQK/LccvEbr9wyvIFflsNrG+0dWwVcKk+bqTBcBllg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JjkNm7oKt4sA6VrE/8mn32hKuYf0xG3PavoY/W17WvM=;
	b=Hd8687G7IZszWkGqOomD2lToQMRLMP/vQWWRpCwD3FQ8WBjOH/5vV0rtX0kqNRici86S
	 9qOxqYcX44TCbsrVEXt8eWVpLyRJwxh5KWEAxy6LmPUlTq1/AAIDs2fFvjsvqWiUCoFRZ
	 7N1881jTer+dQAG5RWofKGkiOO56F/Sp2xqOANGR9Lax3FtGOHVIBeGyNewh4SowLzNv0
	 CHX5vTjvkgg00uqm3bWskmIEP41shdCouZSiWj8/+w3LqlQv/eFU9ijeCOchBH2SLzxiR
	 fEBqxhF05Nso38NJ7F9T1Zx7rZrYO42fuwt458uRyJXuVNyB19bxV/jsnVorbtEOM/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SSB4lXJt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1924E606A31C;
	Wed, 18 Nov 2026 21:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SSB4lXJt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691141F000C4;
	Wed, 18 Nov 2026 21:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036735;
	bh=JjkNm7oKt4sA6VrE/8mn32hKuYf0xG3PavoY/W17WvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSB4lXJtJKVY2UqcNfD1LTvTSjZc4zeHuHaCk/cJdT6VxaIVZLjG5oiByExa/18U8
	 nvyi7EmBd0wFrClZ/MUgQE7KpTGXCtbmOYnI22++mqvXumIF5YqRlH8HR6QUb/rnNT
	 CMPUU3piUvNpuDmG53C72FjHV6Na1BXlF6gKY58Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1166/3318] ALSA: compress: add missing OPEN-state gate to SET_METADATA
Date: Wed, 18 Nov 2026 15:29:48 +0100
Message-ID: <20261118150355.096192855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8545c7bbc58e3..3c259b9419598 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -677,6 +677,9 @@ snd_compr_set_metadata(struct snd_compr_stream *stream, unsigned long arg)
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



