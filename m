Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031820;
	b=uaPSKqXcWGbcnvqdu+kAg8tWQ1tb/w+CsjbbZGcFBo4/lZ+J8kEt0sTwjTv3JT/mf835
	 6xHSwF6H1b4kHhIBhw19ebGk1stvKvIjlrAVcRCdinxAMqCjzpg/WgoL+JGzGonLtczRJ
	 jBKSDbochuhqzCNUOGYQr1MABrLLJb03ZGmmByMdph1Fb90yAZqP0QrFcNXkA0nnsz/LC
	 jCw0Tfl/w296eDkUgZUremDtggIERqdwqNYOpIRoohQXoR72us9PU5pWb7AiSoNmo+piN
	 Qke/GcU69TQbc8FzCI2Afz0KvuufvetLVFVOJEDLqba9pOJYczTEZEl0kOBns2nijUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vxk/WmOQYO2A1S7ZHKpdg+yWdUzqjZy6Kfgu+cdVqTA=;
	b=1vKTzZ72UBlxgx0kNGb/mg018oSH4BHEOviEmkg26vhv25pzu9yaC8zyYp8Ma+LbQVZr
	 V5m5AX3u5vVJvfr/1b5+PqN8aUvd+oWnoMWxSa6lGqPKazsxFfvUOpYiRuGwZ176cKW8x
	 oW72XRsoiRlgIck4OprttLCZsgw5kJDJZacwfjxYv3GmdEDzgC1v3l7g3uMZ+8Tj9AqEu
	 tmlSz0q4e2mmqwTq9kCLXrIo8esn6k8uSuGcXHOQnBovcIP0uPEkdOWDaUPQ0v+Edtp8D
	 vdF1X+GR9fQgE9wLkpT5urJ+t4z0mJzBOf54tzvkTuGrAvZtsyutq5vsqAdLtBuXOyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WoqzzYMn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C943606A31C;
	Wed, 18 Nov 2026 19:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WoqzzYMn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E13A1F000C5;
	Wed, 18 Nov 2026 19:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031819;
	bh=vxk/WmOQYO2A1S7ZHKpdg+yWdUzqjZy6Kfgu+cdVqTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WoqzzYMnPX4viQu1C2PhajfmbPl9wDrwNJyaoZnKZsoYrnJVWIcJLkoA3A2w2BhbZ
	 VVZSL9MZORrK3d4REBh5Bqzdv9kXw24vJFc7fonJlx1+qIgmD2vwhBu/RzSAJ1gAEw
	 7Ulcvwpik8YZD07Xb+Mv5XWFTm04eJWy0ctiQIkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1151/1756] ASoC: amd: ps: Fix acp63_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:54:38 +0100
Message-ID: <20261118150055.859554383@linuxfoundation.org>
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

[ Upstream commit 172888114dda96492d40e4a6e0ed16146cb76e2b ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp63_pdm_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 5137305662ef ("ASoC: amd: add acp6.2 pdm driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/ps-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/ps-pdm-dma.c b/sound/soc/amd/ps/ps-pdm-dma.c
index 318fc260f293f..f3f1a9b059260 100644
--- a/sound/soc/amd/ps/ps-pdm-dma.c
+++ b/sound/soc/amd/ps/ps-pdm-dma.c
@@ -211,7 +211,7 @@ static int acp63_pdm_dma_open(struct snd_soc_component *component,
 
 	pdm_data->acp63_base = adata->acp63_base;
 	runtime->private_data = pdm_data;
-	return ret;
+	return 0;
 }
 
 static int acp63_pdm_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



