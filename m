Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062477;
	b=H/j30gomABMd5Wyt0WFfV2C3E0ZTpdlNA7HNPAUYMy1MgnF2jsM2IaLUVLQGwX5k58UL
	 qNBl2f651SQA/IjMYm1oMhsjlX7a8RLAgng/TxLPZYvQCFdac+idxRYEnuLoxzbNMcyno
	 u2cDATlo35FxJ/wAfbDJI0R+iSCXEapvngHMHtngWeEqlq9dXXiPaa4VSjxTenhsEXp6v
	 SdmDbdj8PO4r6x253tlmkpDp5G/OaCIMvL+X2PfRkwAgMT/k6w/WpKQtW747lNJ5hY85d
	 xQzuBR6KPNOC1yiiXWa0+dwC+c6TassB4U3E9B6wwRU2q3qH1+klXASLkgVw9Xo6LRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PWCovdcc9wkFos0VaYd1y9IBcetlCCmGoG1M6bFo6m8=;
	b=mGf5yEWsz8llMMKkdOVABNounch2GOzHDdS7sqzmZJFGMPaNeIo+y/toyTnftgb3Gnaf
	 D6OUwSYrDdMotVa7Fk5Rvx4/kVtsClEnfmV752fxAwCiljoyJCfuPVUh8bExEV+C5ldof
	 BpMjgudfyDmdi6xXh7RgBaK691tzdI+hk0fudFGrZbVez8agEuiJ/vQRkz3Ynj6Z1eSnG
	 iot4tGEZdiN+NRt6GY3slti/Gb8L4vigVXHqhLzNuSjQi+ng93KfR7kC03aJk3/aI46H4
	 zHiyj2iauPgQvJRBw3RDAUvkM640Kc6vd2pWm3Vwsc1JUOTo2b4w1wcNbs/J8tZBLFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fi7hjwpp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB07D606A33D;
	Sat,  7 Nov 2026 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fi7hjwpp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628581F0089F;
	Sat,  7 Nov 2026 14:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062476;
	bh=PWCovdcc9wkFos0VaYd1y9IBcetlCCmGoG1M6bFo6m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fi7hjwpplvAT20AqAGCHP7uOhAaJImhiWrFrYh779yUnES7L9PLeutSfoYZULnxve
	 lGq70LfMC/gb0a0h0axvZ6vqOVsltWIOCbj18Hf68KxAfpdBZfHxiwN6MW++ETOW9+
	 DMABX4iyQhX12AtxBrWGV0IgukSg9PqOjuVEWCzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Maciej Kucharek <qchcio@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1379/1536] drm/amdgpu: reset VI ASIC on Apple boards with VRAM at 0
Date: Sat,  7 Nov 2026 08:56:35 -0500
Message-ID: <20261107135036.567289151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0cab98957ca40..5d822a3c7e279 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -1426,6 +1426,16 @@ static bool vi_need_reset_on_init(struct amdgpu_device *adev)
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



