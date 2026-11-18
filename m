Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058612;
	b=viN16qIXdfBb3epxHd1Ua+f2I1pb7k0HXJUPbg+0kVQhJ1WWJRYebOqHTHIfvO+ahGXt
	 8xfePN1D7vbVA8dKMHUppbERyg+i2LgNloIZDzLW9xI6WEh40xtGaBpi13nKRGdWVjR4U
	 w7m77ZB2d1NM+DcjGDLaMx46GKj9A1yqAi1eFTP5po2u3is2fW5zM/H9ISt+tNa4s0mBG
	 LHUMiQlv3EcFzWoKyw4YJvq3nb5Dmp8Lwz61HguELs4HlK89HSD5H3DvgUFqiwgCTYK7B
	 EmGZIUKhhnR/i4/ukd+TQu8ON/3w7sBFY3pe1Ni1zOC16I0x35/zEuD2aF3erqCsNUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=syDaaiP8z925x5NKjhLF6H5aM53sYQssqfccJvYjgww=;
	b=WVmAMyHvh1GC/S1u95TarbWWCENpe/0vqcfctiL+01fTNp0kWh4awdafQ36c0qbOGt4o
	 hpTz26Y7OXJoXGxc3RnMpjUdi0A3oM8mOPHAxVKcbzer2YO4I5zooiCKPy3wMNDKCqykc
	 Eqxg2J20JjprHRJ1g84puvuoiY2P+RM4Q6VO8SHICe1EgWOXIbCLqTYhc4RDQjyWgzHVf
	 R86j+j2pIyAnU54rK4eyjzNOf4hfwCP2yCuUgZ/kNV0Emx3nH+JXOkItOr1zhJcekfyLh
	 s49HrpcZdcC+J0HQujGn1zLQ32ZHGUooBcq4OOuYC/MLJ5cLXX2LLgslVUYw1KN7Jxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jta7Zyyy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD465606A31C;
	Thu, 19 Nov 2026 03:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jta7Zyyy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B611F000C6;
	Thu, 19 Nov 2026 03:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058612;
	bh=syDaaiP8z925x5NKjhLF6H5aM53sYQssqfccJvYjgww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jta7ZyyyQqaPQaxNzCJjEpRta1ihUnwzgNeHCl0Eqb7/q2N8cBIJE3XA++ljNuvEt
	 VELfZo59ZTm2AElv5P7kU57/aQZS5TJo2A5rbm+35UiprU4UuPb2OmIQplrmNdxhxy
	 PqLVX2ipqdJOfOw9H/IistjhSHZ6zzPee1iWJyak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Maciej Kucharek <qchcio@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0548/1848] drm/amdgpu: reset CIK ASIC on Apple boards with VRAM at 0
Date: Wed, 18 Nov 2026 15:43:06 +0100
Message-ID: <20261118145937.902365019@linuxfoundation.org>
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
index 453464914f353..f8ccf31eb01ca 100644
--- a/drivers/gpu/drm/amd/amdgpu/cik.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik.c
@@ -1882,6 +1882,16 @@ static bool cik_need_reset_on_init(struct amdgpu_device *adev)
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



