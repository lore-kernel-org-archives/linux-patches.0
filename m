Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17302E62C;
	Mon,  8 Apr 2024 13:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581826; cv=none; b=rj5q4mCrnvbpiaVrrvQgCJLcWQSzoN/7J0o1cBZI/7ghoO1Q0Dg1Kn4FG208vEK39AM0bFzDvDADNuyQAajVCnlilrNh5+r9vyU4ArjomJdRH9YnBcpxkERyAnFI2C7lalZih4+ZYtuSnVViziHYa8IaY3ZTwE+F/AiEgQmZhzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581826; c=relaxed/simple;
	bh=Vnq88HixqJZmyYkPb5nnxPhz4D98spFR6TtLcFgBNgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHGoBTgJl7g95DWcF1Z5StHazLrrSaak2X7et/QTpgdI6OTcI8tiRQqvpsvwSEGc3jn490equIZV1qhu7k1J0WELYqpIy+yaM/Yt2mHVAQHOZVBzBoxY05ayweEnvURMeEqmLiP+8VyPhwt54oxCqdiOSLsTA8iC86cwno86Xh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxXiqdl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxXiqdl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DBBC433F1;
	Mon,  8 Apr 2024 13:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581826;
	bh=Vnq88HixqJZmyYkPb5nnxPhz4D98spFR6TtLcFgBNgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxXiqdl+tRSMdjiiijzOJWejGSJHN35XhDj1XxcOyP3uEBf749hNJT/B/FAxLjFLb
	 TwUdp+n6XMr5KLQ0mGbAuiK9Czg0v/FBLusaBijIKEukAcR72SqA4Y/+94bgY/Z16A
	 DZz4geH3YK90+0AhvuRvWGvpVcQrU75LeWFScr9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 023/273] drm/xe/device: fix XE_MAX_GT_PER_TILE check
Date: Mon,  8 Apr 2024 14:54:58 +0200
Message-ID: <20240408125310.013030177@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 23e1ee3a2317f41f47d4f7255257431c5f8d1c2c ]

Here XE_MAX_GT_PER_TILE is the total, therefore the gt index should
always be less than.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240318180532.57522-5-matthew.auld@intel.com
(cherry picked from commit a5ef563b1d676548a4c5016540833ff970230964)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_device.h b/drivers/gpu/drm/xe/xe_device.h
index 08d8b72c77319..ee8be4c6b59b1 100644
--- a/drivers/gpu/drm/xe/xe_device.h
+++ b/drivers/gpu/drm/xe/xe_device.h
@@ -58,7 +58,7 @@ static inline struct xe_tile *xe_device_get_root_tile(struct xe_device *xe)
 
 static inline struct xe_gt *xe_tile_get_gt(struct xe_tile *tile, u8 gt_id)
 {
-	if (drm_WARN_ON(&tile_to_xe(tile)->drm, gt_id > XE_MAX_GT_PER_TILE))
+	if (drm_WARN_ON(&tile_to_xe(tile)->drm, gt_id >= XE_MAX_GT_PER_TILE))
 		gt_id = 0;
 
 	return gt_id ? tile->media_gt : tile->primary_gt;
-- 
2.43.0



