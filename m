Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B02D2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D4DC433EF;
	Sun, 22 Jan 2023 15:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401259;
	bh=VphJR+CIUThxctrSeScv7ZIbRVxJ5WWEHo+nYV7h4Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fIFJKC3sgyh2EZ3T9zT2LI9aU4Fz+r+z6wDEfCIycSRp8uus8zS4j8OsqnrLhevTm
	 a+sCsW8vkgJlMpQfBviVrPO8M7p6LqPj+SjIxnSaZKM+Kcc02JQVdemQeJXh34+YVn
	 bz0DS+PRb09/t68DAD1cbEUrrZz+JLueiSZmRlYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 171/193] drm/amdgpu: add smu 13 support for smu 13.0.11
Date: Sun, 22 Jan 2023 16:05:00 +0100
Message-Id: <20230122150254.231105849@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yifan Zhang <yifan1.zhang@amd.com>

commit 51e7a2168769c2f46edd93a18d4cba4a6d4adb13 upstream.

this patch to add smu 13 support for smu 13.0.11.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c  |    1 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1689,6 +1689,7 @@ static int amdgpu_discovery_set_smu_ip_b
 	case IP_VERSION(13, 0, 7):
 	case IP_VERSION(13, 0, 8):
 	case IP_VERSION(13, 0, 10):
+	case IP_VERSION(13, 0, 11):
 		amdgpu_device_ip_block_add(adev, &smu_v13_0_ip_block);
 		break;
 	default:
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -250,6 +250,7 @@ int smu_v13_0_check_fw_status(struct smu
 
 	switch (adev->ip_versions[MP1_HWIP][0]) {
 	case IP_VERSION(13, 0, 4):
+	case IP_VERSION(13, 0, 11):
 		mp1_fw_flags = RREG32_PCIE(MP1_Public |
 					   (smnMP1_V13_0_4_FIRMWARE_FLAGS & 0xffffffff));
 		break;
@@ -303,6 +304,7 @@ int smu_v13_0_check_fw_version(struct sm
 		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_YELLOW_CARP;
 		break;
 	case IP_VERSION(13, 0, 4):
+	case IP_VERSION(13, 0, 11):
 		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_4;
 		break;
 	case IP_VERSION(13, 0, 5):


