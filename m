Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C3B29B799;
	Sat, 30 May 2026 18:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164781; cv=none; b=M49j4Le7VhL//JnLfEZappxDYw4/yIJyUb0970eUg0AOuNGBQspjbfhL4DuP/2Fb8b4CyzyPN4PN5+MMfKuZe6Xv8zu5edyMoZQAwRy0CloYFWh0zbPQ/oRU7BsX9ShX8Rt8D/Sj3qnnW4eeiKr189GPDrmkyneok8GxGQ5VAvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164781; c=relaxed/simple;
	bh=TB4NWzM8rw3TaPEAOYmMrMUb8Zu/0iol4XlS22xVOBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7WNoXnAnzeMQx33XCsFvPwZs682RnPNxnpBWBne6sLEXletdMwu9YVTCCmnRWSUl+UWt+IBL7Bs95MNjh0K6s2IV6eZbHeCmGzzwEBhpvwzPFO2g9s5Z/VIMTfSaHGuJJ27IWZnbIwKjBAaBIPaGEQXRXELWNC1za2eFZEJ1sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DhUzsLdp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhUzsLdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D2A1F00893;
	Sat, 30 May 2026 18:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164780;
	bh=GNoYjfRsUviuu2vE6W50+HUccqslU1vbfrvVX65v/68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DhUzsLdpnpfd+MN8TN4RS362U4VwzbXBAMPKCxhXjs/bUgRFR7B7wrdjRljKenhnF
	 E2ksluArQmmD3UucCCGA9aVrUDLXz2igTc+Hk9j2ldN1uPrn1yw6hAJ09YfxOTU/AH
	 pq9fXMlxbm5HBS5Y/7LCCnoPMQuJykcJ88bMP+jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 618/776] net: sched: choke: remove unused variables in struct choke_sched_data
Date: Sat, 30 May 2026 18:05:32 +0200
Message-ID: <20260530160255.961713158@linuxfoundation.org>
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

[ Upstream commit 38af11717b386560f10f2891350933fc5200aeea ]

The variable "other" in the struct choke_sched_data is not used. Remove it.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: d3aeb889dcbd ("net/sched: sch_choke: annotate data-races in choke_dump_stats()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_choke.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index f3805bee995bb..e38cf34287018 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -60,7 +60,6 @@ struct choke_sched_data {
 		u32	forced_drop;	/* Forced drops, qavg > max_thresh */
 		u32	forced_mark;	/* Forced marks, qavg > max_thresh */
 		u32	pdrop;          /* Drops due to queue limits */
-		u32	other;          /* Drops due to drop() calls */
 		u32	matched;	/* Drops to flow match */
 	} stats;
 
@@ -464,7 +463,6 @@ static int choke_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 		.early	= q->stats.prob_drop + q->stats.forced_drop,
 		.marked	= q->stats.prob_mark + q->stats.forced_mark,
 		.pdrop	= q->stats.pdrop,
-		.other	= q->stats.other,
 		.matched = q->stats.matched,
 	};
 
-- 
2.53.0



