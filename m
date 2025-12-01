Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEB6257842;
	Mon,  1 Dec 2025 11:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588569; cv=none; b=Rl58OxKF2ok/vsYUdBjHbB7sAA7notk+oeN3AnpGw3jHNt1kk9oqnRJKlF7yeuB52BVDq/Z3srEv5RYIvmEm6lZAie0+ZiRGb0XOYfxI+3YnqMZtZEsaNHkozcEURgVILc63dHxRepQ8y/MEMflFNVU/PQkJMBsJjgfV1jv5Qvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588569; c=relaxed/simple;
	bh=Hkf9a206IFMbfDf8jdFC/JvXfQS3C4SF9rnrDgcqweM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lo2vWvv/FUfJlldb/AP/XpPZJFU8bVpXWJ4aXP/E7zGMPJybKxb92iefKr3RSHTsEG/Sh2zSLeXR2Bm6z6B3YkgEuizSXaW7tpz1bPi1s1AJCLh3NZD5Gp6Hj15z67Py1mfUO9uO5Z7m87K44iHMMK64XGt11ZgZrcOLk0dsM/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzNxNQB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzNxNQB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1ECC113D0;
	Mon,  1 Dec 2025 11:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588569;
	bh=Hkf9a206IFMbfDf8jdFC/JvXfQS3C4SF9rnrDgcqweM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzNxNQB8s3g3Ql4BuACCRmdbUMuqSHZNKkMkTMrMc3HRrBdPDLI/Hcq67lz8/0RAw
	 A2R5Sy09vpYzaW1CLGXKSm59v37dWA53KPsNyPVzGGa4g5MYCeyHaAuhRb6/EG1j3F
	 TVXBpBDU5qJb4sQb+PRPuyl/yMF5V6/3C1f/0nDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Brahmajit Das <listout@listout.xyz>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/187] net: intel: fm10k: Fix parameter idx set but not used
Date: Mon,  1 Dec 2025 12:23:23 +0100
Message-ID: <20251201112244.673536231@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brahmajit Das <listout@listout.xyz>

[ Upstream commit 99e9c5ffbbee0f258a1da4eadf602b943f8c8300 ]

Variable idx is set in the loop, but is never used resulting in dead
code. Building with GCC 16, which enables
-Werror=unused-but-set-parameter= by default results in build error.
This patch removes the idx parameter, since all the callers of the
fm10k_unbind_hw_stats_q as 0 as idx anyways.

Suggested-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Brahmajit Das <listout@listout.xyz>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/fm10k/fm10k_common.c | 5 ++---
 drivers/net/ethernet/intel/fm10k/fm10k_common.h | 2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c     | 2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_vf.c     | 2 +-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_common.c b/drivers/net/ethernet/intel/fm10k/fm10k_common.c
index f51a63fca513e..1f919a50c7653 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_common.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_common.c
@@ -447,17 +447,16 @@ void fm10k_update_hw_stats_q(struct fm10k_hw *hw, struct fm10k_hw_stats_q *q,
 /**
  *  fm10k_unbind_hw_stats_q - Unbind the queue counters from their queues
  *  @q: pointer to the ring of hardware statistics queue
- *  @idx: index pointing to the start of the ring iteration
  *  @count: number of queues to iterate over
  *
  *  Function invalidates the index values for the queues so any updates that
  *  may have happened are ignored and the base for the queue stats is reset.
  **/
-void fm10k_unbind_hw_stats_q(struct fm10k_hw_stats_q *q, u32 idx, u32 count)
+void fm10k_unbind_hw_stats_q(struct fm10k_hw_stats_q *q, u32 count)
 {
 	u32 i;
 
-	for (i = 0; i < count; i++, idx++, q++) {
+	for (i = 0; i < count; i++, q++) {
 		q->rx_stats_idx = 0;
 		q->tx_stats_idx = 0;
 	}
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_common.h b/drivers/net/ethernet/intel/fm10k/fm10k_common.h
index 4c48fb73b3e78..13fca6a91a01b 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_common.h
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_common.h
@@ -43,6 +43,6 @@ u32 fm10k_read_hw_stats_32b(struct fm10k_hw *hw, u32 addr,
 void fm10k_update_hw_stats_q(struct fm10k_hw *hw, struct fm10k_hw_stats_q *q,
 			     u32 idx, u32 count);
 #define fm10k_unbind_hw_stats_32b(s) ((s)->base_h = 0)
-void fm10k_unbind_hw_stats_q(struct fm10k_hw_stats_q *q, u32 idx, u32 count);
+void fm10k_unbind_hw_stats_q(struct fm10k_hw_stats_q *q, u32 count);
 s32 fm10k_get_host_state_generic(struct fm10k_hw *hw, bool *host_ready);
 #endif /* _FM10K_COMMON_H_ */
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
index be07bfdb0bb4a..40c5bdb3ac2c1 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
@@ -1509,7 +1509,7 @@ static void fm10k_rebind_hw_stats_pf(struct fm10k_hw *hw,
 	fm10k_unbind_hw_stats_32b(&stats->nodesc_drop);
 
 	/* Unbind Queue Statistics */
-	fm10k_unbind_hw_stats_q(stats->q, 0, hw->mac.max_queues);
+	fm10k_unbind_hw_stats_q(stats->q, hw->mac.max_queues);
 
 	/* Reinitialize bases for all stats */
 	fm10k_update_hw_stats_pf(hw, stats);
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_vf.c b/drivers/net/ethernet/intel/fm10k/fm10k_vf.c
index dc8ccd378ec92..6a3aebd56e6c4 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_vf.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_vf.c
@@ -465,7 +465,7 @@ static void fm10k_rebind_hw_stats_vf(struct fm10k_hw *hw,
 				     struct fm10k_hw_stats *stats)
 {
 	/* Unbind Queue Statistics */
-	fm10k_unbind_hw_stats_q(stats->q, 0, hw->mac.max_queues);
+	fm10k_unbind_hw_stats_q(stats->q, hw->mac.max_queues);
 
 	/* Reinitialize bases for all stats */
 	fm10k_update_hw_stats_vf(hw, stats);
-- 
2.51.0



