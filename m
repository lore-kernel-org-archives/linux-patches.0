Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51930E56A;
	Fri, 15 May 2026 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862770; cv=none; b=LmeSWzD32LRVv18iktN7yK//15grMBbx/1eTtQU2/Rqv6E31P5Z0OPOR3LIM2GxvvMXEaIJm7mKoqlnd+1F2Baw81jFuCJWbhj5/cLup3Fcd4OLLIbXMMVJA20FARRVt+bjsR86AuI1iAQCP+2spPF8fKPV+BSdyihmoPvU8G2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862770; c=relaxed/simple;
	bh=i8BVy6L+JJ6X53PbYFmQ2JZ3ryZ+T5U/PLCzw9gH2a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EekHEr64r2Y+DdwAb2D0/SmobySSf9HgFzsrMNT3MOV8LPWjVemwwypv7VxEKHIbKdi0i1vXWLGj+/Vr/tAf1h7VaPyvr+sNAQnXbeQOc16GctEknocMg/FF8nVhJMwFcZwaeuq9ek8v1QFdvgTcyyQLUUZVnVtTxkeOqAo6EbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KO/RxS60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KO/RxS60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDC1C2BCB0;
	Fri, 15 May 2026 16:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862770;
	bh=i8BVy6L+JJ6X53PbYFmQ2JZ3ryZ+T5U/PLCzw9gH2a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KO/RxS60OczDj/5m4IUxU2StFGd5yNNDv1IUpOjgBZ19DlWXOrLvWCeADCemjAnQ0
	 tVGpADdSzUwJaUEWZSWbl6LQ5TsNtqq2OEAPFx52IbYpp5zso4NHNDNoR+CIovGfMU
	 jVsCaIDVhj9IJxcaKCq6/NXAYF4oPrzmEMMqvFZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
	"Ramalingeswara Reddy, Kanala" <Kanala.RamalingeswaraReddy@amd.com>
Subject: [PATCH 7.0 134/201] drm/amdgpu: Use SMUIO 15.0.0 offsets for TSC upper and lower count.
Date: Fri, 15 May 2026 17:49:12 +0200
Message-ID: <20260515154701.468516174@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -64,6 +64,11 @@
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
@@ -5187,11 +5192,27 @@ static uint64_t gfx_v11_0_get_gpu_clock_
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


