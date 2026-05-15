Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47C33FD947;
	Fri, 15 May 2026 16:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862087; cv=none; b=A23ajd/8YSX0pusOoXqMwcwHwK1sXe0tfkZSViht4HopjUG9fQIBmq8+SOEjlcCq4ytmPP1XORfbd+i3UfZ+SVhmRY8yklea2gR13EuEQarjHVyUJsWW7+7UM1GqR1tXvJH+CZuU9CmyVJ6quOgcpp/oPHUbFIHbRhyXIlNIctU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862087; c=relaxed/simple;
	bh=G7FULhrOrH98BpC1Xc9MTm1Qbf0VXyHu4/d6fxXQ/U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7qOt+GlXgMZgLUK4zEO1ErsAgE8z5pqr8bRx8IdvCvjO837wbFwWu6kRD9d7hf1/ylooORwPG6CeqzjXEFOIn81qNZcwOMfRNYIX6NWcEM/FjY5IIiGHxOfkXpWNwYqXHY6PXzsC9nZ9t/i8NH6+pVGS1/jsSrdElh5/kj7lyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKExXmnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKExXmnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDC6C2BCB0;
	Fri, 15 May 2026 16:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862087;
	bh=G7FULhrOrH98BpC1Xc9MTm1Qbf0VXyHu4/d6fxXQ/U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKExXmnjCe4sdDrjlpnje3lx7d5R3jN36AufiiKzcClFj+wxtvA1VVGsZOKDKduZR
	 qsk1mobdMGKsLUR99FWa0GBQcOY4JNpQN+HPKzT8ZWU6zs6RWzoS7H8KGc7FB5L3OS
	 E5UjdT0YDYG9fm5kYbCE+rcex/X/UquWcXBei4A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
	"Ramalingeswara Reddy, Kanala" <Kanala.RamalingeswaraReddy@amd.com>
Subject: [PATCH 6.18 102/188] drm/amdgpu: Use SMUIO 15.0.0 offsets for TSC upper and lower count.
Date: Fri, 15 May 2026 17:48:39 +0200
Message-ID: <20260515154659.541833852@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5174,11 +5179,27 @@ static uint64_t gfx_v11_0_get_gpu_clock_
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


