Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5090E645
	for <patches@lists.linux.dev>; Sun, 26 Jan 2025 06:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737873916; cv=none; b=ZmAsqo5I75vuTVZVNmKWclJOZ9mbIYJ12FuGg34NCO79xsUWD3rwbI6RzQtGd3/xBv7Ta1HC+Cg7+BToV4t6mGn1Zs0AyCST/NPYg1b46L7ZbW2cy0KV0wMC6IPd80r/AJBNvVx46rtWfBR6TxighEpRBXUI02ECv7LLZjPV6CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737873916; c=relaxed/simple;
	bh=acnt/doy/5XHj70XEGLItNmI0Vgak6ftbZKRvMcrXTg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FDl/OZQYRmbAdJ9GXvv5XkM0ZLrwwv4GgrBT9dwyvVHS/fM3VDW/N3s4PECgnP6vRUqusdCTru/nr3cLp8J4mOHBy5jSHEEimlxmw3clT6oQCbD2w1masN54XaU/7tpSBrPRJ4bZLZB1L6t5gambRp88J7I3iclT5jFvkZhMhtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eEjmkd6y; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eEjmkd6y"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2eec9b3a1bbso4791620a91.3
        for <patches@lists.linux.dev>; Sat, 25 Jan 2025 22:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737873914; x=1738478714; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FqNaVZFEEca3E3wz8Ju8ZljshuiNP61cQ6d6L0AnGGM=;
        b=eEjmkd6yKUHVABTrmofK6uxgupxOeV+HMzMowLY2oecOFoVOTa9F1xgbssehaqKkei
         xC7uXcQ78ZjufKJN3n5Q6+g4kPNkf5nzMKzEyxpPbcnKte/HFR2dePln55uIFhj1HQDZ
         NoMtI932d5DdVrHnLQeLWyWAnoaedQlgX4Ex3BqSsZ9261hM0tt6J50FzOK9wi3FtJjn
         rwckpcXRRB0KhRGhibY2sSb7ZnZ+k5S9PwNr3YGBByYO4RvXrECaDhMg5ls6SUb+t2j/
         xQ9CR1uPVuwWTAg6XbCIc70JgQzLm6XiAMuTLUIj9r8u5kQeYhCYFvUle/Ga6J06KhKu
         xeWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737873914; x=1738478714;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FqNaVZFEEca3E3wz8Ju8ZljshuiNP61cQ6d6L0AnGGM=;
        b=jQVQYe/M2w729A7agbRENAlKMzZGvIxI/afRlVd53FY4XRFYxc0En72ze62oYZsBUI
         YJkSdJdLxQMC1kd+hwXf8sXku12drD3VRMPa3rpm2sQ+o9HNEdLcHIJ8Rm3ZlyjK2rv1
         st8cTAMJ8AHe/f2rVsXG9I5xA5buLyL4hg/scLLaqBTQNNZWeZfQ9XadLbREeI6S3ZXm
         E7eQkBQLnHUxzRKgzpSysISvDii5i3Rhi5ITZS1zMShwVtA7iYKOdSpn2ZmK1VR0UswU
         45DxQV2cSjX3W9vKjJ25f6smQzOLr1e2LFWhz6MYhDrv4lJYIZatN6iUCYtVmz0CUt0U
         sLkw==
X-Gm-Message-State: AOJu0Yzy0DottjJpBf7Kc1dgS0M8p3kyA5gZVG8r2hneDjZkPkKFdMJu
	FYHoaPm5CWYjArD8MU/mAc0o3RoKnrNc1Rogs73dlSCwBvBzs3jS
X-Gm-Gg: ASbGnctiLAclQNMnst6boreXfDn8WYMwWcPwPhHFL53H8w9L93r1q9edFsg9/wjAmTS
	bqUDxm4WYDPeQyqimJ1HN1NE4ckdjtSjjPyd2DvUztL17DhlJ+ObAwn2leKqvzV3W2p2EV8XMdx
	72uabZ4Difn5YnFo0IRXPsvBahuQycx3IuoL6j7gusCQ/UwPbr+ybh+KM/oPZRiaE3vxlszDRS4
	b3tVa7cWgKiIyhO0DGFCIMUqaibzs38l1FMuQ0Dfnl/DkBaEYiPCqh09hDR1uPyGWbqIKhrHH3J
	SE/DK+8dXKc4mcHLssaVmaWObXe/
