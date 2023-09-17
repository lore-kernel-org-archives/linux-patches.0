Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83247469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06E7C43397;
	Sun, 17 Sep 2023 20:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982143;
	bh=bnPhu/E1S9t3/vmZK68WxF1oJzF0VwS1AWSkNBn5P9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F24HABknbVb4cA6T2TRbC2R7YKhYEykVQCa+yGqnM+sggM+WP7trNZCbmLyPYCu0B
	 4A1U6xIyG2G1PiglE7i99eu1OUYhxZs2pTJmw0OcibobjcBR1AhzIxLqBYrJZz8LTl
	 1npLO4E57iUL40+OGiqevuMYTrZNdrnqHppXzcFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Ryan McCann <quic_rmccann@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/511] drm/msm: Update dev core dump to not print backwards
Date: Sun, 17 Sep 2023 21:09:52 +0200
Message-ID: <20230917191117.827665373@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan McCann <quic_rmccann@quicinc.com>

[ Upstream commit 903705111d863ed8ccf73465da77d232fc422ec1 ]

Device core dump add block method adds hardware blocks to dumping queue
with stack behavior which causes the hardware blocks to be printed in
reverse order. Change the addition to dumping queue data structure
from "list_add" to "list_add_tail" for FIFO queue behavior.

Fixes: 98659487b845 ("drm/msm: add support to take dpu snapshot")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Ryan McCann <quic_rmccann@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/546200/
Link: https://lore.kernel.org/r/20230622-devcoredump_patch-v5-1-67e8b66c4723@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c b/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
index 369e57f73a470..8746ceae8fca9 100644
--- a/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
+++ b/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
@@ -185,5 +185,5 @@ void msm_disp_snapshot_add_block(struct msm_disp_state *disp_state, u32 len,
 	new_blk->base_addr = base_addr;
 
 	msm_disp_state_dump_regs(&new_blk->state, new_blk->size, base_addr);
-	list_add(&new_blk->node, &disp_state->blocks);
+	list_add_tail(&new_blk->node, &disp_state->blocks);
 }
-- 
2.40.1



