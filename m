Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA4C50E5A5;
	Thu, 17 Sep 2026 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667644; cv=none; b=Qe69clEHjGtCPxOkpBUucs5Umpuj7XnEg7CfbG02h4Pfenchu/UM+CRE8IzkkAnoGogKkjy9eGKE3oUP+TSZbCjbzYqJkJgN+o9v232cPDZkiRY6HkxouT3RrSFFtOdFejm7Oi4pHWuymRZQdmZeGW4q0d0Es/EJX2hT7LacKgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667644; c=relaxed/simple;
	bh=HKLHcJlOnKZPFhKvd4F0q/oOXjQpN6H44u4qphQsazI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EE71UpL/j43DOVPSnbKmhOSf0N0d8etpz+/E9J1gpj540kdeabfy4+ZsuY1phxL0zSbieLULskTMTllMjSJnGndWY6WL/LENNElb0YHYWTzi6C1vEuV1GUDZkpF/UiC1yFAnOtXNxD0DeN7JDtidL3ndFb65ZJGOQ5Kmn6i1V6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hytw73xO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hytw73xO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D521F000FF;
	Thu, 17 Sep 2026 17:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667643;
	bh=pTYtYCG4t0nJLq1HBV4sAIL7Ipf7unzW3V9zyhrixo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hytw73xO4V9yzd69iw/Nx80ZJwgC+Tp8+XFHKQttl0x22hOWyTMGG8zM38DddehjX
	 +PCHIDbx8zQsM1SOzftHCXSuXRC30JbQgtF/7TwdNNW8u3sAmf4JbahnzBQrqGhWJY
	 YuQNvpxgjCNE/Em7YiG2wEyQnyfaHmAhta1wBhWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0160/1102] drm/amd/display: Initialize dsc_caps to 0
Date: Thu, 17 Sep 2026 16:01:43 +0100
Message-ID: <20260917151543.552064392@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Lipski <ivan.lipski@amd.com>

[ Upstream commit d18ecfee5187e3b2dbff7e67dda8b2f54ff5231c ]

[Why&How]
If we don't do that we make DSC decisions based on random
inputs, which might result in disallowing DSC when the
monitor and HW support it.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 83f13c65c0a57..0222ede6a0bb4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6735,7 +6735,7 @@ create_stream_for_sink(struct drm_connector *connector,
 	int preferred_refresh = 0;
 	enum color_transfer_func tf = TRANSFER_FUNC_UNKNOWN;
 #if defined(CONFIG_DRM_AMD_DC_FP)
-	struct dsc_dec_dpcd_caps dsc_caps;
+	struct dsc_dec_dpcd_caps dsc_caps = {0};
 #endif
 	struct dc_link *link = NULL;
 	struct dc_sink *sink = NULL;
-- 
2.53.0



