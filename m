Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4DEC13D;
	Thu, 30 Jan 2025 14:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245688; cv=none; b=StzqogZn1BGZ2VmIubOYOYxp9GrQHnBJOA2cnZcHBcB4Wt0EW4lq2v4RRxjWey744r4aAcNT2bF6AKh39Sd3bi/jOHLoVXPOfARwwFzDRh9Ux4EG5iCANkfjEnDp/Jb0kcHeyuFHTvBxfeINecqp0BTkk7PhqmpcpvzvoLU+qbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245688; c=relaxed/simple;
	bh=7HsMKcmPy0vVJ07WL435gTTxCT+ULREEDixvayDqNHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnPSIjuT5ZWClgRH8m/ztX7RUNkJz1aFppDjeKDWMrTcJfgsEHT3jlDAq7husUdnLDCYsrUGwjF6pWkLSbAflrvt/ENhKXk/ucbHeOe5okk/X/KMTStTcLOTBphxXzaz5TUGZCN15PzkiSmWpitsbQdCuUPg759Q6exDZPWsZdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wa5vm7NF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wa5vm7NF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BA2C4CED2;
	Thu, 30 Jan 2025 14:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245688;
	bh=7HsMKcmPy0vVJ07WL435gTTxCT+ULREEDixvayDqNHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wa5vm7NFbBOc+EVGL0K9hpW/SAUuQgNi0EH3xHgPvP4lHZO216w6w4UONlzHfSfu0
	 H95ajlEDIeRHSUEPENMsz0xISYMmXc4a+yWorMy2R8zQqj4LT7ASdErG0iy0vjlzlz
	 +YGSe9T+KYGXyMDjD/NK76fTfUmvG+A+gws2AKIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun peng Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 07/40] drm/amd/display: Use HW lock mgr for PSR1
Date: Thu, 30 Jan 2025 14:59:07 +0100
Message-ID: <20250130133500.006823327@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit b5c764d6ed556c4e81fbe3fd976da77ec450c08e ]

[Why]
Without the dmub hw lock, it may cause the lock timeout issue
while do modeset on PSR1 eDP panel.

[How]
Allow dmub hw lock for PSR1.

Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a2b5a9956269f4c1a09537177f18ab0229fe79f7)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
index bf636b28e3e16..5bb8b78bf250a 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
@@ -63,7 +63,8 @@ void dmub_hw_lock_mgr_inbox0_cmd(struct dc_dmub_srv *dmub_srv,
 
 bool should_use_dmub_lock(struct dc_link *link)
 {
-	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1)
+	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1 ||
+	    link->psr_settings.psr_version == DC_PSR_VERSION_1)
 		return true;
 
 	if (link->replay_settings.replay_feature_enabled)
-- 
2.39.5



