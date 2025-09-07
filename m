Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6AC1F09BF;
	Sun,  7 Sep 2025 20:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276636; cv=none; b=I+U/pO70qiD6OjTm+lApW0/x0YDBN/Vgg37frRasuuZe+cIBHs1DWHtgM62u4FYEpqQvhaTpVoeNwcKWkGaB1a0hoo5A0Y+AV0itmnZqp7yIiLThJ8EMhBZJ6J6ogAJZA3q9u+H0/Pi3AKfIasJntxWSTNe15IhYfUAlkUbGHWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276636; c=relaxed/simple;
	bh=ML0BShXLh/EYWJOmtFJryVEqvN3R/T0H4ePcvSGRBMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgBXRypP7Hm7kz3Ugt+jEbQmrTbbxWRJEi7XzHLSNHavjRf5eVcMkeb1y6Mq/UDTz2octl8ZbXEhxGshZi8Qgd/mahsa7+QH5hC12xs3XFMFKzMlVtE3sR7a7AtuM7rQQQBxTKfuLeByJ3UmxL+AIXoEmO7+yepGMzr/1Mq3KAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRdlk//n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRdlk//n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3C7C4CEF0;
	Sun,  7 Sep 2025 20:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276635;
	bh=ML0BShXLh/EYWJOmtFJryVEqvN3R/T0H4ePcvSGRBMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRdlk//nQ0F7UY+FoyvzVOoc30LNYqWG5ag+WKQ4St79OXJy25x/QyJHR4EkDY5tt
	 wMsg6CY8V/7U9b5t3XJlG2pj7B7sDf/zFZUKjglUFwpa4bDZiuZABYr5i8eTQudHEj
	 FUoqkhnhT44lFvfEqlIVNdxHbmHV33GfeqYHMRds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	oushixiong <oushixiong1025@163.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 063/121] drm/amdgpu: drop hw access in non-DC audio fini
Date: Sun,  7 Sep 2025 21:58:19 +0200
Message-ID: <20250907195611.456303103@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 71403f58b4bb6c13b71c05505593a355f697fd94 upstream.

We already disable the audio pins in hw_fini so
there is no need to do it again in sw_fini.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4481
Cc: oushixiong <oushixiong1025@163.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5eeb16ca727f11278b2917fd4311a7d7efb0bbd6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c |    5 -----
 drivers/gpu/drm/amd/amdgpu/dce_v11_0.c |    5 -----
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c  |    5 -----
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c  |    5 -----
 4 files changed, 20 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
@@ -1459,17 +1459,12 @@ static int dce_v10_0_audio_init(struct a
 
 static void dce_v10_0_audio_fini(struct amdgpu_device *adev)
 {
-	int i;
-
 	if (!amdgpu_audio)
 		return;
 
 	if (!adev->mode_info.audio.enabled)
 		return;
 
-	for (i = 0; i < adev->mode_info.audio.num_pins; i++)
-		dce_v10_0_audio_enable(adev, &adev->mode_info.audio.pin[i], false);
-
 	adev->mode_info.audio.enabled = false;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/dce_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v11_0.c
@@ -1508,17 +1508,12 @@ static int dce_v11_0_audio_init(struct a
 
 static void dce_v11_0_audio_fini(struct amdgpu_device *adev)
 {
-	int i;
-
 	if (!amdgpu_audio)
 		return;
 
 	if (!adev->mode_info.audio.enabled)
 		return;
 
-	for (i = 0; i < adev->mode_info.audio.num_pins; i++)
-		dce_v11_0_audio_enable(adev, &adev->mode_info.audio.pin[i], false);
-
 	adev->mode_info.audio.enabled = false;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
@@ -1377,17 +1377,12 @@ static int dce_v6_0_audio_init(struct am
 
 static void dce_v6_0_audio_fini(struct amdgpu_device *adev)
 {
-	int i;
-
 	if (!amdgpu_audio)
 		return;
 
 	if (!adev->mode_info.audio.enabled)
 		return;
 
-	for (i = 0; i < adev->mode_info.audio.num_pins; i++)
-		dce_v6_0_audio_enable(adev, &adev->mode_info.audio.pin[i], false);
-
 	adev->mode_info.audio.enabled = false;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
@@ -1426,17 +1426,12 @@ static int dce_v8_0_audio_init(struct am
 
 static void dce_v8_0_audio_fini(struct amdgpu_device *adev)
 {
-	int i;
-
 	if (!amdgpu_audio)
 		return;
 
 	if (!adev->mode_info.audio.enabled)
 		return;
 
-	for (i = 0; i < adev->mode_info.audio.num_pins; i++)
-		dce_v8_0_audio_enable(adev, &adev->mode_info.audio.pin[i], false);
-
 	adev->mode_info.audio.enabled = false;
 }
 


