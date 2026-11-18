Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038918;
	b=ueTAxf7wv8FR3dDO0AT1XIIAPf+N/orR9vfjmvXQxxDoye2ZUbTv96eqkuD+d9kIqd9U
	 ARPCMg83IqUGoPSDQo+B5o+0iT3777igsDtHvOENAbDNCV3YeRqAUaiantgjeqDAXfSLI
	 cOnEqVUsa4LUZxPxyCZLqppdVU0nVL9aXKY0/C/+d1fK+VtSpEhwu9i3fcloDRCjhAbHq
	 Gp3GqaXAw/bSsfMRV8P8R/ER1i0Uo7hp6mo+xSYqPiASS6O9MCPGYXEw/VNdeBxSe1sEh
	 +ADzIpOPIxkCBKUXizZ2xz7uM5cMIe5ePePOxM2YI7MCaxed/q44DIdeqt5/4RgvGUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jzcGu/rvX3qRhkx6biXRB+ROM+iH+soQtWhLRmRywJE=;
	b=RVLBMn/MPRwgvwzOiHLCb9DBQtx4OxQoiyVpL0dDoQrzs/BPGFzfxEfpAfxA68D3xyjI
	 unkv+JjfdGW/CvHhZ2KKnwJZVhPLTfLOgqSMGPKjvo/4kr6kPKfaA62KdAF/X8Hryyawv
	 WVqOQmYcgpDpY5GARBXHmfbAGEvdYLvNhWX0G+MPiQ6O5IxRyqqRuXxx1SxsxMpjXpl5/
	 I1rp3ZIfWuctKt88MDaMkfIOCnTngApW9ZKGxEAMHCB6ZUz1Jyw2/8Aixq8J6paka4r5O
	 oOb/tHxK72QUP5L8DNVEQqITnDyz9XfBDK+vV+G/fgc0ipxX3Jh/r8mUYKVYkQo9Llg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0zPXK+gj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B038F606A325;
	Wed, 18 Nov 2026 21:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0zPXK+gj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0D51F000C4;
	Wed, 18 Nov 2026 21:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038918;
	bh=jzcGu/rvX3qRhkx6biXRB+ROM+iH+soQtWhLRmRywJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0zPXK+gjrtSPgZ81KIkf/3khEj+f9icrntPB8x4vvjqRW730YzK1duEcjFqXI0RKA
	 39u6tnZWH5KZlerRJOUa4LctQYzlJVij0hh8THFYLFqo4+HHWRXJDwlCFWA8yAs6VC
	 KApNSgdU1z5apb8FJAGBzSWQJGxsm0PNhg1FR0wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Wang <kevin.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1912/3318] drm/amd/pm: populate unique ID for smu 13.0.7
Date: Wed, 18 Nov 2026 15:42:14 +0100
Message-ID: <20261118150419.366834399@linuxfoundation.org>
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
[ sashal: Adjusted placement of the get_unique_id callback and its registration because newer surrounding functions and table entries are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index b97015fc3c8a4..5b56819f26ecd 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2177,6 +2177,25 @@ static int smu_v13_0_7_set_df_cstate(struct smu_context *smu,
 					       NULL);
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
@@ -2245,6 +2264,7 @@ static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.set_mp1_state = smu_v13_0_7_set_mp1_state,
 	.set_df_cstate = smu_v13_0_7_set_df_cstate,
 	.gpo_control = smu_v13_0_gpo_control,
+	.get_unique_id = smu_v13_0_7_get_unique_id,
 };
 
 void smu_v13_0_7_set_ppt_funcs(struct smu_context *smu)
-- 
2.53.0



