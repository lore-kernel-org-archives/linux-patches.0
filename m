Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034646;
	b=B8G+D+5ndGsebko31xbBASNIievwgtGJRe5z2Q0KD80QDcqF7UcvAGvbM/TOSmaN6pTw
	 eqiAZtJUVuEqYwRmDgur4NPtoAFZDb2paokwh96iJRqMcS2d2hLlaFZoYmxlAouV6d5Ti
	 nZeyu+4ebI7m2aKUL8/c/Di0IeslCdsUn9wqamAqtCJ0CtdeQc68QaQiMWxny0nfPqrTp
	 8LaFSIclFWe7oNdUWzKuioa5KtUQt0bALLZZDktn3iT9+Q7YCn2nA3UkT6tNYcgjsMUaP
	 ylSrseGs24dc29ZoBDEqqWIMQ3NKYOnws8pztEAUr2ZMHF9A97H2yXQ3in4aCzAB7kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qOW0AD1AQzTkDWHHUZ1kZLM77uhJZ9MRe9NdvzhWk20=;
	b=dOEE1s5+DJG0zGiKP4rEVUEaxZ/bPN+Wwl074SXSXswVMZHwhYpO7ZxlwvR+qpwjGBvE
	 yZdUbTbYxoOSb6OS8/bGcj2pEO/HWTHSg2ca8OZjQyRMvFaboa5BNB5aozl1wzkQwj3sM
	 Dq0yrP8caX5tnBlrEWb7T53JhP8vyKdnVM7e1U8omH8Cgie8YhyAUC0iUKZ3MyfHi6t9l
	 6er7jEvmYGN9mAN6sNNfmrJJrqnnsAy+bi2IUN9tBrLAQQ10tc4pJe2R3jCo81XIWrlVe
	 plwlW0HROwlB/gZPjufcIyy/stNn2ZZtRy89j7FQmqr4tfiHijzf5SlSNSL8hMfoV+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OK1m6rKA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135A7606A32F;
	Wed, 18 Nov 2026 20:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OK1m6rKA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647631F000C4;
	Wed, 18 Nov 2026 20:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034645;
	bh=qOW0AD1AQzTkDWHHUZ1kZLM77uhJZ9MRe9NdvzhWk20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OK1m6rKANLfriPuzSsBjfSrNEjcY/didSAetyH0qfSHm5ie2qud45N9Y/AdIL9v2y
	 daySf0akchI76B3RoHdWirXA6CV09XSCUVOxl9j3DFQpDsuakthria7PYFv1OglRvm
	 eUi+tKrvyjakluoBc1Icw1fD86s5oJR7Woat+X0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0444/3318] ALSA: rawmidi: Return the error from snd_rawmidi_input_params()
Date: Wed, 18 Nov 2026 15:17:46 +0100
Message-ID: <20261118150330.043380644@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit f4a23e17d84fd2a152d9e12369761934e1af0ee8 ]

The snd_rawmidi_input_params() computes err for the three invalid mode
combinations and for resize_runtime_buffer(), applies the new framing
and clock type only when err is zero, and then returns 0 anyway.  A
caller that asked for parameters the kernel rejected is told the change
succeeded, and the substream keeps its old buffer.

The open_mutex conversion turned the early returns into assignments.
It handled the output sibling correctly, which still returns err, and
left this one behind.

Fixes: 94b98194b62e ("ALSA: rawmidi: Take open_mutex around parameter changes")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260902125058.19499-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/rawmidi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 9ffbaa184dfdb..7da8ce4c1ef09 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -780,7 +780,7 @@ int snd_rawmidi_input_params(struct snd_rawmidi_substream *substream,
 		substream->framing = framing;
 		substream->clock_type = clock_type;
 	}
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(snd_rawmidi_input_params);
 
-- 
2.53.0



