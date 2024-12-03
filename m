Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA3C20010B;
	Tue,  3 Dec 2024 15:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238514; cv=none; b=boYbaHOTwTbQM76Kw/Eic/gaaqbyKLzWKX7VVTR7dRbOlCYxDA8lUz+LZi5OBkLRervmc4bm01SQK/ozcLtELDcKoUNX0+J21tkovtvq9okgh5dkLFHJRIJGxvz/Z0Xkx1/ecYV4lXSfSwRmoAzg+LBfhl72JcFyaNnKXAcWMN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238514; c=relaxed/simple;
	bh=LMIi8RIxaZ6PBpiq6Gr22lTSGnVcloixz7Op4BuJ2Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iu2pjNGgGJDAnF2HaOO+hYNHKjcoK6HpmbSD20QBmEDtoFHxQ5Mo7fnda58T599M2OK9/KRDAqHcVWxGfweD5e+Bg3e1ErKNgBRHs2d2tjWww41hehl7QOgHK1jowfT+0C3F+aff+UfLCvvTPUOO15NJgMCqulqQpthh65kjRTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7ygSgKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7ygSgKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E646C4CECF;
	Tue,  3 Dec 2024 15:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238514;
	bh=LMIi8RIxaZ6PBpiq6Gr22lTSGnVcloixz7Op4BuJ2Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7ygSgKoTsOJu3lIEG+q0wa83uPbSIjDUX+wGEmzbyUqhO1yd7V1cFHU/8HeehlEz
	 k4+9kn55/CPOsLideBOSdSIbDmQzlJWUdW3RBo6hHddPvRDzzfa8JcD+X6+Da517lZ
	 +x7peZcuuLPm4oamrClobQQh8JrftkeazatYzEJA=
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
Subject: [PATCH 6.11 302/817] drm/amd/display: Reduce HPD Detection Interval for IPS
Date: Tue,  3 Dec 2024 15:37:54 +0100
Message-ID: <20241203144007.605016471@linuxfoundation.org>
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
index 4593c158cc156..5ca9cdbac3d72 100644
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



