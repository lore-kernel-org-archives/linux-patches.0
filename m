Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063536;
	b=eyp0mXZxlKQ7sWjbHbP2n2D31G2tDT67+4vT3RpfYYM78ImwlAETV39ThXnYE7SiGGGh
	 f0HNiUrzn77k9wntEQV7up8DeLijMq9xzLYfRU6Od8R6AfV4Z9tW1tCIhsOT1XA7hRhE4
	 02wZKzQZVqDW6gwbTx17xI2fL2vbo7TQz4dEuEwsUsf6x6To3HX8a9Vn+yuAgrmgFJSUN
	 yBpPyJRCMcuOqqNgzj5Yau5toXWFv7kHdQwEScDBeoAJE3/9Dy5yzRy9xVpZUDSSV5FFj
	 AZkddgmNNXswpRfVwJ5IZR2tazSPP6bWVAOU/R+9Txt/l26mONUf2Dtw+6mZW3bSj7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ja02xdjxU51F2Mag/kDg0/JHutrSlepUXHc32KB4IN4=;
	b=gU1+ygRnGDZdiKOU/3ZHxh8Ldhz/o3fMoPtN1wyC2rAW5ocfPw0soGmxQRFqChfDfMwn
	 qog1ZM8S2Kw0cKXLBrLMPtKLGIkcP/M6TP9EMYYhPPJHu2vNeJ3Cfj9ouBdDxJiiz8BZZ
	 XrqEZkvSI7EDtT+cn9gnE36s3RZjGmNR8bsoo+OHjOUlXnwjCnmIR1XRJF+OLBH84ayKP
	 FZYkfFmIxadhbCPQPBpIug3TbfBsoeFWTumiAmRcgM8fHXqFq5lmUmrHecPi237ssM53G
	 BmMXVFtghN9/IrZT7hwKW3c8uqnPKWnUgYP+XAcMuXH9Ma0EN/zNtZKFDtSEWGC+uGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MnhqGNjA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC212606EE82;
	Sat,  7 Nov 2026 14:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MnhqGNjA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BF91F008A1;
	Sat,  7 Nov 2026 14:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063535;
	bh=Ja02xdjxU51F2Mag/kDg0/JHutrSlepUXHc32KB4IN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnhqGNjAP/P6rXuhwqyWfqnejSXCpumJpBggWlO41mowUe+384zJ79NqtUrCLiSe6
	 he4x6j8yMOyPw2aqiVRZWKVCtuhMM23JLPFcczFsVlD3S1+vqhUrhVl95dv0Y9jJUi
	 8JNIFQrs3nHgPPPNfUFYlBqtvH2ryD3BsSf1K00c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Maciej Kucharek <qchcio@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 672/869] drm/amdgpu: reset CIK ASIC on Apple boards with VRAM at 0
Date: Sat,  7 Nov 2026 08:55:54 -0500
Message-ID: <20261107134915.896004650@linuxfoundation.org>
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
index 9cd63b4177bf2..4bc35b5f7c47c 100644
--- a/drivers/gpu/drm/amd/amdgpu/cik.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik.c
@@ -1932,6 +1932,16 @@ static bool cik_need_reset_on_init(struct amdgpu_device *adev)
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



