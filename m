Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A0D1A6192;
	Tue, 30 Jul 2024 16:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357624; cv=none; b=oX8203CmmEKiKSFj04n+Gn9DVfABqRgTyRQDNFsyWpBuDsrYYwkz788QG7y1MOzYsIN+VLtXuELLHFpDrVdF659Kiff7+fjqWKQorj2CWVgFB5PVZrGtGaB+va9l2mxqt1WPX35NfHYGGl7mhVL+cbcreCcnNRxvRXSzepOg5gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357624; c=relaxed/simple;
	bh=2o4JDjY15iMI2kGkvR5CeuLdlswqkU32uCd3RNHK+fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWy6mzDVwb9PisK41cmPZQc2FUcMHKg4LEXEDsIpL273TLJT0FaVyET3eQ9q0WJARJ5Sf5oNXX9EHdLWzQBBgjMK46UtLC1bROXs1/pUy3LP5ItXpy3WRKhJUO142suwzbPRGqi7idXAMLz4g05jkEmnczMxWvhzEZa8QJZnH8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBCacuHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBCacuHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08ACFC32782;
	Tue, 30 Jul 2024 16:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357624;
	bh=2o4JDjY15iMI2kGkvR5CeuLdlswqkU32uCd3RNHK+fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBCacuHhBFMBao67h307tK9kXMre8gwrMXZhr0fYs2hLhX9KV0c9ZdPikSk7tiS/K
	 Eg4DSwGUdAQ3JuYjxgJyaO01Iuf/USM+HywYUIjDSxfB3kMY+bQoZu7p1y+hCLH4f8
	 G2HKqq5EY5n1wWjFA+Ej149irPHn7ZMsepGToFDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 273/809] drm/amd/pm: Fix aldebaran pcie speed reporting
Date: Tue, 30 Jul 2024 17:42:29 +0200
Message-ID: <20240730151735.374959955@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index a8d34adc7d3f1..b63ad9cb24bfd 100644
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
 
 #define ENABLE_IMU_ARG_GFXOFF_ENABLE		1
 
-- 
2.43.0



