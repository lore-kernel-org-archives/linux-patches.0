Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EA243B4BD;
	Mon, 17 Aug 2026 13:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974329; cv=none; b=eL8L7NrWBhatKyRvKHlXaV+FqByrZE2J5Wr6E37NRjXV3pQjHdRCp8sYAvS329xObN7JonBlb+CrST7LXG1uY50DQln9+U07Rr5Sk214wQyfiFvyv+EjwzYhRIeBgU8xxkPxcWiUobUVQ+AZ7SIwgBfDjgmTQrdNJE3PkDw5rYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974329; c=relaxed/simple;
	bh=KOLf0PmajOZ7OJUBKHvXf6N46xnmlL4PRJ9CLlYUb34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngH/25XyV/zH8bGc0oDSsEa0H9hx3wZRYpBk79GGsW3d9LjmVJMaHeMnDbm9BG0UyGMPAC7rbqsz/IkwM7P1o2UURv6owg/Ory/dpvky/tf+/iGc9ijLmo7W+sOmHS+qzc0JPUoTHPtpKQRWUc0BywPQfKAeZyVamdMnM/oVzkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2Ua2R+k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2Ua2R+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFF61F000E9;
	Mon, 17 Aug 2026 13:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974321;
	bh=C+73DDFU2T/I1OdjRsksPN75Bjoz97F3EFCKdPSUqb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2Ua2R+k/3cERWr/ZbdRslQniRVbGOGgIpg9zrKSePAnpWUKrDgr/nSUKO4y8DeJ/
	 W7OkISpO/rsW+E2EdqVKn3TwFCHbiowANnPmOd/XFMIBcLP0MbafrdYQ2Oj8Wxhxcl
	 BXnVe2EkklITncjgBX4kuZSYrZi1tYzcMVL7WVrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Sergio Callegari <sergio.callegari@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 163/271] Revert "drm/amd/display: Fix backlight max_brightness to match exported range"
Date: Mon, 17 Aug 2026 15:31:28 +0200
Message-ID: <20260817132543.605381403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

This reverts commit 1191285ecb4233e5bf907da7e9394d7999055566.

This patch is apparently missing a dependency from 7.2 as users have not
reported any regressions with 7.2-rc, but there are regressions on 7.1.

The regression manifests as inconsistent lower brightness at the top end
(e.g., around 98%).

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5562
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Sergio Callegari <sergio.callegari@gmail.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 40d82a3eeec05..6f9d4bea33795 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5401,11 +5401,11 @@ amdgpu_dm_register_backlight_device(struct amdgpu_dm_connector *aconnector)
 	caps = &dm->backlight_caps[aconnector->bl_idx];
 	if (get_brightness_range(caps, &min, &max)) {
 		if (power_supply_is_system_supplied() > 0)
-			props.brightness = DIV_ROUND_CLOSEST(max * caps->ac_level, 100);
+			props.brightness = DIV_ROUND_CLOSEST((max - min) * caps->ac_level, 100);
 		else
-			props.brightness = DIV_ROUND_CLOSEST(max * caps->dc_level, 100);
+			props.brightness = DIV_ROUND_CLOSEST((max - min) * caps->dc_level, 100);
 		/* min is zero, so max needs to be adjusted */
-		props.max_brightness = max;
+		props.max_brightness = max - min;
 		drm_dbg(drm, "Backlight caps: min: %d, max: %d, ac %d, dc %d\n", min, max,
 			caps->ac_level, caps->dc_level);
 	} else
-- 
2.53.0



