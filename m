Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619707;
	b=wPW1kiVgPtOhNReISx0eUoHwsT0R0LBund39Z3GpVV8PJKCZlqhf32CW5nKjFSV0X37H
	 UIARPYuCGD2DhfpUB8SgRbEZFrne6a9BUwi5/yqJjnZjDqp142Lqf7jxkHuAKxE0hnJAZ
	 3Eu87SzlgkECSo6VxNSrMCIkhcTXa7srNA6GADC/LjY3YTswJIzbcYb5hCLncwDUaYJ6K
	 b5Af+ZXKLEC59aTdS90RBmRqeBMtYaq+6fca+B/VxinvilnkpJDoZxFjF0Me3xXEfjKzq
	 vUdXnPaGZzk7N8gP3UDxx83nkyzeyTeQDdpoHlK6gw4bjLFwU1u/mP0rp/p94ToaCxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EJSvzFU7ua8dxWU/rlOZA7Y2b+Hb5XIKjSQ4eYGcllg=;
	b=KOgCc8Nfd1354ah43asYRObFAYgD+DQYLzACIYyh8e1MSGK/SxWF83PtXS8XLd3lMMoi
	 g7m6ITAl6galqQMWesy1skjHoR8hMtIeIjrDuejyPdel4jlaMBHztdbq7EhpbGfXmuFQu
	 q+S9uGqXWEjS2Tn1D1t7/L4AO5bsHZVpk+ufF5Te871XLU6vghCKeop/rWma/1CmUp7mj
	 NJP0atQF3evEs2tZtzcEzZNBVJ7rL1o799H2F0yb9VhV3xGJETiukQUBnR0XLKYTSfjxd
	 Fr30inl65kmNGBm9AT37obtlsOL/IeO/kPFMvaXyiM6RSyAyyvNYabMaEuvveqmfIQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UbuUcL14;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8001E606A323;
	Wed, 25 Nov 2026 15:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UbuUcL14
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F1A1F000D2;
	Wed, 25 Nov 2026 15:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619707;
	bh=EJSvzFU7ua8dxWU/rlOZA7Y2b+Hb5XIKjSQ4eYGcllg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbuUcL14hjBgI6kzA/R+b4dFAafaDHNuLGurR9sFiYPMlkgmGge3+P1L7rWgy3+Cs
	 3Bv3kIg/15j0ubX3wpLRlDZnAMCzKOGNLmoyIPoVJWiswYpgrB7Qf+N0Gsx+dP1hMz
	 /MGXd4mekdKlCqdqhczGePSwq1CoeyunoUupnwm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael McAllister <me@michaelmcallister.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.3 0682/1005] ASoC: qcom: q6asm: Reset PCM positions when preparing a stream
Date: Wed, 25 Nov 2026 15:33:40 +0100
Message-ID: <20261125143837.729535512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Michael McAllister <me@michaelmcallister.org>

commit 54e89fab723d5a374972d3f5c3e0b89ae055bd18 upstream.

Preparing an existing PCM stream closes the DSP stream and remaps its
buffers, but leaves queue_ptr, dsp_buf and hw_ptr at their previous
positions. ALSA resets appl_ptr during prepare, so q6asm_dai_ack() can
subtract a stale queue_ptr from the new appl_ptr and queue an incorrect
number of periods.

On the Motorola Moto G10, playback works after opening the PCM device,
but the first write after snd_pcm_drop() and snd_pcm_prepare() fails
with -EBUSY and "Error queuing playback buffer -16".

Reset queue_ptr in prepare, and reset the DSP buffer index and hardware
pointer when allocating the new buffer ring. This keeps the queued,
submitted and completed positions aligned with the new PCM stream.

Fixes: e386c2cf3df2 ("ASoC: qcom: q6asm-dai: schedule all available frames to avoid dsp under-runs")
Fixes: 44432315444c ("ASoC: qcom: q6asm-dai: use q6asm_get_hw_pointer")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Michael McAllister <me@michaelmcallister.org>
Link: https://patch.msgid.link/20261021204202.43738-1-me@michaelmcallister.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6asm-dai.c | 3 +++
 sound/soc/qcom/qdsp6/q6asm.c     | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/sound/soc/qcom/qdsp6/q6asm-dai.c b/sound/soc/qcom/qdsp6/q6asm-dai.c
index dc5230f13a97..77e60b13400c 100644
--- a/sound/soc/qcom/qdsp6/q6asm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6asm-dai.c
@@ -243,6 +243,9 @@ static int q6asm_dai_prepare(struct snd_soc_component *component,
 		prtd->state = Q6ASM_STREAM_STOPPED;
 	}
 
+	/* ALSA resets appl_ptr for every prepare, including xrun recovery. */
+	prtd->queue_ptr = 0;
+
 	ret = q6asm_map_memory_regions(substream->stream, prtd->audio_client,
 				       prtd->phys,
 				       (prtd->pcm_size / prtd->periods),
diff --git a/sound/soc/qcom/qdsp6/q6asm.c b/sound/soc/qcom/qdsp6/q6asm.c
index 3f9f2448eb32..d042132caf03 100644
--- a/sound/soc/qcom/qdsp6/q6asm.c
+++ b/sound/soc/qcom/qdsp6/q6asm.c
@@ -514,6 +514,8 @@ int q6asm_map_memory_regions(unsigned int dir, struct audio_client *ac,
 
 
 	ac->port[dir].buf = buf;
+	ac->port[dir].dsp_buf = 0;
+	atomic_set(&ac->port[dir].hw_ptr, 0);
 
 	buf[0].phys = phys;
 	buf[0].size = period_sz;
-- 
2.56.1



