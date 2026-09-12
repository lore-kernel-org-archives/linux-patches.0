Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F6735F191;
	Sat, 12 Sep 2026 08:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203408; cv=none; b=EwkdC/Luy5VuP8689FA/LY7TF/NAIZ62R0X2hTZ72B11ZbjXeBuqkYzNaI4Il2B35ZpCUrUwU0v5QQiG7kIe5IMf3M3c73XIh1KfQ4pyaYQvLSFt7dbKkVCwD0xLpgebrhp24eXxLdVD+SEXOx2NWW8YO9FcS7Phlxo1M913EXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203408; c=relaxed/simple;
	bh=PYurNvvxjuxjBdVHIyBerz0MyIQYLkLKVEafaEhSabA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIykxHyUYSs0o2b/GDiT1naOv/cDLGSqFnIlU5Uh+5x1yjgc9SJYQZFW5A/iqPn8nM+Uf3V1ge4YpniuN3BsIVcAbny8H8C7Vii9KYCqLWA1YqKM8K6MCkLJ3tpjS/uMORrn+iExFKawky5nNZs8yFLAmUaAYVF6y0jPr87kCcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQn3hvUk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQn3hvUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99F81F000FF;
	Sat, 12 Sep 2026 08:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203406;
	bh=q+ReKny/B1M/NLj3EotwseJYlyeVyYW3t7u7TJTndGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQn3hvUkSf3ABaCFvINpq6qmOBSnGcFw3OHPWvL1FumKINpFKQ5JhfMrkTy7tUMbl
	 eSLOVCqcpUqeS1T2DdDk02LovsWZtJ4sQxNCwKx/iSRk0N2YPK7YVqG6blE3OpTUIl
	 1QJ9opwJK3FT6oDLKZYWttIEyMLu5BXDA6mAnIVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Dan Carpenter <error27@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1401/1815] drm/amd/pm: silence uninitialized variable warnings
Date: Sat, 12 Sep 2026 08:52:31 +0200
Message-ID: <20260912065721.913545476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit b4cb43789b6ac0f25fc0d9b21c5e7a6225cf6a31 ]

Smatch complains that:

    drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu15/smu_v15_0_8_ppt.c:1964
    smu_v15_0_8_set_performance_level() error: uninitialized symbol 'ret'.

In this line there is an "if (ret)" condition where "ret" is either
zero or uninitialized.  Initialize "ret" at the start of the function to
avoid a potential uninitialized variable bug.  But also delete the
condition since it is never true.

Fixes: 422b399b09c7 ("drm/amd/pm: Add od_edit_dpm_table support")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu15/smu_v15_0_8_ppt.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu15/smu_v15_0_8_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu15/smu_v15_0_8_ppt.c
index 118eda5429ff7..68bd673c0573d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu15/smu_v15_0_8_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu15/smu_v15_0_8_ppt.c
@@ -1915,7 +1915,7 @@ static int smu_v15_0_8_set_performance_level(struct smu_context *smu,
 	struct smu_dpm_table *gfx_table = &dpm_context->dpm_tables.gfx_table;
 	struct smu_dpm_table *uclk_table = &dpm_context->dpm_tables.uclk_table;
 	struct smu_umd_pstate_table *pstate_table = &smu->pstate_table;
-	int ret;
+	int ret = 0;
 
 	switch (level) {
 	case AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM:
@@ -1956,9 +1956,6 @@ static int smu_v15_0_8_set_performance_level(struct smu_context *smu,
 				SMU_DPM_TABLE_MAX(uclk_table);
 		}
 
-		if (ret)
-			goto out;
-
 		smu_cmn_reset_custom_level(smu);
 
 		break;
-- 
2.53.0



