Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B485331A41;
	Wed, 20 May 2026 18:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302178; cv=none; b=d9ly0oHHGhyOZBynYoN5QbbZ7aBvioDrK6jQbW3P7i7FtG8F31DoyosGmMCZCeVrktqP88ofvCOH06vMYMPrvhW5Lj4XVcNkBS4sTz0yxeoWaxvmDPXMOQG02a2ixStnCist6gmjIJ7YyrH2vmhhMPVxCElP786oi/UDD3fydmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302178; c=relaxed/simple;
	bh=3db8NSAepVo6GLo695pGw7+IwbDvYOyfN4T71FL7LGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mECEB2hQQ2V0rheLWwZ8pvDtXJ+oS6/STuJKw4HV4Fd7SvBGv3+DFbTfwdCuPwa/Cqr8ComBIEZsBNuHWIEOijDkF7GJ4/xcDLF2pZTlyH2pWHuh7oUf2yR/q78NEFrsXF+F2v9KUxsHuTVmJm9vdvmvMTO5tHq2bRJIRobe1SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVgdxOD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVgdxOD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0AF1F000E9;
	Wed, 20 May 2026 18:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302177;
	bh=ML1MzakHzznCl47ND9FG5EuGpYzrxAztKdrcFM+3ceI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OVgdxOD2VKYPGfSwfDDC1Gvh9ttftpmehK0IRBZusPmMnQAUWwKKbQtxV6nSh01vh
	 8sQv2rUSfdtUzscQpRoXFU9yUarAeikgP9z/PsWgz9msnhip7mWEDfcitiUomsnhTV
	 1htclmqQJ1Ckxui2+roPihB3gCJCm77oarnl3UNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/508] drm/amd/pm/ci: Clear EnabledForActivity field for memory levels
Date: Wed, 20 May 2026 18:19:09 +0200
Message-ID: <20260520162101.359994108@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b600a87fbb005..4a0e8887fa74b 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -1217,7 +1217,7 @@ static int ci_populate_single_memory_level(
 	}
 
 	memory_level->EnabledForThrottle = 1;
-	memory_level->EnabledForActivity = 1;
+	memory_level->EnabledForActivity = 0;
 	memory_level->UpH = data->current_profile_setting.mclk_up_hyst;
 	memory_level->DownH = data->current_profile_setting.mclk_down_hyst;
 	memory_level->VoltageDownH = 0;
-- 
2.53.0



