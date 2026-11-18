Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058615;
	b=1tsd5hx41DrmGiRHIcNAauE/TPpYgDnWeXd39I76Zg/DR6tbOFfMYZf7wdHfCbm/7Xhg
	 +hrAjJ15Dfd5kKyvynSqdrZCTeSoqRX+eY45GQfGjoq1GSBJci7s6+mG52XXLbI/G2UUO
	 cAGUe+yBftQ/BhHlrBhFWoRIjq2h0ISghLApKx5ASieOFCTYLD6/ksYOsnYoaHXUdf8ES
	 kF1ZtChZx+mh8BI2BBhF+MLlA6jPFc3AkbrY9JnGEgPl+xi4R+a9Cs0haMtIsGnoNhW52
	 n2CIKdHGRV0XsalwOP0PX3Hf9F8K+nUM415SGrG51f2PFlmsTc5gL+U92sDAMH1DI/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BY+zfizMfuN3O5clHh6J0ovnkQU/4J11e69xy9edDnE=;
	b=Fo5EsmLEMHPoqafFW0NQON4T8q3J6siyGilAc2vjwC2TDl1bFIXVpbGDYIPqIE6HZMQJ
	 HlF6vQbXCfpS4upSXOvA82q4c5+H0R58fJj5gyuiCkj+vY+xKlNb1+LajZ2bjaa+NLZKo
	 ZtkdvOsh28Bb/wR0iI9NSYJokLbcglI56j5u0wYyFcprZuYdQoVbAMi+fZN6nqN7U1Bfo
	 nEWETY0RfYwSg59gwp5kqtuc1CGe1PjEtkDPg7tjMWm3ZSsoHCUpr1pVjOb8EG2Ovty9a
	 Qbn2oFoTdP+MCpUxTDubCFz1uaXVMRjtz52LqYK2sDLLpN/bNcnFEML2ThuD5Y9G86g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3qo2Aim;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5E5606A320;
	Thu, 19 Nov 2026 03:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3qo2Aim
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EB11F000C4;
	Thu, 19 Nov 2026 03:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058615;
	bh=BY+zfizMfuN3O5clHh6J0ovnkQU/4J11e69xy9edDnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s3qo2AimVSY4u7dwLu4uf675u8uJKyIbJ/NuZy15qqmfyaZDZpHvosx/ylc6wPzuW
	 VZSTD1VKoIxlpzVZfyu2t058SXE6D8jpnVmQCi/rpSgwNkecLJHl+3SW542IA8sYvS
	 8EUs6LaRuTJwS1pnlFa/5ufzojVEor2u4GXYlTbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Maciej Kucharek <qchcio@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0549/1848] drm/amdgpu: reset VI ASIC on Apple boards with VRAM at 0
Date: Wed, 18 Nov 2026 15:43:07 +0100
Message-ID: <20261118145937.937261789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Kucharek <qchcio@gmail.com>

[ Upstream commit 92a5184787b81e67f7b831ad860ca9b053505cf8 ]

On MacBookPros with switchable graphics, the firmware puts VRAM at MC
address 0 when the iGPU is enabled.  A later post (S3 resume, GPU
reset) moves VRAM back to the VBIOS default.  gmc_v8_0 reads
MC_VM_FB_LOCATION once at init and reprograms it only on SR-IOV.  On
bare metal, the driver then keeps using the old layout.

vi_reset_quirks[] handles this for the MacBookPro14,3 by PCI ID:

  commit b6b1d9721851 ("drm/amdgpu: reset VI ASIC on MacBookPro14,3")

Add the test that SI and CIK use: an Apple subsystem vendor and VRAM at
0.  Other Polaris MacBookPros then get the same reset at load, for
example the MacBookPro13,3 if its firmware leaves VRAM at 0.  These
boards are not tested.

Keep vi_reset_quirks[].  Its MacBookPro15,1 entries fix a different
failure, a module reload after S3:

  commit a5be7ad8f5f0 ("drm/amdgpu: reset VI ASIC on MacBookPro15,1")

VRAM is not at 0 at that point, so the new test may not cover it.

After the reset, FB_BASE is not 0, so the new test does not fire again
on a module reload.

Only compile-tested.

Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Maciej Kucharek <qchcio@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c2335b685b1e1e387f2fea1c67f56b5b8a8b6dc6)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
index 1ceb23f2fd92d..c2f93e4144644 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -1076,6 +1076,16 @@ static bool vi_need_reset_on_init(struct amdgpu_device *adev)
 	unsigned int i;
 	u32 clock_cntl, pc;
 
+	/*
+	 * MacBookPros with switchable graphics put VRAM at 0 when the iGPU
+	 * is enabled.  Any later post (S3 resume, GPU reset) moves it back to
+	 * the vbios default, so reset and post on load to start with the
+	 * vbios layout.
+	 */
+	if (adev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE &&
+	    !(RREG32(mmMC_VM_FB_LOCATION) & MC_VM_FB_LOCATION__FB_BASE_MASK))
+		return true;
+
 	for (i = 0; i < ARRAY_SIZE(vi_reset_quirks); i++)
 		if (adev->pdev->device == vi_reset_quirks[i].device &&
 		    adev->pdev->subsystem_vendor == vi_reset_quirks[i].subsystem_vendor &&
-- 
2.53.0



