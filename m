Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590449;
	b=wF0kbfoP8XKVs2Msx7xsg98u32k6fdoFcPsbLPnSal486Wzq7dvdiHtoUe60gulcRgT6
	 HeTR5lYkZjScgjPRlZeyJJuE/EbLcIutMAmpS/BbdVnuDp0nf5oVIqcy0Gjvnc4t9vuv4
	 QejbwAHtfZo9sYtVmEe4JfV3lNW+mreYjLwjBp5uFih12rNRagnG/DJWCLACTxIY9F5Bl
	 pCYdI2XsS9gtoxjVWeBU+YHR2pjd4CMjE4EXBFk2t43AsfnGQal22iQlMT66eHjIgnAmc
	 8Uc4nPwBlYUFdzVBvXFnfCzD9tJcheK5KjO9/vyf2eoMCqwnQqnShAcWfYHHWexY0/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wtagBJ/uCQOCRsCvxQPx8n8ormtT+gagNhCaq8j3jcM=;
	b=yE7cV3GsKbwpLye00zXI2B6V4sUmGdVUO0+ZYzkzxld46op1SSbQ1OP03LEt+9OqaXG+
	 oOecbvQ2SkcGL3AlVBltf5/lADLSAeLb3xVWGt9NeUpOfQ893LeI45BgiAr7T/3JvCUFQ
	 MpsOv6nWM7p/8aCblijnNzv3O0LYC0gRmODc2U4iosPWeeHVRNo6gq8jzl6wq+wU1KJ13
	 gbieYvpSVcbe9QVful9wT2GVFpyKPli9zLpHDjXEKpn9xWGZNoZIV6cfGvZrQJS17vwQP
	 1eOXBeVrSmWwTHN+JAyt5Qat/+gspUQ924FeqlJsuwIPGskObzUXZLJK29o6ykRThcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZ2wL8d9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C0E607141B;
	Fri, 13 Nov 2026 17:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZ2wL8d9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7241F000C4;
	Fri, 13 Nov 2026 17:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590448;
	bh=wtagBJ/uCQOCRsCvxQPx8n8ormtT+gagNhCaq8j3jcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZ2wL8d9tWw18K2hnD8z4VojWVhxldev/Y4L75NAULCx6md7XU04IQrXykNmZVeDZ
	 tz8Z19WvEtCqlpjzbp69tA63g9Nyiz/eLAaSc1nsUVxFPzCwh5gtIWEjNHPs95qOJB
	 86pz02nHQ7HyYw0zjXZP5hZpLalBJzFwHMqOZHUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danijel Slivka <Danijel.Slivka@amd.com>,
	Milan Milicevic <Milan.Milicevic@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 405/686] drm/amdgpu: publish IH enabled before PSP programs IH_RB_CNTL
Date: Fri, 13 Nov 2026 10:48:58 -0500
Message-ID: <20261113153834.704824627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



