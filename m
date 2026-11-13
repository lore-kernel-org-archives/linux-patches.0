Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585771;
	b=kl0yEISSaKFfKk7cfry4d1IXi5YFcIo5Dru9tP8IQTyugyns97O4OIBNBgzkjRAK4YlV
	 wL9fWYePn2iRGmiK8T40GvwKYjkGqIJaKatwhmzJqBYce529hgZcKilWXnZ5MMzLzcSXA
	 KGIy+NCr+rh3ustzst6/xICLW6MTeW/IjXZK67MGSTaPZjsUO/LyBu4ti4dNeCbrwkErl
	 DxrmF3G3FBH3hC1PMzQt7ijCTIRcJj/Z2DLfPIhpizCxPuYCCu3mem3n0dytKdeeylApW
	 M+rVH7MdXYWZSTQLIQ8hSiyTMp0eWCLAqsPaq5DtFOxIaELkqwXwUnrpKeoG+M7OYSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xMuoTCmVDaaLhTTZ/1Wu1AY3T8EOeibIGexC/ZCFjlc=;
	b=K+4n4gl6PuptZfV1U8yvYD439j0/pEN82EprL23i3zuSynan61V+QJK2Gt/MKssAjeOw
	 mVi3FJHS9FaM54k7nNONglgsCcF3jSBahfMgBGZzqaBX/SCs5T/cjaZpX4DAtmqUmhniJ
	 EZmYaqDNVLdzyacDfd4ruiFAKnNbnzztgxYDaGh/OvgdKMFLM1ikHs6kF/Nvn66IL9A4t
	 lsJDtmbVekRVxMxNUPNVK7AK2Tc9oGg7o/yWwqLUuAJ4b3v5axOoFMnIZ5qqAzNeUmqH8
	 /O21JdkSb9juxH6TJ9ZwTIlHcNxu/cqmXxKkl3N5dMSoOtJK0gFLzVkpEm1sQq6GxpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fTnvc2F8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A10A606A334;
	Fri, 13 Nov 2026 16:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fTnvc2F8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DCC1F000C4;
	Fri, 13 Nov 2026 16:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585771;
	bh=xMuoTCmVDaaLhTTZ/1Wu1AY3T8EOeibIGexC/ZCFjlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTnvc2F8hyFN3caJFjUWTWNzgqzkm51cAzLIZryBeFyLlJ+xdSoL7nRAbozo4PGUh
	 BxW9bD4Dksn++5fQHUS8jL7o+V5sCht7Urpef6qKeHjOZXXW4d9CqYZQ8FNTLoWE99
	 pBQPSTvsav7kElnBg39xZAqisESAWS4PQIaH80nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danijel Slivka <Danijel.Slivka@amd.com>,
	Milan Milicevic <Milan.Milicevic@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 361/507] drm/amdgpu: publish IH enabled before PSP programs IH_RB_CNTL
Date: Fri, 13 Nov 2026 10:51:05 -0500
Message-ID: <20261113153808.159371244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milan Milicevic <Milan.Milicevic@amd.com>

[ Upstream commit 9d550dd1a3b4b96da49f3560a84b5c2413a88cd3 ]

On SR-IOV, programming IH_RB_CNTL through PSP is slow enough for the
first MSI to arrive before ih->enabled is set. amdgpu_ih_process()
then drops the interrupt, rptr stays at 0, and RPTR_REARM never
generates another edge, so every ring hits the fence fallback timer.

Set ih->enabled before psp_reg_program() on the indirect IH path for
Navi10 and IH v6.0, and clear it if programming fails.

Signed-off-by: Danijel Slivka <Danijel.Slivka@amd.com>
Signed-off-by: Milan Milicevic <Milan.Milicevic@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b2f9434f9d17c94798e8d8957af3adc4a9949016)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/ih_v6_0.c   | 13 ++++++++++++-
 drivers/gpu/drm/amd/amdgpu/navi10_ih.c | 13 ++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c b/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c
index 333e9c30c091d..535c84e55558f 100644
--- a/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c
@@ -168,8 +168,19 @@ static int ih_v6_0_toggle_ring_interrupts(struct amdgpu_device *adev,
 		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, ENABLE_INTR, (enable ? 1 : 0));
 
 	if (amdgpu_sriov_vf(adev) && amdgpu_sriov_reg_indirect_ih(adev)) {
-		if (psp_reg_program(&adev->psp, ih_regs->psp_reg_id, tmp))
+		/*
+		 * PSP programming of IH_RB_CNTL is slow enough for MSI to
+		 * arrive before this call returns. Publish ih->enabled first
+		 * so amdgpu_ih_process() consumes that IV and rearms.
+		 */
+		if (enable) {
+			ih->enabled = true;
+			smp_wmb();
+		}
+		if (psp_reg_program(&adev->psp, ih_regs->psp_reg_id, tmp)) {
+			ih->enabled = false;
 			return -ETIMEDOUT;
+		}
 	} else {
 		WREG32(ih_regs->ih_rb_cntl, tmp);
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/navi10_ih.c b/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
index 1e23d123e7f77..bed0eb4b6ec3b 100644
--- a/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
@@ -194,8 +194,19 @@ static int navi10_ih_toggle_ring_interrupts(struct amdgpu_device *adev,
 		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, ENABLE_INTR, (enable ? 1 : 0));
 
 	if (amdgpu_sriov_vf(adev) && amdgpu_sriov_reg_indirect_ih(adev)) {
-		if (psp_reg_program(&adev->psp, ih_regs->psp_reg_id, tmp))
+		/*
+		 * PSP programming of IH_RB_CNTL is slow enough for MSI to
+		 * arrive before this call returns. Publish ih->enabled first
+		 * so amdgpu_ih_process() consumes that IV and rearms.
+		 */
+		if (enable) {
+			ih->enabled = true;
+			smp_wmb();
+		}
+		if (psp_reg_program(&adev->psp, ih_regs->psp_reg_id, tmp)) {
+			ih->enabled = false;
 			return -ETIMEDOUT;
+		}
 	} else {
 		WREG32(ih_regs->ih_rb_cntl, tmp);
 	}
-- 
2.53.0



