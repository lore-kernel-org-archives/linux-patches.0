Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36C13F9D2;
	Tue, 12 Aug 2025 18:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022172; cv=none; b=fybpcCbPABunM5q7KsYXM585cs1VOwGXl8jEVCZ0gyhQ62p/doGMCUXXh9JQBlJ6qt87m1kBU2M/p4eAcZ48fqcvfpYc3ZON+ZxL3hKGTqkxeA5hMRyrfrFmjA3bt1EhGiytNmKL5qixgyQArLLtgDGyygyCWgkyntJqCQ3czMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022172; c=relaxed/simple;
	bh=ujk7KHASznHZ1YK96nS8rwBbCfvMYvuqq5YBSqwLzEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eO8ML2M2b5G+6rhCX10Qm/0izElMGifzc9v63EMHoUNwSz8s4GCNbNlsmH+bSjJoWzfSTg5IB/W9S5ELT5A4QRBrwikTq7YVQb8j4tLQ8+CFaGdTsbigxH2ABbnQPoi76jz/sOsBsQ8hEp8Yz6gcnx1fE2mZdguAIxprLP2ipoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LC2qESl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LC2qESl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169F1C4CEF0;
	Tue, 12 Aug 2025 18:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022171;
	bh=ujk7KHASznHZ1YK96nS8rwBbCfvMYvuqq5YBSqwLzEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LC2qESl0IrmTa33X0SgIaanJgEj58Z459049+8pP4n/fHXXh1uyDh8fh30pSjcQw0
	 znpvrKQNZd9hpoB15O6h2GYaInW465ddVKjub0iAhMIBa3ge/ekEyFpNKZZ1sCN/Aw
	 OZIgBVpv8tYj6mYu82AScMtl4y9CUXo7SSwROKh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/369] drm/amdgpu: Remove nbiov7.9 replay count reporting
Date: Tue, 12 Aug 2025 19:26:14 +0200
Message-ID: <20250812173017.684297276@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d1bd79bbae53..8e401f8b2a05 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
@@ -32,9 +32,6 @@
 
 #define NPS_MODE_MASK 0x000000FFL
 
-/* Core 0 Port 0 counter */
-#define smnPCIEP_NAK_COUNTER 0x1A340218
-
 static void nbio_v7_9_remap_hdp_registers(struct amdgpu_device *adev)
 {
 	WREG32_SOC15(NBIO, 0, regBIF_BX0_REMAP_HDP_MEM_FLUSH_CNTL,
@@ -453,22 +450,6 @@ static void nbio_v7_9_init_registers(struct amdgpu_device *adev)
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
@@ -509,7 +490,6 @@ const struct amdgpu_nbio_funcs nbio_v7_9_funcs = {
 	.get_compute_partition_mode = nbio_v7_9_get_compute_partition_mode,
 	.get_memory_partition_mode = nbio_v7_9_get_memory_partition_mode,
 	.init_registers = nbio_v7_9_init_registers,
-	.get_pcie_replay_count = nbio_v7_9_get_pcie_replay_count,
 	.set_reg_remap = nbio_v7_9_set_reg_remap,
 };
 
-- 
2.39.5



