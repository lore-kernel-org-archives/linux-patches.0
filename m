Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498943C2F;
	Wed, 21 Feb 2024 13:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522806; cv=none; b=WDxAtog9SyBfuuh2UhMXrFCHrhyXSKmbSSLetCb92Q6x5LclJzDA+M0cm6am+UkWz++kjLsDvCMRWFQZ2IWugrppqPEVRroEvQhfWik89VxwZtNuMS6iEZ5yAXq3hjq65TY7ncRM1qRMN1QgHFZChsABr4eargBqvgWtzGWB+Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522806; c=relaxed/simple;
	bh=97KYGg8IJiShj2O9xGCTISHRoGptnUHIT+HWXc2CPxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mBrjp7HV5Zmm211xqa9biEQAI2EqVIATAAnk5okydZ0N9CUdh+chE4Xs05o26ZQkw0wZBv+8jPjiP+xTreSJsKO5cFh/OjUZ9FwI7GFyRqJZVDmAwJ6BWF+PuHQUszDHPTg1yil5ejt7gmwxz3z5l01eRVvSVFWzn22eyiq9bEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXpezb9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXpezb9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBADBC43390;
	Wed, 21 Feb 2024 13:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522806;
	bh=97KYGg8IJiShj2O9xGCTISHRoGptnUHIT+HWXc2CPxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXpezb9ArIihPCRWEuTny0uqWoHkhyr9JhXX9g/RQa0JEVRxcozL+9Gri1s58JMla
	 QTaOyfaQ9cpOzj3EX1esBQ9JQFRWKc+1PVc9KBw2JE+g3qfJvZrOMyI6jqtfxaESeF
	 zqPmVSb4wPfINooQxNDNuGEsle2NXPwHkm/2HmP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <JinHuiEric.Huang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/476] drm/amd/powerplay: Fix kzalloc parameter ATOM_Tonga_PPM_Table in get_platform_power_management_table()
Date: Wed, 21 Feb 2024 14:05:15 +0100
Message-ID: <20240221130017.606436250@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 6616b5e1999146b1304abe78232af810080c67e3 ]

In 'struct phm_ppm_table *ptr' allocation using kzalloc, an incorrect
structure type is passed to sizeof() in kzalloc, larger structure types
were used, thus using correct type 'struct phm_ppm_table' fixes the
below:

drivers/gpu/drm/amd/amdgpu/../pm/powerplay/hwmgr/process_pptables_v1_0.c:203 get_platform_power_management_table() warn: struct type mismatch 'phm_ppm_table vs _ATOM_Tonga_PPM_Table'

Cc: Eric Huang <JinHuiEric.Huang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
index f2a55c1413f5..17882f8dfdd3 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
@@ -200,7 +200,7 @@ static int get_platform_power_management_table(
 		struct pp_hwmgr *hwmgr,
 		ATOM_Tonga_PPM_Table *atom_ppm_table)
 {
-	struct phm_ppm_table *ptr = kzalloc(sizeof(ATOM_Tonga_PPM_Table), GFP_KERNEL);
+	struct phm_ppm_table *ptr = kzalloc(sizeof(*ptr), GFP_KERNEL);
 	struct phm_ppt_v1_information *pp_table_information =
 		(struct phm_ppt_v1_information *)(hwmgr->pptable);
 
-- 
2.43.0



