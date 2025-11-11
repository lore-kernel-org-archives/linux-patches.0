Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658272AE8D;
	Tue, 11 Nov 2025 00:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822318; cv=none; b=vCEzvKtkuJsY7DqAaNSTv1FXcm6D5JLimY4pcrdBaj5VyjD4C2gLm9e02ORgsj3RgIUP+d4ZJeANPkcWzS4bWklHvxXstA5mtWTseyJRISzVOTsGIRQgYI6PWFKsqLJThzIi16hNrwl+loJvzP330pUX7M5RPoAHM1dxcVkebX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822318; c=relaxed/simple;
	bh=vwyehnNZUn1OZj+58BBZBSsVJtCJGA5NDZmqH9Wdg6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlawIvZRiUdqYntndGDb2LPIdnKfxMiINV+UyPP4k61DwuTCfv67hdUokOdhm0EdN1Vy4WWNedqEL1HdOAxxuBhEXoeUYZdkMdyFLsdG/mBjMhWeITdHS1J4xhVgTGA5Nv1mUATUET8O+45bVehK9yEYn2q+CB8XCpWm+Hq35UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VH2ayWiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VH2ayWiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2732C113D0;
	Tue, 11 Nov 2025 00:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822317;
	bh=vwyehnNZUn1OZj+58BBZBSsVJtCJGA5NDZmqH9Wdg6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VH2ayWiXXxAIy2LsKrDVoHYUATZfcxfvQ5MLjAqb9RxgNi2ShjYQe90Esag2FwZho
	 +ESlBIdbmyTi4XNWA9pGdRmmEc2ZvAq+yZA1zGDaNGOmf1yNN6QQUouuce3m8hZBlX
	 FZFPAeI0lQpbPf+aJ2SxvbDyKG82L+qxIC0KUBY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 084/849] drm/amdgpu: fix SPDX headers on amdgpu_cper.c/h
Date: Tue, 11 Nov 2025 09:34:14 +0900
Message-ID: <20251111004538.451341242@linuxfoundation.org>
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

[ Upstream commit f3b37ebf2c94e3a3d7bbf5e3788ad86cf30fc7be ]

These should be MIT.  The driver in general is MIT and
the license text at the top of the files is MIT so fix
it.

Fixes: 92d5d2a09de1 ("drm/amdgpu: Introduce funcs for populating CPER")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4654
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit abd3f876404cafb107cb34bacb74706bfee11cbe)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
index 25252231a68a9..48a8aa1044b15 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: MIT
 /*
  * Copyright 2025 Advanced Micro Devices, Inc.
  *
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.h
index bcb97d245673b..353421807387e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: MIT */
 /*
  * Copyright 2025 Advanced Micro Devices, Inc.
  *
-- 
2.51.0



