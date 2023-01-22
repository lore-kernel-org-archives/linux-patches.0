Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C542590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C14C433EF;
	Sun, 22 Jan 2023 15:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400825;
	bh=iWBhOR3tiqHKL6w7EWqf1jPTFmfJiAK171phNrqQBR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEZJ0OpTPt4mAqY6C4oJwdQ9bj4pdcCPWEWNYF4QYrO6tXfT71z+BJmdeE0KSXm48
	 SzyNLGnaD/A46jcgj7MUtkolj3Qg96BvcZl/N9ubcnVc9/gbiLUV5gP0VWfu+Bl/sk
	 Z21a9Bjrlpi8wyvqYVx6rC3W155iK5P0n8T4rtF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	kolAflash@kolahilft.de,
	jrf@mailbox.org,
	mario.limonciello@amd.com
Subject: [PATCH 5.15 103/117] Revert "drm/amdgpu: make display pinning more flexible (v2)"
Date: Sun, 22 Jan 2023 16:04:53 +0100
Message-Id: <20230122150237.119191565@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

This reverts commit 78623b10fc9f8231802536538c85527dc54640a0 which is
commit 81d0bcf9900932633d270d5bc4a54ff599c6ebdb upstream.

This commit causes hiberation regressions on some platforms on kernels
older than 6.1.x (6.1.x and newer kernels works fine) so let's revert it
from 5.15 and older stable kernels.  This should be reverted from 6.0.x
as well, but that kernel is no longer supported.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=216917
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: kolAflash@kolahilft.de
Cc: jrf@mailbox.org
Cc: mario.limonciello@amd.com
Cc: stable@vger.kernel.org # 5.15.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1510,8 +1510,7 @@ u64 amdgpu_bo_gpu_offset_no_check(struct
 uint32_t amdgpu_bo_get_preferred_domain(struct amdgpu_device *adev,
 					    uint32_t domain)
 {
-	if ((domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) &&
-	    ((adev->asic_type == CHIP_CARRIZO) || (adev->asic_type == CHIP_STONEY))) {
+	if (domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) {
 		domain = AMDGPU_GEM_DOMAIN_VRAM;
 		if (adev->gmc.real_vram_size <= AMDGPU_SG_THRESHOLD)
 			domain = AMDGPU_GEM_DOMAIN_GTT;


