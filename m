Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31280194A45;
	Thu,  5 Sep 2024 09:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529863; cv=none; b=uYKVxgr6nGNS6PianXYqOqyZ6l3mYVlmR3LXbhWrQPUfjb9uGHW5ynWrVAo6+Xl/8tsX17Q97rCDRBURicnvz6mGl0Qft8d1Pv7Z7XJr/jESmGyNqUb8c44kmZYLZHp6Lao/apVyd/KsW9AXHRPAS+uIIZW7pYaEf/lzuWryk4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529863; c=relaxed/simple;
	bh=8pbL2o1RADaQQx+35Me4kMZBy6EHb0nUQuqDSq3h2b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eVr57tTe9AcS73eFbgAV9/Cd+xy7DuXR1W/eJLX5HbxcmpgS0lEOCIDw9zdaVpyYyrcO/WGwQ/ZzdhWdvRi0IV5yTXKEvbN+uCXJfRTDPfxIUkmHW2/jJl3/vGBZbkjijriy9YNDUXbbOOPlwztmhZoclIHPX+9i2Iml7d5NNwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5B7zs5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5B7zs5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65886C4CEC3;
	Thu,  5 Sep 2024 09:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529862;
	bh=8pbL2o1RADaQQx+35Me4kMZBy6EHb0nUQuqDSq3h2b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5B7zs5Oef4RU5svOtKM7h07eCursZjxqNAwQpe3LcRWm6E+jDCy23XCxMgiLYgSk
	 dtF3BXs8SyrwftqJxqaKhFB9T4THLyPh+9DQLWYinZKf/R9/Yt/zEhaAt3YagrTuVR
	 WENYLAIAOGqpqZ+RZRCzdLWrhY/5pJhP7+jijuXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 166/184] drm/amdgpu: fix overflowed constant warning in mmhub_set_clockgating()
Date: Thu,  5 Sep 2024 11:41:19 +0200
Message-ID: <20240905093738.819827631@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

From: Bob Zhou <bob.zhou@amd.com>

[ Upstream commit be6a69b21a3517122ba6cf7ab8f62f4803637dbe ]

To fix potential overflowed constant warning, modify the variables to u32
for getting the return value of RREG32_SOC15().

Signed-off-by: Bob Zhou <bob.zhou@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_7.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_3.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_7.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_7.c
index 92432cd2c0c7..9689e2b5d4e5 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_7.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_7.c
@@ -544,7 +544,7 @@ static int mmhub_v1_7_set_clockgating(struct amdgpu_device *adev,
 
 static void mmhub_v1_7_get_clockgating(struct amdgpu_device *adev, u64 *flags)
 {
-	int data, data1;
+	u32 data, data1;
 
 	if (amdgpu_sriov_vf(adev))
 		*flags = 0;
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
index 02fd45261399..a0cc8e218ca1 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
@@ -671,7 +671,7 @@ static int mmhub_v2_0_set_clockgating(struct amdgpu_device *adev,
 
 static void mmhub_v2_0_get_clockgating(struct amdgpu_device *adev, u64 *flags)
 {
-	int data, data1;
+	u32 data, data1;
 
 	if (amdgpu_sriov_vf(adev))
 		*flags = 0;
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_3.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_3.c
index 238ea40c2450..d7c317825497 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_3.c
@@ -560,7 +560,7 @@ static int mmhub_v3_3_set_clockgating(struct amdgpu_device *adev,
 
 static void mmhub_v3_3_get_clockgating(struct amdgpu_device *adev, u64 *flags)
 {
-	int data;
+	u32 data;
 
 	if (amdgpu_sriov_vf(adev))
 		*flags = 0;
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c
index 1b7da4aff2b8..ff1b58e44689 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c
@@ -657,7 +657,7 @@ static int mmhub_v9_4_set_clockgating(struct amdgpu_device *adev,
 
 static void mmhub_v9_4_get_clockgating(struct amdgpu_device *adev, u64 *flags)
 {
-	int data, data1;
+	u32 data, data1;
 
 	if (amdgpu_sriov_vf(adev))
 		*flags = 0;
-- 
2.43.0



