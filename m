Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045647;
	b=CqB5AEpUYtyrspYsnxR69bxfO5SgeXhyigpwUn7aU89Jq7y0hJL3FvTSUcO8Ym+wygGs
	 ZmhsSluXYNxUZiM3wg+Fr1CEF/FgvmOJsfdlhSd95nKq6F77g9ye+F+QIQhuEMNejYusK
	 G9JT/bBMfSLEigxxQO21N2/oBE3Q5pHVE/5AWAxQ2XSHXoLwMdPTLYX8EEgGsK0SmWjU6
	 Tgx8gA06B9UGRTkIi/BbgJbRN5hOeA4Dqm82LnEs3xXO+LKuecb6j1bPni3UYkk05mH+X
	 YiVUU3RNlRdigijkgzCr7eOKSVUveI4rxpCjzKgQW4+Yv27Ooda5IqMCMHh6gw9fE0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CYZyPqE0rc7x3Ld+WEeGedSKbDfctTIJlyLOqC4bGJc=;
	b=LGW7a5cJqFBrmySnQKgQ/HAX8ovXoaCGwqgq/qHf96tm0NiB8EyS8LLqSq8bxmaU93uS
	 2uXTRVAxAVDJqC24f0Z1Z7d+uKPdb4k1m+AcXekr3LVw/kSogh1XQt3gvwnY5vshHxcNz
	 0AQLDgtVlbRQFbdf0ZkujBqf+6AG6BAaSQWV88OQuHl/yRr0aNSXaZCZ+C4YYJYVGukeB
	 TYAZWtfQnvQzZ3279LaDh4oXjXormtxha9T/D3UCW7Pd4BmmlGWQB7ksKubLWu3AIGGh4
	 6dIGbXD3b1td/SR9u3EBvBeITQ7f46weAhAnsjLd8xfFq5ewWW4HB2HQvHKfgI7rZuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKI5IY3E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4CD60A260B;
	Wed, 18 Nov 2026 23:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKI5IY3E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79AB1F000CB;
	Wed, 18 Nov 2026 23:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045647;
	bh=CYZyPqE0rc7x3Ld+WEeGedSKbDfctTIJlyLOqC4bGJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKI5IY3EE+LIux4rtFU/ZmslHU2i/sovZ+sc9x3nSO+2/gdHRDfhSawZLt8N+1XjR
	 fwMurQvW4/4kUDXjRJt5p6LzW7w6f4baEY8clLP8Uq6BhwTf+NHdNVUqBUQQJhmNTJ
	 Ulb7pSJ9jTqA739SShNBb/1qIlcINRimMvojUD5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Maciej Kucharek <qchcio@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0999/2857] drm/amdgpu: reset CIK ASIC on Apple boards with VRAM at 0
Date: Wed, 18 Nov 2026 15:33:53 +0100
Message-ID: <20261118150237.570851156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



