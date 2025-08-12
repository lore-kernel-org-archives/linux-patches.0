Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6483F2DA779;
	Tue, 12 Aug 2025 19:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025707; cv=none; b=Oy3/+UqubhCN05vgYQK0vj0ZowTEzMKXoFt/HTSj8IUxB6L6cGd8hTNrcbDmcbM0gijzz3bSuLTsfuEvtt60c3dK0OWgh4qVXErOIvGmA9K1lxvxz6cK7joIcywd0mNMC+T//KT77PysjOcAvkkI79kCFwN5BZs5WWdYYlJvQAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025707; c=relaxed/simple;
	bh=v/VLXAHmDgsWRAmqCNlOz+1CIHBT9lvWWAccaCQhuio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mj48ep6d8QfGB3quwdyHtngPQaGLevLS2chMIQTcHEHSe3clIoPqplES94ZvM2P9q8ds6I2MMraMXyCzgW7KNgfeEAwnfR7E8sCbUSmmUfOhDJssyL/FjvIDySm6n8cK1ob91GaFiEgO8qqAam69B84HE9Ml719uXFPz8UfuCvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsqYkVjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsqYkVjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C758FC4CEF0;
	Tue, 12 Aug 2025 19:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025707;
	bh=v/VLXAHmDgsWRAmqCNlOz+1CIHBT9lvWWAccaCQhuio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zsqYkVjPR1N50+QBTCRwA+qCcZH9pLspAo+Pd6i+nhJUsQC1TEljKaF4dXmU8tdHa
	 lEK5Pf1YtAdcT58ISMq31LYaxZFav2CXD6FEVutNZJuAnx+ShiDwhx6/xJGgxAS2WT
	 EYvQnfi5pGyvGOZFSh0JmW7vzn8FBuK6tUx2y588=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 113/480] drm/amdgpu: Remove nbiov7.9 replay count reporting
Date: Tue, 12 Aug 2025 19:45:21 +0200
Message-ID: <20250812174402.155805399@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 0f566f0e9c614aa3d95082246f5b8c9e8a09c8b3 ]

Direct pcie replay count reporting is not available on nbio v7.9.
Reporting is done through firmware.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Mangesh Gadre <Mangesh.Gadre@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Fixes: 50709d18f4a6 ("drm/amdgpu: Add pci replay count to nbio v7.9")
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
index f23cb79110d6..3a78d035e128 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
@@ -31,9 +31,6 @@
 
 #define NPS_MODE_MASK 0x000000FFL
 
-/* Core 0 Port 0 counter */
-#define smnPCIEP_NAK_COUNTER 0x1A340218
-
 static void nbio_v7_9_remap_hdp_registers(struct amdgpu_device *adev)
 {
 	WREG32_SOC15(NBIO, 0, regBIF_BX0_REMAP_HDP_MEM_FLUSH_CNTL,
@@ -463,22 +460,6 @@ static void nbio_v7_9_init_registers(struct amdgpu_device *adev)
 	}
 }
 
-static u64 nbio_v7_9_get_pcie_replay_count(struct amdgpu_device *adev)
-{
-	u32 val, nak_r, nak_g;
-
-	if (adev->flags & AMD_IS_APU)
-		return 0;
-
-	/* Get the number of NAKs received and generated */
-	val = RREG32_PCIE(smnPCIEP_NAK_COUNTER);
-	nak_r = val & 0xFFFF;
-	nak_g = val >> 16;
-
-	/* Add the total number of NAKs, i.e the number of replays */
-	return (nak_r + nak_g);
-}
-
 #define MMIO_REG_HOLE_OFFSET 0x1A000
 
 static void nbio_v7_9_set_reg_remap(struct amdgpu_device *adev)
@@ -520,7 +501,6 @@ const struct amdgpu_nbio_funcs nbio_v7_9_funcs = {
 	.get_memory_partition_mode = nbio_v7_9_get_memory_partition_mode,
 	.is_nps_switch_requested = nbio_v7_9_is_nps_switch_requested,
 	.init_registers = nbio_v7_9_init_registers,
-	.get_pcie_replay_count = nbio_v7_9_get_pcie_replay_count,
 	.set_reg_remap = nbio_v7_9_set_reg_remap,
 };
 
-- 
2.39.5



