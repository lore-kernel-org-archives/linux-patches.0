Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164F533A6F1;
	Wed, 30 Sep 2026 19:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795489; cv=none; b=GBGaQPITL+/HGN/LkuLB0cAaoDpqPRXs5Nyn+folFKHx1b+IA7rmSAAB4BpeLffT6FKSp+bEnOYOh9viytfuI/c0iX5G2GG909bi8m+DjD+e7FNXjO2QFdCGnmEp0NCBjNUom/VqHZY1K9L419qxxd44To8StcXDV+4sZIakwO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795489; c=relaxed/simple;
	bh=Yeml1DqLcdPk3cny5zvya/+ZfyHl+0jX2HNffCROWu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjkHzFUoTF9ccA2Jlw86GKA6E3OuUmExqZe1S+np8AWW2z2/iOixL29+DmJbUMYzsmlvXiCHUS/RgC2glCoOwfZTDYwdOYOlfnkb/+jNxKMrHYSdMV1iNUcBK2Oln03bT8yKBDCkSoSDcln7DZV3d2g96kBXdSfEWk7YorGLrRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xxH05a7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xxH05a7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EB71F000FF;
	Wed, 30 Sep 2026 19:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795487;
	bh=8Du7LbCwUZpqZiUIqSfBfzPPSynZT4rP7IQNer50x5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1xxH05a7pxJbx0U5EbNau6vRaIE3tHTYQEvU+ZLYAj/pNc4TUJChtjIFaTviYgVPO
	 OnGYMgNC/0+uUsUdM49zMFkdNZu/Jub1UaVxeaEwJNhiaXLZx3xENdZPxAaU6YYirp
	 ZRclC8FSc/9TN5Rrg40BJv4wbAHTwddB2+4s/w44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changbin Du <changbin.du@huawei.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0580/1193] perf/x86/intel/ds: Remove redundant assignments to sample.period
Date: Wed, 30 Sep 2026 17:21:04 +0200
Message-ID: <20260930152447.130443850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7e3768d4b12b3..0dbe7470f3fad 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1632,8 +1632,6 @@ static void setup_pebs_fixed_sample_data(struct perf_event *event,
 
 	perf_sample_data_init(data, 0, event->hw.last_period);
 
-	data->period = event->hw.last_period;
-
 	/*
 	 * Use latency for weight (only avail with PEBS-LL)
 	 */
@@ -1810,7 +1808,6 @@ static void setup_pebs_adaptive_sample_data(struct perf_event *event,
 	sample_type = event->attr.sample_type;
 	format_group = basic->format_group;
 	perf_sample_data_init(data, 0, event->hw.last_period);
-	data->period = event->hw.last_period;
 
 	setup_pebs_time(event, data, basic->tsc);
 
-- 
2.53.0



