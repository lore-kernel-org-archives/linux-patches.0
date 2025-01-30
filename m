Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626671E9B1A;
	Thu, 30 Jan 2025 14:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246514; cv=none; b=OVF4z0fqLtpxuTU9F5WRHh9ipiyeTc5zx8p+Gule1OvAus0tEOxSodA1TmP6uL8d5duk4DcbRoUflS6QUs7GLUqdN9ZXwjsxu+9kwqPnGOxOdwR0HJ/Wp0x3T79YupfKXaWMLe3tinXRaSm5smAmn+F8Lrumb+LhgwObuX4UhnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246514; c=relaxed/simple;
	bh=PC/nooqNg5MrnQQKHf0Ts58jsCcs4rRVwfObVOgJSas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiTwS0j+Ba+ZxhUlZ7ULxFcpmw1Ke5NRAaBSCOHwnshpHQADaM1OFQLkKDadV4Pjgbnq7R/K7Gj7oWxFZojtShca46yMkNzUhENsXzMnzGJ90PE4UHghhVr5pVZ+vToRjl23f3ypazL93KaPELGRaYIMxmSHRkFGg0UHEITE4cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDulm+BW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDulm+BW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC26C4CED2;
	Thu, 30 Jan 2025 14:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246513;
	bh=PC/nooqNg5MrnQQKHf0Ts58jsCcs4rRVwfObVOgJSas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDulm+BWvhDedHcLn2oAF8sNdjlcgkBurF3AuxmCJo1QJHR4zBn0lcuW8tZ6yCxsP
	 H2eaXbfccchWeocDGcFMfVS0DPB7hX60iRqRH0VcRclhrnBFNZlJsi6a/cnfIX43BR
	 qajTbgeimE5g6H49Dkuz6h+ac2iWPER37BiyEM6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun peng Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 05/43] drm/amd/display: Use HW lock mgr for PSR1
Date: Thu, 30 Jan 2025 14:59:12 +0100
Message-ID: <20250130133459.118244786@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2aa0e01a6891b..f11b071a896f5 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
@@ -63,7 +63,8 @@ void dmub_hw_lock_mgr_inbox0_cmd(struct dc_dmub_srv *dmub_srv,
 
 bool should_use_dmub_lock(struct dc_link *link)
 {
-	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1)
+	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1 ||
+	    link->psr_settings.psr_version == DC_PSR_VERSION_1)
 		return true;
 	return false;
 }
-- 
2.39.5



