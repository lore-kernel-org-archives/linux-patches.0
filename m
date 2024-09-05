Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AF519885E;
	Thu,  5 Sep 2024 09:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529565; cv=none; b=Dx2AEt5bOzXQLe/zi0Z0n3dDy3WJ8CZW4rsEf0UY6K6lRv3zVHScTn0d8NJ+0+ZBGWgmaIfPJXvVk4vPtgkBGsPcg5VIs5WSW4t2dSMp2MEYkQq2zgWg/RbAf6TxoclRW3haCJBlOzUCB7sXeYN6SmptneLXgoXKT1wMCqZ5dew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529565; c=relaxed/simple;
	bh=DvXORbj3uTWFeXtTAQRzLO99Euf7kpToHR4yiXbnrV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D92CR1V8H/jFCtVB5Zn7DlRAGPPGeOdhhDuS8urrp1t2p9AThTT/iQEgxq19AYhZOgnwlmBfMNO211l1ugtzxS7H2bhVMZ/bkD4g5sqUN2HQRGLrPGOszsb9GTgwfFpCBj5sXo2QcxGq3Gn9gCB2HtWdiGnlc3+ZVa0jTDuWFL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBR6xAhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBR6xAhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69285C4CEC4;
	Thu,  5 Sep 2024 09:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529564;
	bh=DvXORbj3uTWFeXtTAQRzLO99Euf7kpToHR4yiXbnrV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBR6xAhSaqW7MkcIhf+BlGpJV9qYxa38Q+qJFixHJ6jb7p1dNu7QCwGXIU+00wRRM
	 2fdGq9w2vTKRMCZSc7vwW0RoN4ttEZniOb8L0/iPhBt+5pbTJ3iYH30y3lTpJ2pShu
	 5zap2CQ3MJq7YKrvvh0EqmpdmikXAvYL6o10bmXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 074/184] drm/amd/display: Fix Coverity INTEGER_OVERFLOW within decide_fallback_link_setting_max_bw_policy
Date: Thu,  5 Sep 2024 11:39:47 +0200
Message-ID: <20240905093735.131637979@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit 83c0c8361347cf43937348e8ca0a487679c003ae ]

[Why]
For addtion (uint8_t) variable + constant 1,
coverity generates message below:
Truncation due to cast operation on "cur_idx + 1" from
32 to 8 bits.

Then Coverity assume result is 32 bits value be saved into
8 bits variable. When result is used as index to access
array, Coverity suspects index invalid.

[How]
Change varaible type to uint32_t.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index d487dfcd219b..b26faed3bb20 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -534,7 +534,7 @@ static bool decide_fallback_link_setting_max_bw_policy(
 		struct dc_link_settings *cur,
 		enum link_training_result training_result)
 {
-	uint8_t cur_idx = 0, next_idx;
+	uint32_t cur_idx = 0, next_idx;
 	bool found = false;
 
 	if (training_result == LINK_TRAINING_ABORT)
-- 
2.43.0



