Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D98A5616DF;
	Mon, 31 Aug 2026 13:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184063; cv=none; b=gkjLlh85eaUaKA6X/Gdc0vdomIEBiozwUlRtAUZGKX/UHzkrwNY9RzQGD2A5q4tjySO6xLjnpqG/lrtcTb7SNaZSUAhudT0hSF7gVnNJP0WUVFFlcEhnIaEK5z7DJXrLiMgPPQXiWK2nj99V78iW7r9KqxqHjFdZBCdNmUmfVFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184063; c=relaxed/simple;
	bh=/rxAhD+Ivjb+T+bcXYrZB6St+/qEk2E+At8sr5OqYoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HHzoin+8xey55PfEcyE7lTfmu2RBiKlOO8mykii7e08yfKbgmZUXnn8VNPuIMjKo3S5RZopIr+k6Bbts3K814YHgCbITTnYGgc6Db2IqnYLsazkZ2uBnzmABCT4TGPvQdXh1KWZMvNOp+VTt7MRqT37A+hYpV2kemjQpmQuofs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tx1meAkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tx1meAkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A2C1F00A3D;
	Mon, 31 Aug 2026 13:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184061;
	bh=6LzGMzzETcrwCkz90eapR/18hijxC9zgk6vD6kUQoJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tx1meAkCtbw9xwyndSOEKcO1LPMozo0rFVjcJSdQDb0/tc3pYlY1cLkH4FTVVeWQb
	 JDyjCCCS7XSQI6dcoCA1YuRvigyjPRo3vN4eTSZj4grEhtzsvgX5U9gpREzC+Y3Ney
	 XbH89np8mneGOW7U+1h3NvgBQcffALnej6eN9rcIFLC0E6zAtP6ARfSBiyjtXdPXOC
	 dGIS/7164AG8UdGf9lt+39Ric1VX9mFFo9Ib+0Ed96+rC2Whfw7oJ5PhnJaIChES4/
	 BULWMT8Kgh7AU8oZwnomH+Whd/fCOyfFGZeJwx2uKkDaK8uhnaPfVhz+cch8b9cCDt
	 PBiUAxLQn3v7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/amdgpu: Prefer ROM BAR for default VGA device
Date: Mon, 31 Aug 2026 09:28:16 -0400
Message-ID: <20260831133314.4125787-468-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 9e32d17592950478baffaecdbda8e2e60935fd3d ]

Fetching from platform ROM doesn't work with hybrid ROM images. For
default VGA devices also prefer ROM BAR.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background `git log -S` search finished, but this stable tree’s
shallow history isn’t useful here — it only surfaced baseline import
commits (`19eef1d98eeda`, `ac3fd01e4c1ef`), not the real introduction.

The function was added upstream in `27145f78f56a` (“drm/amdgpu: Prefer
shadow rom when available”, March 2025), and that code is already
present in v6.18.43. This patch is a small follow-up for default VGA
devices with hybrid ROM images.

**Verdict: YES** — backport to this tree.

 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index 4e60753e16e90..dec312b0f3b0a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -33,6 +33,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/vgaarb.h>
 /*
  * BIOS.
  */
@@ -491,7 +492,8 @@ static bool amdgpu_prefer_rom_resource(struct amdgpu_device *adev)
 {
 	struct resource *res = &adev->pdev->resource[PCI_ROM_RESOURCE];
 
-	return (res->flags & IORESOURCE_ROM_SHADOW);
+	return (res->flags & IORESOURCE_ROM_SHADOW) ||
+	       adev->pdev == vga_default_device();
 }
 
 static bool amdgpu_get_bios_dgpu(struct amdgpu_device *adev)
-- 
2.53.0

