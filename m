Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689A4302756;
	Sat, 25 Oct 2025 16:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409648; cv=none; b=Oe9EhGOikXwJbj33P7KiofbFtdnGxYJ4fAH4PDxW98lJkPxHlsI6aElJxZXAmV7lOKNt/2eqbyTebtCf1YH5fl83xhNl8cV3mZpszKBsP14OV4SSO1imIM2l3qQgtQSWi0bjLfOrBBbVW8huq1sHO8w8GICVPxgnxJNpHsf6pzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409648; c=relaxed/simple;
	bh=2jGDePxhMX+fo++WSFv5HjcT4SohZrpGO4VEL7tSEyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nz4c5WqHa0RYxmYYfT7Nsc/uCiIg0zehss0rfa/PSDTWcY1rGpmJe0I+RsjuA6mpqDNrE5MnW0G4eez1S5/zijiHUVllN/6OdIdDjc81NWvBcbtXyW9JjI2gRyWNRo82UBzPoAIydPXpzHbOoCeEraZQBFyCr9w9kIkMQBhrbKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KBQ3m6Ft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KBQ3m6Ft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE322C4CEFF;
	Sat, 25 Oct 2025 16:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409648;
	bh=2jGDePxhMX+fo++WSFv5HjcT4SohZrpGO4VEL7tSEyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBQ3m6FtD57lTb0icI94fwUj4Q2Bw3At/39TBqdXZks6TsrUJMagGRKJlZPyuvpAp
	 Wjj99K6776ssYqFNCO/ndbtkzSu2UFAGhslKjgXk4vcTyNA3UEpgPYSXgBPhSje1+v
	 jXyVyMfAdqfNmRu6azqZk5JbrYBdLXLkyiKaJSyVuwoJa85nra9LGxu8KMMikVWKox
	 pJS55i6mgRYGyCvTc4P89ld2483HtJyD3+JafgLMUr/oBHkQgUeKKp4n6xhWzsPGfa
	 2duZPYTAxQXqSqecDSI24ZLzO5pfaAsTh9N+OmNTF4zV/IkkoZXtjhI2ujB4Cwlb5A
	 n0LMhSCMshE+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mangesh Gadre <Mangesh.Gadre@amd.com>,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	sathishkumar.sundararaju@amd.com,
	leo.liu@amd.com,
	Hawking.Zhang@amd.com,
	christian.koenig@amd.com,
	lijo.lazar@amd.com,
	alexandre.f.demers@gmail.com,
	FangSheng.Huang@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: Initialize jpeg v5_0_1 ras function
Date: Sat, 25 Oct 2025 12:00:35 -0400
Message-ID: <20251025160905.3857885-404-sashal@kernel.org>
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

[ Upstream commit 01fa9758c8498d8930df56eca36c88ba3e9493d4 ]

Initialize jpeg v5_0_1 ras function

Signed-off-by: Mangesh Gadre <Mangesh.Gadre@amd.com>
Reviewed-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it changes
  - Adds RAS registration for JPEG v5.0.1 during SW init, guarded by
    capability check: calls `amdgpu_jpeg_ras_sw_init(adev)` when
    `amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__JPEG)` is true, and
    bails out on error. This mirrors how other JPEG IP versions do RAS
    init.

- Why it’s a bugfix
  - JPEG v5.0.1 already wires up RAS infrastructure but never registers
    the RAS block, so poison error handling does not activate:
    - Poison IRQ sources are defined and added
      (drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:149 and
      drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:156).
    - IRQ funcs and poison IRQ funcs are set
      (drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:924 and
      drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:919).
    - A JPEG-specific RAS late-init is implemented and would enable the
      poison IRQ via `amdgpu_irq_get`
      (drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:1061), but it only runs
      if the RAS block is registered.
    - Without registering the RAS block in SW init, late-init never
      runs, so poison IRQs are never enabled and `adev->jpeg.ras_if`
      remains unset; the poison handler early-outs
      (drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c:268).
  - Additionally, `jpeg_v5_0_1_hw_fini()` unconditionally disables the
    poison IRQ when RAS is supported
    (drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:310), calling
    `amdgpu_irq_put` without a prior `amdgpu_irq_get` can trigger WARNs
    (see `amdgpu_irq_put` checks in
    drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c:608). Registering RAS
    ensures late-init balances `get/put`.

- Established precedent and consistency
  - Other JPEG IPs already perform this RAS registration in SW init,
    e.g.:
    - JPEG v4.0.3: calls `amdgpu_jpeg_ras_sw_init` under the same guard
      (drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c:207).
    - JPEG v4.0: unconditionally calls `amdgpu_jpeg_ras_sw_init`
      (drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c:138).
  - The RAS registration function is already present and standard
    (drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c:311).

- Scope and risk
  - Change is small and localized to JPEG v5.0.1 SW init.
  - Runs only when RAS is supported on the device
    (`amdgpu_ras_is_supported` guard), reducing regression risk on other
    configurations.
  - No architectural changes; it brings v5.0.1 in line with existing
    JPEG generations.
  - The only behavioral change is that if RAS registration fails, JPEG
    init now fails (as it already does for other JPEG IPs). This is
    typical and desirable for critical error-handling infrastructure.

- User impact
  - Fixes missing RAS enablement: poison error reporting/handling and
    ACA binding (drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:1068) now work
    for JPEG v5.0.1.
  - Prevents potential WARNs from unbalanced IRQ enable/disable paths on
    RAS-capable hardware.

- Stable backport suitability
  - Fixes a real functional gap in error handling on supported hardware.
  - Minimal and self-contained, consistent with stable rules.
  - No new features or ABI changes; guarded by capability checks.

Given the above, this is a straightforward, low-risk bugfix that aligns
v5.0.1 with other JPEG IP versions and should be backported.

 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
index 03ec4b741d194..8d74455dab1e2 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
@@ -196,6 +196,14 @@ static int jpeg_v5_0_1_sw_init(struct amdgpu_ip_block *ip_block)
 		}
 	}
 
+	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__JPEG)) {
+		r = amdgpu_jpeg_ras_sw_init(adev);
+		if (r) {
+			dev_err(adev->dev, "Failed to initialize jpeg ras block!\n");
+			return r;
+		}
+	}
+
 	r = amdgpu_jpeg_reg_dump_init(adev, jpeg_reg_list_5_0_1, ARRAY_SIZE(jpeg_reg_list_5_0_1));
 	if (r)
 		return r;
-- 
2.51.0

