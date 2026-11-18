Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037777;
	b=Ugv5es1hYC6F1L1w56gN/FGreng+yFedlAf9S67FWmZhdihxdDBcZG0equIu4Z59DO05
	 K8pHQcEmGOR6VIz2yQ968K4AZXLcueSKwRBf3BCHL8eRc05ySHpKe+GlyzUhjIo3SOspL
	 En2H3ZkiRtENFHWcJiOuTcMzlP8yQ+QrByWq4OVqiuXOJg6eKZB08KAYi8MdVwN5+1dup
	 +up9OzlXCnEuJmSwvMyYICrT34sZ+KmVC0NmCX66MWEWfG+FH5c6A+VwcyvjSiinEeN4R
	 OhBcpxNGofFVnNQ1Ye+yNsNodFONmNvNGnH4pqUs3P6RdCM3R+nmFrw25k9Ubftq/2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D05iLTs0PreSaQAhGh8SHM/KN/BeUMBGqy000EtZeM4=;
	b=S0ysBRpM+ktSXBW0/2Bdsun42qkexC0hWgHaL1hXtP6DJQq4XckRYdEvbC+uwbJ+Cwjy
	 Wskn+Rph/mWjT0VF0wTL+/4WZ19GPNUV7TktWiV7iEI0nwim3QeMiwcA7pL/XM+YZko8a
	 S0c4A+dicocKK9v8EwEfZegcgrcVg6Iftm3/7e49B7eQ9GqtQUM4vxnrkYVzJRqXdk8wz
	 mNu9N7inBBcOeIwcRU0+jvqez27X9d06xcGGdYCbJvxe0U4RdP5jVwNEBHWoZ2gbFBgIt
	 u586494AL+fzqmEMj1jLKIzFX2Fo5bm7M8GprCSd0I/6/YTd/cKgoXAkp9ctu9ea32w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itXxKMfB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A77B606A31C;
	Wed, 18 Nov 2026 21:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itXxKMfB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6483B1F000C5;
	Wed, 18 Nov 2026 21:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037777;
	bh=D05iLTs0PreSaQAhGh8SHM/KN/BeUMBGqy000EtZeM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itXxKMfB73uDiEzm5KCm0K4H1tsz2iKxlxt9yG7dQR94+7yAii3qfvx4HgaWMu4zj
	 twCcV/Kl7OuNJwDDhNgKM3RyJqmX2bU7vvGRwahX+ui0QUzXXgsx0CHkL/oUQ2FOoB
	 EetKfAqjc+TPA7yFx3HSw2DRKGrIPHNbrV7YR66U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	Mohit Sharma <mohit.sharma@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1474/3318] ASoC: qcom: q6apm: Guard callbacks until probe data is ready
Date: Wed, 18 Nov 2026 15:34:56 +0100
Message-ID: <20261118150405.120883683@linuxfoundation.org>
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



