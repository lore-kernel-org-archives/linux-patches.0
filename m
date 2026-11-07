Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064908;
	b=4L8JvNkCNrCMeKvPfQGFl9GvmGzBpVkX1588A2PcevjFXSxuw5c0REqA6e8QgbSjTnrY
	 J1eYr5pBrqxs0HW8ep202nJrbYDGLEqRl7dDa09Z9/ftFSIbwOP1rOv+hgHH9cxuuhxvo
	 j8P6foUH4sbw0HLBPTEoD4grTVSNcQiEQOqLtBrJjLMAkCo93mFjSIVto5EHS2SvyHQ/F
	 4jdh4MOLPqhK5e4Rto930bmHP6PUC+WJ29m3Qa2j8LOnUHXwbosX91l/XlbdS62S5ouA3
	 sXOij0pS3wJaS1cdAtN05NNXVsR3ufiAAYayoC/WFNedlUZWGVqGSQIB8Lh/fjG+1eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o4z4Z6gujaXT8hdRFprnRlwr/AN9euT6JWeykNCFABI=;
	b=CP0tuW+FgORMruIMONmHFlD3SMWdPVzSn6Gfwx/iOlEukV7EeDjprCOcBnluGlm3VVOo
	 pSsgWk24GwQvz2qMgwqvxo1s94jgFEJ4V1N7/frg5IKpZ2ZwzvsXwl3AczsVtEK+eHdMB
	 UWTgZPulnGgIr/SNjTiJ0BfokZqS0/r4G4S1SSd50MxG6OxKkOymop4vMLP6lgB7pXhkv
	 vFMwIJhzKSU1NWcUPlFz8PgM+USSl2J6hG5MXrGET8ChLjAr81cRQgwFzsByvxtL2S0cL
	 F0i/KyAwkgxN5CVK9UGwKxaHEKenHsCbZsv4Uy517Sm3Pf198pDEoUkCO9gCGho61SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oZysN6i8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336D3606A9CA;
	Sat,  7 Nov 2026 15:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oZysN6i8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCCF1F0089F;
	Sat,  7 Nov 2026 15:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064907;
	bh=o4z4Z6gujaXT8hdRFprnRlwr/AN9euT6JWeykNCFABI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZysN6i8G14yEHtT6wQ8YV05ECWNnitej2W1s2wW9G/oqRNVfGalhH1Sl50csU0rv
	 /yqW/UIAX5OIp5JJA3OFCDLf5yhrtv84lk+Dx0Snla59LJQSJs9BEWWc13AxAZY4AW
	 ng2KmvcZFc94aoL7er4WaVcHLGvJc/y5rKH2rUzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladyslav Tymoshchuk <tvlad744@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0809/1257] ASoC: qcom: q6apm: reset the hw pointer with the fragment queue
Date: Sat,  7 Nov 2026 08:51:45 -0500
Message-ID: <20261107135001.683902492@linuxfoundation.org>
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
index f167b9dae3fa1..4467652aeb044 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -283,6 +283,7 @@ int q6apm_alloc_fragments(struct q6apm_graph *graph, unsigned int dir, phys_addr
 	mutex_lock(&graph->lock);
 
 	data->dsp_buf = 0;
+	atomic_set(&data->hw_ptr, 0);
 
 	if (data->buf) {
 		mutex_unlock(&graph->lock);
-- 
2.53.0



