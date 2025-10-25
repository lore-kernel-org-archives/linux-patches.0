Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB44302170;
	Sat, 25 Oct 2025 16:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409473; cv=none; b=QGPyDZLktSJ40maA9iquKPdRSPqQaIndQvsXnSf3oSHtB6biFuMpfdNFuNiqqWwTJ6eF1M2neDj7Xxv1E2dxi8ZKH0XFh6gLMFjwEr6bMgIiCu30vC2X3mbGLy/uzAuZe21i1sPET03pMesIHso+VZyqmHcKHr5RnRsuTlkvZww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409473; c=relaxed/simple;
	bh=COAKrwwrLIsKHqF7EzLXX7dpHzLrYjDVUDaPo5tIwKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F1qUQopacC3g3f3XYyd9x/NNyiMr1j1kMIT7uQVxhFJqFdYChjZ4DEwGGwAJ/lIG14c7bBJI57BjNqmQ0DgRVwk5avB67qz+y9iFjcpKK94lo6nm00psMlFuNfoIgwnEgZPyL8b2JvLpbd5Kz8McMq3oMaCBaWLwCrD/86p2DyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2tBY2ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2tBY2ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92551C4CEF5;
	Sat, 25 Oct 2025 16:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409473;
	bh=COAKrwwrLIsKHqF7EzLXX7dpHzLrYjDVUDaPo5tIwKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2tBY2baKFNoxPjstjquDfNIn8qPN8dE6P4Oc4L67SMxDjUgYYY7ryAGwiYocXHRH
	 Iduscw7ZOVOrL2WRhdy9jE5/TXdCrVIHMiDzhltiL86mcIkUSsx4lf0Nulhl5q2JuW
	 EiNsRWWSqtjaHgZWGAgocI7D5EydUpy2Djf1Vx3NeZ7qonVy7jSvhd+AXvh0eS2nlZ
	 lDwkt3+XsRlDs2ZMxDX42Y7lt2YOQtHCd+w63ZEllN2o7+EX+7eLIXheo+GUicIrBj
	 Rgdhc6seMJP8KF0FtGy3av9M3cve940JGxUAhu+8fTnKx8gledl/N9g24VPN2br2jq
	 m2tm8i+6oyXUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	leo.liu@amd.com,
	Boyuan.Zhang@amd.com,
	sonny.jiang@amd.com,
	lijo.lazar@amd.com,
	Jesse.Zhang@amd.com,
	sathishkumar.sundararaju@amd.com,
	alexandre.f.demers@gmail.com,
	FangSheng.Huang@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amdgpu: Avoid vcn v5.0.1 poison irq call trace on sriov guest
Date: Sat, 25 Oct 2025 11:59:28 -0400
Message-ID: <20251025160905.3857885-337-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mangesh Gadre <Mangesh.Gadre@amd.com>

[ Upstream commit 37551277dfed796b6749e4fa52bdb62403cfdb42 ]

Sriov guest side doesn't init ras feature hence the poison irq shouldn't
be put during hw fini

Signed-off-by: Mangesh Gadre <Mangesh.Gadre@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: Prevents a WARN_ON call trace during VCN v5.0.1
  hardware fini on SR-IOV guests by avoiding an unmatched
  amdgpu_irq_put() for the VCN poison IRQ that was never enabled on the
  guest. The WARN arises because amdgpu_irq_put() checks that the IRQ
  was enabled and emits a warning if not.
- Precise change: Adds an SR-IOV VF guard to the RAS poison IRQ “put” in
  the VCN v5.0.1 fini path:
  - drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c:352
    - Before: if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__VCN))
      amdgpu_irq_put(...)
    - After:  if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__VCN)
      && !amdgpu_sriov_vf(adev)) amdgpu_irq_put(...)
- Why the call trace happens: amdgpu_irq_put() warns if the interrupt
  type wasn’t previously enabled (no prior amdgpu_irq_get()):
  - drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c:639
    - if (WARN_ON(!amdgpu_irq_enabled(adev, src, type))) return -EINVAL;
- Why SR-IOV VF should skip put: The SR-IOV guest doesn’t initialize VCN
  RAS poison IRQ (no amdgpu_irq_get()), so calling amdgpu_irq_put() on
  fini is an unmatched “put” that triggers the WARN_ON. The RAS “get”
  for VCN v5.0.1 is only attempted when RAS is supported and the handler
  is present:
  - drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c:1702
    - if (amdgpu_ras_is_supported(adev, ras_block->block) &&
      adev->vcn.inst->ras_poison_irq.funcs) amdgpu_irq_get(...)
- Consistency with adjacent code: Other blocks already avoid the “put”
  on VF, demonstrating a known-good pattern:
  - VCN v4.0.3 fini: drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c:391
    - if (amdgpu_ras_is_supported(...) && !amdgpu_sriov_vf(adev))
      amdgpu_irq_put(...)
  - JPEG v5.0.1 fini: drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:318
    - if (amdgpu_ras_is_supported(...) && !amdgpu_sriov_vf(adev))
      amdgpu_irq_put(...)
- Scope and risk:
  - Small, contained, and localized to VCN v5.0.1 fini.
  - No functional change for bare metal or PF; only suppresses an
    invalid “put” on VF where the IRQ was never enabled.
  - No architectural changes; pure bug fix in a driver subsystem.
- Stable criteria:
  - Fixes a user-visible bug (call trace on SR-IOV guests) during
    suspend/shutdown or module teardown paths.
  - Minimal risk; follows existing patterns in related IP blocks.
  - No new features; clear, targeted fix suitable for stable backport.

 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
index cb560d64da08c..8ef4a8b2fae99 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
@@ -284,7 +284,7 @@ static int vcn_v5_0_1_hw_fini(struct amdgpu_ip_block *ip_block)
 			vinst->set_pg_state(vinst, AMD_PG_STATE_GATE);
 	}
 
-	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__VCN))
+	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__VCN) && !amdgpu_sriov_vf(adev))
 		amdgpu_irq_put(adev, &adev->vcn.inst->ras_poison_irq, 0);
 
 	return 0;
-- 
2.51.0

