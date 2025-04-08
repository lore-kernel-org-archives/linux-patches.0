Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF20E267F65;
	Tue,  8 Apr 2025 11:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111028; cv=none; b=aZR07L3hjxsnDvRtB4FR+4HMY81uDL59C5BsvY/GQrVBgNkOwfv3Qjcxu//U28clNAkfCTse8OhqYWIcwWussEWGZ06GMBS4lVaGwHzUIqZzODc4DFtDjh7tIyvK0R1H6frX2RbAiAsmbs2ICbvL9tCws0gu4zWrh3qBxOcoYKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111028; c=relaxed/simple;
	bh=d/Bvdnq2SFUtemWpMTMRxBT6pcnZPImzfL8okziOxLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOSAK+mN954m8zpc3Opz3LxLo+hMfw9MNXX9Syg5S9tVmXlaTOEfauUX6+1vqv5DSufxUMwb7dcRwmkUByMp+2BDYPyCpZIYvmo3QH7Epn7w4Xk7HV+/oKHpm9ilMcLP0GRsYuecsok941FvrDoXnnJKDUXBjVs86HgI5IYCiGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5Qmi8zE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5Qmi8zE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAEBC4CEE5;
	Tue,  8 Apr 2025 11:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111028;
	bh=d/Bvdnq2SFUtemWpMTMRxBT6pcnZPImzfL8okziOxLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5Qmi8zEZMCxqqdETVbKSStmBIH6q7cwqpjbdbS1LdqOYTipKrfk0/xVT1gUX6nQx
	 0/EN62PeQUOK9HLBP6vy+0rXsL0Cd724kVUoZC4XC/LN7btpNXDFc/6qFxhzlK31gf
	 lmxxnqBDfMk4AHuKeWs/bm0ty6RMRlRVW8y1i2nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Lang Yu <Lang.Yu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 282/731] drm/amdgpu/umsch: declare umsch firmware
Date: Tue,  8 Apr 2025 12:42:59 +0200
Message-ID: <20250408104920.839040732@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit fe652becdbfccf265f4cea0eb379418d08c6596a ]

Needed to be properly picked up for the initrd, etc.

Fixes: 3488c79beafa ("drm/amdgpu: add initial support for UMSCH")
Reviewed-by: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Lang Yu <Lang.Yu@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c
index 2cfa2447d13e7..78319988b0545 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c
@@ -32,6 +32,8 @@
 #include "amdgpu_umsch_mm.h"
 #include "umsch_mm_v4_0.h"
 
+MODULE_FIRMWARE("amdgpu/umsch_mm_4_0_0.bin");
+
 int amdgpu_umsch_mm_submit_pkt(struct amdgpu_umsch_mm *umsch, void *pkt, int ndws)
 {
 	struct amdgpu_ring *ring = &umsch->ring;
-- 
2.39.5



