Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063537;
	b=X38bRf064p6ofLZ0uvL48jg5RQnQgSB3v2Cw1kY4pk8bs4NksfTdGUEq7H0FrbnAr0Du
	 6DedwXC5o3ujuFGXIx5g5WJN0g4d/e6ECbY0q3NdIQ1rdgiRhHz58oES1odcNb8JY1P58
	 qgbM8XpOCmpqRL72iYBiAw1e2bkmphdcAQQE50lHMNpvgVqwlQ0QNAemqZBeRHxRkfErJ
	 tqyW63dyw7vRWpvJULP9mWPj9MGiY2+LMrLI1S1bOqauKLWV1+vwuLannWDKUEUy4xr5m
	 NenoLeYBnK1uOWKtDxXqWZ0MUtLUmHcvUdGOn5EWotPB8CbFO5mCsx4dQ5+N1kkJ7mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sP/gHTO5TTxYAPybEP0XTldxju26iNX1DjVt1Msus3U=;
	b=W6yfuu3xI+zx1pfLPWwj9p3NKz0tQjldovbh2QJ8CWn+XrBGP6LMN7Pkf9I/JfwFrmUG
	 x6WHOuMNuj31QCvLf1+XO14nbhPPStnpjUuYmwqG58NGhXT9DlXSsHo6kxKOiHv676mBV
	 wFbbXWNI89UzlXgP0oypvFzw47kPB3tpTopwl2UCXKNNBSqnyw4o92KkisD2vL47eN+v7
	 R+VtwhIIEjhVDHlDMNF3LkPq9C93qBqB8CjGMczqWErXlYnz9rBkF2uZYURH0UHmcKc5f
	 uJm0nwoCxf6ZpryWY2sgm/jwhF3+5etQ9vlR3cd2InaOPNe9PEsJXVOjWxQ9TD7a42A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bboK89KH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF04B606D81C;
	Sat,  7 Nov 2026 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bboK89KH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8844D1F008A1;
	Sat,  7 Nov 2026 14:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063536;
	bh=sP/gHTO5TTxYAPybEP0XTldxju26iNX1DjVt1Msus3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bboK89KHEAxHhfKcTmfeOvNofK0zfi9na5JirOi+friderJnVFu0IPQdp94PNCxX7
	 HnwwMx/wv+SlkI9jVgePxY2z+tpx1m4xg8PVyrAiyia3cxsVYZh3lz1K26d3fVe3rV
	 BdIHhEhZ71pP8Amn0oZMblmd2v3m/Fx57gdukC4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Maciej Kucharek <qchcio@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 673/869] drm/amdgpu: reset VI ASIC on Apple boards with VRAM at 0
Date: Sat,  7 Nov 2026 08:55:55 -0500
Message-ID: <20261107134915.924962727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index ce54e29381079..bb81251319084 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -1425,6 +1425,16 @@ static bool vi_need_reset_on_init(struct amdgpu_device *adev)
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



