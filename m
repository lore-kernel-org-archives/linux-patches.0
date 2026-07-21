Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CAD46D2B3;
	Tue, 21 Jul 2026 17:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655605; cv=none; b=HcIfUJDZEv+f8UWMETEp4IjSHKOwtvyVCdIRzHfnsvM6zB1n3hzZflao5qXPLiFe/mZfXxcR5cKigbL5kDYPXlLOFkzSN4HBycnhGoP9PB0GMf+ET9uNRYn5C3LP9dsr82GAfqHw84ZevQHFOljSIf0oFKu8Lp8ynorBQmfUobg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655605; c=relaxed/simple;
	bh=OaaE3IVekJM5l7HfFQx9tXNESdhEELVuUHR2nVqd4bM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0uEu+E0uzvjn8zV97wDg/tBnrl66LgRZH163ClCIXtuq9mWf0hDo+iKzUr356udsSot6oSGeNbdRtfBHNx3RcVi+uzlKBTRCqnvGNcs1KNsM9D5cvpuAoKcKzQqZGyJuP1GrpX422c52q9QX/RFUAk7lUqgLT/xCfD88DJODe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5x/LX9G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5x/LX9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495B31F000E9;
	Tue, 21 Jul 2026 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655604;
	bh=RSq77zD7MuZtRzk0mHFcxcUni22VVN+VjoUDk9kJ8ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5x/LX9GP+Bs7gd9SX+ZUBN1KCJ0Y368ruRkM2vD0LuRmcHhPxf8nWmG4R7TgAASM
	 chx7QaBMMPtnR53ZYBCfguwqFoLA9tQyb1iVWXZl7MrEN9bu/Nz+NxR5jlB5d/Am+J
	 y48ZrRLI5fw29NdcG0ESLBrR0qNev+T7Yl375BVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0072/1611] drm/amd/pm: remove trailing semicolon from AMDGPU_PM_POLICY_ATTR macro
Date: Tue, 21 Jul 2026 17:03:08 +0200
Message-ID: <20260721152516.455965728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 0d892afb52d2b940d891b6b52dc9f04debef2d81 ]

macros should not include a trailing semicolon as per kernel coding
style (checkpatch.pl warning).

move the semicolon from the macro definition to the invocation sites instead.

checkpatch.pl logs:
WARNING: macros should not use a trailing semicolon
+#define AMDGPU_PM_POLICY_ATTR(_name, _id)                                  \
+       static struct amdgpu_pm_policy_attr pm_policy_attr_##_name = {     \
+               .dev_attr = __ATTR(_name, 0644, amdgpu_get_pm_policy_attr, \
+                                  amdgpu_set_pm_policy_attr),             \
+               .id = PP_PM_POLICY_##_id,                                  \
+       };

Fixes: 4d154b1ca580 ("drm/amd/pm: Add support for DPM policies")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index a7e6d7854b7b2c..0d72118a12b4cc 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2463,12 +2463,12 @@ static ssize_t amdgpu_set_pm_policy_attr(struct device *dev,
 		.dev_attr = __ATTR(_name, 0644, amdgpu_get_pm_policy_attr, \
 				   amdgpu_set_pm_policy_attr),             \
 		.id = PP_PM_POLICY_##_id,                                  \
-	};
+	}
 
 #define AMDGPU_PM_POLICY_ATTR_VAR(_name) pm_policy_attr_##_name.dev_attr.attr
 
-AMDGPU_PM_POLICY_ATTR(soc_pstate, SOC_PSTATE)
-AMDGPU_PM_POLICY_ATTR(xgmi_plpd, XGMI_PLPD)
+AMDGPU_PM_POLICY_ATTR(soc_pstate, SOC_PSTATE);
+AMDGPU_PM_POLICY_ATTR(xgmi_plpd, XGMI_PLPD);
 
 static struct attribute *pm_policy_attrs[] = {
 	&AMDGPU_PM_POLICY_ATTR_VAR(soc_pstate),
-- 
2.53.0



