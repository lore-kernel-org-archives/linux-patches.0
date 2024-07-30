Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA02A184535;
	Tue, 30 Jul 2024 16:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355796; cv=none; b=qzuyzoyJRb3tJqZHHobq6UbNVvlwCG1Qer+Y41Yq06fhz1Gnv1VaJzsN/8Y395C37RnuEx7ND1sB1dNrXy95yvfv+kKpYjCHWgDGhrXUyZvvx86qP9Af6laZ1UlJ1yajk3BtD3pWJz5nuX8z3eiWTzD4ivO2V3PsQB0iQUUFEuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355796; c=relaxed/simple;
	bh=dWYseY3WNzkrECzNEgextxUc/U7+6pUvSdF7Ar6hpSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7j9WhOnpL9hIQKmrQAbepmCR0LUvZ9kfXK5I6LQkfkI0wnDfPIBHT2aCZbuzyoKtZjXNY37OPszjpZevAdPvLge5Oz4ze+yCw0ATKRoFKfD68mAvBUgtVLTlJ2KmU/F5EyRoXHYlw25bdsvWjN2ELAB/codSok4ZevgXiJ/oko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GgJDIHWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GgJDIHWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCB7C32782;
	Tue, 30 Jul 2024 16:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355796;
	bh=dWYseY3WNzkrECzNEgextxUc/U7+6pUvSdF7Ar6hpSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgJDIHWCRb09/+GNTeRGELETMiQzrUoSac5Wgrs4yAR/NQcr+TCUQM6AyO8LPIBqv
	 ahUbiYUlSvFuJUQH5lGesh+8+lM1kgGhRWnNk4GiDIkVlFRd9/ATYmyKiem3/9Y9Je
	 w21O6LzmlK/Woy9VdhMofqp/Uqj/QB1mI0N6lgIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/440] drm/amd/pm: Fix aldebaran pcie speed reporting
Date: Tue, 30 Jul 2024 17:46:04 +0200
Message-ID: <20240730151620.998755282@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f3257cf4b06f2..3aab1caed2ac7 100644
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
 static const int link_speed[] = {25, 50, 80, 160};
-- 
2.43.0



