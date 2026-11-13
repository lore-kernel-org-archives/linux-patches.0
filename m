Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590324;
	b=wkWfOTVUrGKZBOtaXqSpLpWptz0/rRgypZVA2wKHdOw9Fhe4JwMpgMWN8nbD1X4Neg4G
	 olFFSMCh3drhoL9yN8PuWSMc7uI4iDcEIuJik0lUXtHIwSJNCAL2phrNYjRchs2pyWQah
	 9HVx2eT1gpzdgo3si+cW02/byOOW7UY0+HMoehN69cpHMjQnV+UX0DK+ADo6aZh2nEk0n
	 DWycSr3dU4GKH+2gboYpBkWPQgbafYBrn3Y+o6L3sX3Qo4aV4c6gmsVFVmsWGw2SyKxeb
	 EaIuZCvYVvEX6aRzyRyjmsWlkAj/jbovdSZcSEPT8qPYN2E+SEWAdmmhrnykX/BbLVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tQ107kMt9jDAidD4b/JLyRBkbX8WSuJQoaUByM7ls00=;
	b=23anUfuvG5p0Rm8k09w9Vi8XX6afmntfreQNPVk/pHyEe4tVsoSxphqgOeboEdPIgpBA
	 nrDqd6oMTrL1sdWPj7272ugRxOrXYkW/57rvri7ntvhrmHIP3aMrA8HvB0AVHvawK5Iwp
	 T5U9gx+AHcQR0l1Ms//zlt5K0cPyfqiYbofvy48z0P1IfG36ybBw7yJ+W2vMD85/R46Kf
	 YpMrsvIGs0c9ZvZzHdbbUAsr5bmRLuroGg9JCq4GdDXsHZKo1ZaW2x5vVrEUdwPDhLmu8
	 y6fUGh8ly6mgboVK2d+lRwzolZj7YyNtL5cV8NTVCWTRQ8oGWsOlPHuTGI7H9XrO47g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hBc8+CjK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7667607EE51;
	Fri, 13 Nov 2026 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hBc8+CjK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621DF1F000C4;
	Fri, 13 Nov 2026 17:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590324;
	bh=tQ107kMt9jDAidD4b/JLyRBkbX8WSuJQoaUByM7ls00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBc8+CjK3S5aukEON18S2pB6TsiE6nP0PyDEUMS9LOpu0ET7bg9MHzetTlnuyqg6a
	 gsWF+Iln2Aunrt3EGiaGbfWIRJcW7XLbAruWsVMqZb6vJz0vH0YCrDLCskjsNkUFV3
	 1pS0u8UwO+o0HfFj1QPTS+fqOc9R5WdsTXPX8enI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	Mohit Sharma <mohit.sharma@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 305/686] ASoC: qcom: q6apm: Guard callbacks until probe data is ready
Date: Fri, 13 Nov 2026 10:47:18 -0500
Message-ID: <20261113153831.288877784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 50d5d2143daaf..7894d4430ff17 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -765,8 +765,6 @@ static int apm_probe(gpr_device_t *gdev)
 	if (!apm)
 		return -ENOMEM;
 
-	dev_set_drvdata(dev, apm);
-
 	mutex_init(&apm->lock);
 	apm->dev = dev;
 	apm->gdev = gdev;
@@ -780,6 +778,7 @@ static int apm_probe(gpr_device_t *gdev)
 
 	idr_init(&apm->modules_idr);
 
+	dev_set_drvdata(dev, apm);
 	g_apm = apm;
 
 	q6apm_get_apm_state(apm);
@@ -820,6 +819,9 @@ static int apm_callback(struct gpr_resp_pkt *data, void *priv, int op)
 	struct gpr_ibasic_rsp_result_t *result;
 	struct gpr_hdr *hdr = &data->hdr;
 
+	if (!apm)
+		return 0;
+
 	result = data->payload;
 
 	switch (hdr->opcode) {
diff --git a/sound/soc/qcom/qdsp6/q6prm.c b/sound/soc/qcom/qdsp6/q6prm.c
index 81554d2026589..22e2a174a3871 100644
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



