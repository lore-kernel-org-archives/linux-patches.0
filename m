Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE4E345CBE;
	Tue, 11 Nov 2025 01:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824167; cv=none; b=Vft9FFEj6p+1PB4d9z+3diNdWZKPbjDfvviFs65HiY9sObxGV8QH6P0GUUUfyb+Z5D9lkZCAeRAWjOsFP+vSOxdXZcbpATRMNzyrzTbEsjC/3d4EY0NW2HQeM7t8m/1ig6mkZTsqhT4/oo1wEIuLFAEmOQl8qRzq9/G6XubZphI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824167; c=relaxed/simple;
	bh=BNnXRM1DV1Hpd3DirFFP0fTk3C7xm6ty3mTafVSHHsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oj1kQNUWPiW4aoHLqveyfoQspcGI9ilY6k2KNJn1Zc9MYIGlUyqan7hMeGZ/doBqqkcxrX2uKP+fXgj+8+B6LdGIcJodaPUYwgwWMUJBq1FaxkjZaODI2bmuzZfXliqYiyLuVsJQiNh/c4zy1/obyJPnzeIUly35M2cMu6NvSZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSDs5FNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSDs5FNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991ACC19424;
	Tue, 11 Nov 2025 01:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824166;
	bh=BNnXRM1DV1Hpd3DirFFP0fTk3C7xm6ty3mTafVSHHsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSDs5FNjVfurmcz1KTE0jzqr7N37+2HKx76ndMjydeG6VOeKDf68XqQQ23tQrKfaO
	 iX7lP565fxRvby/k1I/SHS9JraoZKrbUJe4csy2qL2eCu7AzIcVpuVAybj6h4r0JSg
	 BSycOBZV0TGgYNctoZk+0qOsR07Kei6MLxSXr4mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Brahmajit Das <listout@listout.xyz>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 400/565] net: intel: fm10k: Fix parameter idx set but not used
Date: Tue, 11 Nov 2025 09:44:16 +0900
Message-ID: <20251111004535.869904497@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 98861cc6df7cc..797b99af0c453 100644
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



