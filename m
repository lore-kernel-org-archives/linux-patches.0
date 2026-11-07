Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064476;
	b=dajku9MUJRKvUhS5tazWE448sA+rR9deqlMeCARq9jw2oPVPTZBOesvLCx5bebWinzMK
	 FDj30LMmkam3RaglVJcpmvPL202CwR2gx5WTQMpIEfv6y5X7/D8tCRoXGUgmF+bsd9TPt
	 b36x2XZyPer8YWxwLmxmL+2dvDT6hCESp0QZ2/gd2tp2s+BbfOt1wwaJKYV6Ijf4J1BF8
	 70lLMcAZvj4gmdVw38f3euecCK3aaEuvmAlGaIm/RI9nBhGpcqkxbo8oT5lZOY07n/v2F
	 K58AfkX2RtAjbsKVkVbeD4a21A74/FU3EHtp/dT258Fz/8zX+QRNmhDQMeSbrLD2qgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ilp2dVUeAhc+DnQeTVq171kwSFZ17Hmm6PYO/YWDC8U=;
	b=x1LDI+juDRsZDLzkUBa8IQLMOUIQP7eKjV9ZF6oRGC6bkpNRD4HgD2FqiCf/OGcf2Zie
	 tzypIpc+N4zA2HkszPIfreLwF+83hVe6ID6YYxJoJv/uXfYjOZ16nfYp7uw4q1hzhStLC
	 5XqYkRcov5TBKZ1QSc1C35teid5Pxl/trOqVEcrqo1IhVH4xyYYARkp4farbkysVEW6Uj
	 z91NuxMWcfwDBDE+rjr0fL8m//pTmbXo0Os2U/mkgzjlIWQHNqlZeAcwXkItncY0YypwW
	 xrclX8RaAtdeBAD15RqzMUrRc/Sx/Iuk15ZRUaCsWi38aWJxmBWZQtTpFkLLjVUFSMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SCX6Q40A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082C4606C015;
	Sat,  7 Nov 2026 15:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SCX6Q40A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECAF1F008A1;
	Sat,  7 Nov 2026 15:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064475;
	bh=Ilp2dVUeAhc+DnQeTVq171kwSFZ17Hmm6PYO/YWDC8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SCX6Q40A0pCXn7Fmt3Ui4UxtTbB5QK9N48m3Otd2HVZrJ+5z9IIO9SwZmWGnuCDRq
	 l1vDBCXCkc5b2w437YlhwINxp/GQYmg6S+MSdU/n9ocVlvStJt+RxxIbmdtR6y/ZfF
	 yH1I8EPu3MAliJlm80wBjQSRU/dhsU28zeQLg+9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0515/1257] mm/damon/core: keep the temporal tuner quota over an unmeasured PSI round
Date: Sat,  7 Nov 2026 08:46:51 -0500
Message-ID: <20261107134953.656340066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit df7d9a0f8d916eeea375430ae3360724afecde15 ]

The patch in mm-unstable of subject "mm/damon/core: handle uninitialized
damos_quota_goal->last_psi_total" scores a PSI quota goal without a
previous sample as achieved.  This leaves the consist tuner's input
unchanged, but the temporal tuner sets its quota to zero for an achieved
goal.  A running scheme with a nonzero temporal quota therefore loses a
charge window after a quota-goal commit.

Use the effective quota to preserve the temporal tuner's previous
goal-achievement state during an unmeasured round, as SJ suggested [1].
Score the goal as achieved when the effective quota is zero and as not
achieved otherwise.  A new scheme's initially zero quota stays zero, and
the consist tuner's behavior is unchanged.

Move the PSI current-value calculation and last_psi_total update into a
helper that takes the current PSI total.  This lets a unit test cover the
unmeasured and measured rounds without depending on system memory
pressure.

Link: https://lore.kernel.org/20260923055139.2982-1-sj@kernel.org
Link: https://lore.kernel.org/damon/20260916001311.101024-1-sj@kernel.org/ [1]
Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Assisted-by: LLM
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: <stable@vger.kernel.org> # 6.9.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0463e7ec0e14b..2edd906787a35 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2813,6 +2813,28 @@ static inline u64 damos_get_some_mem_psi_total(void)
 
 #endif	/* CONFIG_PSI */
 
+static void damos_set_psi_current_val(u64 now_psi_total,
+		struct damos_quota_goal *goal, struct damos *s)
+{
+	u64 last_psi_total = goal->last_psi_total;
+
+	goal->last_psi_total = now_psi_total;
+	if (last_psi_total != U64_MAX) {
+		goal->current_value = now_psi_total - last_psi_total;
+		return;
+	}
+	/* uninitialized last_psi_total; make no effect this round */
+	if (s->quota.goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST) {
+		goal->current_value = goal->target_value;
+		return;
+	}
+	/* let temporal tuner show the same achievement as in the last round */
+	if (!s->quota.esz)
+		goal->current_value = goal->target_value;
+	else
+		goal->current_value = 0;
+}
+
 #ifdef CONFIG_NUMA
 static bool invalid_mem_node(int nid)
 {
@@ -3049,13 +3071,7 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		break;
 	case DAMOS_QUOTA_SOME_MEM_PSI_US:
 		now_psi_total = damos_get_some_mem_psi_total();
-		/* uninitialized last_psi_total; make no effect this round */
-		if (goal->last_psi_total == U64_MAX)
-			goal->current_value = goal->target_value;
-		else
-			goal->current_value = now_psi_total -
-				goal->last_psi_total;
-		goal->last_psi_total = now_psi_total;
+		damos_set_psi_current_val(now_psi_total, goal, s);
 		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
-- 
2.53.0



