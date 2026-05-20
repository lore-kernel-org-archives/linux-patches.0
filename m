Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31AF36B05E;
	Wed, 20 May 2026 16:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295281; cv=none; b=cwhZWeyNjUv/aRPnLW0QOKrSYP9IgCN8Q39I9rKqcpJ6XwgB5djwBVoiMRYJSDvVr9HRzowffXWwwNyW8fBVI8Gqh3H50xojG8SSA3FsRtusyv/xb7S50YM/XbMHFtoUPVOhTA+tqRXhFnpPqY2lpH9xAKoI63KHqXW4zwXx8wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295281; c=relaxed/simple;
	bh=r0vci2TfYZas9C0a5Gz08V8CGeCEA+v2Is58dr/XKb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pHBQ5QajWhP/Pg3ib9eppXSNhtloqexRfus9UWLMsmaCEMHwKhpCJ88qjCb5Pl/2O3cy+u9u7eSP3GcVzYHwESuAk4j6ox+zneq3v+RPtwQEHFqmRwRj8lTb5MPWEcyjPZQjCZTkgrLPisvErKeawcv/KYChosNmSTkG78YZgpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6Y4DgTI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6Y4DgTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644051F000E9;
	Wed, 20 May 2026 16:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295279;
	bh=ghtvidYwyFhC9Q+M79aniIodkd4Owz3JSg+B2P7snTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w6Y4DgTIn+bZ6RKIyCbqkovpLP+2qdQ3xwD10xFNP8zaaxG7xoUkrnsClD9MQvBwf
	 MytDT6/GjHA/wKbFNgS6FjcLp4jfuJGzvSIA28qVB7v65Vsw2MM5Y3qKnky1LV2Uak
	 q9Zk0SIUxM8V1/xP10sbSznYOZOWkFsLAQuqkQZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0342/1146] drm/amd/pm/ci: Clear EnabledForActivity field for memory levels
Date: Wed, 20 May 2026 18:09:52 +0200
Message-ID: <20260520162155.940810894@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index b5f6a5da6549d..9898c846c78e2 100644
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



