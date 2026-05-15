Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F6F175A87;
	Fri, 15 May 2026 15:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860493; cv=none; b=NRyNtUBoj193eedVkdB7wNN95Auq1GZwgwSFcX3rOvxmt0GFCpSxlnzMRZQ9U51/Ro5//493n7ihaobnRsSyVk7mek1QeXp1ypIP7h0DGmycapcTrHOGHQgMDh8dscVDsd4HV2tKyRYnhFkBl7MCsstHcpZiYf1+ZbglY+qCym8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860493; c=relaxed/simple;
	bh=is7RaoVblCVMobnLonKU9RuRxuQ7NLaOja/90UV3/Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNzYkyxG5sw54OwoLWp+9voSbw67TO5YxSC++5Goh7OE1YrwVMBqKRZdy/OhaCWwEET0lY/vnFWL7DY2w9FiWmCO/03eYoUxOzEmiQEavYymEfa5zQU+YsxknGorW66U0bey73N2WxQYh+SFBphMEo/nCw0YqqjjLQguwtZQSLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPL256yM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPL256yM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723CCC2BCB0;
	Fri, 15 May 2026 15:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860492;
	bh=is7RaoVblCVMobnLonKU9RuRxuQ7NLaOja/90UV3/Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPL256yMKFrIdDHCFsMgjgipSbTdZLP0G8W7rTYS+KXMsrI7XE9AookQV4CZDyOKO
	 6fPuuOP9ZhiBdHZSes5z1I6kwSSGSqI5mSu66L52p9kVUtL7/QJBhesONg502zWYR6
	 VNHIG2k27eX6XA2PCwgtrhN+o7DjASnkxa25BK3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
	"Ramalingeswara Reddy, Kanala" <Kanala.RamalingeswaraReddy@amd.com>
Subject: [PATCH 6.12 068/144] drm/amdgpu: Use SMUIO 15.0.0 offsets for TSC upper and lower count.
Date: Fri, 15 May 2026 17:48:14 +0200
Message-ID: <20260515154655.120444484@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramalingeswara Reddy, Kanala <Kanala.RamalingeswaraReddy@amd.com>

commit 574b3b14f7d1b329fc6e67b79328f0e6f4d4b3d4 upstream.

Define and use regGOLDEN_TSC_COUNT_UPPER_smu_15_0_0 and
regGOLDEN_TSC_COUNT_LOWER_smu_15_0_0 for TSC upper and lower count.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>
Signed-off-by: Ramalingeswara Reddy, Kanala <Kanala.RamalingeswaraReddy@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -63,6 +63,11 @@
 #define regPC_CONFIG_CNTL_1		0x194d
 #define regPC_CONFIG_CNTL_1_BASE_IDX	1
 
+#define regGOLDEN_TSC_COUNT_UPPER_smu_15_0_0               0x0030
+#define regGOLDEN_TSC_COUNT_UPPER_smu_15_0_0_BASE_IDX      1
+#define regGOLDEN_TSC_COUNT_LOWER_smu_15_0_0               0x0031
+#define regGOLDEN_TSC_COUNT_LOWER_smu_15_0_0_BASE_IDX      1
+
 #define regCP_GFX_MQD_CONTROL_DEFAULT                                             0x00000100
 #define regCP_GFX_HQD_VMID_DEFAULT                                                0x00000000
 #define regCP_GFX_HQD_QUEUE_PRIORITY_DEFAULT                                      0x00000000
@@ -4975,11 +4980,27 @@ static uint64_t gfx_v11_0_get_gpu_clock_
 		amdgpu_gfx_off_ctrl(adev, true);
 	} else {
 		preempt_disable();
-		clock_counter_hi_pre = (uint64_t)RREG32_SOC15(SMUIO, 0, regGOLDEN_TSC_COUNT_UPPER);
-		clock_counter_lo = (uint64_t)RREG32_SOC15(SMUIO, 0, regGOLDEN_TSC_COUNT_LOWER);
-		clock_counter_hi_after = (uint64_t)RREG32_SOC15(SMUIO, 0, regGOLDEN_TSC_COUNT_UPPER);
-		if (clock_counter_hi_pre != clock_counter_hi_after)
-			clock_counter_lo = (uint64_t)RREG32_SOC15(SMUIO, 0, regGOLDEN_TSC_COUNT_LOWER);
+		if (amdgpu_ip_version(adev, SMUIO_HWIP, 0) < IP_VERSION(15, 0, 0)) {
+			clock_counter_hi_pre = (uint64_t)RREG32_SOC15(SMUIO, 0,
+					regGOLDEN_TSC_COUNT_UPPER);
+			clock_counter_lo = (uint64_t)RREG32_SOC15(SMUIO, 0,
+					regGOLDEN_TSC_COUNT_LOWER);
+			clock_counter_hi_after = (uint64_t)RREG32_SOC15(SMUIO, 0,
+					regGOLDEN_TSC_COUNT_UPPER);
+			if (clock_counter_hi_pre != clock_counter_hi_after)
+				clock_counter_lo = (uint64_t)RREG32_SOC15(SMUIO, 0,
+						regGOLDEN_TSC_COUNT_LOWER);
+		} else {
+			clock_counter_hi_pre = (uint64_t)RREG32_SOC15(SMUIO, 0,
+					regGOLDEN_TSC_COUNT_UPPER_smu_15_0_0);
+			clock_counter_lo = (uint64_t)RREG32_SOC15(SMUIO, 0,
+					regGOLDEN_TSC_COUNT_LOWER_smu_15_0_0);
+			clock_counter_hi_after = (uint64_t)RREG32_SOC15(SMUIO, 0,
+					regGOLDEN_TSC_COUNT_UPPER_smu_15_0_0);
+			if (clock_counter_hi_pre != clock_counter_hi_after)
+				clock_counter_lo = (uint64_t)RREG32_SOC15(SMUIO, 0,
+						regGOLDEN_TSC_COUNT_LOWER_smu_15_0_0);
+		}
 		preempt_enable();
 	}
 	clock = clock_counter_lo | (clock_counter_hi_after << 32ULL);


