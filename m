Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49502C80;
	Tue,  3 Dec 2024 15:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240949; cv=none; b=hQcj+klTds3ADAUrE41XXSVUheSIO+55hM6lEyMFs4oS0X8NfoClUcOipUcUKW8v5sY/qcWUIz94v3bmWCvVhH7t5rfvL+ZuV2jFS1VCyH15fT8oFUr05KjPvH8DcoDzrhfjMhypZ0ibpd+Y4/1NsoRx9tYUsOO7LTKRxo45C3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240949; c=relaxed/simple;
	bh=bBEprhbZ5aQH0zu48Y1hjo6xWqJOQNWXo+0EQDnxv9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8gTV699/+lEeVqVqGBq+FdxtKTAAeCEYSzahDeLDJfo4Ax+WiC5uOcQ6Bq8j3WIsIsZi/5v2h8JKz9CHbRiUdoFOHwiDca/DFPnKzmWUpEoVFLgVtxZyXJz9DG6idTEm5DOo1Ca5kPMdlLQ00jlcUZVOiWXeKqYiIhDDlVn6bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzmXXNBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzmXXNBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6E5C4CECF;
	Tue,  3 Dec 2024 15:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240948;
	bh=bBEprhbZ5aQH0zu48Y1hjo6xWqJOQNWXo+0EQDnxv9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzmXXNBk60QecRoNX7VpxAfDZX3cVbORbZxP5QjlCyKhnxak8US8CKspJWGWIZH1K
	 hKD+M9HLSgpYxHum8jun2gq4SeaDueIykj/bM34Oyli9yFZgqgawq06ajvz0VsGPuO
	 wWfxqh0DREjmYQbFcGekb74AFiA/gbUwx8S6wAGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun peng Li <sunpeng.li@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 283/826] drm/amd/display: Increase idle worker HPD detection time
Date: Tue,  3 Dec 2024 15:40:10 +0100
Message-ID: <20241203144754.810008789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit 60612f75992d96955fb7154468c58d5d168cf1ab ]

[Why]
Idle worker thread waits HPD_DETECTION_TIME for HPD processing complete.
Some displays require longer time for that.

[How]
Increase HPD_DETECTION_TIME to 100ms.

Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: a88b19b13fb4 ("drm/amd/display: Reduce HPD Detection Interval for IPS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 288be19db7c1b..8780d4737680f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -36,7 +36,7 @@
 #include "amdgpu_dm_debugfs.h"
 
 #define HPD_DETECTION_PERIOD_uS 5000000
-#define HPD_DETECTION_TIME_uS 1000
+#define HPD_DETECTION_TIME_uS 100000
 
 void amdgpu_dm_crtc_handle_vblank(struct amdgpu_crtc *acrtc)
 {
-- 
2.43.0



