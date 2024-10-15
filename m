Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BAF1EBA19;
	Tue, 15 Oct 2024 12:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993953; cv=none; b=ZIIgNM//e7oXgWA9oC09VvUFtPckhlW3gTuLaOvYLztSV+d9Dlp7PnnyFWpCMRCLhcuN4F95SOioCHDND9B/0vKJDWQSCgMIzSznSCWWJ1+EN84hQfiHRb8pP1jZPCIDEkQBaUq5vcn81sehSANLCJCUCHy3+zzCu7ZXiMUYj8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993953; c=relaxed/simple;
	bh=7V4V7u/Y6MrxyFO/PlOppLf4PCPxa0f25awaDdOWurI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XLNL+KzoxK4a94b4RGXjnAHJwnpOeQ9Ic2usNqkdQ5jyLn6gWD+lxK1LMmPzU00Oqt1vrY9Q3pgv66bhZpjsm/sfoUsEbYrJTexBkFZ94J8+omCONRy8AfD2DGmlTbHhS6WpPit2D4P5bTL/1d7pB4rupxmHFskFLVHSkY/m3bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHaYjuH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHaYjuH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7731C4CECF;
	Tue, 15 Oct 2024 12:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993953;
	bh=7V4V7u/Y6MrxyFO/PlOppLf4PCPxa0f25awaDdOWurI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHaYjuH2fcwLgSO2QvpdfIqeWdMK5M1O91YLLQ/vJXF2W7h3ZbV+g3VuXKV0zHr94
	 FqTVkB312GKFjd+RvfpkrT7XdkP3P2ciL/3L5lZjAe3DWujDFZ4G3m/+NHwsA7WaX5
	 Cmv1Anyckr3aYsZJoP9qFMFOM7g3RBfp1YwnYsSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 564/691] drm/amd/display: Allow backlight to go below `AMDGPU_DM_DEFAULT_MIN_BACKLIGHT`
Date: Tue, 15 Oct 2024 13:28:32 +0200
Message-ID: <20241015112502.728584470@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f964e79babdb5..bfa15d8959553 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3936,7 +3936,7 @@ static void amdgpu_dm_update_backlight_caps(struct amdgpu_display_manager *dm,
 		int spread = caps.max_input_signal - caps.min_input_signal;
 
 		if (caps.max_input_signal > AMDGPU_DM_DEFAULT_MAX_BACKLIGHT ||
-		    caps.min_input_signal < AMDGPU_DM_DEFAULT_MIN_BACKLIGHT ||
+		    caps.min_input_signal < 0 ||
 		    spread > AMDGPU_DM_DEFAULT_MAX_BACKLIGHT ||
 		    spread < AMDGPU_DM_MIN_SPREAD) {
 			DRM_DEBUG_KMS("DM: Invalid backlight caps: min=%d, max=%d\n",
-- 
2.43.0



