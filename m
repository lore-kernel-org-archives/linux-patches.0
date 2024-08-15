Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795EE1714DD;
	Thu, 15 Aug 2024 14:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730446; cv=none; b=OZ5OH1+ryNxHTwpRs/nC6mIKcMn5wqyg33fB2WppXd2IEqMR+4AdNYHrNpX0IP8mtLpigKReuFU0CUZ54nz55Z6+vRssndbyC2ddk35WgCfqTPtSnIOq8HxLIvqBVhP6bnFyPpWlhf719JsrHa5cUZ4DOgDTFPq6aay0157PPXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730446; c=relaxed/simple;
	bh=lH/vhQFxezme1BN2/9GKbFZq31f8XxdedNokhH+a+bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaVB2wOImUGXmqSWB7eGC27Snkdq5wSMpzgftj+6gVa5lHlV5nohM/v8SVDZhwK3IDzZ1KjWoCD24jM9g5Fyv0tr/jT6pBVeGJezCdevdhnCENl4lMtGYnc4kgk2WE9gYSmEXmn0pr+XbXHjG+QiOtSb6sEATBRBjWGsyyqLNgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkYJ5jtZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkYJ5jtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF115C4AF0C;
	Thu, 15 Aug 2024 14:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730446;
	bh=lH/vhQFxezme1BN2/9GKbFZq31f8XxdedNokhH+a+bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkYJ5jtZtPl+9dWLBnsncwck5gsv0d+vucBCp8HKurvNnUfodISk9ooWOR2+XUaR9
	 5d72tbAIe831ExODF8djENkweDFytr1NxaOp5FDIUO6JgsEHAMXga8lfCpmtGtaWNd
	 TT7qyNC0oRjxpFGJPOHEko7HcYWO5qa/qGy5zhcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 411/484] bpf: kprobe: remove unused declaring of bpf_kprobe_override
Date: Thu, 15 Aug 2024 15:24:29 +0200
Message-ID: <20240815131957.325812299@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 0e8b53979ac86eddb3fd76264025a70071a25574 ]

After the commit 66665ad2f102 ("tracing/kprobe: bpf: Compare instruction
pointer with original one"), "bpf_kprobe_override" is not used anywhere
anymore, and we can remove it now.

Link: https://lore.kernel.org/all/20240710085939.11520-1-dongml2@chinatelecom.cn/

Fixes: 66665ad2f102 ("tracing/kprobe: bpf: Compare instruction pointer with original one")
Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace_events.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 511c43ce94213..d5618d96ade67 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -828,7 +828,6 @@ do {									\
 struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
-DECLARE_PER_CPU(int, bpf_kprobe_override);
 
 extern int  perf_trace_init(struct perf_event *event);
 extern void perf_trace_destroy(struct perf_event *event);
-- 
2.43.0



