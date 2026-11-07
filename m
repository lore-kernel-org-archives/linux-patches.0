Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065051;
	b=xDR1j28A4xInQ3D2ZSba6xv3B0JRvVcCnAWOrS0hQwJsd2DFsHqdOBjYT5V3A3ykxZ3z
	 dA19iwfWoXQxktQ0ZU4tzVABm0FQbXFOlby56mNhyBBbAV9sJSRiYod2KpGVt3+WEIIoG
	 GARgJCpAoxAlOVDQflJJ+pzL7sL1CGLvNAK+lb6hLMlXsv7Moechn3F0/XxXozQTZvCLe
	 E5mEJTa4tSaz5sT7MxQiv2uI5HXzLgKVGhbPPX+UYSMJCku8daEXExl4ysLSWCnkq9zZa
	 FFdWk5SF+gjpUNhKTREGSQ3u+MChWWRkYxBqi1qTa+YdNQZBc5T8gEvjLwW2yURyaqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JfbaR1t8Vh6dgmsQtg0EyKU7+dkmPsTKvfBSbzJD/Eg=;
	b=qk/zoYtGNYaSZeCetMuXzJ8Hns+yA7ZKMRmeXGeqCJN8e0K18mtDDBta/qc+gbpXBi11
	 fzFQNy8FpQNbRV6WvmY3fkgDd88HJvPllGO54MiXx+AmjVODVv/mvVmhPORYcxbNibwE/
	 4klojhE5PceinvzFlYq+wsjqAusKfxGnhotwS+AyPuEPihOyW4XEQvUFbOalGPD4s0N6U
	 BHpL+IQByFN6mUuc+G5iBH69HfiC0FIIddgMAl180kCjibmvzU65J7/D0hbKDqpGdicFJ
	 hf7ro0TGGiFOSMsl7HDzkkK9sprLqUXZuIfaLLOedy+5uAbMh9njmwH4X6PJ3zoR4lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eyh0Io2X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BDD606A32D;
	Sat,  7 Nov 2026 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eyh0Io2X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2171F0089F;
	Sat,  7 Nov 2026 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065051;
	bh=JfbaR1t8Vh6dgmsQtg0EyKU7+dkmPsTKvfBSbzJD/Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eyh0Io2Xgo8BY5uKQKavd24C0MhWMh1ZfmQpfbCDb12Fbiikn8SNJSq5E6WkD7qPW
	 kSf5LJnh6pObmAtqFdANpIgMY58taihHWB1UrAM0EWCq0oc1f08z+qboBEotzcRf51
	 td8Gfj/qLpUcNWijL49jSrKx+yvUg6peAs1Xo9cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0901/1257] ALSA: compress: reject buffer geometry change on gapless next_track
Date: Sat,  7 Nov 2026 08:53:17 -0500
Message-ID: <20261107135004.216279558@linuxfoundation.org>
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
index 85abcca385024..6edd1375a867a 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -669,9 +669,19 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
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



