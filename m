Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047592;
	b=XGVN3oZHFdziw39ksbKArkGzqtnimHx+FUUfr5S3dhi86Rg/0E/N8CR561v+Lht8gkHa
	 loym2W68YVVJA4w9mbU634vpropEDomt8kYojKuIE8tqK8VSTBLMhAyj0ipz66obXcC3Y
	 2BcvZYL375IVZw4oe+UIAui46fiWz21DVQ5qdxjfNvI0d2mzJyC24HcJO/NU2bKYYjqqL
	 +8C+qDX8YPvddueSVU3pVgkbRXm+tYmNw0q1b3p0EybCwv2igQGwNvAbec4QcZTb6reQ8
	 FMZS5pqN7415sMIMT+SGRGyc2DOwpMqSOlVtDiAJx14XElpMb65RKBCjW8CVzuMPGVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UDa0i5RyoT+sdnppzraPTmVpBjyBl++Ia1EX0Gdp2FE=;
	b=SnoZ+c9eahwBfCVR+QBCWVkqTpOK6q/fyhoCHV+e2ZBMvXPd90g+DPxoBQZfWzDeDVWa
	 8dWJdJZBtEGBUFolfc6f6rgyHgKaz7ya9Q+xgRse81/P0IKcylTCDgUwD/v1/ftdzHEJf
	 E/4pUuP+Au2VKW2uoiuUyYkg4wX3379UMUwHjCe1J/iAXqrywTRmOc3MEF3QS3aij7crq
	 7aF3Jz8gugqjk0ZpJTAOqSIbHsl8Mt3fYT2P3KZ99OkVv3iEq7tXvU+drJIpZTNr6g0yD
	 MsMJg8A8C7wf0nk1U2Tkdt7ciV0MRBMCwmM8aWcr1U8yXrSrqA8ZKROruIYlxt9ahMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oGzGSMwV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAE2606A31C;
	Thu, 19 Nov 2026 00:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oGzGSMwV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8E61F000C4;
	Thu, 19 Nov 2026 00:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047592;
	bh=UDa0i5RyoT+sdnppzraPTmVpBjyBl++Ia1EX0Gdp2FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGzGSMwV5ldF4SGF7JsYeFTzIzrZySoK7mDKtJWaoHyo5pIWhKtHQw+ai96M1NHPx
	 nOGjER/C2/nQwa7vg0ZUJ7tY/OiPrOCLsjqPkmzz625v4AcxNmdTVUKiWU8QuiICGx
	 xrdpKrv9PXAp5Wj3hhhWISgcKml58e03AL/l9Cn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	Mohit Sharma <mohit.sharma@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1695/2857] ASoC: qcom: q6apm: Guard callbacks until probe data is ready
Date: Wed, 18 Nov 2026 15:45:29 +0100
Message-ID: <20261118150302.365138290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4f9143b903b31..8529381139865 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -757,8 +757,6 @@ static int apm_probe(gpr_device_t *gdev)
 	if (!apm)
 		return -ENOMEM;
 
-	dev_set_drvdata(dev, apm);
-
 	mutex_init(&apm->lock);
 	apm->dev = dev;
 	apm->gdev = gdev;
@@ -771,6 +769,7 @@ static int apm_probe(gpr_device_t *gdev)
 
 	idr_init(&apm->modules_idr);
 
+	dev_set_drvdata(dev, apm);
 	g_apm = apm;
 
 	q6apm_get_apm_state(apm);
@@ -811,6 +810,9 @@ static int apm_callback(struct gpr_resp_pkt *data, void *priv, int op)
 	struct gpr_ibasic_rsp_result_t *result;
 	struct gpr_hdr *hdr = &data->hdr;
 
+	if (!apm)
+		return 0;
+
 	result = data->payload;
 
 	switch (hdr->opcode) {
diff --git a/sound/soc/qcom/qdsp6/q6prm.c b/sound/soc/qcom/qdsp6/q6prm.c
index e3b8ddeb769eb..16504683ed725 100644
--- a/sound/soc/qcom/qdsp6/q6prm.c
+++ b/sound/soc/qcom/qdsp6/q6prm.c
@@ -197,6 +197,9 @@ static int prm_callback(struct gpr_resp_pkt *data, void *priv, int op)
 	struct gpr_ibasic_rsp_result_t *result;
 	struct gpr_hdr *hdr = &data->hdr;
 
+	if (!prm)
+		return 0;
+
 	switch (hdr->opcode) {
 	case PRM_CMD_RSP_REQUEST_HW_RSC:
 	case PRM_CMD_RSP_RELEASE_HW_RSC:
-- 
2.53.0



