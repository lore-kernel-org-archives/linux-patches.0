Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C9C3AE6F8;
	Mon, 23 Mar 2026 16:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282197; cv=none; b=bqoHEfZfvq09rZ4oEGiiyp/cgy0hY7ePqQB8AsI3rm64X6jCdOiNr1aH313RzWyvWtNFoci/qwtmwfuRNZSEdP9888wtRuGlS0zrcpKOXAwMCJOJjhYGs+/K/YwkmEVktqFZMJ30tMo6m1PRSHzTt4coxW9sIxIUEhbgczT5WH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282197; c=relaxed/simple;
	bh=Riwuko69TZpd2MBIgQza+YifR1BPGTw5EWaJRi/bTEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klKLIcup5HCkXqJdcEu6BR/SzfKRYOYV0mv5bbWwjywb40xSO8SHhZUbhro9+hqZSq2EeY8tLAZoCXdXiavD91B0PD0iTVuQFbijQTgPtfGejMGN1LwiJsi45YA/Sx3N4YYFCUCIHhRPzzVBQTGw7xlO2byfCWptrmjQO3x8Psc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJVuHZNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJVuHZNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E32C4CEF7;
	Mon, 23 Mar 2026 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282196;
	bh=Riwuko69TZpd2MBIgQza+YifR1BPGTw5EWaJRi/bTEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJVuHZNyGVzD+pH7AFwvwKHX9KZ0C3A+Hecs3fntD2+nYSCnBhUbKrcQc08EnYo5r
	 qE4IJT4UBPZ7DsJ5vsWN/1sQcV4z9LCqp0irKEQcsRY+9ETsrmz4XB1wtDLJb6b53q
	 o1Mi2yB9560eLMkqeqLPsG06z2dJpiHW8TEWCwIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/481] drm/amd: Drop special case for yellow carp without discovery
Date: Mon, 23 Mar 2026 14:40:49 +0100
Message-ID: <20260323134526.860238296@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fd98d2508a22a..4bc05178504dc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -652,12 +652,6 @@ void amdgpu_gmc_get_vbios_allocations(struct amdgpu_device *adev)
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



