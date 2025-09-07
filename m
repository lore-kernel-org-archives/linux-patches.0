Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D911CDFAC;
	Sun,  7 Sep 2025 20:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275819; cv=none; b=OFuaZZBOuZ3jgAQsWBV61ipVseeCoUuw1Xn83/CvwmV1baOD97OhRZ9tWJO1OR1tI8O+J9cAhJ6lH/eaZWBbLADXjYgz3eRJ8TSuvt3GEAOtpSRuXzMx4M/HUon4c5uT9LSRPw+4s8DGOZZMagiAbevD5nCg7aCfzz//lsYNy0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275819; c=relaxed/simple;
	bh=QfgGWkT2ce22Wmyl56AEvDknJx7pYCYK7BlLdujFYfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvD8H4HJvuQ05Wxr2vv6eeNhzy/8IPl1Xs0n/Tqs+9ienDz1XV9lrFaDDFduxrxfJoAWu7/8VFVRI5fYkhgXGyN9j72kZ0afWKz9PJYoyZvOh6EF71Prt0GMXGQ7zU4SscJXjbbLkkvtNq/FqL4U3IiJ+7l1kQ9wXVDbJ2ZS3w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7oi9XNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7oi9XNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3915C4CEF0;
	Sun,  7 Sep 2025 20:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275819;
	bh=QfgGWkT2ce22Wmyl56AEvDknJx7pYCYK7BlLdujFYfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7oi9XNqykStha2jF9crMyOsHSHAyhwh+NJoO2004JSdZmdDVbvKHmYb7utnpW+E8
	 iQiYam+4bU3w6xo8FDDjEI8PrVwmktHhKS7Dt23U4VDbMJk8Qg+r6U0bUn53xMl25g
	 6TxF6no37ZD70SCSeYeQkhMCpOeMAX6+E24KEPyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	oushixiong <oushixiong1025@163.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 21/45] drm/amdgpu: drop hw access in non-DC audio fini
Date: Sun,  7 Sep 2025 21:58:07 +0200
Message-ID: <20250907195601.575022979@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1445,17 +1445,12 @@ static int dce_v10_0_audio_init(struct a
 
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
@@ -1487,17 +1487,12 @@ static int dce_v11_0_audio_init(struct a
 
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
@@ -1358,17 +1358,12 @@ static int dce_v6_0_audio_init(struct am
 
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
@@ -1408,17 +1408,12 @@ static int dce_v8_0_audio_init(struct am
 
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
 


