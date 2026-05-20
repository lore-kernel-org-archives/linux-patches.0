Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1D13EBF35;
	Wed, 20 May 2026 17:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296915; cv=none; b=m/YhBVKF9NGks0sdx8ckB2ezjv7mpfGGIl/Wk1M4VQavIg7Kzuk6Xcgc7KkpjN5/zXEIJ8amJIG9K4iU8z1BUjqNDqNXbtVwais8eFqhDGKrmXEq+dTJMAoQWafaV0/4rox9oO+JXzJJWajvapptGyNf4yuEhvRQFX7LqqHluKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296915; c=relaxed/simple;
	bh=hvgSa5zcV+hr205UfwoaQr/KWco8gMAuZ3DBjmdRBfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ttnx2dn2x1+5W+sesq5Y5qoVMV8hVECb5L4KpQX1Y9xcQIeTgkEqLGEgAPGrKxUVw8ZBYyuk3ACdvXddar6JeO9oGpVKYsVSbIt29gac2l2RHXqg5VK+WmiCXmSXTc9l5c/J2GWdEVFaXn3Wv86r+9GRJYG0yx/Pe6hsx5GmknU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfadswAr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfadswAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E73C1F000E9;
	Wed, 20 May 2026 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296914;
	bh=h4clyJjB2vJu6w3krgFXatOgQcLUJx/s4O2l3tYjCx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xfadswAr0AUwBVXGJTTI94+y2Z85YuV1DDDx7IaQ+OdYIOJ4eclvkzHio+RNNZdto
	 kKQn5VB94L+ZK8HmWNwrwHs/cgsK1R2xTwSTfa6XrNHCNdQP76LF/o9Qlesy+3gE+g
	 d8B8yyJ/2LV351L40yijstD1SJ2bC8rsKlx7/tSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0980/1146] drm/amd/pm: Add fine grained flag to SMU v13.0.6
Date: Wed, 20 May 2026 18:20:30 +0200
Message-ID: <20260520162210.411229610@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 47a5dfc8add4e60ff1ddc312f79998e70cbb0c09 ]

Gfx clock is fine grained on SMU v13.0.6/12 SOCs. Add the flag to report
clock frequencies correctly.

Fixes: 7380228401c4 ("drm/amd/pm: Use generic dpm table for SMUv13 SOCs")
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d4871d837bbf70173f63426a84fa80b39e408b9e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
index 870bcc86fd794..c62b12d672d48 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -1122,6 +1122,7 @@ static int smu_v13_0_6_set_default_dpm_table(struct smu_context *smu)
 	/* gfxclk dpm table setup */
 	dpm_table = &dpm_context->dpm_tables.gfx_table;
 	dpm_table->clk_type = SMU_GFXCLK;
+	dpm_table->flags = SMU_DPM_TABLE_FINE_GRAINED;
 	if (smu_cmn_feature_is_enabled(smu, SMU_FEATURE_DPM_GFXCLK_BIT)) {
 		/* In the case of gfxclk, only fine-grained dpm is honored.
 		 * Get min/max values from FW.
-- 
2.53.0



