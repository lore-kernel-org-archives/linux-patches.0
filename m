Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AD1137750;
	Sat, 30 May 2026 18:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166905; cv=none; b=XAmyOXIg4dG9JPZ4beEBM1fxGSEJfyI6yOx8LhQXGpwgmiNhQu+fM7aj+uJOjOmjuISITOrdkfYYfud6QCqvGdVCSzMpfEP6GYSGsf2fU24gfLjuHcq+Upj9fZ9pJbFvQfv4l/qEinNMwhc9Z+cvSwRDvd1Dc7OLxAp0tp1ATCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166905; c=relaxed/simple;
	bh=JvJnreCv/txBqyxPLnd0lT0uDgm+iju/bhLVWNUj3xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhusioLS5ASaz3EZIZNmtpy7kZt/69j2DigB1FwgyF5O9e0OC8mVKOPyYsLbtTxwt0eTM/K6mI0ktOL7AcOl3eO919q44XeJxARzecaw3umJ+ZYec0QEcnFImgA/B3p0BwE2w0Cw4UYF9x6YkfZgBoSQIam2iAV0W+tHT+IgTS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZqAgRsA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZqAgRsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B201F00893;
	Sat, 30 May 2026 18:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166904;
	bh=NrooeZmy7kCfcfdUgUq0nkkWeIbith0LbWlTh146sxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZqAgRsA+dxkeKPcTHi9rOkvd+mEJcl8WAuDMa2KuYmNXgTiPy2GDNktQNGTN1ZBE
	 lfJDHJzn0Daa5z6pRI7tC4IgqDH+LxtlyTlvRLh+BBOY6q1a8HcA3lyXjBO6raW6Oh
	 5ACq4MfdSTz0jBlCrJMuFccqBr4PioQr3oGRre9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 477/589] net: sched: choke: remove unused variables in struct choke_sched_data
Date: Sat, 30 May 2026 18:05:58 +0200
Message-ID: <20260530160237.179624802@linuxfoundation.org>
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



