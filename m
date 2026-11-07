Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065137;
	b=KY7ktBFAisrZlVHTkTd/mFcFo0y0im9m9skGA01aDaQSyPcb0/qFbaBgsv70CfEBDwM0
	 eVMLh+NkKKFj3EPv8+dNlxyWx636HJCDDHRhAf+nxioTD3D4wSKTfd1gfA6EWP6WgrfoF
	 8VAyMPSCJ9WE7RZ/a3DYmFhId/uorCMBVyHK3TxSBmz38iyiRaD8cuKoiD3xf8cHrjjOt
	 ErcGFBIXUAAfIph6H3Jfr4RuVeLxAnVGJ9EPfzjaT/kO2Et+ti5vKx2IjELsh6Xw9BnIv
	 RFtg2ZYy8I9pMHh3lpzDjlQAJJG2Qxb7hKsZPAWKgbNt3f4kyEYDPkMjIuU6piQXLLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jCyxaOnDHHeo0Wu9NyB/jdc1T8Q/1h6of6ZcpUmc0AM=;
	b=e5O8aKCW2dizFncFWalA3nh9ens5BrFs4HBtEwARV1blJV63DO9x5Wuf3iw8smyXfZ/Y
	 xfrZCi4iRnCTEf+HDMcPKvqOoHZ4ay4jseMfG75Q01PfaT8JOxYyxS6qjBu4mTPYIlE1u
	 79HHQz42vp6RerV0UxIDR1f6+hz+uYYOSWts/mTBPVZJnHvJvdthoK25gA/7NQsB8eOUv
	 FQ3QK+3OfZSriYXz0c/wNu3wacDPxkz77J2qIKjZI5ePRv6O9q8O0ahc66z2RcG11UJlj
	 o5O96m+5jxbebuLiYb4KU9l90XYKGmJTZuIx7GCEux9DeBqIgqjBMRzMC06iCe29Mew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ext+worE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A04606A32E;
	Sat,  7 Nov 2026 15:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ext+worE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BAF1F0089F;
	Sat,  7 Nov 2026 15:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065136;
	bh=jCyxaOnDHHeo0Wu9NyB/jdc1T8Q/1h6of6ZcpUmc0AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ext+worEA7hxx6qNXssEecoToNN4MNb0oW2nnfUFo/h9i1O14xwnEPnFCPwUngIV3
	 pHJWC7n6N+TTHUKJHXknfOgOXhJ3VgskwYYWtvXpSLT/eXGQ60gfOS9wqy5d6YsqA/
	 xT11xMkK2s7/vtKJVmrZNGNCQKojL/hAkkOqxIVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Maciej Kucharek <qchcio@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0955/1257] drm/amdgpu: reset CIK ASIC on Apple boards with VRAM at 0
Date: Sat,  7 Nov 2026 08:54:11 -0500
Message-ID: <20261107135005.718557156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index e037c08c85479..71eeaf42fd33a 100644
--- a/drivers/gpu/drm/amd/amdgpu/cik.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik.c
@@ -1927,6 +1927,16 @@ static bool cik_need_reset_on_init(struct amdgpu_device *adev)
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



