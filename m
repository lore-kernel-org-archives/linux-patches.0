Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062424;
	b=2xTs38bF64AcM+TaLWlmEl8MGpFXdEN0fRz/vnlQDUV9fPRzkvIulhhMrWqYaPrOzux/
	 NPfAFPv9CBU1nLN4/m3DW693JuMhGOhWtTWlkGXy002Zg9Nap3IYzMfqTWupaAmxpPKey
	 Kz9ny135Oz1UccNXNJ2luBYP6VBNhu9ZHdN+79pQParPjw1G461tba2bOz0yYno+g4ena
	 0qL39wLzgmj0Yald7W6ECTXyZwHfMWWmQLMJ3LDFEcGxzz++aVJdy/yQSZzPG8EALLfex
	 FlXkUbf42RyPxUTG/mVSWB/D14DlPCrGLMGecK4LlVdMRtb5H2/OBdPxCfBKr2xjn7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7/BQLCSaN2Wny9L8r8ApDvzh7C91Q8dNIPfBxBsKt8E=;
	b=3wkn5VsI7PUByE/SjptT6fgdTIR/lG2kn/8+R4eNsyWd7bhMmuYeSgxaq7nP4C24ywiU
	 goJKcKUCgT7MybZ8F+DoIHq/vmh0EV+PN2F6LDjLZXSpbhELyDtzOkyNAjAqDHYsifz+C
	 iGELhehu5aXdO3yW4tGnOhpMv+1Un8ErDYmrHYlVeEtnkmPH8UAo6/Vhl2eDbHvdnf+PK
	 G5iaBKBSxfcMIouKRpN1c1W4wdIrWngBNcmOj0vY8gNOHOmqKlK8RRzSX3+OyBGCOd4x9
	 YCIQA1LuHuJcPWBXK4thn+lg11cNenOGq80iuOtUiF8fRQ11m/4+UCK4ZBoGdCJM8ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AcFzEh09;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3972460A261B;
	Sat,  7 Nov 2026 14:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AcFzEh09
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB45E1F0089F;
	Sat,  7 Nov 2026 14:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062424;
	bh=7/BQLCSaN2Wny9L8r8ApDvzh7C91Q8dNIPfBxBsKt8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AcFzEh094rofr71ZlBZ0erMBB+OnhQzRoTHum0oUPZxIPK7VBIsql0WiyNL5KqYaR
	 bRAd+DQopsniOhdZToCOsXvEqbgrzN4ewGkjC0xQhgn/ZP7WQ61nZ+ERRpsmPK0XDJ
	 Vk6D9nQPe2K2S/P+nYdtTuVz688V76eq+mcSPppc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladyslav Tymoshchuk <tvlad744@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1320/1536] ASoC: qcom: q6apm: reset the hw pointer with the fragment queue
Date: Sat,  7 Nov 2026 08:55:36 -0500
Message-ID: <20261107135034.882422555@linuxfoundation.org>
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
index 50a496e665f85..426c1429d01be 100644
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



