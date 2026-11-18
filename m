Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054569;
	b=FRWhiFC3U0zSNFyubSKCtJ0QScHacmvE5GUv2u2P8r0yTrnikHSqpo7nIOiyWMM7pTiE
	 bONGraSQrbeVdPPMp0FkjxsC+O+RQvZbImqOvG0xf6H5/np6mBaSOuvojL6aRiHnzS7Ay
	 wyUnZLRZpdrVwGn04/PSBerPlzrnivmxN8mXRq9DreYlw5jOEla1ilcjTRzh2JJvGamUo
	 zCXkArs1ZRy4tAqufM0CruSf6397AdPbm8yMrYbR4UwSRdTZsExzref/qQOal+AKZr8GM
	 B+yhkaf6Go8SYwMgHKxcCSV2vAWewU84tuoHZNooCdTCxCTRTWZyliROLb9nzlgq8EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f7VSSue8FhnFWVdemR7F6deEHyj1CdUAEdIFm0DgElk=;
	b=p1zh943HZxZX+nyy2FmE2yJ7uus/504RLdt20hNa8Id/e+x5BL91UDOIIjsdeCbBmKyA
	 IeoxqMc5R1mLBACFOK2UhdywngmkYj+8UZAifeh3t8yC0tp6D36GjWXuhcJ5mp4xPMlUx
	 1dcn3PJKOC/FIDqXqOQqfmqO0ssoPRVcWM3YUfdEsNIEYaBRBiEfmjiOgeA2GycK1O/wf
	 Ao6TEZdP7tP/wTNzr6R1hBNRvVoJXAAVyospX6njwtoBH6LoD6SklQb2qZA23ue3a0TKI
	 9vRPVZV3YE5LnG+KdLgmr0AjTzRTXmgyhk4BWJWol3/q6aUV19jzcaTctQKNkweeilA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zs7AemuL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78240606A32A;
	Thu, 19 Nov 2026 02:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zs7AemuL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92E41F000C4;
	Thu, 19 Nov 2026 02:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054569;
	bh=f7VSSue8FhnFWVdemR7F6deEHyj1CdUAEdIFm0DgElk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zs7AemuLLOPwFxNbtJnOwrNzVJtZwsHudFw/kaF6ej8YAv2S7k6R0AMOYdLN9svLg
	 tdpWPZqZw1eI/YmOR+sEfQyOCGEDOl84hraEHmh/MbHtkNWApRE/Ekp8cOt4DCInzq
	 ZgX59TNGUqWi+4KdEEOyPBX35YjkM5N6rDH8xLd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danijel Slivka <Danijel.Slivka@amd.com>,
	Milan Milicevic <Milan.Milicevic@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1320/2214] drm/amdgpu: publish IH enabled before PSP programs IH_RB_CNTL
Date: Wed, 18 Nov 2026 15:49:56 +0100
Message-ID: <20261118150104.270060211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Omitted changes to the absent IH v6.0 driver. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/navi10_ih.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/navi10_ih.c b/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
index 9425a9448cf51..352d6f14aa413 100644
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



