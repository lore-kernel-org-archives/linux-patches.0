Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063428;
	b=suhbtoncrlqWWRznYByc3aY5rZcvvSGrpihN3a2Y4YLwm2vGyUU7TG9kUt3Zp9lSbuhY
	 9JKrQkKS0oj+0etN9TfSCoB8sYJIwpIuE9zT1ZKcOHV/sFKRLic+S7ove2tcObFl0CrC/
	 BFXpwmIVCpT7rPGC6cDOdJ9uq/Ok78H74PXEuTsUi4ylUlCXEstOGebL3pzEPlS8B1J+1
	 x/2tmO+/23blpMfJ+JNLdIzUP7sWAMTtHlt75yn6F/bd9p3GfaZ+YFD1Vanq8Vrsw3PBU
	 pfU4xI8zJu7VssS79PZsHZUPgRx/29sQvUnqYufP3Wb9r2/Qfx+t8JOya0nSDupVdVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Q04PYNetNkZ51LXq+AlJF1W40U13sOP6RKG+5zSE4U=;
	b=vDqoBL7KY76fqcSjzwHqXILT/Rf/HYLEGV+bfqMAtl/zGO6qScZFGfWtcHFhVTpPG/22
	 PebJOWCLNjTv0bndsIA8R8cGA+UUiVWHfyQdgbBKXAQTMjpdIX9j4eNTX7OMRQjnhcxPj
	 O/uuOH+YMnwFUsVpO27SaQuOOvi1kwEjHpLMf+b3NLb3uRe/UYuz7IeOXvJHIWa3CN99I
	 z2iG5CMLm52nGi+IUdPTncyF9ty1N09BP4cE+Tsyw8wW4ZyHwyDi2Dou3JmeKBCKiDfNp
	 zZlv5RvY9r2nAPFIEs7r+XNujY71wE4rK8rVEATCM9b9Ly0amGgbt2gCxjIJCGOHA2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2PDIdkV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3F3606EEB8;
	Sat,  7 Nov 2026 14:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2PDIdkV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6021F008A1;
	Sat,  7 Nov 2026 14:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063427;
	bh=+Q04PYNetNkZ51LXq+AlJF1W40U13sOP6RKG+5zSE4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2PDIdkVQ0CaqTsRae7J9wPqgQpTbse0qmBfwqshxKKoMyD5Hqqk/btXExPV/RiEL
	 VORoxvq/rI8Wv/bp43110KRCrToWmr9zSXteSVI16BoCq/E2v6R6/BwVI1vuwVhIaj
	 jDs/rFbh+etrDHMC3XRqc0I8wU6Rm0dhFbZ88dzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladyslav Tymoshchuk <tvlad744@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 592/869] ASoC: qcom: q6apm: reset the hw pointer with the fragment queue
Date: Sat,  7 Nov 2026 08:54:34 -0500
Message-ID: <20261107134913.181741898@linuxfoundation.org>
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

From: Vladyslav Tymoshchuk <tvlad744@gmail.com>

[ Upstream commit 0337b8129cf676b8eb767b2a1f312955760a5460 ]

On every prepare in queue mode, q6apm_dai_prepare() frees and allocates
the fragments again, and q6apm_alloc_fragments() resets dsp_buf, so the
first buffer queued after it is the first one of the ring. The hw
pointer that q6apm_dai_pointer() reports is left as it was.

q6apm-dai used to keep its own position and cleared it in prepare.
Since commit a93dad6f4e6a ("ASoC: q6apm-dai: make use of
q6apm_get_hw_pointer") the position comes from the hw pointer, so a
stream that is prepared again, e.g. to recover from an xrun, reports
the position of the previous run until the DSP returns its first
buffer, while ALSA has reset its own pointer to 0.

Reset the hw pointer together with dsp_buf.

Fixes: a93dad6f4e6a ("ASoC: q6apm-dai: make use of q6apm_get_hw_pointer")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Vladyslav Tymoshchuk <tvlad744@gmail.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261014162703.10172-3-tvlad744@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index 9122876e00a2a..50d5d2143daaf 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -223,6 +223,7 @@ int q6apm_map_memory_regions(struct q6apm_graph *graph, unsigned int dir, phys_a
 	mutex_lock(&graph->lock);
 
 	data->dsp_buf = 0;
+	atomic_set(&data->hw_ptr, 0);
 
 	if (data->buf) {
 		mutex_unlock(&graph->lock);
-- 
2.53.0



