Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585589;
	b=lXhLEu85/gLGSoSTjeuhOhLpB+fGbBVZ+z+PWvb7O+oEv2yiPXXbMulz47Dkq9jN9D9l
	 WORHsHZT3V+0KPb5MP7ko4S0+H2PYA7olBchjDcVgFXC0vlyP96rxhtduyo0s/gYfzhwX
	 6oc18e1SvRzaYBNqbIk45WMXuGzOMGd5f5cvzJltORj+k6qzft0JGZDND4R7ExJV8/k40
	 Mej5tAEDoaQTYmaQ/KftFpVhTqH1r4x4WgCfpjC0XaTuxA+fE9TYZ4B7lHekeM4qY8T3s
	 xq4jrK/wZeIhi+Rew75WgKFaVI+uAhIMxGViihMRQDBicethVKFyKt6CRWBKYJMQFJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZfUzA9cheh4XH1FnEPhSEh1ZZey7cU8/ypgkWG2MgO4=;
	b=JRlHctAFkPMHlpXMKjpF/lsTCJBAzTYYLGHm8kHF7ZmSUoq6Vf1VzM3yCmKQYVoh8OeQ
	 YnzGFnrtWb4PMiHoi5iRUirbLGg+M7Oa4sh61xk6XBo5j3uXBSEAAlEAotduJXmDDby33
	 pqzr0JoSnUp1Fq4qNPtlwOCZmM8P9jneI9izzr0hhhtKuAJF9wIfKtJY3sIapBX6mnlhR
	 bljAh84s8k1FxYPhrx0GEiNDJFXdUeqC+VBMbs0xVXhasD4/g6+Mv03dJjMLHdhjhjwNk
	 /eBMhhiYja96agKmWB+RadgohIZyLBjkxJJce0S8lnO2y+sxJqJerxhohBsEgmvz4dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xcz4fRyf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAD4606FFE9;
	Fri, 13 Nov 2026 15:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xcz4fRyf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD80F1F000C4;
	Fri, 13 Nov 2026 15:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585589;
	bh=ZfUzA9cheh4XH1FnEPhSEh1ZZey7cU8/ypgkWG2MgO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xcz4fRyfA1uS++6I+SOYiPtA1GneEouNIt0oLB7r0wN4WcDWeQDnk45O9lohv0YpF
	 Z6k0JXgYtRpc4AhzK7TKXIopogpKU/7XO7gCi4e3fDtIConaQo7TWmrqjBv0cIs0xm
	 OK2ncvmURF8Z3SB7zyoCtwpIqoK2t2CLOs9vIxpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	Mohit Sharma <mohit.sharma@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 218/507] ASoC: qcom: q6apm: Guard callbacks until probe data is ready
Date: Fri, 13 Nov 2026 10:48:42 -0500
Message-ID: <20261113153801.877386764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Mohit Sharma <mohit.sharma@oss.qualcomm.com>

[ Upstream commit ef7062864c0511bba52775d0eb3aa72d886b5f3a ]

The GPR bus needs to make response callbacks available before invoking a
client probe because clients can issue synchronous commands from probe.
This creates a short interval where a callback can run before the client
has published its private data.

Make q6apm publish its driver data only after all callback-visible state
has been initialized. Have the q6apm and q6prm callbacks ignore packets
received before driver data is available.

Fixes: ec1471a898cc ("soc: qcom: apr: Add GPR support")
Cc: stable@vger.kernel.org
Co-developed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: Mohit Sharma <mohit.sharma@oss.qualcomm.com>
Link: https://patch.msgid.link/20261022144130.2443667-2-mohit.sharma@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm.c | 6 ++++--
 sound/soc/qcom/qdsp6/q6prm.c | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index a79bbb34c777e..8a756249e5884 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -884,8 +884,6 @@ static int apm_probe(gpr_device_t *gdev)
 	if (!apm)
 		return -ENOMEM;
 
-	dev_set_drvdata(dev, apm);
-
 	mutex_init(&apm->lock);
 	apm->dev = dev;
 	apm->gdev = gdev;
@@ -899,6 +897,7 @@ static int apm_probe(gpr_device_t *gdev)
 
 	idr_init(&apm->modules_idr);
 
+	dev_set_drvdata(dev, apm);
 	g_apm = apm;
 
 	q6apm_get_apm_state(apm);
@@ -942,6 +941,9 @@ static int apm_callback(const struct gpr_resp_pkt *data, void *priv, int op)
 	const struct gpr_hdr *hdr = &data->hdr;
 	int graph_id, is_pos_buf;
 
+	if (!apm)
+		return 0;
+
 	result = data->payload;
 
 	switch (hdr->opcode) {
diff --git a/sound/soc/qcom/qdsp6/q6prm.c b/sound/soc/qcom/qdsp6/q6prm.c
index 1f3ce4cc08370..bcc73127d54db 100644
--- a/sound/soc/qcom/qdsp6/q6prm.c
+++ b/sound/soc/qcom/qdsp6/q6prm.c
@@ -192,6 +192,9 @@ static int prm_callback(const struct gpr_resp_pkt *data, void *priv, int op)
 	const struct gpr_ibasic_rsp_result_t *result;
 	const struct gpr_hdr *hdr = &data->hdr;
 
+	if (!prm)
+		return 0;
+
 	switch (hdr->opcode) {
 	case PRM_CMD_RSP_REQUEST_HW_RSC:
 	case PRM_CMD_RSP_RELEASE_HW_RSC:
-- 
2.53.0



