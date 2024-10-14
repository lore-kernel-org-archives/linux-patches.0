Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6394B1C7608;
	Mon, 14 Oct 2024 15:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919658; cv=none; b=Xkncq2D67j74Cl0TvM7FsEVUEPNItkj5oXK4pa/OSFAbg1PzG60/yzczhqKvvx0vYnIZYyPsKF41HIRQiXoROIdqBdQ0Gb54O0XMCC/5rje6LK+b32GAImxacepZ4iAJoaFWPD3eVWe5QX/rLtWfpUlogWW7nxc5Xoe3Sx5DEXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919658; c=relaxed/simple;
	bh=U9TnY9xK9o6mS4ZCZxKaIhwq/eX2AJvi/9iM8yz4A9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SZCWLskSuwAtyZNbz7kwKgvJRfB1AvIlbV47ij2I2yUPG4OYNu+8P4TnmiBrb1/ISOIb1hziGfx+FPnkKh3IausLxwyvUQ5r1BYWftbqtKBfnzPwFGCTkJuDJ6aPXY5w155LoTFRw4b2AhSB66BqdQ3X84GD+ZW2lhfrU7AVoKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1ewJYan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1ewJYan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5029C4CEC3;
	Mon, 14 Oct 2024 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919658;
	bh=U9TnY9xK9o6mS4ZCZxKaIhwq/eX2AJvi/9iM8yz4A9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1ewJYanDX2Kx0cc9a1V6ytByJEtOBmYcseICUR7ueDmoX06DrW3wLV+4eO6GsBgz
	 2QqdwB3UhYtY25+Xp4HmzYXDICLMFR4jR1kiH7M92bP2pA1oBBAwN1ydwqEZj4I8nL
	 n2RErjN1jS7SPbmIeyCffAzTt4Xm/t8ury5Mx998=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 630/798] drm/amd/display: Allow backlight to go below `AMDGPU_DM_DEFAULT_MIN_BACKLIGHT`
Date: Mon, 14 Oct 2024 16:19:44 +0200
Message-ID: <20241014141242.787953258@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0625c4f075f2d..8f7130f7d8c69 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4077,7 +4077,7 @@ static void amdgpu_dm_update_backlight_caps(struct amdgpu_display_manager *dm,
 		int spread = caps.max_input_signal - caps.min_input_signal;
 
 		if (caps.max_input_signal > AMDGPU_DM_DEFAULT_MAX_BACKLIGHT ||
-		    caps.min_input_signal < AMDGPU_DM_DEFAULT_MIN_BACKLIGHT ||
+		    caps.min_input_signal < 0 ||
 		    spread > AMDGPU_DM_DEFAULT_MAX_BACKLIGHT ||
 		    spread < AMDGPU_DM_MIN_SPREAD) {
 			DRM_DEBUG_KMS("DM: Invalid backlight caps: min=%d, max=%d\n",
-- 
2.43.0



