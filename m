Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031822;
	b=TLBVbUhP84Fp48zwSXkMXoWcVFn91+drCNJ8iAgzs/KHmxCFWuBB8G6JGRzUCipIcejs
	 ZD1mZUBRlMrOoRiOQXSEQ3OiaPGuL9W1kr0js8AffERDoO2hyGJA4c5q+KEcsDYjInnzn
	 yqrU7oAD4L/fRO8jFSgHgmwxGNQEWMAGD29eb6a0JRmUW5RLxi3ilZIaFOteW7Nocsp2A
	 QCMg6MlZBPmAioVp6U7lw1AUj8oqq+t+bRtYMMiAy773AFhL5m86ho8UQxXBd3JuyoG1U
	 w1I0aYdhOxs+XPkAGY9afuH3o03gxm+7j7xUBvAos/OtMcuEPcB08uko4AzsQ4PqgBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6hz+61Korzq/Lh9RRPV54uHNz40tnOkTiKcXVQksgFk=;
	b=JjLgXc8F/LD2jIePatcjdFEyrjFJiZjLELBZ0rR/7XMFCpvjJVq6SABspAkgGfRC+Tcc
	 DyCRVUMnYf+RuPQLAVBRB2bnNFx9yno+/qtspoz4sZB2hc0Up3+LQYIj/UuPoTwh9eGfp
	 ADViWpAiyV+gDD2QUDd1DFZnVLnVGL9rtqbAJz6Fh2zcTLGBht8kT9DgZnGVAjNX6i+Yc
	 knvy4toT96o7rDtKYS2NJZ2fxxH4fefV8N2038wk04T4iJgLEEdbGrolmu2Gv6PYD6Wn7
	 cA80UAKprXVCazQtKCSnP7KWO2t8pcHoZQD4NDny35kjEbnpNKqqZjzjJU+MbiHtctQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJyzZ2Qi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10E0606A320;
	Wed, 18 Nov 2026 19:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJyzZ2Qi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EDD1F000C5;
	Wed, 18 Nov 2026 19:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031822;
	bh=6hz+61Korzq/Lh9RRPV54uHNz40tnOkTiKcXVQksgFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJyzZ2QiGjRVabf4czKV2yHS/JoQ90a28PMoBTIfR4jA5kdtv2sfr013VhQQw/Y9O
	 4aABXdynpqwOFfiZrt0UFlXWoNtB0uO+MbAozmd6ShCILMmN/C4DlFXaWnWQpXZZLR
	 Mc3WNNbXC5A18+6yAiNwPbwKJqnTsfBPHbo2ZkB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1152/1756] ASoC: amd: ps: Fix acp63_sdw_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:54:39 +0100
Message-ID: <20261118150055.894990947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 45dd2b22ea8934ed69dd05e6ecbf3c66ac3baebf ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp63_sdw_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: f722917350ee ("ASoC: amd: ps: add SoundWire dma driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/ps-sdw-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/ps-sdw-dma.c b/sound/soc/amd/ps/ps-sdw-dma.c
index 3b4b9c6b3171e..fc470b18a2de6 100644
--- a/sound/soc/amd/ps/ps-sdw-dma.c
+++ b/sound/soc/amd/ps/ps-sdw-dma.c
@@ -243,7 +243,7 @@ static int acp63_sdw_dma_open(struct snd_soc_component *component,
 	stream->stream_id = cpu_dai->id;
 	stream->instance = amd_manager->instance;
 	runtime->private_data = stream;
-	return ret;
+	return 0;
 }
 
 static int acp63_sdw_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



