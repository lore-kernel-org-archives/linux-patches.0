Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF8C198E78;
	Thu, 15 Aug 2024 13:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729387; cv=none; b=slzu2znZbu8cBZnCV9RStRMcQ8CQc6FS8cyEI3TkHUWdb7VmsviwKS14vx0MgLZ7qI/tFfxDLm1NxbWkQ5KxgcBbtWGRfVonxxdZVvzR97AlAWnUc/arI8L3o0v2HHvK0ex19B0SNjdU94xMC09uRibQ9SAqn47LrkX91RwEIeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729387; c=relaxed/simple;
	bh=wDUy2JQKJ0cG3z9wVCk7eR7E6PG0FRnNshMKDmmbQ+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBglo5kZLxBXYPxqeB+L4TS9wvIms1j3YEaElVom3VdPx7QuhL83tBDj8ppmaHc9zaE0wwYc79jTVtpk5FFMfXjlX1HriGahepH8xnSJJ/geUWFotg65+c5VyltIlfuDmf87vkM45Bx+ZiYroH72JusBbE/bBCtm+tj6CBC/g9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EW5YJQSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EW5YJQSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EE5C32786;
	Thu, 15 Aug 2024 13:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729386;
	bh=wDUy2JQKJ0cG3z9wVCk7eR7E6PG0FRnNshMKDmmbQ+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EW5YJQSo6hBdJGleBrLcMV61ic15GsgMLtdWfXp/tmdo0ZGbZAQT+Ugr9meco+Q7+
	 tEGndZ5j2waeh4jIZ9dWdJpfBlC6yaYeNqmUwlX2JbIONncmBHCve0rC7fWf6ik7vC
	 oF6VP3Jw1zPxH/4XSTWW2DJE2SlPX+0I000MUUZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/484] drm/amd/pm: Fix aldebaran pcie speed reporting
Date: Thu, 15 Aug 2024 15:18:59 +0200
Message-ID: <20240815131944.412590235@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a3723ba359231..7671a8b3c195a 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -69,8 +69,8 @@ MODULE_FIRMWARE("amdgpu/aldebaran_smc.bin");
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



