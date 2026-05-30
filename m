Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E623434389B;
	Sat, 30 May 2026 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161086; cv=none; b=uzxbMmZ7AEsbwRu7upX5bwkRCIPXg7mpqRKPhiLgWIm0AQIGQZ/EKQqAe+hWyPLnN1wIzGCkp+sYkfgr41ed2EPB+wdkMmeooKbra2nbIXE0Q47BCT0r4u95dTrNCG7B0dycwGBuLuxzAI0LP4zwIbe/4rCrtNB2/8RvgFeXv3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161086; c=relaxed/simple;
	bh=+eZmsAKfsJigzf6ZoqpOFkeFt2hmPeSyexbMSUpLZvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CxixPd+mRy4VD/lm3GpgSiXZ5vMRMXJncAUn6g4D/ctlzJ7gy1c7rjSreJFl5WVQEJMenzKYb7itIrDhDishCco0fB7BUthz9xF7SF5pr9NH1vxdATA3/Yd5aqZQpdV4xFdCbNEa1tisZEpF7Wm6DtGYdtVms92RNg/VbeMQUDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnscPPHs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnscPPHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE3C1F00893;
	Sat, 30 May 2026 17:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161085;
	bh=Ff+IsprVpOv1+nW5qtD4f4dnGlOPbWFP6iZu1T59K9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnscPPHsIuqCFx9kwuyU/qfSxjoirWSifUTHFJ62XW3CL26Qu6k1EY78qNajgWZFe
	 42r+wa2P+S0drthrGRsjRXEZW4fL07E3VmnQy9PC04NPyQrNuQ4/Avj2obfW5m4vag
	 yRGJ7LPFoxOQAro+QdZPqnQC8oRX0m2Hwe0YRaw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 521/969] drm/amd/pm/ci: Clear EnabledForActivity field for memory levels
Date: Sat, 30 May 2026 18:00:45 +0200
Message-ID: <20260530160314.740823761@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 5facfd4c4c67e8500116ffec0d9da35d92b9c787 ]

Follow what radeon did and what amdgpu does for other GPUs with SMU7.

Fixes: 9f4b35411cfe ("drm/amd/powerplay: add CI asics support to smumgr (v3)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
index a43753f11ee96..0839be4dc38c7 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -1218,7 +1218,7 @@ static int ci_populate_single_memory_level(
 	}
 
 	memory_level->EnabledForThrottle = 1;
-	memory_level->EnabledForActivity = 1;
+	memory_level->EnabledForActivity = 0;
 	memory_level->UpH = data->current_profile_setting.mclk_up_hyst;
 	memory_level->DownH = data->current_profile_setting.mclk_down_hyst;
 	memory_level->VoltageDownH = 0;
-- 
2.53.0



