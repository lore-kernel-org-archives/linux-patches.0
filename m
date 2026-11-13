Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591125;
	b=uDnf8hW59Z9mPa0Pa4hQJw9UJxTsIwi4/sdFgb99ucG7lY4TCL9b4Dft+f6o0fDJE+M0
	 oPf8BDH4aUx9IAggfOnBF9MVRXDIMeSEfeFx5i9H1dXPTJMMJKVkX4tJsNerX2JPaTtPF
	 eGAMtsutyi8a5ERBG7dW/GGrfOwKTebzS6/druBjrJ7RRiRtyCh8gmo+Alaq5jAPnn2UU
	 nXCXtbGOPB+cA6ONsPDf1BEM9uZKOcH2dLzADD1LzCrGNWUCqJe2jNWKR+jdwI1TJ99+r
	 0mqYZu78u/wfBvUUssfONCWjeK2agvesbwHWYi/0+7FNCRAyFCx49GU10D1XL2zsZ6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r54NnGbigODRLhY00745ZHK+EA1+f41uQyUAaTwsq+M=;
	b=pOOCjhZR48E6HlfW0LLC46HlVt4vjGw3CpbQ8wj/gs+gFU1oT9Paxq3AeZYR5bdWvqiu
	 +w77MKANUQOXv1HU/lOLQKh9Wmy0MlMtNWc9KvYeWPf6B/Vx8UqYgDCWu2CKcx8VE4vIO
	 j0cg1Y+0Y8Qj3NF/AAAYhJUIBzgCBexhMopSxduoz14wzQNHR7g+VM8saokKALw8yCgnr
	 h8J6UqlzTQb6mnsT/Ieof+nRhpubHcJTa6eabtsbwAdvex+MzzDyLVPZBfBG/fOEk83Wj
	 o6priVr9g5jcXhMjWevccdNta4geUozekgM8RSz/VK5DOKD/Q5R5xO4o5ZDTlFaB8GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rIAJEaQ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D92606B379;
	Fri, 13 Nov 2026 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rIAJEaQ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCBE1F000C7;
	Fri, 13 Nov 2026 17:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591125;
	bh=r54NnGbigODRLhY00745ZHK+EA1+f41uQyUAaTwsq+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rIAJEaQ9aslDpXHNRgT64nKXZ9WJk82T/42+a2C2Yfp+8mDK9+ECsS5T1DC+51CP8
	 d9gCKvL5Szq8P9mcQK2RnE6uL0RJAeWACAwPQS+/R1S9PV2NO4LJJLSTadyNp1I+E0
	 QfX1O+ZJQa1vkntz82SS1e0LpNdDot405MXdJHos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	Mohit Sharma <mohit.sharma@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/670] ASoC: qcom: q6apm: Guard callbacks until probe data is ready
Date: Fri, 13 Nov 2026 10:47:18 -0500
Message-ID: <20261113153821.177536226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 426c1429d01be..1025ddde9e316 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -762,8 +762,6 @@ static int apm_probe(gpr_device_t *gdev)
 	if (!apm)
 		return -ENOMEM;
 
-	dev_set_drvdata(dev, apm);
-
 	mutex_init(&apm->lock);
 	apm->dev = dev;
 	apm->gdev = gdev;
@@ -777,6 +775,7 @@ static int apm_probe(gpr_device_t *gdev)
 
 	idr_init(&apm->modules_idr);
 
+	dev_set_drvdata(dev, apm);
 	g_apm = apm;
 
 	q6apm_get_apm_state(apm);
@@ -817,6 +816,9 @@ static int apm_callback(struct gpr_resp_pkt *data, void *priv, int op)
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



