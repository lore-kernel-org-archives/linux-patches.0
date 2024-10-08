Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C2F192594;
	Tue,  8 Oct 2024 12:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390977; cv=none; b=phz30ttuPptpFlAx7I5SgXjOGJ2DEP3LuXEcdLhHEYGiNBs7mnZ/5mgPhaMNfQTeFP6yHM0EA+/xFPo2hUZrBwowhWBRn4oQ9kd9THtFKtfWskA+lOrTpzXnE/yMZn8Y6cZs8VyDV5Tmx2kMiGAycMw0zyFPZrLmwaS/0QpaN/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390977; c=relaxed/simple;
	bh=EfKKo307UtEOv/T+MKGne6fEe7GrIHKMLeC/nn6G07Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cGvWGyJy5X2AQENtBu29HzS/vHGBJ7nMMKDWx30nSJBmrT+iza6kZ21rCkcaDqhld0rxByANM4tqRdt4dSlnbctBxF0xThqXR1OrxjLmzgEU/v6BgLrYMKPZ9VthzRp5N9NvTETRMl7ozumVA+jci6PW5nhMjPqlQMx6URbSLbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGl5+rJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGl5+rJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2070BC4CEC7;
	Tue,  8 Oct 2024 12:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390977;
	bh=EfKKo307UtEOv/T+MKGne6fEe7GrIHKMLeC/nn6G07Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGl5+rJllojLU3eoFjGHyxhIVr738jNfPE8F4IsULva1dzp6hXSWDQ9iTVhm5Jre+
	 6VAmFM1dTtkZicXmljgJgdeDnccW3dECbj4CurSXfimhfNTVzwLlTkc5u7i7SBb6s+
	 eufQAETfaqVjtjk6uCeZNJ2wngPkSTYiXf9Sr/Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 452/482] drm/amd/display: Allow backlight to go below `AMDGPU_DM_DEFAULT_MIN_BACKLIGHT`
Date: Tue,  8 Oct 2024 14:08:35 +0200
Message-ID: <20241008115706.305897026@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 87d749a6aab73d8069d0345afaa98297816cb220 ]

The issue with panel power savings compatibility below
`AMDGPU_DM_DEFAULT_MIN_BACKLIGHT` happens at
`AMDGPU_DM_DEFAULT_MIN_BACKLIGHT` as well.

That issue will be fixed separately, so don't prevent the backlight
brightness from going that low.

Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/amd-gfx/be04226a-a9e3-4a45-a83b-6d263c6557d8@t-8ch.de/T/#m400dee4e2fc61fe9470334d20a7c8c89c9aef44f
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d2554b4a14fe9..83f4ff9e848d7 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4176,7 +4176,7 @@ static void amdgpu_dm_update_backlight_caps(struct amdgpu_display_manager *dm,
 		int spread = caps.max_input_signal - caps.min_input_signal;
 
 		if (caps.max_input_signal > AMDGPU_DM_DEFAULT_MAX_BACKLIGHT ||
-		    caps.min_input_signal < AMDGPU_DM_DEFAULT_MIN_BACKLIGHT ||
+		    caps.min_input_signal < 0 ||
 		    spread > AMDGPU_DM_DEFAULT_MAX_BACKLIGHT ||
 		    spread < AMDGPU_DM_MIN_SPREAD) {
 			DRM_DEBUG_KMS("DM: Invalid backlight caps: min=%d, max=%d\n",
-- 
2.43.0



