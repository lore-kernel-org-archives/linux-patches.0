Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022592;
	b=rsPB8m6R3BoXmLnmXsygJZrXxY0xc9lvh/Qcu2+u+rgUhwy1RwdKpbrbq0rBH/vQ0rNu
	 IMxrv/95LrfqsRwjovS2QYNK4mOnrc1cma5ZFDBH5qdUWed9f0bdeT3Ejr6OWaRoHs1NR
	 20A3KACJfla2uZVs2RIug0egB14D5W14J42pObfPVZzd7gKNy41ZZfQS1CUGEMxOk2ChQ
	 lPv6YyW9Ws62fTRbV39swM4bXOgL+70wnRJpzlWkAHD3K9oyN4aGatvLyTp20bfOSRcUV
	 UnPNFuOJr0PrsuQfEiak+wiVW073v+eB4cfp8nMtN1F+pG1ChBGxwj4/rHL4WCj5k7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bwrfmdjWhvUw+6FU7nj4A8uGFpmWol+Np83/detiKgk=;
	b=D1i4XEHlVavFx/4yV0LgbCFOXJk6LOPa9mbJ+Hm4ZFYsEPfewvcfg2tZcXKCxV7taLGq
	 0LAxFu9bVkzrbHnhhD5Bc+7uLInlHmA/D56SfQiJXAW9P0z2gF1IVpl3D1jOIwVG/qqsb
	 KEObXap92qNQccaiS59yiZ6eNVyiCsyb0OXYVd4ca2QeIaAmfiXxoUf4ZdB8pcvJedDMM
	 yRsRFriUUp2RdMyXfdyeX8ZHGzGTZ5TsjBIct54bPdWM85uUt7pmGFLap7g1D2mWYx52x
	 TtSAtlulIt7pBjxZVoCB93UcjmmhqUzGZ0wFzj/0JH9+cRj5PpVxD2k753p/bZ5Yj7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tiPYXgXM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AE1606A31C;
	Wed, 18 Nov 2026 17:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tiPYXgXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E671F000C5;
	Wed, 18 Nov 2026 17:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022592;
	bh=bwrfmdjWhvUw+6FU7nj4A8uGFpmWol+Np83/detiKgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tiPYXgXMSdhKqIYgSL2yuGrW3vB82iBlHFfWiW8VYEipGv0XmT+TJRaRRI41Kzulg
	 5ksvCAHQH4KJZgh7FrnrhYbMAF8T7DugE+gsgRP9MZ8A3S6JGppUvLgK3TRTR5DYwD
	 FpPfVsLbk3MqcGSYDWGOhn6/n022YXnKHNuSh0Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Wang <kevin.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0068/2151] drm/amd/pm: populate unique ID for smu 13.0.7
Date: Wed, 18 Nov 2026 15:30:03 +0100
Message-ID: <20261118150124.236854037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Kevin Wang <kevin.wang@amd.com>

[ Upstream commit 079f9103d9cde68fb2ccc414e94520f43ee102de ]

The smu 13.0.7 backend does not register get_unique_id, leaving
adev->unique_id at zero and KFD topology without the stable GPU
identifier consumed by HIP.

The failure is observed at:
    auto ierr = hipDeviceGetUuid(&uuid, 0);

Fixes: 113cc31dde66 ("drm/amd/pm: add SMU_13_0_7 ppt_funcs for SMU_13_0_7")
Signed-off-by: Kevin Wang <kevin.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5e2585daaf8336d9ce1bf52e55a9b7a8cdbf625b)
Cc: stable@vger.kernel.org
[ sashal: Moved the callback before smu_v13_0_7_ppt_funcs because the surrounding upstream functions are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 9947b3f6bb5fb..5df28b89cb696 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2836,6 +2836,25 @@ static int smu_v13_0_7_update_pcie_parameters(struct smu_context *smu,
 	return ret;
 }
 
+static void smu_v13_0_7_get_unique_id(struct smu_context *smu)
+{
+	SmuMetricsExternal_t metrics_external;
+	SmuMetrics_t *metrics = &metrics_external.SmuMetrics;
+	struct amdgpu_device *adev = smu->adev;
+	u32 upper32 = 0, lower32 = 0;
+	int ret;
+
+	ret = smu_cmn_get_metrics_table(smu, &metrics_external, false);
+	if (ret)
+		goto out;
+
+	upper32 = metrics->PublicSerialNumberUpper;
+	lower32 = metrics->PublicSerialNumberLower;
+
+out:
+	adev->unique_id = ((u64)upper32 << 32) | lower32;
+}
+
 static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.get_allowed_feature_mask = smu_v13_0_7_get_allowed_feature_mask,
 	.set_default_dpm_table = smu_v13_0_7_set_default_dpm_table,
@@ -2905,6 +2924,7 @@ static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.enable_uclk_shadow = smu_v13_0_enable_uclk_shadow,
 	.set_wbrf_exclusion_ranges = smu_v13_0_set_wbrf_exclusion_ranges,
 	.interrupt_work = smu_v13_0_interrupt_work,
+	.get_unique_id = smu_v13_0_7_get_unique_id,
 };
 
 void smu_v13_0_7_set_ppt_funcs(struct smu_context *smu)
-- 
2.53.0



