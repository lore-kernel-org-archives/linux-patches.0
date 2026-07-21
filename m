Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3F733ADB0;
	Tue, 21 Jul 2026 19:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661437; cv=none; b=JBPgCeYEtBcNkjnMQclxUdiFugH3Xl/kpCvNDtaJLdfMoLgK5Z4lMxxwajcJhMf7pwExSsCRKCqYtWsFqRXC1nXcoXHBbVaFlsQwuF+5LRf2byPqgYyAbSzRx4kgkEdthrAvRM2Ipd69Zvq/kqhpy0umzef6WVQTfFFEiO93VYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661437; c=relaxed/simple;
	bh=wzAnl7umu42JHhUoPzdZfwJHS6zdxgh7LVsF5y+89ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRHy5U+N89Y48R1sP2f0QhOPQ27eWar8TwxO4Ef8PzKln05QqIvSdtMjdy69y8MxKTWjBV77mW48i9nV/RQyXgwbk0QRLSV1xJDPxQVhm3irq/DztN3kzooJ39ePq+Z2A+Av4gfKmZDyTCmApgON9vBv3K/9y8rsKQtrnuzc7Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmw2urEt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmw2urEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18821F00A3A;
	Tue, 21 Jul 2026 19:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661436;
	bh=8THIfYOQLtP6OAKlw0Zkq71LMCGxsWR31hwC6YKVWwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zmw2urEt1rEn01O5f1hQUdQCzDq1RLT3slnrgWRlfVHsEWcgrdxsbURimJRYpZLmV
	 UPLUxQl4Mzx9XwX28sYC7yhGHqvZ6QdQN1tu3UF8GSWQJb1431kQM35wN1bLMepuCk
	 QgWgm9jTS8o17uesc1o0hcLMvutadrYImnI6IDnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0066/1276] drm/amd/pm: remove trailing semicolon from AMDGPU_PM_POLICY_ATTR macro
Date: Tue, 21 Jul 2026 17:08:29 +0200
Message-ID: <20260721152447.564732175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 57b5d90ca89b3f..9ab0a7fc3cd9be 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2363,12 +2363,12 @@ static ssize_t amdgpu_set_pm_policy_attr(struct device *dev,
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



