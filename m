Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062474;
	b=sBMEfG4fQWdEHE4s/rMI9lqwlQwZraLZBrC6lNdYdaWtydevyqi0OC0qrL3iao5BYrZo
	 Y7cJ/zohcKurMqpcSAltixyy4OvuEwcNGYUCuw1176nTOc479+L4iGPdgR765sar2yl+5
	 Jq5+qYuUyj3epNWMR8jDqsow6zr+H0xrmXdl9bhZLUV6VUS/CcLbS5Bk3OBbpxQVHrPTP
	 vBw9mKS6jllXArj5AONx4SgGNtdyPKLM0AROA9GogNVkFsG2/P+UWAkXpWF/uOsnqmG5R
	 EwAikxUucM9ISD5Ah5hMaSNawdEP6XuC+5YA2w6J9H1U5x0FU9KVzYAjuZlH5/n6PWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wtvw75RS80mX0Wvoqdp4fziB/raiZTtNZsmibtA+buo=;
	b=3VnJiRfaKjY1eQJ5tj4EuNPKYNRJ11RdrILbTX7gMzqwO2dOxf2OMkc/8ebJyjW8ihiy
	 /os0okrvPo7aSx6LMW8PkAfYPaCrYKwU33/E/w0uFFzkmRkjgvpuvpmLkZx/NlAH9/mrl
	 StZFGqahVlftyJBhlBt9TBaqL2JOl1e1E+V5zu2KBcgpF7vldRciZduNlOcnG2zV1x8FC
	 U1ddpx5edM9rK2J+grGAVSwOtJWjlJIG6/17v+G8/8MJtMSJMSzZvnZtfYv6ZkZDG7ohu
	 LXWksKmHOp9Xdvl2SDw5rObDbKELA/QvwbXKiyAlUTsYAWEv38x0ZrOe1Ww72IuXShw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gfi1scic;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA82606A65A;
	Sat,  7 Nov 2026 14:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gfi1scic
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00691F0089F;
	Sat,  7 Nov 2026 14:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062474;
	bh=Wtvw75RS80mX0Wvoqdp4fziB/raiZTtNZsmibtA+buo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gfi1scicpjL+01dVQhbnx5Q0WUydgDfE6edD6tnGKybKKjSC99x2aGLtjwPjfWaIi
	 etex/ozP+Tp+APK47qE7BIW+qPuJk4/Wos8iLmJgr2+KMbS2ZfE3EXgpaztrPTrTyV
	 qu4nl+mWHXhAQlSgMzu2zJV1Upmd6TJkIFfXTWu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Maciej Kucharek <qchcio@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1378/1536] drm/amdgpu: reset CIK ASIC on Apple boards with VRAM at 0
Date: Sat,  7 Nov 2026 08:56:34 -0500
Message-ID: <20261107135036.539453086@linuxfoundation.org>
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
index 0a0114de11b49..46a0ba1900045 100644
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



