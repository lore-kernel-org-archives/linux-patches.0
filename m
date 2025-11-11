Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E311C4A24;
	Tue, 11 Nov 2025 01:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824198; cv=none; b=fFDx3etUJ9+CvFQI2OYE0WZAkfF9NR5zp3nrhYPouWLd9UQzrGnfmLARD57HBNlTV5LYDzwcYOJ/sAiQ7MIhpriCg/b5RcizFctnlM85gyeBPHi//TgcUUtPcm8kPNKwCXbYgvujjLSktJaVyUyqpLiTUPUGpepFZtePNTZMUls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824198; c=relaxed/simple;
	bh=Vywo1JvmdO2ALzS3zJmdWGjWrpDEdIydu2lw7elflTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1e8mYw5bI3DQfGZhzSWU7wlPTeAITwEMyyutS90HwIjteip/lgXtCLrAhYcT6jqhwjxiTtY8Dq+n2T0iRAZs6bvGRiUdQteCGj+hF4N0wANfvHFCTUyFLuOhB4+lcDlNjkCrpmzII3JC03vew0zNpZB/OJBQ9BFnRsfr3Q324I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HelsQVHz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HelsQVHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B959DC113D0;
	Tue, 11 Nov 2025 01:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824196;
	bh=Vywo1JvmdO2ALzS3zJmdWGjWrpDEdIydu2lw7elflTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HelsQVHzO9b7Os8sFI4yu6iO0o4UPzWctraWcos1C7sdBrCoHJY8VkWMQjAp5PGuq
	 6UasCzDvF2iqNJ8XEIzEJqew1Heljs0yT7HAsCtoHRS2o2R+FcuwUmJEl9rx3wj0LE
	 iqTpbVOe75a8L4L7GRJOJIGvlqw1fUdK+4uyqaAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Wayne Lin <wayne.lin@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 460/849] drm/amd/display: Indicate when custom brightness curves are in use
Date: Tue, 11 Nov 2025 09:40:30 +0900
Message-ID: <20251111004547.549098781@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <superm1@kernel.org>

[ Upstream commit 68f3c044f37d9f50d67417fa8018d9cf16423458 ]

[Why]
There is a `scale` sysfs attribute that can be used to indicate when
non-linear brightness scaling is in use.  As Custom brightness curves
work by linear interpolation of points the scale is no longer linear.

[How]
Indicate non-linear scaling when custom brightness curves in use and
linear scaling otherwise.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index afe3a8279c3a9..8eb2fc4133487 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5032,8 +5032,11 @@ amdgpu_dm_register_backlight_device(struct amdgpu_dm_connector *aconnector)
 	} else
 		props.brightness = props.max_brightness = MAX_BACKLIGHT_LEVEL;
 
-	if (caps->data_points && !(amdgpu_dc_debug_mask & DC_DISABLE_CUSTOM_BRIGHTNESS_CURVE))
+	if (caps->data_points && !(amdgpu_dc_debug_mask & DC_DISABLE_CUSTOM_BRIGHTNESS_CURVE)) {
 		drm_info(drm, "Using custom brightness curve\n");
+		props.scale = BACKLIGHT_SCALE_NON_LINEAR;
+	} else
+		props.scale = BACKLIGHT_SCALE_LINEAR;
 	props.type = BACKLIGHT_RAW;
 
 	snprintf(bl_name, sizeof(bl_name), "amdgpu_bl%d",
-- 
2.51.0



