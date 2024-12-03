Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C244A1F8924;
	Tue,  3 Dec 2024 15:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238511; cv=none; b=mdhf/G+ZSRMmPRHzoRA79cRvLpSkq8fatPzcAmQ1RNuzziTNFqEJj5B5oXq6vRM/6/Cnav0FnsAk2j3YOBh1itHWQDlx0fXFVcn0HbfbYYD94P0xPOC4KImspt87IuJLkYTctP4QGESB8eqDn5ct6hAgndrb+OvMt5u+iqaQ7XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238511; c=relaxed/simple;
	bh=Cxg1T9H+esJn7zb7CUzvcgJLlYwMrsIzbjhBelhao0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezn2Vp/AAFYQpDFtsCmzCgK8y2FICSJZyqQf642KHM2Nz1bKCt7RVbhUOYsxYfyIjREA5p2w9vf2FD3fC8vo0P/Zlr2TrgwOD5lDHdU6oVb306GIniJcb0ADZz65oHTGo+fgnGcZNseoqRjuM9zOijuUNc9AkhMhgClCy48/enw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhzvkECR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhzvkECR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E0DC4CECF;
	Tue,  3 Dec 2024 15:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238511;
	bh=Cxg1T9H+esJn7zb7CUzvcgJLlYwMrsIzbjhBelhao0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhzvkECRTMPUFGZiUh7S7lDMKouGFNm9g/+P/9KoVpRqgQp5QEvXFsTpR5ojMKe2y
	 dAR/ZCGCvfk5vsCDGAia4hlYPy1HePEGCCCQNrUOh6hz1U6mPtNChPbTxbxfe8WLK5
	 QgiYaUtk5bB5UekCV1BTvcLfCCvNiCN60RstKucc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun peng Li <sunpeng.li@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 301/817] drm/amd/display: Increase idle worker HPD detection time
Date: Tue,  3 Dec 2024 15:37:53 +0100
Message-ID: <20241203144007.566044282@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index df3d124c4d7a1..4593c158cc156 100644
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



