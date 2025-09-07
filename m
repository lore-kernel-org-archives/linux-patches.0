Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30691B424F;
	Sun,  7 Sep 2025 20:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276262; cv=none; b=HzWtHNgRgUbv59CM2Ovxj976Vz+whVjqjpcKUBhgO0c0J1vp1NOr5jnWgi9vys8s//vMX3iKF0YPaGRTOLbfolX8Q1qlFBqYmg9ZXG5/P39CZaG2Ew681VHjWyeftueB39vjqpQ+OBZpPrTLz3X7w7iXUJrcMo4FIHEA1KyLPwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276262; c=relaxed/simple;
	bh=rovSKnFO2X3hmgGVnJQq9tsupR0iNyTNfUkzQPeYlf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYcprAtC/Zts7bP3Zs9ZiARgggIBLNDRccGE5jOXRpF+XuIzkhY1oetXBAQpWJMosQ8OQCYmHQcl3EURP1NVu/AoTF+bE5mG7N6ckC/iX/DPgJ96vbd0NGGoXpKhvJupWsSQimHXFna6XUBA6K0fVXBU7+g+9J+cFKUNgK1VIpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0T2vIDYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0T2vIDYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523A6C4CEF0;
	Sun,  7 Sep 2025 20:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276262;
	bh=rovSKnFO2X3hmgGVnJQq9tsupR0iNyTNfUkzQPeYlf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0T2vIDYMLm8E4VCm5gtwwPH4tjnua9oqAMpTII1qLMCnP9qYq3e1x7PGzOKnhg6DG
	 VmYY9TUGVl/jTgjiG/lSTZip3co4TEfX8MDCBtYPZHV0AZ+eVoX9f+nZY0vKq4RTJr
	 XUcIeTxOdQURj3aKxXzxsX8awyAa+rqrk6yFxWBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	oushixiong <oushixiong1025@163.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 048/104] drm/amdgpu: drop hw access in non-DC audio fini
Date: Sun,  7 Sep 2025 21:58:05 +0200
Message-ID: <20250907195608.940130147@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1464,17 +1464,12 @@ static int dce_v10_0_audio_init(struct a
 
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
@@ -1506,17 +1506,12 @@ static int dce_v11_0_audio_init(struct a
 
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
@@ -1375,17 +1375,12 @@ static int dce_v6_0_audio_init(struct am
 
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
@@ -1427,17 +1427,12 @@ static int dce_v8_0_audio_init(struct am
 
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
 


