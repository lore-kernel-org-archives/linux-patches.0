Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608F7304BDB;
	Tue, 11 Nov 2025 01:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824417; cv=none; b=ot1Cis703ooWcVvfJEHoZb+zwZ09h0qiY5MgyD1QxNiX24m+Y0s33Nz0RBJmaZqlHwij5dQEXuukHuT5p9cB8YvUXIG+cD7j9woNbsyjo+N0PYWOVpjEUwiLHw66oX2W5jGejQoVooWxrv4f/zGNLX4DJpXb3F/0zdmDQjzPll8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824417; c=relaxed/simple;
	bh=krjBI1iW/svi+kDvXRlTC0nItvDHVHJbLmpN3vCM2Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0a5bnZQT/JuOf9Fz17TlR6wKWrE19ZprUFrydFPmxiPhRYR/RbZQ+b4YnlzXt9XmI+kgD9EFIexcCgJFjGzydrBO1oz4PMSWwEjb7efWXqK2FdF/2UjFi++I+6iPm4lWiXwrJobzWZao8kWeRQIwTCecgaV3yTwGQ6oX5Z6jzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgyptyUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgyptyUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86D8C4AF0C;
	Tue, 11 Nov 2025 01:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824417;
	bh=krjBI1iW/svi+kDvXRlTC0nItvDHVHJbLmpN3vCM2Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgyptyUHBwjO3N1Vy6OgArep/7K2zZrn1Wg1Lv5P74l14DQLkbMDosgc3Mb01tTZz
	 hMQQ5Cuv8uinrIli/obdo1jLSejNoR6n1fJRXE9UtxjynCvd7W5VzVuOBVHjftxcpF
	 fMvRJMlZnmNtTFBwQpunDcUwePJswO1ZEbkn4Oz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 455/849] drm/amdgpu: dont enable SMU on cyan skillfish
Date: Tue, 11 Nov 2025 09:40:25 +0900
Message-ID: <20251111004547.429016758@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 94bd7bf2c920998b4c756bc8a54fd3dbdf7e4360 ]

Cyan skillfish uses different SMU firmware.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index e814da2b14225..dd7b2b796427c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -2126,7 +2126,6 @@ static int amdgpu_discovery_set_smu_ip_blocks(struct amdgpu_device *adev)
 	case IP_VERSION(11, 0, 5):
 	case IP_VERSION(11, 0, 9):
 	case IP_VERSION(11, 0, 7):
-	case IP_VERSION(11, 0, 8):
 	case IP_VERSION(11, 0, 11):
 	case IP_VERSION(11, 0, 12):
 	case IP_VERSION(11, 0, 13):
@@ -2134,6 +2133,10 @@ static int amdgpu_discovery_set_smu_ip_blocks(struct amdgpu_device *adev)
 	case IP_VERSION(11, 5, 2):
 		amdgpu_device_ip_block_add(adev, &smu_v11_0_ip_block);
 		break;
+	case IP_VERSION(11, 0, 8):
+		if (adev->apu_flags & AMD_APU_IS_CYAN_SKILLFISH2)
+			amdgpu_device_ip_block_add(adev, &smu_v11_0_ip_block);
+		break;
 	case IP_VERSION(12, 0, 0):
 	case IP_VERSION(12, 0, 1):
 		amdgpu_device_ip_block_add(adev, &smu_v12_0_ip_block);
-- 
2.51.0



