Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E792E1BA294;
	Tue, 27 Aug 2024 14:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770457; cv=none; b=lvjhDvkZroWD6m5MTyKHO/GT5Nn8KrX5txmd7PL0yuF/rgo8/9/bAq8CwbuUs6/xnUl489UzVrbOUzoUoiZkBwO6MUgkSMJf8DyeN2GQK93MtSo+0j+Gz+mMNJBCSEKvZqwoTXLXm4DFnjhM/gsf5l2/MNA3cBxdP1shi3Kf3Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770457; c=relaxed/simple;
	bh=Q+/4+n5I758kDMiOU1iYcvRBUgYAMXun2m1vfGNmFac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uv3kbE1uYj8k14cDOGMgCuhPjZz9YyucLH9tqMmynYO2dhTAqFy8b15aIeGgv3g9ASFci6AJ3TCu/Dx/1OrCY0Kp4vPcH0qQV7rtu87KUFSztmpcWe45mBsJLGRizy1/yteccoZU5IQnGbPQRhnORDF2w5RAUAtNdf7E85DHFTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEQl62g8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEQl62g8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E043C6106F;
	Tue, 27 Aug 2024 14:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770456;
	bh=Q+/4+n5I758kDMiOU1iYcvRBUgYAMXun2m1vfGNmFac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEQl62g8r7oX161rJWSwYtmymqfxcAV8okWDSyruyZ36yAZJDcd18XpHTAWR786Hm
	 UfDgf6M5F0OYjD9BU00iI/wTUoarO256WvVqqf8AJ89KWKdopdnW14E8RdrNmVRPui
	 P8T8jlAUS5XXD/eleNBsUHW7ZaeJZbnmS68z7uDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Loan Chen <lo-an.chen@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 235/341] drm/amd/display: Enable otg synchronization logic for DCN321
Date: Tue, 27 Aug 2024 16:37:46 +0200
Message-ID: <20240827143852.351758978@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Loan Chen <lo-an.chen@amd.com>

[ Upstream commit 0dbb81d44108a2a1004e5b485ef3fca5bc078424 ]

[Why]
Tiled display cannot synchronize properly after S3.
The fix for commit 5f0c74915815 ("drm/amd/display: Fix for otg
synchronization logic") is not enable in DCN321, which causes
the otg is excluded from synchronization.

[How]
Enable otg synchronization logic in dcn321.

Fixes: 5f0c74915815 ("drm/amd/display: Fix for otg synchronization logic")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Loan Chen <lo-an.chen@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d6ed53712f583423db61fbb802606759e023bf7b)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
index 8d73cceb485bf..aa4c64eec7b3d 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
@@ -1756,6 +1756,9 @@ static bool dcn321_resource_construct(
 	dc->caps.color.mpc.ogam_rom_caps.hlg = 0;
 	dc->caps.color.mpc.ocsc = 1;
 
+	/* Use pipe context based otg sync logic */
+	dc->config.use_pipe_ctx_sync_logic = true;
+
 	dc->config.dc_mode_clk_limit_support = true;
 	/* read VBIOS LTTPR caps */
 	{
-- 
2.43.0



