Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052756;
	b=JEy0ID5kRTL3iYnjzTJaHKM8IdDPdy6GXm2ETyAea5MRZAKYi5jeZUuRcxQMVD2pY5DU
	 3s0s/oE6iy05Wxi4IpFDqYvQbT5sSphZ+3rWZ76X/EO5xdF03Pf7Mad3hq+b5FoX7/7oI
	 xiBoyIuO0CVA53VDtmD+kpUv9GQkQHCFpxdYDu9nheMF8v1LHpRTG0nZu3o5azMqEwiPm
	 XA5Y7f7IlHEc+WzVPpjXkpx6gDtiSLf/o6mTYlKMA4P9RwGalKUVB+uDisTyLCiuzfOEx
	 YxBD2/SuBrJDdkMC0G1xIuU0AZXA7uXX4VpBvFWW3dh8HFVbCtx+WzNjJpvEVC2ugNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ksb82AQzpJXvSH2bwcYpmM20DfV5xXSKBkB04c2bN7k=;
	b=dUwVkfohTNWhlQVBo4M2sXX3iakbvaTJSA+LmorIS4TR07SOKs9USKb7cT0zL5i82d7q
	 ox1c2RLklSmlmKLqz5zDkB2Nb1eS5y/dhsMthBZ2SFBrZXhHNsJusopzwVLs/gJjQuIgd
	 XsFV9ABJ7S5NMLsJyKApsAmJsG207b/VBSlFji9Iei5FABTjxBmGBzHW2uYjPubm7taix
	 hEka1WgKoriQKWZwnn/ERnjzM3ebUgeEGGgRHNd+qEcL7gIEIddiSSaoiCnpjEXejGUr7
	 7a9mGhMZGxwcDgYu2lABJ2SMHd8Epmz6WcwQ6ZWVwJjy1ILjZhdBE9a6mcfiAKQ/nZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hg5mWu2k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B88606A31C;
	Thu, 19 Nov 2026 01:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hg5mWu2k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9ED1F000C4;
	Thu, 19 Nov 2026 01:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052755;
	bh=ksb82AQzpJXvSH2bwcYpmM20DfV5xXSKBkB04c2bN7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hg5mWu2kiqznj2dINUEdeJPJNUc/jwnPpRFrIAjzdWtjezfJLl2DDIliXK/4gFhtT
	 QHNgATbySge1wXqSIcoYw9Xte69nEEW1j4rgQslzkGQ1c1Duz4dHymWWbzqPKQs/ox
	 FqlUp/aHqGqzB99gNfPiG75fli77ZlKZorPa/oBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Maciej Kucharek <qchcio@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0675/2214] drm/amdgpu: reset CIK ASIC on Apple boards with VRAM at 0
Date: Wed, 18 Nov 2026 15:39:11 +0100
Message-ID: <20261118150038.804611258@linuxfoundation.org>
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

[ Upstream commit 095f634ea0aa5b9da19495520b5fc1a155b2c137 ]

On MacBookPros with switchable graphics, the firmware puts VRAM at MC
address 0 when the iGPU is enabled.  A later post (S3 resume, GPU
reset) moves VRAM back to the VBIOS default.  The SI fix resets and
posts the ASIC at load, so the driver uses the VBIOS layout from the
start:

  "drm/amdgpu: reset SI ASIC on MacBookPros with VRAM at 0"

No MacBookPro has a CIK GPU, and no affected CIK board is known.  Add
the same test to cik_need_reset_on_init(), so that SI, CIK and VI
handle this firmware layout in the same way.  gmc_v7_0 reads
MC_VM_FB_LOCATION once at init and does not reprogram it.  A CIK board
with VRAM at 0 therefore has the same problem as the SI boards.

After the reset, FB_BASE is not 0, so the new test does not fire again
on a module reload.

Only compile-tested.

Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Maciej Kucharek <qchcio@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6bb4b79d6a6c461b40750fd67cb4e2a070e20b67)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/cik.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/cik.c b/drivers/gpu/drm/amd/amdgpu/cik.c
index 9be6da37032a7..83f6fa22eef8c 100644
--- a/drivers/gpu/drm/amd/amdgpu/cik.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik.c
@@ -1947,6 +1947,16 @@ static bool cik_need_reset_on_init(struct amdgpu_device *adev)
 {
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
 	if (adev->flags & AMD_IS_APU)
 		return false;
 
-- 
2.53.0



