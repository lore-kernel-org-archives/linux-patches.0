Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028614;
	b=f0KMqjDW5ZgwkMv7ydMiuwVBNSvgfXXp+di+K2+H2tU66WcY4OQHcoTKwBHhvYY+jPnH
	 Q/yuX5+MwSdleKtWKPP2RG9jLd/QnOIvMUCQA77/xk5/vwQ1UEikSNoRIkknHypPaVeAp
	 oMzPtVx7VPDo/JezYtPguB0qqx/jDsR6y0S1Uus8gNcdRCkMyC16y+d5MNYuZ5QI8qadn
	 xhYp58tTSfjlZlbYaaUlP8ipw3lIQ3QdxcXHnjO0Ly9R8ANy17FB+K0XdrsSLT/oF75Wg
	 ERZRb5piqf8Z+9lo7xg8WqU9OPK9+H7gcEPlhqpC8JG12E9XQTj4BwCU5SIu4NIKK4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mw1oEUQz8SMP62uSJRMMhZf0UFMg6LvHaQplUGDwJnM=;
	b=RHlNYu9KA28VNzBRAeO39pEVVkX63PG5I4MeLs2S+p+5jylKKkQ+tdpYjPBqivZQqliU
	 wu5FxrzKL1dCkMP1sgdv3BdhVRF8qZwELxKnjwkCFQS83dYqIA3v3sEgiTjpw/0NuzgXu
	 ZzGBwUAMUXk25sLrLi8QaAH8tMFNEzZRAzjUsJJ7LMG4FST9GXHM/5ycp/4nhKciCG3tK
	 TPfQO8Hv8yTXrcPqhSW1pkAKWGDx5gVxKqwYhh+pGRJJmHJM6nxpZgZ6i4JQArGKqYuQg
	 DSnOxIXbIhvhrO1tlqJU7VClVmZQmjL4mawQf7ZWC7P11yhxQXzOdsQ+jmRbgph1qqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oezJcsUb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6253606A320;
	Wed, 18 Nov 2026 19:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oezJcsUb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136EE1F000C4;
	Wed, 18 Nov 2026 19:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028614;
	bh=Mw1oEUQz8SMP62uSJRMMhZf0UFMg6LvHaQplUGDwJnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oezJcsUbCxYypFR0hRbXSR3xhqdhzA6vNN4bQpTrvUHTX5asYmgdyJ2UsZbBSk9Mh
	 Iaicqq+TR5wPqa7DmfD7ct2qWRA4bM49nRkVTopURQKUqOchlvPQ0s6iOTSpyUMUA/
	 7HDttklyA8jeF8rdVG7Z05VRMscg6PugGkBIjYHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Wang <kevin.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0057/1756] drm/amd/pm: populate unique ID for smu 13.0.7
Date: Wed, 18 Nov 2026 15:36:24 +0100
Message-ID: <20261118150010.638655698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
[ sashal: Moved smu_v13_0_7_get_unique_id() immediately before smu_v13_0_7_ppt_funcs because the upstream neighboring functions are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 9467db88969c6..22420256750fa 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2669,6 +2669,25 @@ static int smu_v13_0_7_set_power_limit(struct smu_context *smu,
 	return 0;
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
@@ -2739,6 +2758,7 @@ static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.enable_uclk_shadow = smu_v13_0_enable_uclk_shadow,
 	.set_wbrf_exclusion_ranges = smu_v13_0_set_wbrf_exclusion_ranges,
 	.interrupt_work = smu_v13_0_interrupt_work,
+	.get_unique_id = smu_v13_0_7_get_unique_id,
 };
 
 void smu_v13_0_7_set_ppt_funcs(struct smu_context *smu)
-- 
2.53.0



