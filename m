Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC45D302CD6;
	Sat, 25 Oct 2025 16:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408574; cv=none; b=O6C6Ru2Z+hukhrdxegcUpbTEdSTasGDpAYXwJO17BWJL+gO9+L0Xr2ufTKDe3qqSbGJhSOZnn7NxAqR3Rqi0EZJ+OaCpAnfeINnlGOtuEjb66dhd21PNxa+vuw7k7xXC7Knuc7M5RY2VSaPKP3TCMPeRqGVQcFyz10Jb0YIXNaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408574; c=relaxed/simple;
	bh=l2p8ytWrsCQMp25+omQ8DepULd7IcPVXRE79VUYC7ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MI4xjDp2dIheZ2pCkQYhVo+lMPcUVJUKDJOFgvTIs13fiSOH+YRqNbN319jzFqmFVQs4xlSAmJVMyqaTKKR1Q3mQV+EBiBC0ljSuAqpZiGu18EKI8EDSLAJA5Idc9djdj6auvyEyfsY2XwvPIGUBegSflmYjEA0HuNJITHlrl9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4lEsNUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4lEsNUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B015C4CEF5;
	Sat, 25 Oct 2025 16:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408573;
	bh=l2p8ytWrsCQMp25+omQ8DepULd7IcPVXRE79VUYC7ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4lEsNUqjBPucKKBhvir4obMU3Cc8mAZrYUT/PRmEapvawVMtKIo88hVSuFjfRfby
	 jYZOfVw9AlnVX963s4l49S3nKos7DEgOg8zVS3LzWTeTWJl3NTOYqvgI227F6e4LZ0
	 uIkBVzwGZy5iQ3Naa92uOHIp8AOONRw2ps+ZUMi+Y9YNI7exCGEsnPKgQ3AYIaZ/To
	 EI8FSiAs25fqSoOWG6g7jq18XgsbfJMex6TF804An+OML8GzedaNemLCRIuWIGWQC1
	 i13iLYkmdoQOBBl6YzVpVgrFvH3PW6PH6DOmLHDhyuSZtDYn9MnHPPnnA1WfYDzZyb
	 duZ2utQPKmOlw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brahmajit Das <listout@listout.xyz>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	przemyslaw.kitszel@intel.com,
	intel-wired-lan@lists.osuosl.org
Subject: [PATCH AUTOSEL 6.17-5.4] net: intel: fm10k: Fix parameter idx set but not used
Date: Sat, 25 Oct 2025 11:54:01 -0400
Message-ID: <20251025160905.3857885-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES – dropping the unused `idx` argument fixes a real build break while
leaving runtime behaviour unchanged.

- `fm10k_unbind_hw_stats_q` now only walks the passed queue array and
  clears the cached indices
  (`drivers/net/ethernet/intel/fm10k/fm10k_common.c:455`), so the dead
  `idx++` expression that triggered GCC 16’s default `-Werror=unused-
  but-set-parameter` is gone; this restores the ability to build the
  driver with upcoming toolchains.
- The header signature is updated accordingly
  (`drivers/net/ethernet/intel/fm10k/fm10k_common.h:43-46`), and the
  only in-tree callers—PF/VF rebind paths—are adjusted to match
  (`drivers/net/ethernet/intel/fm10k/fm10k_pf.c:1392`,
  `drivers/net/ethernet/intel/fm10k/fm10k_vf.c:468`); all of them
  already passed `0`, so no logic changes.
- `fm10k_hw_stats_q` only carries the `rx_stats_idx`/`tx_stats_idx`
  fields that this helper zeros
  (`drivers/net/ethernet/intel/fm10k/fm10k_type.h:419-426`); no other
  state depends on the removed parameter, and no additional callers
  exist (confirmed by tree-wide search).
- The patch is tiny, self-contained, and purely defensive: it keeps
  released stable kernels buildable with newer GCC without touching live
  datapaths, so regression risk is minimal and it meets the stable
  backport guidelines for important build fixes.

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
index b9dd7b7198324..3394645a18fe8 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
@@ -1389,7 +1389,7 @@ static void fm10k_rebind_hw_stats_pf(struct fm10k_hw *hw,
 	fm10k_unbind_hw_stats_32b(&stats->nodesc_drop);
 
 	/* Unbind Queue Statistics */
-	fm10k_unbind_hw_stats_q(stats->q, 0, hw->mac.max_queues);
+	fm10k_unbind_hw_stats_q(stats->q, hw->mac.max_queues);
 
 	/* Reinitialize bases for all stats */
 	fm10k_update_hw_stats_pf(hw, stats);
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_vf.c b/drivers/net/ethernet/intel/fm10k/fm10k_vf.c
index 7fb1961f29210..6861a0bdc14e1 100644
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

