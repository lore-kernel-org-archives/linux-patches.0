Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899FF8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C49C433EF;
	Mon, 13 Feb 2023 14:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300207;
	bh=sDsNj1HrGF2WR6Q950hDa0HSJFUhA10jD3RwuEufay4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7dHlh/oD8vG/GJZZltjkkUNmX59faW60ldH/s/BBzlvw7hKC+syGgNdbtNrhR8ll
	 IeDZjDj1TYHJ9QbypNNYLsy+2L8RwbETlhAPjgK8TIMwigSbhV5/8E3FAVHtU3e7vU
	 YrzBumorLt6oCuiV3RPwNtAlcE3oHkuiXgo/RcnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Guchun Chen <guchun.chen@amd.com>
Subject: [PATCH 6.1 105/114] drm/amd/pm: bump SMU 13.0.0 driver_if header version
Date: Mon, 13 Feb 2023 15:49:00 +0100
Message-Id: <20230213144747.634907297@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

commit 9874cc2df4e892c8744aa0472866cbf7c3cf1862 upstream.

This can suppress the warning caused by version mismatch.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h   | 5 +++--
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h                 | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
index d6b964cf73bd..4bc7aee4d44f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
@@ -123,7 +123,8 @@
 									(1 << FEATURE_DS_FCLK_BIT) | \
 									(1 << FEATURE_DS_LCLK_BIT) | \
 									(1 << FEATURE_DS_DCFCLK_BIT) | \
-									(1 << FEATURE_DS_UCLK_BIT))
+									(1 << FEATURE_DS_UCLK_BIT) | \
+									(1ULL << FEATURE_DS_VCN_BIT))
 
 //For use with feature control messages
 typedef enum {
@@ -522,9 +523,9 @@ typedef enum  {
   TEMP_HOTSPOT_M,
   TEMP_MEM,
   TEMP_VR_GFX,
-  TEMP_VR_SOC,
   TEMP_VR_MEM0,
   TEMP_VR_MEM1,
+  TEMP_VR_SOC,
   TEMP_VR_U,
   TEMP_LIQUID0,
   TEMP_LIQUID1,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index e8c6febb8b64..d9c4821bcfc8 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -28,7 +28,7 @@
 #define SMU13_DRIVER_IF_VERSION_INV 0xFFFFFFFF
 #define SMU13_DRIVER_IF_VERSION_YELLOW_CARP 0x04
 #define SMU13_DRIVER_IF_VERSION_ALDE 0x08
-#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_0 0x34
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_0 0x37
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x07
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_5 0x04
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10 0x32
-- 
2.39.1



