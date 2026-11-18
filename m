Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037817;
	b=eSLcBv39n0j32F1eJgjmvxrF880mimMUwUTqWsHNKzUfT3kMeIdWDncbtebq0CjRUvtc
	 HS/A9E5NjCidS68o8jpmG9YN8gZFj0+KCffWUNwZOgmQGGcl6iM6J2v54hML3CZJ5HN9u
	 7UmWWvZUZYDgVOqPyfciiPDXeht7lh/1CdA20wT7H3BZoJOYSHJxfRQLHcKGGG0TYWhUV
	 9X5HEdaRQtarbxLL4CMLGzNHuyJ5QE8Qzg8rxAZQOh51EF1Tj7a75k0bYgmmZuLdjkR2V
	 idbykabGXN3kG2hY23cFApSgrhVKtAq8GPBOJ7qbs7qfhiIQxHydpszsUSNUbByWq/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uRi/6LoagYe2qAQHDRBBsncAHQBzlsRVyyM0pmm/Kn0=;
	b=16DxJWLfIr5d9ArErWYXg66rNnt/e8ED8ws90KsqNPl9mPhpFWg12pWay1wq1B3hD04P
	 9ek28E5gWw7xWkbEfmPAyEyrEQP3N4dkQFVIiE3aJWQvMBNMS7nJhXS6sXZkhWjvFbwf6
	 ZK7/CvzRduhl/RwlfbcuOHwE+Kt1Vjfdahbw9YAW/Y4Yn7XZNuM0ZbdMlo2EHipVMdlqz
	 56eaQq10MZSMgnME9274p/TrvEQ2goqH+1qM5z6Bd6R6eXiqWsd0KoBgOqQ0ObGsX2oLc
	 QC8o5grFFlEMYR17JKEftnNU2U9vyWoLAuMpNHXy+f3e2mmxnxit1lJeGA25mgVVBCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2YOIYlNG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64ABB606A325;
	Wed, 18 Nov 2026 21:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2YOIYlNG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755A21F000C5;
	Wed, 18 Nov 2026 21:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037817;
	bh=uRi/6LoagYe2qAQHDRBBsncAHQBzlsRVyyM0pmm/Kn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2YOIYlNGaxvRL8UaATyv93yWnffNTLFg+73YGBp1KeXQ2z0f627rE7wTohaH0UJlq
	 t9sVkJIKBnva/H3ihAuu1kjj3qyKcyjDu/CW/OgE6xM61c9sHK37dMFv8UKlNOthd7
	 /coLQX3F6EJmO3NxxYoyCUyXA8Ycl90cENEnvFjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danijel Slivka <Danijel.Slivka@amd.com>,
	Milan Milicevic <Milan.Milicevic@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1529/3318] drm/amdgpu: publish IH enabled before PSP programs IH_RB_CNTL
Date: Wed, 18 Nov 2026 15:35:51 +0100
Message-ID: <20261118150406.839395958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 725b1a585088d..c4b7d64f7be3f 100644
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
index cdfc334d793b7..8dfed6dc855f1 100644
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



