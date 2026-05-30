Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545782F3C3E;
	Sat, 30 May 2026 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166707; cv=none; b=NjUWpZsa/bd8uTgSh/x9KsVmThd1nJQvN+FdkdFwEORmQ/xYuutDBQYjqAR0SrvpYndFcgh24BOG+X9vGmZRVsjzpu0nglvxcJRGUSyaS779mr9lGO5TPKXQEi1e9Y/jlgOEn2Q09tH8n1K3I4HFZ5HrWBuNHwmyrkzZhkanuB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166707; c=relaxed/simple;
	bh=StBCUKD+cxQEREzHrZET+3f6NEiNEilluRoJZJVf65E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URNgIyHrY+TTl12ItDMT8AwaaNuccFz0iiiK121sKkltG/1omAhtJj+wPrnQ9orpfTwhIjB96ZHs8vZW8Sswtg5/tk1cUZChTIvveLehMIJOx42QeS3XrGdZLCMqr954Ufjl7tz5EraGBxuzbmT7J3j2E7eg8rk6XGBk5o9vQVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUvbHfdf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUvbHfdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9DA1F00893;
	Sat, 30 May 2026 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166706;
	bh=W0GgRugKPx0xd5JL7+CgT0PBUHR6B3tOgR6GpX8uHoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUvbHfdfYpjASYaIxfHrDBhsohJ0eDpAjrptcDDI1JiXWJo2RilUV+HzRhq4t2EK4
	 GYIfPJOpITT76F9ZTNIRRT0n9W9rgLghjIbDbbzODjOD5v9BgCXmcf6xEo0x4yuWHl
	 BkektDOTF/YtgDIkBWsh4eVSWS7yo6aSlIGxEy1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 447/589] net: sched: gred/red: remove unused variables in struct red_stats
Date: Sat, 30 May 2026 18:05:28 +0200
Message-ID: <20260530160236.446868400@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cc9f6b0d7f1e9..2fc217a07ade4 100644
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
index f4132dc25ac05..db3b695d072be 100644
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



