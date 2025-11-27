Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC9828CF42;
	Thu, 27 Nov 2025 15:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255857; cv=none; b=UYMyII9ZqOwj933JLTJNQ0kfGLqyaeslQveg4hE/G7i0IxRF4aTt55qely/Q7uLfWqj9cLMItahh03HFsdEASk0XnQyZ3E1kmyICK13qHDDKD1z7u5aRxhXxWyYo6H5E9tvMTBrzGEH8wHrLPHc7x4KvP8R5HOT3HUffve5KnAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255857; c=relaxed/simple;
	bh=rjXiduA133FZ5YC7Qs2HPI5joPfa5uy0y2EnaoV3xoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQX1q3Z9C6ebpQO8xgKPi65ky9OkJifAu4rzOghMpqRAJz5s3AEwt1xVRRMeRrrggSdlXT8CA8PTQnB+6EQDGu4rj787wwXjGrfNlVU6LUn0MCoZ1HrzqAjV5vMFYxVv2+IHR1CjRGWKGlQU1ohRPe8mutAN1QZc05vBPRezNdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnN22JJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnN22JJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7B6C4CEF8;
	Thu, 27 Nov 2025 15:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255857;
	bh=rjXiduA133FZ5YC7Qs2HPI5joPfa5uy0y2EnaoV3xoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnN22JJAGvIPm5EKND+Y/ImfTC+dNF+/oboTq0P6KxLaGgFXtHweNTQU094XaEcrN
	 3+331FILpxxHsMlOl1yY6eovf1GchFZBUYCi8Nn01UUcsK7KiwW1IJKkmNvg68jh7i
	 l9AJaDpVd7rm/bdqwbTlzYSCaFUkj0hx6N2YRLJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 105/175] drm/i915/xe3lpd: Load DMC for Xe3_LPD version 30.02
Date: Thu, 27 Nov 2025 15:45:58 +0100
Message-ID: <20251127144046.794204758@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>

[ Upstream commit fa766e759ff7b128ab77323d9d9c232434621bb6 ]

Load the DMC for Xe3_LPD version 30.02.

Fixes: 3c0f211bc8fc ("drm/xe: Add Wildcat Lake device IDs to PTL list")
Signed-off-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Reviewed-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Link: https://lore.kernel.org/r/20251016131517.2032684-1-dnyaneshwar.bhadane@intel.com
Signed-off-by: Gustavo Sousa <gustavo.sousa@intel.com>
(cherry picked from commit a63db39a578b543f5e5719b9f14dd82d3b8648d1)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Rodrigo added the Fixes tag while cherry-picking to fixes]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dmc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dmc.c b/drivers/gpu/drm/i915/display/intel_dmc.c
index 4aa2aa6379787..8ec06a734d8e3 100644
--- a/drivers/gpu/drm/i915/display/intel_dmc.c
+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
@@ -127,6 +127,9 @@ static bool dmc_firmware_param_disabled(struct intel_display *display)
 #define DISPLAY_VER13_DMC_MAX_FW_SIZE	0x20000
 #define DISPLAY_VER12_DMC_MAX_FW_SIZE	ICL_DMC_MAX_FW_SIZE
 
+#define XE3LPD_3002_DMC_PATH		DMC_PATH(xe3lpd_3002)
+MODULE_FIRMWARE(XE3LPD_3002_DMC_PATH);
+
 #define XE3LPD_DMC_PATH			DMC_PATH(xe3lpd)
 MODULE_FIRMWARE(XE3LPD_DMC_PATH);
 
@@ -183,9 +186,10 @@ static const char *dmc_firmware_default(struct intel_display *display, u32 *size
 {
 	const char *fw_path = NULL;
 	u32 max_fw_size = 0;
-
-	if (DISPLAY_VERx100(display) == 3002 ||
-	    DISPLAY_VERx100(display) == 3000) {
+	if (DISPLAY_VERx100(display) == 3002) {
+		fw_path = XE3LPD_3002_DMC_PATH;
+		max_fw_size = XE2LPD_DMC_MAX_FW_SIZE;
+	} else if (DISPLAY_VERx100(display) == 3000) {
 		fw_path = XE3LPD_DMC_PATH;
 		max_fw_size = XE2LPD_DMC_MAX_FW_SIZE;
 	} else if (DISPLAY_VERx100(display) == 2000) {
-- 
2.51.0



