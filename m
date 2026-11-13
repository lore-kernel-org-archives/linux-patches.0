Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590906;
	b=Orh3fcy5OIVcaTfafesJ1Y08pjtsYWeKXHWqAZZCfA41GOpC4fWHHLhTf6zJd4+BNkDE
	 9rqxKpALneQD/OO0ziKHOMvc4dG2hn1lLnhGXq5E6vN7TPHSeR0aRsmyMtKbQoNJsWuaT
	 h20e2LHmyrdOWBNXogjWBSqO0J4+so3V+/A8UI+0b2JU4+ZR3/54jrn3ciyl3/NtrHKQV
	 L9xBz7iZDsOTDuBOCb3o5NOFZybXkjFI4expWo40GxxnsnILBtPRva4PEGr0EB8T4mmub
	 5J3x8YqOe7oKuzQrCGbqwPHUDwn6D0a1tehU25qnW/2Q2Aq+iZscm0LcVDQ1ldnsAFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TV/asRgHA8uzH+InN/CvWuTF7QMBJwzXnGD+M8mKX48=;
	b=BNcuPkTkdTqboGik+BDX85xwiVu0tEaLLWxTgYzi/ItY/maaIulnd8s0/BGrT9dLQMmO
	 5mlalRvo0jbaH8t/82sS6Fp1Kd2C7RfxYw6iNEtHgBJgFa3+5m2qPR77hctqNcsRynOdh
	 Lx72018XH+dRAwhAHxqlZhew/LmBkj/A9kC/B37nJiMN53oh9x1PNyYNJhgtF+PIZEiMi
	 B7Ig07t1toVy2JiC8DllIJ59hk4cdA/7F5+q7TA5Ob0DhnFI+K3oq+cvzvN/rcwYpVzzk
	 1bnw5WRKcLGe2WSHovXm5upYWeAZRl6ZL5DGEaX3NxSKidNzE/fk00L7a/1Rgndl4bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1oOsCvdO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D077606E237;
	Fri, 13 Nov 2026 17:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1oOsCvdO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C384E1F000C4;
	Fri, 13 Nov 2026 17:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590906;
	bh=TV/asRgHA8uzH+InN/CvWuTF7QMBJwzXnGD+M8mKX48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1oOsCvdOq7TArZGMvn5dIsEkLIe39TM3HhUwLyyPSB4n0vTdOwp1e1oPFmL+Uwnar
	 OGtRtmW11lB2GJCaHTbEqmFcEMs3pwTPCSpmn9Q7EHZsP8NQvB21B17mzVokS36CG3
	 zQI7RIyAMh7eSYN3VJwJoE08ZuVZsNEOpiPhrKkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/670] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Fri, 13 Nov 2026 10:44:18 -0500
Message-ID: <20261113153815.086316727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 29c6084658af41b5b1fefd873d26d441830ced34 ]

When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
delta for the feedback loop is calculated using
damos_quota_goal->last_psi_total.  However, it is initialized only after
the first feedback loop.  The first iteration of the loop uses the
uninitialized value.  As a result, the feedback loop can change the
effective quota in an unexpected way at the first iteration.

The user impact of the issue is not big, because the issue impacts only
the first iteration of the feedback loop.  The feedback loop also has an
internal cap of the quota adjustment.  The wrong adjustment will soon be
corrected over a few iterations.  For this reason, doing no initialization
at commit time was intentional.  It is also explicitly commented.  That
said, nobody likes behaviors that are unexpected or difficult to be
expected.

Check last_psi_total initialization and skip the tuning round when it is
not initialized.  For this, initialize last_psi_total with U64_MAX in the
goal creation and the goal commit time.  U64_MAX means the field is not
initialized.  The tuning round shows the value and adjusts it to guarantee
the current quota is maintained for the round, and last_psi_total is
correctly initialized on the next round.

Before this change, committing a new PSI goal on an existing PSI goal with
goal-only DAMON sysfs command (commit_schemes_quota_goals) just worked.
After this change, the tuning round right after the commit will be
unnecessarily skipped, because last_psi_total is unconditionally marked as
not initialized in the damos_commit_quota_goal_union().  This is an
intended tradeoff for simplicity.  Skipping just one round of tuning is no
problem.  Meanwhile it makes both the code and the behavior simple to
understand.

Also update the quota goal commit unit test for changed last_psi_total
setup behavior.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260902002725.108635-3-sj@kernel.org
Link: https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org [1]
Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Tested-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 6.9.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index fc4f9aa0a3620..4952ca7ac00dc 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -324,6 +324,8 @@ struct damos_quota_goal *damos_new_quota_goal(
 		return NULL;
 	goal->metric = metric;
 	goal->target_value = target_value;
+	if (metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		goal->last_psi_total = U64_MAX;
 	INIT_LIST_HEAD(&goal->list);
 	return goal;
 }
@@ -707,7 +709,8 @@ static int damos_commit_quota_goal(
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
-	/* keep last_psi_total as is, since it will be updated in next cycle */
+	else if (dst->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		dst->last_psi_total = U64_MAX;
 	return 0;
 }
 
@@ -1622,7 +1625,12 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 		break;
 	case DAMOS_QUOTA_SOME_MEM_PSI_US:
 		now_psi_total = damos_get_some_mem_psi_total();
-		goal->current_value = now_psi_total - goal->last_psi_total;
+		/* uninitialized last_psi_total; make no effect this round */
+		if (goal->last_psi_total == U64_MAX)
+			goal->current_value = goal->target_value;
+		else
+			goal->current_value = now_psi_total -
+				goal->last_psi_total;
 		goal->last_psi_total = now_psi_total;
 		break;
 	default:
-- 
2.53.0



