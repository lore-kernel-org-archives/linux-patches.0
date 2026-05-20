Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA41D331220;
	Wed, 20 May 2026 17:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298150; cv=none; b=in6CQi0X4Vk5HN6R4+0IJejzxuy2616e70rX+hFGzxjHla6tLODgBjKEdy8lpUVQbZnWN4CpoXkQjgEh4+KA338sSsEnvF3SX5H2mgcbVa4OLPTIfdcjmEXt1z4ounw4oHOn97o9yjTtETerha9TTkJX3bl48qcV/qv40MClOCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298150; c=relaxed/simple;
	bh=Kq7BjAp9OpztnEXuaJ8nEF+BBQ/WJI6o7FvEeXuJV9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ekIBuTaPZ/MxduwURqH43U/+V7fGE2qKCUUTP4kbnqqidJqZc0XEQ4qEsFwWgGERR5bjymxdpVQ72qO8gaF0T+ayfEon4aOFLo1WwndcJOSlnOehqMv4y73D2Hyi/VGdnpY9wwtiONEKE7UUGW/Ay27zxMSUHJfLfaF1VKfied0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TkMTPi2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TkMTPi2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2D71F000E9;
	Wed, 20 May 2026 17:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298149;
	bh=ozgy0kSjb5iMgU64lhcsEvhMe6UGlDpuPiHITdM9B+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkMTPi2yHKWWem4qv//eaCJslgHCQb/IXoNbOXJ1gVHuZ5KAQ1lAW9Q0YrSnoMm2Z
	 G6yXKIyX1WiKHI27wylRP08heYzKOTifOoUAVRdT0g+Y2mBytiAGQPNzLqnL/70x9F
	 fOeyVNrKJB9gchMjMYaUXKYeEJ+BHVeCzA+qTcwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 264/957] drm/amd/pm/ci: Clear EnabledForActivity field for memory levels
Date: Wed, 20 May 2026 18:12:27 +0200
Message-ID: <20260520162140.269044799@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1d99b4f9bc03e..1494143132eb5 100644
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



