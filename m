Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0207E352027;
	Sat, 30 May 2026 18:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164609; cv=none; b=WJt072XCOD1+cIykz1rpVrwlI95TswpNXvlGfActBUT6fRVWOIf8KkPDlIcDBSIR+9C/5NhFE0PdBJIsm7AXeEe8+ErndJaykxsqPoLTHuzx+/VIH6Jyxa5jg+IHmDRuUQ12Xb1UPbbz/pRboonk91Q+IoLJJb11slwl0zzcKxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164609; c=relaxed/simple;
	bh=ZptHESExAyjP4tQu3dYsSYhusam0hKTob2wVQ4xjc0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVwkMmzFSwwaM+oW13Ng7Wba9lszteh8Uf+273UuiyftRFWnTlz9unDoeIRz8SqMIPu2mXuUCjI0vX4WEwZAe4Vz/OJNPl9LMKYEYWDvjlwLCdtBkFqE25vaffHQeTndWDtrQ7dpqmkyFpFsALN3aFgV9PRaz9JMW+iJEKAOYRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXY2c1+1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXY2c1+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472251F00898;
	Sat, 30 May 2026 18:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164607;
	bh=K9f4bBtrWbHJworlQ5ZL2bVC3gzYHS7INjOPshntRtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXY2c1+1IWM4sGuhqPQbbieYhVSJW5H08z/Zs8xUfr9feYnFI72qIBj1ZQjiZPyz3
	 DDFEuQ59DdTBfgaYah0FwzTco11+zUIDL1A8ibNSqglHa0pSqfUUwQdZKjNcIOj3co
	 hVOVPtvDUbfYJrj/Gjw+PCj17coG7GlH8t75cAGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 588/776] net: sched: gred/red: remove unused variables in struct red_stats
Date: Sat, 30 May 2026 18:05:02 +0200
Message-ID: <20260530160255.263224663@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 4516c873e3b55856012ddd6db9d4366ce3c60c5d ]

The variable "other" in the struct red_stats is not used. Remove it.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a8f5192809ca ("net/sched: sch_red: annotate data-races in red_dump_stats()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/red.h    | 1 -
 net/sched/sch_gred.c | 3 ---
 net/sched/sch_red.c  | 1 -
 3 files changed, 5 deletions(-)

diff --git a/include/net/red.h b/include/net/red.h
index be11dbd264920..454ac2b65d8ca 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -122,7 +122,6 @@ struct red_stats {
 	u32		forced_drop;	/* Forced drops, qavg > max_thresh */
 	u32		forced_mark;	/* Forced marks, qavg > max_thresh */
 	u32		pdrop;          /* Drops due to queue limits */
-	u32		other;          /* Drops due to drop() calls */
 };
 
 struct red_parms {
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 621dc6afde8f3..8caf9623f855f 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -817,7 +817,6 @@ static int gred_dump(struct Qdisc *sch, struct sk_buff *skb)
 		opt.Wlog	= q->parms.Wlog;
 		opt.Plog	= q->parms.Plog;
 		opt.Scell_log	= q->parms.Scell_log;
-		opt.other	= q->stats.other;
 		opt.early	= q->stats.prob_drop;
 		opt.forced	= q->stats.forced_drop;
 		opt.pdrop	= q->stats.pdrop;
@@ -883,8 +882,6 @@ static int gred_dump(struct Qdisc *sch, struct sk_buff *skb)
 			goto nla_put_failure;
 		if (nla_put_u32(skb, TCA_GRED_VQ_STAT_PDROP, q->stats.pdrop))
 			goto nla_put_failure;
-		if (nla_put_u32(skb, TCA_GRED_VQ_STAT_OTHER, q->stats.other))
-			goto nla_put_failure;
 
 		nla_nest_end(skb, vq);
 	}
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 063431a5ae1dd..a2c1db8ac3945 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -463,7 +463,6 @@ static int red_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	}
 	st.early = q->stats.prob_drop + q->stats.forced_drop;
 	st.pdrop = q->stats.pdrop;
-	st.other = q->stats.other;
 	st.marked = q->stats.prob_mark + q->stats.forced_mark;
 
 	return gnet_stats_copy_app(d, &st, sizeof(st));
-- 
2.53.0



