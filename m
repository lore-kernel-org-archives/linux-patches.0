Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFD136C59E;
	Mon, 23 Mar 2026 14:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277735; cv=none; b=CLOl9/3ud2ABVYBWfw/YC1zfPAdzYq8CJMOsloAqdQx/rao3KxJPKOlpiCo3NA4SXwKZ+R6IMxitgSlsVC6n0X4rmQncI5jXYKmv37JSHZs5mX13MRaleAA9b4NKIIvWZhtwaplG1PtNY0Dp/DiYDpAzJfmY9nIySa6g6c/x5I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277735; c=relaxed/simple;
	bh=AGhkyLDjRwIdUFV0hzARoJ7O6UszI2kXWVKsKnW5S3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpWa1du1VoUbIV7+D5BS5uZqAl8O/wFOqA+jAaIjtBPjJ5EbUal+IDC4Bng01DgVsbJSdVAWkevjzXMDDAn1bty6SvPJ9v4wfFAbgBUXfIFKKxwGDhfITtihPPvb/2dCXRpuhzg49JR9j4Ir9halAIbEEDqZqF0TUtniHBGgRF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ociyHeB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ociyHeB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2522C4CEF7;
	Mon, 23 Mar 2026 14:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277735;
	bh=AGhkyLDjRwIdUFV0hzARoJ7O6UszI2kXWVKsKnW5S3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ociyHeB9HsW+chMiqgYcdgio5Xs1M74ZsGTfEfzkNkerPmMNDIh12rDYbi98vei7x
	 6lH+YnmK0UsmD/KNdCGdVxNyRFHEg6ffdH/gHJpuYtfJmSXcSwQV/5GaoLdNzxbZ1Z
	 p2QJwqEwB6/skHFeph+ikfPWV42USjwmmV7lEd84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/567] drm/amd: Drop special case for yellow carp without discovery
Date: Mon, 23 Mar 2026 14:40:05 +0100
Message-ID: <20260323134535.932455713@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 3ef07651a5756e7de65615e18eacbf8822c23016 ]

`amdgpu_gmc_get_vbios_allocations` has a special case for how to
bring up yellow carp when amdgpu discovery is turned off. As this ASIC
ships with discovery turned on, it's generally dead code and worse it
causes `adev->mman.keep_stolen_vga_memory` to not be initialized for
yellow carp.

Remove it.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 096bb75e13cc ("drm/amdgpu: keep vga memory on MacBooks with switchable graphics")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index 3c24637f3d6e9..7d120d4175499 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -728,12 +728,6 @@ void amdgpu_gmc_get_vbios_allocations(struct amdgpu_device *adev)
 	case CHIP_RENOIR:
 		adev->mman.keep_stolen_vga_memory = true;
 		break;
-	case CHIP_YELLOW_CARP:
-		if (amdgpu_discovery == 0) {
-			adev->mman.stolen_reserved_offset = 0x1ffb0000;
-			adev->mman.stolen_reserved_size = 64 * PAGE_SIZE;
-		}
-		break;
 	default:
 		adev->mman.keep_stolen_vga_memory = false;
 		break;
-- 
2.51.0



