Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052759;
	b=CTDaggbyaEl3EApvIf+LVnKQt2AWF0l9lAB67HFdadZl/a253R6MTPG0NQRwJ2GfmE5D
	 d4/0sno+cUAhDirdWuFc8/j7LKXeHml0QovyWoGD9st6e7JPzcVRpzZ/f2C5Ga6pWK1Yw
	 V47/dMxAMflBYMYQ3AQ5AmiZVkTN/cS8+ssS0rakUFfv3HHNYPQWzCmTM1JwE6kaosXha
	 MZqrFzi49JalFQv4aF+8DKKRvryWfbzPYwnr0B/LvRFJaTZ3o3lk1iyG0ZIg4g6ePiGbi
	 OiADLKucPnPnu5jKjQKRJ6fNKzdrbB6ZQjI12xTlKJhjb/ekNQ19I4BUEYndYTIZpBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wLbq6pIDqUmwO7Ne4fR9Jmf2MN4CNZLozKfHbdMzVmo=;
	b=qYw+nD2++mDAdc7gp1fAEYZ3NMeswZWQJZwlwLwpo4nM73YuJceHmUQHkyVJKsPFaAU5
	 QKS0450UVmZZAgD7ASt9HUI8OYQptRh5PWbb213L16vxkO9srEwcc95B6lSKBhMVMRGcf
	 t1T6hxBDA8qeHFM3D6Z5GRL+/0M2f4/zZ9+XrMlBhOifgKW2V+aaI+ZGNGz6wr9wxj42g
	 wXIKjZaWRIkPKDHpqIGmsAbmvY1dyXPQyew2hnda1LLNNZx8dYzEztSTzzssA0HIy2WTZ
	 wn+yZOMMsITqUq/902BUO8OxPrHxNsuIGx4hABZkFbASQ7EuoVikTv/rwP+kuDeP/WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7LLFQyL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036B2606A31C;
	Thu, 19 Nov 2026 01:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7LLFQyL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7CA1F000C4;
	Thu, 19 Nov 2026 01:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052758;
	bh=wLbq6pIDqUmwO7Ne4fR9Jmf2MN4CNZLozKfHbdMzVmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7LLFQyL/bPzKbu9I/X4qhco5jDE8zjznDbVobSeYphpA8712M2eXZXp87z0Chq1p
	 ccw6Mu7iUokXGFmOZAzfVYlQY8mq4yvYRvyRkGsNZ75hRqUwuh72+BUibG6/6y10uS
	 p2k+NQ33aDBxq2Zi5fJt1iZME1dxyQ570067mQf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Maciej Kucharek <qchcio@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0676/2214] drm/amdgpu: reset VI ASIC on Apple boards with VRAM at 0
Date: Wed, 18 Nov 2026 15:39:12 +0100
Message-ID: <20261118150038.840785730@linuxfoundation.org>
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
index ef26e8973829a..98f37102578c0 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -1450,6 +1450,16 @@ static bool vi_need_reset_on_init(struct amdgpu_device *adev)
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



