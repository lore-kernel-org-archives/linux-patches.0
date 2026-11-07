Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062464;
	b=SG+p04PYUYEQfptHqvDhbiu9T+EeUVyq+Cx/kZx/DZfDv2nrO5aeWy2c6GGjOmS/N+Gd
	 lANDs6uxNEEiQwmKQGFHTWoZ+fkYr/iEpPUEbKs08f8ziVXje8arJHqtzkm3UAdOsRKfl
	 zYwR7Ug2L5gwO/365TmYfPDiSzfBCE17xVhQhluapT5dHXLJgRn2NXRDZ2fRtPk8dEO/K
	 Y1Eyt6D2uR3ryFLqIJZRVNPWAtKwlH7k9chZHzYL6OUZbPYbl+JVJLJyhorFl1lG+voUD
	 zx7cX5JrybZVSVSssKxwkTQKj+yCwR4QSX2DNjwtM6vIBOx42b8577uaw7CvVtQKxTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OkdKBSZMv4vyijy6frg+UY7U54m/cpjhAV6dQa5lLb0=;
	b=a5j77YoM5DZXmR/4FnqVIm3fX3+1NxK+VOpw/QeuH10rx+kDvIS+jrlH8BIFsKZ3ufKX
	 U4icMf7NNsqLK6I1zZl8c+SqE6SJH6vxJ7OFeQrh73Iy1M4O/qu1Lwn7/3lINeG1g3wGN
	 nQ5nSK8Vu1h/H4qE4xWEGbCYVFo7Zuesok1OtP9E7SUoDPfl2dF1JelCi6Jc9IKFJ0p4O
	 ikIWiTtEx+IavyUKuaQ+TdLAWVwYbOAWWXCHrWojSMZEE3o3oSGiH/p+lPkfgK/id2Gp5
	 1qFoclQJegCEZvQ0fkT1coVD0EBh0CdFjjxLamphPAlLO8QC0TbjOe7ccFCooFL9bfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GzYbYlJx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6789B606A65A;
	Sat,  7 Nov 2026 14:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GzYbYlJx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1523B1F0089F;
	Sat,  7 Nov 2026 14:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062464;
	bh=OkdKBSZMv4vyijy6frg+UY7U54m/cpjhAV6dQa5lLb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GzYbYlJx7OMeWjUuIjmXa0vu8g8Pkg9UVIoYSH3vCly4Voz8xpYmLivKAg/StWOQy
	 berF0f5loV9F7cDsGzZNgDmXahecoABahhKIHXTOKRc8Ltx1q98Dc3pRUgT3X6Rt3a
	 n//edwZhcL4qisqeaikw4Prh4DA9ahL728kCEEAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1370/1536] ALSA: compress: reject buffer geometry change on gapless next_track
Date: Sat,  7 Nov 2026 08:56:26 -0500
Message-ID: <20261107135036.320929161@linuxfoundation.org>
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
index 0d5b3c655e849..0436ed1b1284f 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -580,9 +580,19 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
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



