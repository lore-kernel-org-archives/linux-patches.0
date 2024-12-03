Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF762C80;
	Tue,  3 Dec 2024 15:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240952; cv=none; b=oETEUUCpsRynLt1HuBE2ZMrKy5QJmiNat+8ay0SnWc6vHGmRJnMXcl3kk8uNs5y/xVZ/atR1QXunj+KraseMQdbzcGvhD4ROhJvoo7qvfxOXMMlVwtEYPMofPVm7EA+1N9WkIFFNGyg6dvEvTwsQE0ZahpiCtzK6CtbUKl6YWuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240952; c=relaxed/simple;
	bh=rxzI2t4FRiulTdKUS+x/RxzxieKiguvxUpidtdyE+Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9cparLp3h5845EQYfLm/C9IjUtpQrzLKVu2IWHr+Ae5hxu4fDLVYRQmYz4gbbR3jD032O6THTf3gbEuXd2JgQjDn5nH/ZG55UpZm7ie136UoSsSXoXylpCEfUzUG++tP8bbJtiizYrt4CQENCrz8aMDB20+SnHk9yCKWEBxMEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6ZIFG/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6ZIFG/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD28C4CECF;
	Tue,  3 Dec 2024 15:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240952;
	bh=rxzI2t4FRiulTdKUS+x/RxzxieKiguvxUpidtdyE+Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6ZIFG/cHSHT3KXqF5EABSYDWFDk5BcrwaOKNx3BR9la/RREG/wHYl0ery4GCUtmU
	 r7hWhRuJ/UhPNDsHqR3rR+Br8Z7dn0BkGOaEGpEWcnQDiBW3qoOb/ubqwVNq/CNVEE
	 9bV7YbxYKJthAECiGga3X+EPaZG21/k2Oz+jtMEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 284/826] drm/amd/display: Reduce HPD Detection Interval for IPS
Date: Tue,  3 Dec 2024 15:40:11 +0100
Message-ID: <20241203144754.848411040@linuxfoundation.org>
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

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit a88b19b13fb41a3fa03ec67b5f57cc267fbfb160 ]

Fix DP Compliance test 4.2.1.3, 4.2.2.8, 4.3.1.12, 4.3.1.13
when IPS enabled.

Original HPD detection interval is set to 5s which violates DP
compliance.
Reduce the interval parameter, such that link training can be
finished within 5 seconds.

Fixes: afca033f10d3 ("drm/amd/display: Add periodic detection for IPS")
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 8780d4737680f..9be87b5325173 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -35,7 +35,7 @@
 #include "amdgpu_dm_trace.h"
 #include "amdgpu_dm_debugfs.h"
 
-#define HPD_DETECTION_PERIOD_uS 5000000
+#define HPD_DETECTION_PERIOD_uS 2000000
 #define HPD_DETECTION_TIME_uS 100000
 
 void amdgpu_dm_crtc_handle_vblank(struct amdgpu_crtc *acrtc)
-- 
2.43.0



