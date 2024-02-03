Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FFC171D4;
	Sat,  3 Feb 2024 04:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933931; cv=none; b=IHUsXlOUPml7BaYKeiECHA0zElCuSdDBS8e5Pip7f9piacQadt3s5cAFiJVHlUGtMwiIMHjHjkbl7DpJTXmcDlIaBFPvcRg5hkTTbKMbqmo1GJIAET5TlqX7XKBBB3t5rREzBGGhIGUthq9hXTdNolyswjal1VQN1EXjgBMuvzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933931; c=relaxed/simple;
	bh=0yqtR+eLYsbTz3qk9ZePsxENjZefVLMAZf+ySQIWxyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bsgQNskuqybhg95RPCcNkl4x+yeL/fkapre+VvnZFE+aXCTQOqJ+fgROWhso4ITKCcgruGpUiwO3jdOYo43kVdZGpdAlJPdR28WIatSn4jtqy7rRLwkHymyz/CG5KUlXOJRZk0aDBbqLOQZcDjXPFYQ/VAnL+3RDT4F1w1Ja8fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyBCj+kW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyBCj+kW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1650C433F1;
	Sat,  3 Feb 2024 04:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933930;
	bh=0yqtR+eLYsbTz3qk9ZePsxENjZefVLMAZf+ySQIWxyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyBCj+kWKHw2rB9VMeCy4+7Gk8UZf0VWylPKZ9jVGzmI4f6l1rhaKdhYIl3Rlkc3V
	 upz3m2XrczdKSFid96YML3yGURwtwqPCJAWIieOIME9GmEK5Kj0a7nOA3Ev1ORo+As
	 Km7xK36TMZMXE6vzh5YWAczz58ohgmEtM8JPYyZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <JinHuiEric.Huang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 282/353] drm/amd/powerplay: Fix kzalloc parameter ATOM_Tonga_PPM_Table in get_platform_power_management_table()
Date: Fri,  2 Feb 2024 20:06:40 -0800
Message-ID: <20240203035412.691235947@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



