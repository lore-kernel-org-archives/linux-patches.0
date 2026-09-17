Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D343DCD99;
	Thu, 17 Sep 2026 18:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670795; cv=none; b=s95nm6MgNTPw5bd91raUnlMpfl1m/XJcbCabDt9fv8gL3rZ9RBEdF1fpJDLepfdwWD0kdKnElgkJioeOQklQJcRmnahYPGhFSYwG4qnRqofOmqcuLt8QHH7OI8gNrdsaIMjfSVITq+2H5qmIsGTpChdyRvUR/71YKazi740Fa/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670795; c=relaxed/simple;
	bh=OVl3LRMe9h8Fj67KC+JwmfD2LemUu9DrkwNgr9KLx3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJjAbDQ5me01nbSjAiM50rxWi0mwqlNhLbR0oArzUUzTH0ZfkbP0TmVrUcqcPqDcV+W1f5Jzv2lXnRs8d4xmdeQ+hmMJI0bgwnbPdMWu8fsTEPx3SF0i8NKtc62nOyfscvlquLGHIHJkWVsp4RmzDno0pZctrCMa2S7jh5q2PvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+h/OuvH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+h/OuvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4071F000FF;
	Thu, 17 Sep 2026 18:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670794;
	bh=hQwmG8d8hKgCxx0ShC/QbeVLsm4/k4LP1C7e2D9qC+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k+h/OuvHh3EsETQKV/obCwnNmvXOHjiBd98jjoKA0Spbi0PwB44g7aco498kHyM7t
	 MGvpXjj2ll309aEGWxs/BEM0dtIi/giZo1Es03uXzGfu2GkIo/bW897qx4vtnWsPNg
	 XSRBqEFvxrjrqB8p9FdYHehNa9WQu/UPmSQLkaN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changbin Du <changbin.du@huawei.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0773/1102] perf/x86/intel/ds: Remove redundant assignments to sample.period
Date: Thu, 17 Sep 2026 16:11:56 +0100
Message-ID: <20260917151559.857522999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Changbin Du <changbin.du@huawei.com>

[ Upstream commit 75a9001bab36f0456f6aae1ab0aa487db456464a ]

The perf_sample_data_init() has already set the period of sample, so no
need to do it again.

Signed-off-by: Changbin Du <changbin.du@huawei.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250506094907.2724-1-changbin.du@huawei.com
Stable-dep-of: 88aa1223bfff ("perf/x86/intel: Correct pt_regs->flags update for PEBS path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/ds.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index f630485e044af..e1b8c318cf9f6 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1747,8 +1747,6 @@ static void setup_pebs_fixed_sample_data(struct perf_event *event,
 
 	perf_sample_data_init(data, 0, event->hw.last_period);
 
-	data->period = event->hw.last_period;
-
 	/*
 	 * Use latency for weight (only avail with PEBS-LL)
 	 */
@@ -1925,7 +1923,6 @@ static void setup_pebs_adaptive_sample_data(struct perf_event *event,
 	sample_type = event->attr.sample_type;
 	format_group = basic->format_group;
 	perf_sample_data_init(data, 0, event->hw.last_period);
-	data->period = event->hw.last_period;
 
 	setup_pebs_time(event, data, basic->tsc);
 
-- 
2.53.0



