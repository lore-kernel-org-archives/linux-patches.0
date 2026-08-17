Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4116D44236E;
	Mon, 17 Aug 2026 13:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975058; cv=none; b=LRdUkQ5dY9QRoJn2PHBA7mc/Ve2+PdyuBkVgHomF77swzYzh1dfUjVkqb40gbxmdBxH8738bUgDvc+a+v6VvmwSHSBq2jsmuaccbWjCbp3rJOExpAcI3vkiismDd3MDXtC1+cwC6Qs/LyFg+NsbY5RosE0BIckBjoYvRzNrNLoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975058; c=relaxed/simple;
	bh=S1X2v0Gv6PKDvbIbUlHCKlpk+z43PrWOQQsqZAhkOXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=po7RuFNWX5QGpjp8f6UY9qqS/kM78HWK6kDvQCTCQnVgE5cGKT9E+TLNR/I47TntyetgQEFMa5B/d6mgm1pl/J4c3HOd5BAZzK3REm8Ms9qkiKSz2lXuhRyVp5HlnNxUWGgP8hQXn6zBZZemuP/4tsYD6pcvg8Jd2srQZZPmOQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9ynaEFT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9ynaEFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDA51F000E9;
	Mon, 17 Aug 2026 13:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975056;
	bh=4WgW1Pbie6ej6DN/hgZFE6anjGEXf2YAdpc3Ov3rguI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9ynaEFTCcc9mw2zv7jCPVEH/4qWFpAzJwGMjny5P+44a0/hKfnZB//D86WKh2+Pt
	 fB4BSgGydHvo9OINXVulBiagtvjJTBRIAiaGlZ7OY1w8mIB2Q06GcZ2u7fWrdE2ezd
	 WyQxubv8y5umIpGNkLUAirsmNr4YZqvs7RrWBY8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Sergio Callegari <sergio.callegari@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 146/250] Revert "drm/amd/display: Fix backlight max_brightness to match exported range"
Date: Mon, 17 Aug 2026 15:31:47 +0200
Message-ID: <20260817132542.519104730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

This reverts commit 490ceacd2162de919a142bcb4eff363bb493b1de.

This patch is apparently missing a dependency from 7.2 as users have not
reported any regressions with 7.2-rc, but there are regressions on 6.18.

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
index 4f53297786623..fd5a6c6532a1e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5222,11 +5222,11 @@ amdgpu_dm_register_backlight_device(struct amdgpu_dm_connector *aconnector)
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



