Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD74B379ED5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301745; cv=none; b=VjHdY2462L9vsRo1gQVz31sTjFATCbDhXPLjniCNfRW5VCimyLO6m/dCQvAB6v4BjRWsat/20It0UxdUmAiUkD12z6TzqUN7xtJaXtK1dYslGovU6Af4bRQ1JY+I1ruvFp/mk4Fb8wXu1Z+7RLBmDe82UEobzBqhy2kAVyQ9Kx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301745; c=relaxed/simple;
	bh=x7k892ZyynL1qy6EwE9A8dV/2arEG7Ulw6qJsQeafoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enrMwPn9mjJcF0RViQEBhuUll4TIWdgtTA73gnFJXQN19GG1iYJz9oyvlSyi+OUw9isnI6c/c8YEl7L87se4aLyiuExSFqb44HRqG/4gBo5w+tAuutEGgcPljfWL9OidkjamPAEoEg17zkJ1MAV8RZvjb5c4MILIGdW7/LUNmY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GbnBrFS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GbnBrFS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DC4C116D0;
	Sat, 28 Feb 2026 18:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301745;
	bh=x7k892ZyynL1qy6EwE9A8dV/2arEG7Ulw6qJsQeafoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbnBrFS7qsv4WzJCjj+d7JNvJptuOF+730mzyaqsq0v3gl2N3Wu9EjRGsNl3aGKDp
	 gvlTaNIE5l1J07GJjYxixk+CrUtozRXoyKmf0jvLWQunWdtacBwv1cJ9e92gV2Ofty
	 Qt2PEzvwJA1MxNBir8nc/dNkCGTp4Vfq4M/uYi0m6dej0zTSf2cWu+feQkr2YlcGl6
	 Ok6oceqMWyM79QIntOq1jcO8tcsD3RNqfmKnU2j+sLRD+TqjbzzMy5NK7oTmcpsfNH
	 IDiaQPV87sYPkMIsmw5P8gnWurjz2w9L/ykleujQ1zmlAC9NMKFFsbd9rkfKMDRl00
	 w/1smTOthLAUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/385] drm/amd: Drop "amdgpu kernel modesetting enabled" message
Date: Sat, 28 Feb 2026 12:56:10 -0500
Message-ID: <20260228180011.1568201-148-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Mario Limonciello (AMD)" <superm1@kernel.org>

[ Upstream commit 8644084a74a4573278d6f454c6638ccd5965f4e2 ]

The behavior for amdgpu was changed with commit e00e5c223878
("drm/amdgpu: adjust drm_firmware_drivers_only() handling") to
potentially allow loading even if nomodeset was set, so the
message is no longer accurate.

Just drop it to avoid confusion.

Fixes: e00e5c223878 ("drm/amdgpu: adjust drm_firmware_drivers_only() handling")
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 48de2f088a3b9..bf706ee2e0ed3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -3081,7 +3081,6 @@ static int __init amdgpu_init(void)
 	if (r)
 		goto error_fence;
 
-	DRM_INFO("amdgpu kernel modesetting enabled.\n");
 	amdgpu_register_atpx_handler();
 	amdgpu_acpi_detect();
 
-- 
2.51.0

