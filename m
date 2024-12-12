Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE8121578A;
	Thu, 12 Dec 2024 15:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016451; cv=none; b=ZTjKomJCG/p0kzcHGMkPC5PCD+Q4U2sxwzfWvxWqUviTlTROEMqf3wozemddy11CAnvQdLbHE8jcWaau6L5xdJcnP5uHEHplKWhPv9UvSS3YjTuBq2cfGQuCHfGC0ap3aNycK/TN5GOIjirM+PC2X0002Un4oRgJ1i79+MqCHgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016451; c=relaxed/simple;
	bh=+3kUKYTdtrOLB8B/iE1vk3b3BzkE3R7VH/GPeEjcIMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWVVrt1yF8gyiR764niacN7zmfhzxG4Y9vh8nB7eS9DTdnM23UN3iMOQvyP4Su3petZT7HK16C3XXzxaKLlSIjepr/eIWzvr2H100cHmfV+ovt0hInE2O6kn/EvawbstL0WVsun6BFJZQXiO4RY+trHAJYyxg5OKzsPL4qbPF7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwkvHao/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwkvHao/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B3CC4CED0;
	Thu, 12 Dec 2024 15:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016451;
	bh=+3kUKYTdtrOLB8B/iE1vk3b3BzkE3R7VH/GPeEjcIMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwkvHao/tVETOmxwYip8NX1ngPSMPEdPFn4/KSavOOVFwnddpcOCLp+wz1JMm2bEx
	 v+/IO7WckhV4lqL4MXk2+nbpH+2L4sZ2/oVTJvHAG4WQ+37MayG4lBjpR52j5N8OCz
	 UkQCzCkPuO1v+oFycqpx3i2YnEg6PxJ9/MATmMR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akinobu Mita <akinobu.mita@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 203/466] mm/damon: fix order of arguments in damos_before_apply tracepoint
Date: Thu, 12 Dec 2024 15:56:12 +0100
Message-ID: <20241212144314.806956260@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akinobu Mita <akinobu.mita@gmail.com>

commit 6535b8669c1a74078098517174e53fc907ce9d56 upstream.

Since the order of the scheme_idx and target_idx arguments in TP_ARGS is
reversed, they are stored in the trace record in reverse.

Link: https://lkml.kernel.org/r/20241115182023.43118-1-sj@kernel.org
Link: https://patch.msgid.link/20241112154828.40307-1-akinobu.mita@gmail.com
Fixes: c603c630b509 ("mm/damon/core: add a tracepoint for damos apply target regions")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/damon.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
index 23200aabccac..da4bd9fd1162 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -15,7 +15,7 @@ TRACE_EVENT_CONDITION(damos_before_apply,
 		unsigned int target_idx, struct damon_region *r,
 		unsigned int nr_regions, bool do_trace),
 
-	TP_ARGS(context_idx, target_idx, scheme_idx, r, nr_regions, do_trace),
+	TP_ARGS(context_idx, scheme_idx, target_idx, r, nr_regions, do_trace),
 
 	TP_CONDITION(do_trace),
 
-- 
2.47.1



