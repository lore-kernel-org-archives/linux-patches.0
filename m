Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FCB39478D;
	Sat, 30 May 2026 18:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164097; cv=none; b=CNBrdWhcboIGYKPiU87tj6MCYIZYMxMAHoEYYQpSaK+d7BxOcTyLN+wBefu+aaINowqIBirb2MoQvAsDlWAUDuAzWdee4UndG5GCIFT6c3L5uGeZCAv41jyOjTKC3RMqfdSiJfWWMSmsuYz4JJGuKHQ888SpazPgtmAs+g5w8/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164097; c=relaxed/simple;
	bh=5S85IxGx85Uo0xlZyqetz4NPIASiQp01BgyrTFeEvkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MgZgOqBG/qfYI2P8c/b6CSNFrMnNvThtcpCdFMMTIMcf1o7f3HjKuMvO54T304aiqwKeJ5uCg0oBUKfYLNvfaf2MNUr3BaOxD5H7K4pwQTTMlwVIkgUKPxhGVAME8zfg28cKJ3+fx66UbZSBj0VII1naCOotdOcZc2SMEYfqg5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2PaVgW5c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PaVgW5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DE61F00893;
	Sat, 30 May 2026 18:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164096;
	bh=t9xmSuJnmubvJ84c8ndmTs53jw7GWj4hhSrqms3sCWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2PaVgW5cE9mzTYB+WyIanzdGUe9BZZHAWwW+2EhAq6bWpE5LACQdJk3dMTfGCbKGF
	 x1eNMQQA1DPX6LPDwlBBGfbMgMoB3I0X/Rz4cIUHZKX7uT3iPgXEud1bDUS3TRb7Fb
	 yzl31H1ZLrFB22V8nJ/MwjwqhO0taHuuvjVez88Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 453/776] drm/amd/pm/ci: Clear EnabledForActivity field for memory levels
Date: Sat, 30 May 2026 18:02:47 +0200
Message-ID: <20260530160252.091362000@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f898d596c6516..c88ec43bd7c6a 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -1216,7 +1216,7 @@ static int ci_populate_single_memory_level(
 	}
 
 	memory_level->EnabledForThrottle = 1;
-	memory_level->EnabledForActivity = 1;
+	memory_level->EnabledForActivity = 0;
 	memory_level->UpH = data->current_profile_setting.mclk_up_hyst;
 	memory_level->DownH = data->current_profile_setting.mclk_down_hyst;
 	memory_level->VoltageDownH = 0;
-- 
2.53.0



