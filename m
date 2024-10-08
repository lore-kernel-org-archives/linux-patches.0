Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56171DFE04;
	Tue,  8 Oct 2024 13:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394074; cv=none; b=LlUHB3Gkh852cSx3QEDiIzXNtQz82T1i2VF/ifJq/eJuKfwYrPjRzqrKoPGxsbjBbLvemTjbdvUgDgEhYBvzjQfHkLhYBq21Y2usyNHW4MDK0n6xcMgMIrlBszgFrjRgk5j3AlT4wgUTAhz1rCiKgGKUiySmQhBAoCIhEs9iufQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394074; c=relaxed/simple;
	bh=Bmkxw8ZJi8G7PzPBzUUXDwiv+5V+UuwsH4r7r6F/LUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pXkXuXwx7ZlTXRjPmOgXdyp/ExIxmfe2/xrwx4w4NmlQCw7P+FXOyyNeI6dpsZ3B7z8w3ZkktnvX0YYw5Q5TwBn7rffLJMFOH0jRgte2lThIn1N50O30AtIT6SfnB/x1034Zha6eZakxKL76yiEI6x7uzbAnRZ/o/f1Zgck4plk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MO808zy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MO808zy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63885C4CEC7;
	Tue,  8 Oct 2024 13:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394073;
	bh=Bmkxw8ZJi8G7PzPBzUUXDwiv+5V+UuwsH4r7r6F/LUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MO808zy16c4coRY+bJK1KBWqC/hvtjUF5iP6zTFTjdkpIfFtKVpiQED0dM+RKL65b
	 SS506ShirO5zqYaGKpgEyUiGwjAriwyB13ny2rX625QBuRN3k7e+jhZp2541doKXG8
	 I0+q1viLqaGwoQ62r9LUe128xLZeBE/Hr6BbVOqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 340/386] drm/amd/display: Allow backlight to go below `AMDGPU_DM_DEFAULT_MIN_BACKLIGHT`
Date: Tue,  8 Oct 2024 14:09:45 +0200
Message-ID: <20241008115642.763219644@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3636872429d19..a3f17c572bf06 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4064,7 +4064,7 @@ static void amdgpu_dm_update_backlight_caps(struct amdgpu_display_manager *dm,
 		int spread = caps.max_input_signal - caps.min_input_signal;
 
 		if (caps.max_input_signal > AMDGPU_DM_DEFAULT_MAX_BACKLIGHT ||
-		    caps.min_input_signal < AMDGPU_DM_DEFAULT_MIN_BACKLIGHT ||
+		    caps.min_input_signal < 0 ||
 		    spread > AMDGPU_DM_DEFAULT_MAX_BACKLIGHT ||
 		    spread < AMDGPU_DM_MIN_SPREAD) {
 			DRM_DEBUG_KMS("DM: Invalid backlight caps: min=%d, max=%d\n",
-- 
2.43.0