X-Google-Smtp-Source: AGHT+IFg7WVPs9aNmjLP+b1xdMjOuirhgOPLzTaNKIBZZkbsCXo6bvei5V5jnc7lQvWmvL9tsG/2Tg==
X-Received: by 2002:a05:6a00:4505:b0:728:927b:7de2 with SMTP id d2e1a72fcca58-72daf9eba1bmr60305593b3a.8.1737873914435;
        Sat, 25 Jan 2025 22:45:14 -0800 (PST)
Received: from jren-d3.localdomain ([221.222.59.31])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a761134sm4680916b3a.115.2025.01.25.22.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2025 22:45:14 -0800 (PST)
From: Imkanmod Khan <imkanmodkhan@gmail.com>
To: stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	n.zhandarovich@fintech.ru,
	alexander.deucher@amd.com,
	wayne.lin@amd.com,
	gregkh@linuxfoundation.org,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	Rodrigo.Siqueira@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	daniel@ffwll.ch,
	Jerry.Zuo@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	sashal@kernel.org,
	alex.hung@amd.com,
	mario.limonciello@amd.com,
	chiahsuan.chung@amd.com,
	hersenxs.wu@amd.com,
	shenshih@amd.com,
	Nicholas.Kazlauskas@amd.com,
	hanghong.ma@amd.com,
	Imkanmod Khan <imkanmodkhan@gmail.com>
Subject: [PATCH 6.1.y] drm/amd/display: fix NULL checks for adev->dm.dc in amdgpu_dm_fini()
Date: Sun, 26 Jan 2025 14:44:58 +0800
Message-ID: <20250126064459.7897-1-imkanmodkhan@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 2a3cfb9a24a28da9cc13d2c525a76548865e182c ]

Since 'adev->dm.dc' in amdgpu_dm_fini() might turn out to be NULL
before the call to dc_enable_dmub_notifications(), check
beforehand to ensure there will not be a possible NULL-ptr-deref
there.

Also, since commit 1e88eb1b2c25 ("drm/amd/display: Drop
CONFIG_DRM_AMD_DC_HDCP") there are two separate checks for NULL in
'adev->dm.dc' before dc_deinit_callbacks() and dc_dmub_srv_destroy().
Clean up by combining them all under one 'if'.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 81927e2808be ("drm/amd/display: Support for DMUB AUX")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ To fix CVE-2024-27041, I fix the merge conflict by still using macro
 CONFIG_DRM_AMD_DC_HDCP in the first adev->dm.dc check. ]
Signed-off-by: Imkanmod Khan <imkanmodkhan@gmail.com>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 8dc0f70df24f..7b4d44dcb343 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1882,14 +1882,14 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 		dc_deinit_callbacks(adev->dm.dc);
 #endif
 
-	if (adev->dm.dc)
+	if (adev->dm.dc) {
 		dc_dmub_srv_destroy(&adev->dm.dc->ctx->dmub_srv);
-
-	if (dc_enable_dmub_notifications(adev->dm.dc)) {
-		kfree(adev->dm.dmub_notify);
-		adev->dm.dmub_notify = NULL;
-		destroy_workqueue(adev->dm.delayed_hpd_wq);
-		adev->dm.delayed_hpd_wq = NULL;
+		if (dc_enable_dmub_notifications(adev->dm.dc)) {
+			kfree(adev->dm.dmub_notify);
+			adev->dm.dmub_notify = NULL;
+			destroy_workqueue(adev->dm.delayed_hpd_wq);
+			adev->dm.delayed_hpd_wq = NULL;
+		}
 	}
 
 	if (adev->dm.dmub_bo)
-- 
2.25.1

