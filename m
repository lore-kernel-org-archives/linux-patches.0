Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063519;
	b=OBftxoI4PVqK2vr2NLqHNXTh/SyPEtNkKTMRgF3+8TVHaEYYXJAp2Caff7NgB37Q8+Az
	 TUHYIjumA1g1rLI5sjfNdIMvoMIWYmoUPUuwJ6b4W9po2su6MrWrUvvOJuFI96CkRAQWk
	 1FQRHKDGYtn4QdOPH/McFKg6qEM63v96PuhQsqf90smGA9RSwdUIaFcs3ThfwAutu+o8u
	 Z2sy4RAIFitjP2D2CLs1wvh0edV9AZhZXVnuuyDtcP4OFhaj2qU8HPfC68FKQiOfwcbL1
	 8Dh9FohG26SwfG9AOleyLIEY77p+B84AvIUIyiwiE4vDplPE4AqA4GtVao3ww+7KSuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S98DjiBxvLFGt5FrsO5hxUeOmvA3opMIwSawWX4d0BM=;
	b=3rwLQZh4tGX54qDsOdUqb9l2eVRCvvzJOvYNYPr4m9vidTaZLPSwyZUHOvZIVDXYU1rA
	 /CylipiY0oTox17BHet9jWEu7A1n2/jFMd4wcDCfBu7neBkEzjjwCpXlRu1+v0a0+j2w6
	 xH/NzSi5PBtMGslIqezCEAbjW2XYCvq9dDQRI1E5WeHCnot7bSsCaJRnpC2tY9APJcdhK
	 NIGt5+wiEOqVGLJtv3TzSe9Aj2QTMMm/KDIfgEd7Avuck97xWHAzFXT9Qj7rMAYJ7BWWU
	 DCNt+XKQPyFcVyQXLNPstRdzWF4SspxjOrKmSxtpahZBqGkhNxAq8LWvSb3f6kAxX2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1LX+Zg2z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CA1606B8AF;
	Sat,  7 Nov 2026 14:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1LX+Zg2z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1ED01F008A1;
	Sat,  7 Nov 2026 14:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063519;
	bh=S98DjiBxvLFGt5FrsO5hxUeOmvA3opMIwSawWX4d0BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1LX+Zg2zM9/+UsOGA0UMSmX6Lds33QX2Y9OawxkhniwSoTO8Aqt23Y4qED2PGU8rA
	 QrCYp7029KujQTo0zXUvsh5+Lji4EzV95yE9zIjLyk2pbYIXnXY6/yd1pNyuS0oV6e
	 asANRNBTu/4DZFmt5TvjNOhapeB2fWijQCboZ1rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 660/869] ALSA: compress: reject buffer geometry change on gapless next_track
Date: Sat,  7 Nov 2026 08:55:42 -0500
Message-ID: <20261107134915.489587705@linuxfoundation.org>
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

[ Upstream commit 82da1acad6fd60b6072dd5f3383e6a55efdd2ac7 ]

snd_compr_set_params() is invoked from the gapless next_track
re-entry path, which calls snd_compr_allocate_buffer() again and lets
buffer_size change while total_bytes_available and
total_bytes_transferred still hold values computed for the previous
buffer. snd_compr_calc_avail() then derives an avail/count value from
those stale counters against the new buffer_size, and
snd_compr_write_data() copy_from_user()s that many bytes into the
new, potentially smaller buffer, overflowing it with user-controlled
length and content.

The buffer is set up once, with the initial SET_PARAMS, and neither the
core nor the DSP expects it to change for a gapless track transition.
Do not call snd_compr_allocate_buffer() on the next_track path and
reject a request that changes the buffer geometry, so that the codec
parameters that the driver receives match the buffer in use.

Fixes: 9727b490e543 ("ALSA: compress: add support for gapless playback")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261019144533.30665-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index c4114186b0d11..b707bdbb97069 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -656,9 +656,19 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
 		if (retval)
 			return retval;
 
-		retval = snd_compr_allocate_buffer(stream, params);
-		if (retval)
-			return -ENOMEM;
+		if (stream->next_track) {
+			/*
+			 * total_bytes_available/transferred still refer to the
+			 * current buffer; its geometry must not change.
+			 */
+			if (params->buffer.fragment_size != stream->runtime->fragment_size ||
+			    params->buffer.fragments != stream->runtime->fragments)
+				return -EINVAL;
+		} else {
+			retval = snd_compr_allocate_buffer(stream, params);
+			if (retval)
+				return retval;
+		}
 
 		retval = stream->ops->set_params(stream, params);
 		if (retval) {
-- 
2.53.0



