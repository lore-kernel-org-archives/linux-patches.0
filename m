Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97563F54C9;
	Wed, 20 May 2026 17:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296715; cv=none; b=kFJWc28RHC1JS1pDgT8NdRkeNj8Melqf5uQdZplDPBJVn8BdNhu3OSdvgwjzWjBYEL6umqmtaGc282xyRc6RY53JVuxHVhazxAg9BK/qRrOuIhFEatw2S9hykxpY7zoWMlg35ms5Oj1wfHEupuejYcm4F/54pQdzho5NWP+JTew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296715; c=relaxed/simple;
	bh=n9rUwghuiVQbL7/BInnZ3lRqrmyOshzdF/YWf3ddepA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkMiNA/szfcQqh88rOsHXokCHiqPH7DKLqn8WGHUVvvrwXMAsFGR+3hxEKSP9b4Tbm6AyYAOVi//4XoJ7uhGuleXPy5dSTN5KH9iPZmTYYM0DCqCcATQ8pStup3YIQI/6PBH/mikxrrjOqkWLYOq7RleAg5k/G/RyNQ7IIVorHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iduPcOA1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iduPcOA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054AE1F000E9;
	Wed, 20 May 2026 17:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296714;
	bh=Sbc1H3MQJVO0HWRah+wkI6Yq6J5SrKBdH3ruvYUZd7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iduPcOA1sbCwOB2jq/nUjT2eHHJQHp78ul+UoOj0GopMDuTuE1INjWdSQ30yekxVB
	 VsGLKDl1CWi5pcqm9N+Se9IlAuNHYKhn485O9BW+86OTfIwoIGvHEA5E+Rq+q2Ez49
	 rEjkSzeeg8bCSmpH5oYGAA/enePFxbdg1CKBWKfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0903/1146] drm/amd/pm: fix missing fine-grained dpm table flag on aldebaran
Date: Wed, 20 May 2026 18:19:13 +0200
Message-ID: <20260520162208.672373011@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit ccf8932ed8cf4fbfdcd4df2c6b524913691ee700 ]

Add the missing SMU_DPM_TABLE_FINE_GRAINED flag to aldebaran DPM table.
This fixes the pp_dpm_sclk node issue caused by missing flag configuration.

Fixes: 7ea1c722fe1d ("drm/amd/pm: Use common helper for aldebaran dpm table")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3427dea3a48ebddb491a26093f3627384b3cb2c2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index 2b4faab376930..23c9f14bb2086 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -425,6 +425,7 @@ static int aldebaran_set_default_dpm_table(struct smu_context *smu)
 		dpm_table->dpm_levels[0].enabled = true;
 		dpm_table->dpm_levels[1].value = pptable->GfxclkFmax;
 		dpm_table->dpm_levels[1].enabled = true;
+		dpm_table->flags |= SMU_DPM_TABLE_FINE_GRAINED;
 	} else {
 		dpm_table->count = 1;
 		dpm_table->dpm_levels[0].value = smu->smu_table.boot_values.gfxclk / 100;
-- 
2.53.0



