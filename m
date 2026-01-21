Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D943376B8;
	Wed, 21 Jan 2026 18:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020107; cv=none; b=IVWmDAYO/Cz+YD1a5WHja6QyMPAuHWA+xlZmRkVC55LuhdapNYu64EYlZGLxA0DlPl4JzPTE7LxUPXD7ZpHu3L9WxIEULs+WJ3mg1dd6taKb4kthm22rMckciKpwoZEK9/9PuJmtCeS7uZgqoHWmpImqvrKGNvGlGJRGGAh9Ojw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020107; c=relaxed/simple;
	bh=jDMHPYWn7X3pphlw/AE2c+X+XoYym7LJG/WY75T/Ba8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJix0yBYpATb6ORpkhWsMx/8ifcOb8DpyXFx8+jz7S7KIXmiL+J3gKYcvN2EtIKTKxKe9Jvxsd1hUZXiKFz7wtXz9BD6r4j7M9N7dsrysPLxSxb1OcSPyNNKXeqP13Kkmq/nxSnz3QNj9h/U7JwuQELpw+JIkAZVIR3iZpEEBBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDDwS3pN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDDwS3pN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515EEC4CEF1;
	Wed, 21 Jan 2026 18:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020106;
	bh=jDMHPYWn7X3pphlw/AE2c+X+XoYym7LJG/WY75T/Ba8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDDwS3pNe7mObUs+vXGDVLoPtBQOU8FVspEYlkY6IyWuSLYOdH1mc/GQzkw+PJnCe
	 5RrrqwxVkCmW9chopthM1v625jkUvA3t9O/MbdE5ERdykosAICmqQ4LreZEQNex1hR
	 kf7QwfWFLdPzm45/sZbMZ1CigwH9SrWXncpb5NEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 060/198] drm/amd/pm: fix smu overdrive data type wrong issue on smu 14.0.2
Date: Wed, 21 Jan 2026 19:14:48 +0100
Message-ID: <20260121181420.715708393@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

[ Upstream commit 90dbc0bc2aa60021615969841fed06790c992bde ]

resolving the issue of incorrect type definitions potentially causing calculation errors.

Fixes: 54f7f3ca982a ("drm/amdgpu/swm14: Update power limit logic")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e3a03d0ae16d6b56e893cce8e52b44140e1ed985)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
index 086501cc5213b..e735da7ab6126 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -1701,8 +1701,9 @@ static int smu_v14_0_2_get_power_limit(struct smu_context *smu,
 		table_context->power_play_table;
 	PPTable_t *pptable = table_context->driver_pptable;
 	CustomSkuTable_t *skutable = &pptable->CustomSkuTable;
-	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
+	int16_t od_percent_upper = 0, od_percent_lower = 0;
 	uint32_t msg_limit = pptable->SkuTable.MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
+	uint32_t power_limit;
 
 	if (smu_v14_0_get_current_power_limit(smu, &power_limit))
 		power_limit = smu->adev->pm.ac_power ?
-- 
2.51.0



