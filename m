Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E5846AA62;
	Tue, 21 Jul 2026 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648098; cv=none; b=baa04LVGrwHQf0O8lBY7smMGkUPChny44tXLQE4DV5Hb+nnq6mQVR+mk/vfuMn29RxParVG0j/aao9wZzoE3Eni6y5H/NYcHCyREQ46whHZIRRtq+FWw6CmtHCkn+xtmTSzmh5UcuH/ftm8QWqqd2S8wehMk+U3rNwe6HqFcbpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648098; c=relaxed/simple;
	bh=tgf3IINaJRG1TT40EuNNlpcCcZSxZIUT5M25/0FSo1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1TBQArWb19zYo9wB316L7QfyYLTjSZc+VaFh58wq+A1xStD+zKvfBiK8t4UK2by/+cPHvyN2K6tAuKe7OKoJvDmrCDFQ34TBFdLJ4Rsxwtbp2Izxby3+Q44LHrt1HgWhe2pfhyRezagoH/OAhB7CZzOqPndcD8VwJdWvBRQ1hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsHy5qmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsHy5qmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBC11F00A3A;
	Tue, 21 Jul 2026 15:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648097;
	bh=bzAOAgjp/gwituKzIL4MwZ/MIGsrU7fRNcMnTbAe3+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsHy5qmR/HP2HuwKDeoajulQqv+BAH9vseWKy7Ik/pqfhQV4PVEIR8o8N8WLKIt5U
	 Ii/VfsfjfLmuXus4Rj3DtyO85elGM7FZxa6OApol+u5ov4l++b1rMRGgrv4krWf5kY
	 /Z1xnlmn5tnaH++xZDKNQIyWglmg0heRcWlMMzwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0070/2077] drm/amd/pm: remove trailing semicolon from AMDGPU_PM_POLICY_ATTR macro
Date: Tue, 21 Jul 2026 16:55:43 +0200
Message-ID: <20260721152554.343136267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 736304e73ca4d1..024bfdb7c1571c 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2505,12 +2505,12 @@ static ssize_t amdgpu_set_pm_policy_attr(struct device *dev,
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



