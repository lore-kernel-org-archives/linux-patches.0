Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2F23148B4;
	Wed, 21 Jan 2026 18:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020103; cv=none; b=na2uXdjW/LHmfxQpfna2Q8rcXHJT8qC7kfxOMMKwSGgVf6I2OcIoVLPOXd7r4SZIT+pfnJ/B405GU+JbCIY1G/f6JDIEkaSYh2zHF23RDp7zBjmbwUWKCdaS0SHjwgZl9nt8iAHW29DDW0+YPPnvpESplGvaDCPyaxxWKpnR77k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020103; c=relaxed/simple;
	bh=Q5vdc1jIZwKZ57+/aNSChjsH5KLOiCkfcmvCj7VcqHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUJcdMp5sPbs/5Hr9FOb1hP/NEPLcqUVprxRsX8IgCt769DW+hLxQpdJ4rTmXb6gucxtBhMpA+tYGJ7qDQE+SRNS7ptKybSUHJ0imGQDQHhOP2zelZBDJGTAJzraHGtEkIyehVE9enF5dXCB+6UJ7nPV/C/LIZQHgw5CdoBKYNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFt/QTA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFt/QTA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2144CC4CEF1;
	Wed, 21 Jan 2026 18:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020103;
	bh=Q5vdc1jIZwKZ57+/aNSChjsH5KLOiCkfcmvCj7VcqHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFt/QTA6GjOYIMb3ac2MIBujhvam5QIC2F6u8TsTx3jX6uOQGzd2yp7BduiyPYGf8
	 cNMUVBHWSCTmOQ99f92JmVsVcN3jcg6nAKzjGNEDO59HXeazGhaMi6A6mWC5ZX/HDZ
	 ZSkzTlLcANLNHpgxCGHSKqPuLTobW+esFnwyIrBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Matthew Stewart <matthew.stewart2@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/198] drm/amd/display: Show link name in PSR status message
Date: Wed, 21 Jan 2026 19:14:47 +0100
Message-ID: <20260121181420.678737291@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 0a1253ba5096f531eaaef40caa4c069da6ad48ae ]

[Why]
The PSR message was moved in commit 4321742c394e ("drm/amd/display:
Move PSR support message into amdgpu_dm"). This message however shows
for every single link without showing which link is which.  This can
send a confusing message to the user.

[How]
Add link name into the message.

Fixes: 4321742c394e ("drm/amd/display: Move PSR support message into amdgpu_dm")
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Matthew Stewart <matthew.stewart2@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 99f77f6229c0766b980ae05affcf9f742d97de6a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 7fe40bbba2658..f4381d44864f1 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5545,7 +5545,8 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 
 				if (psr_feature_enabled) {
 					amdgpu_dm_set_psr_caps(link);
-					drm_info(adev_to_drm(adev), "PSR support %d, DC PSR ver %d, sink PSR ver %d DPCD caps 0x%x su_y_granularity %d\n",
+					drm_info(adev_to_drm(adev), "%s: PSR support %d, DC PSR ver %d, sink PSR ver %d DPCD caps 0x%x su_y_granularity %d\n",
+						 aconnector->base.name,
 						 link->psr_settings.psr_feature_enabled,
 						 link->psr_settings.psr_version,
 						 link->dpcd_caps.psr_info.psr_version,
-- 
2.51.0



