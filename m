Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036641;
	b=KYym15om73BZI64bmsFfPEUskKJ31UND/2o1MtlDSvIHKalekHr+8ngDABTblLBHH8MJ
	 0mx0OSUO6Y9ua4p33e4fGaEoQTLQjb0d0qhM1NQbLJ4S85UybeHrypZjf1zHxtOmdpJof
	 uGmjgmFc0CPPUw5JvSf5PPmfxngpxHVHCPoAcuDro/GmSyVU1BVCVsoFx/+ZxzNTRnp1l
	 7V3Q1SvOpOQ9jHhvicqW+FZDnjqbltBXg5246WdoQvEht9rZiXvqvQlyfawaMJ26yx5/7
	 r6iW5gL7b/4fYTfn0gHOfUYYN3Bq1CauDi7pib1NGzhQEHZks6J7bHOq0Rg5E15mgRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zpvwVryC7nBU8aZuhxqQaB64BclcsYMNKUSwGg2D2Z4=;
	b=KMOoJeUfHAK5wNc2Ehi8l8a9QizVQshBF5rjsRZ56UAVG7c51/Rzw5DM2ztwsL68hP8L
	 hgv1Xm/MZdhmyxAvaxUCeSfG4lE/QmcEwJinCG83wMDHlMJ/jKzdcQ8ef8AYshoqlhJVv
	 617pFvKdxwQNyJWh5/VYYn2ZkEWmp3rgglAX6m/QAxDGwHxIVSsTy7FtM+778W4TfxBG7
	 jt35eiijpoLSnXhcVTJQLhuqsRXqECawirAjLkbKw0LJoJq/sqGTuVBSBr0BDNNaM0eFw
	 DJt77phrmDhDMEV6MbjH1/ou53KZhmTb8iZ0dJqiYWairAocfGSXFp8ZEQpmZJJtZCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DoI7BdnA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5CC606A320;
	Wed, 18 Nov 2026 21:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DoI7BdnA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EBC1F000C4;
	Wed, 18 Nov 2026 21:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036641;
	bh=zpvwVryC7nBU8aZuhxqQaB64BclcsYMNKUSwGg2D2Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DoI7BdnAA2/boDrg1Mx4EGLYH7MHviVKBnQ4hkHqshMkyAAN4G/hcFpbhOlUVECgB
	 38OJxmePjXurX1yj8zlPMaNpX9bOsJNaWDZXxw5o15npyGcCyw4EOkA64Vw3IBgaFi
	 RlYrDmHQ37OIf/G8P1eZpq2S7bD97/KzSnnnqN64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladyslav Tymoshchuk <tvlad744@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1132/3318] ASoC: qcom: q6apm: reset the hw pointer with the fragment queue
Date: Wed, 18 Nov 2026 15:29:14 +0100
Message-ID: <20261118150354.005539950@linuxfoundation.org>
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



