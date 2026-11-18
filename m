Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038307;
	b=GSLQP9nsOmPp+jfXxw/EQJyPwm71qh19SJV21w4DnyCg0giI7zwtasyHBYIdHjTBvLvu
	 mXlLiHgpb3X5z+Z7Fcke/tqKc6Ba0eNubQklFoIg88mV1TPxBxA7jGg1fMiTZDmvCVbzq
	 /oek5kMBMfLAtqBMIOyKDTwqG+5k2Y3FFAro8GZlxHF2wg6mA+b1VbpcfD6nAPd7sf5uZ
	 ofrZAIDFfbBp73YQKFhNJIR8h5jTR30GKA14kVxUeGZxBZ9rZoKcgJxSgsciW5/28hgFd
	 fGG/gAGR62ZknWM4GbLAybj0hYAdZMyf8KuV0h4JF8I7OSRRTfJU0NT4wX99oM4uK3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aJ1z4cZGfFpPsc0TYT6Yvd1UEPNvi4/NyDQsu9C91/M=;
	b=Nik3qZlVCLHBMEnD0RDs8tjDSdo+I2ltg7gotNNQtj5bLGq28Qx2LLFcAeh9Aq8x0/OV
	 bAE7ErtunC1aVZCuSuRDIRYQ8g92ZXZJT95wfR+0dELHDhY5K/LBz2tUHbz1h30wPAuTD
	 w8/wiuARG/tYEAGLsu+ZFHZ1/RCDczV1brD5UN2Q9TFteMjMiXl2agp53SWWakANbbCkU
	 cziV6tnnPoSorSUZnTbu1g1XZBvJVMORCgM+vYEzn6tiCyGMOzdZXA4ItFBHKMNhZ9NFP
	 pccVCnobmZeBlA4RDiGw81pQSBJnzXKbCF/FUizsOnl44+UCT1Tijbetu5FzjtAz+vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJWnyKWX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EDE606A32C;
	Wed, 18 Nov 2026 21:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJWnyKWX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AEC1F000C4;
	Wed, 18 Nov 2026 21:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038306;
	bh=aJ1z4cZGfFpPsc0TYT6Yvd1UEPNvi4/NyDQsu9C91/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJWnyKWX28UW58Z8SkdsFUUjPgtO0uq7/CbFmurV1iR8sxYYfQBksVaRZdvWw/NaO
	 iFtbhQvN8EvKa+3hQF2ou5WWPB+lQnv452fLzlaHF8dDd/5Cx6N7ixBrBx1FHCfgpc
	 RgCG6tO3TwU46zHhXgn/ZMoYcb4p/QIsEiC9LPDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1656/3318] ALSA: compress: reject buffer geometry change on gapless next_track
Date: Wed, 18 Nov 2026 15:37:58 +0100
Message-ID: <20261118150411.454301626@linuxfoundation.org>
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
index 511087456568d..b7c0ff1b9b5a1 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -592,9 +592,19 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
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
 		if (retval)
-- 
2.53.0



