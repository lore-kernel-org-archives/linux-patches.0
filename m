Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EA21A618F;
	Tue, 30 Jul 2024 16:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356746; cv=none; b=lohfV7pSe2x1ie/VgiByRq1KRUd4AaZ/DTo/PzkGITI+eyNBJmtwOiYQqqoMcf4+0rsJHsTLMoOZtDgGzPwLNhtLXbZB/t33JAy0HyZGQOcML6Ai432uqEAHiM5oGqsaROZ7brdyFnfVJ2EjTzxw+CDQHf0ETyiYSCBY4WwD2us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356746; c=relaxed/simple;
	bh=Og2s7msII++0rDHy9u2ffAo1zI5iobW3M56lReIvoUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDgl34WNEJOBb4OaQpHODBlWI+OYU0f4fJ0kTWisHdKAaPfXgWxTvHASFSBV1jZjMxhELRyol0cp9BAQv/jLtFSgiAKODbCeBh4cZf+km+7Be6LZNvfRYNAb8wG5P7IskOkluyB7kPvC27O6OXz8aYugZXKQi0xEaYOMPxM/uFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flP91TGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flP91TGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37ED5C32782;
	Tue, 30 Jul 2024 16:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356746;
	bh=Og2s7msII++0rDHy9u2ffAo1zI5iobW3M56lReIvoUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flP91TGPCsBXc2FQjsY8RFK8GTtIDol2AHpcOI4dgISbILaVPsjckqal+J4oLJFcB
	 VlaxJMFXzvLgy20X4mysfh3vCCdpVrF0idVINFWwGiphqQsZ1aj6Q87GJAqsIdNtMc
	 J7unXEHH80MKfk3SeaIDHt2xt942BvNI76jGuueY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/568] drm/amd/pm: Fix aldebaran pcie speed reporting
Date: Tue, 30 Jul 2024 17:44:47 +0200
Message-ID: <20240730151646.915415695@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit b6420021e17e262c57bb289d0556ee181b014f9c ]

Fix the field definitions for LC_CURRENT_DATA_RATE.

Fixes: c05d1c401572 ("drm/amd/swsmu: add aldebaran smu13 ip support (v3)")
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index c097aed4722b9..c0adfa46ac789 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -79,8 +79,8 @@ MODULE_FIRMWARE("amdgpu/smu_13_0_10.bin");
 #define PCIE_LC_LINK_WIDTH_CNTL__LC_LINK_WIDTH_RD_MASK 0x00000070L
 #define PCIE_LC_LINK_WIDTH_CNTL__LC_LINK_WIDTH_RD__SHIFT 0x4
 #define smnPCIE_LC_SPEED_CNTL			0x11140290
-#define PCIE_LC_SPEED_CNTL__LC_CURRENT_DATA_RATE_MASK 0xC000
-#define PCIE_LC_SPEED_CNTL__LC_CURRENT_DATA_RATE__SHIFT 0xE
+#define PCIE_LC_SPEED_CNTL__LC_CURRENT_DATA_RATE_MASK 0xE0
+#define PCIE_LC_SPEED_CNTL__LC_CURRENT_DATA_RATE__SHIFT 0x5
 
 static const int link_width[] = {0, 1, 2, 4, 8, 12, 16};
 
-- 
2.43.0



