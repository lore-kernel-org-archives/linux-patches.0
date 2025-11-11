Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D616F2DEA77;
	Tue, 11 Nov 2025 01:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824176; cv=none; b=dFVHl6ffM17dtyr/pNPWR7TBdROEfEmPUgr5iHXbn8bnoUFYNT6plXjNNV1mIvE13cmvXDMFltqaPieA4w+K+4TNNqdZRqj29DhEhFN4889M6+KxedsdtPL2TdIANFBBYsNFlZTNGOK22d1o6aowCApxlPy6Jc1pAs8UHcbI7p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824176; c=relaxed/simple;
	bh=K9NlcVqcsS6yfL6I/UCJppz0Ucm6+bBO3KiJU9AGxdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/KlxmVoooQrTgChoHqLIDILv/OWEvW1PRs/GDVxumaJyEpRa3a/fK3TgQewxPEErNgdqhaGVyXWesnY47lz9jhMaesOGA+F7nV8Db9h3hSih6LAIXGWk0h/iJUaNvL2WGMKNboS1lVCgdqULWqJjToIHGLO5JZ7370SY9uOxNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=daMNiYIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="daMNiYIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A06FC116D0;
	Tue, 11 Nov 2025 01:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824176;
	bh=K9NlcVqcsS6yfL6I/UCJppz0Ucm6+bBO3KiJU9AGxdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=daMNiYIOYioexYAS1Jtev7F398KRQeXiDbWm6OJuYUv6AF6eQ1rA5et3pyz+sSAUr
	 sr0rDZWesR0JX6y+LRh1/KCNSx4gDDAGUgOA72DbBiR4k/EfbIxyOgcKRD2JAOy5Jq
	 fj7jE1oie87Amh8EkqJYx1S78ijC9Ec3Dgvs6ZHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 456/849] drm/amdgpu: add support for cyan skillfish gpu_info
Date: Tue, 11 Nov 2025 09:40:26 +0900
Message-ID: <20251111004547.453049173@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit fa819e3a7c1ee994ce014cc5a991c7fd91bc00f1 ]

Some SOCs which are part of the cyan skillfish family
rely on an explicit firmware for IP discovery.  Add support
for the gpu_info firmware.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 097ceee79ece6..274bb4d857d36 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -95,6 +95,7 @@ MODULE_FIRMWARE("amdgpu/picasso_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/raven2_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/arcturus_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/navi12_gpu_info.bin");
+MODULE_FIRMWARE("amdgpu/cyan_skillfish_gpu_info.bin");
 
 #define AMDGPU_RESUME_MS		2000
 #define AMDGPU_MAX_RETRY_LIMIT		2
@@ -2595,6 +2596,9 @@ static int amdgpu_device_parse_gpu_info_fw(struct amdgpu_device *adev)
 			return 0;
 		chip_name = "navi12";
 		break;
+	case CHIP_CYAN_SKILLFISH:
+		chip_name = "cyan_skillfish";
+		break;
 	}
 
 	err = amdgpu_ucode_request(adev, &adev->firmware.gpu_info_fw,
-- 
2.51.0



