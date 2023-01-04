Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432F3AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1569C433D2;
	Wed,  4 Jan 2023 16:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849549;
	bh=Yx6p5hDXeZKBbDugEG9mlhz8s+XMg9psc0ZBjQ5A3ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=waqzyiVo1ZKJXaZuU7yCMp8N3KcBetp/soRRnOKJYnq3thO0YnqCq6GNByb7zkR4G
	 cRw2LnzIgV1Qy+UGOIRVWMyNJp8h3fAI2scOwZLta/pGKZXU+pQUyuLWdtIEr69tU5
	 3PbZ90mX62vJKxN/uiSxnqCVL/E9zH8JxXN7LxA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 206/207] drm/amd/pm: bump SMU13.0.0 driver_if header to version 0x34
Date: Wed,  4 Jan 2023 17:07:44 +0100
Message-Id: <20230104160518.456791399@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Evan Quan <evan.quan@amd.com>

commit 272b981416f8be0180c4d8066f90635fa7c1c501 upstream.

To fit the latest PMFW and suppress the warning emerged on driver loading.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0, 6.1
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h |    2 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h                       |    1 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c                     |    2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
@@ -522,9 +522,9 @@ typedef enum  {
   TEMP_HOTSPOT_M,
   TEMP_MEM,
   TEMP_VR_GFX,
+  TEMP_VR_SOC,
   TEMP_VR_MEM0,
   TEMP_VR_MEM1,
-  TEMP_VR_SOC,
   TEMP_VR_U,
   TEMP_LIQUID0,
   TEMP_LIQUID1,
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -28,6 +28,7 @@
 #define SMU13_DRIVER_IF_VERSION_INV 0xFFFFFFFF
 #define SMU13_DRIVER_IF_VERSION_YELLOW_CARP 0x04
 #define SMU13_DRIVER_IF_VERSION_ALDE 0x08
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_0 0x34
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x07
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_5 0x04
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10 0x32
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -289,6 +289,8 @@ int smu_v13_0_check_fw_version(struct sm
 		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_ALDE;
 		break;
 	case IP_VERSION(13, 0, 0):
+		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_0;
+		break;
 	case IP_VERSION(13, 0, 10):
 		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10;
 		break;


