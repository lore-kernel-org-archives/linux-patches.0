Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09236214205;
	Tue,  8 Apr 2025 11:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110627; cv=none; b=q9ZmkBZzUTgBdZL4WqhJXk3qb+D5WuDAip/ql7ehQJH9D59b8bI3tU9wvo/6CuwFf9dhub0VKDHtI0YLu3HK+n+gcFA8l5oN0qIb4gGihuzcrUfFdJ2lteyfLcppg7/aLB9iu45FPPeLKHKEI9pbay0MME2w57FMPz+sgskE3WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110627; c=relaxed/simple;
	bh=ZPJXWm4y7YG337VCgsOwVaQlUyFAqb5cxzPdMWuak5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyCPcVOd9bbMheARofgkiGOr7qvBQtkWJbgcvrJIVoNQX0/HukHAuW5yo/Ty244E0M/sxWq4Hbqh/v5pJnOx8SNzdENy6UobXuRnuJLaQfkxVjGRjDGcqVbfhkFe5LBCaDvswUVkK4stk5CDqKNwH/NIqEGaq+2xDzbfiDcOVR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OW61Nk3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OW61Nk3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8997CC4CEE5;
	Tue,  8 Apr 2025 11:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110626;
	bh=ZPJXWm4y7YG337VCgsOwVaQlUyFAqb5cxzPdMWuak5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OW61Nk3PSGySuoHRBQ3OSLvLVYs+PNxXokWAK2cKBs2A8UF7mJoSMbP2e/UtZ6oAh
	 dqSFLUS4PFLgUGNTrgb2gEyLDiPkslQgTthjqyM1VJjaA4BCDk0AcFHE19y+or2kKr
	 mORVW+EO0+IPbgj2FMTOkG6r+pMALbAHhfdhjPqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 135/731] tracing: Fix DECLARE_TRACE_CONDITION
Date: Tue,  8 Apr 2025 12:40:32 +0200
Message-ID: <20250408104917.419156212@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 486df3466daf7b185f534a7408fa6f9dbb16dbeb ]

Commit 287050d39026 ("tracing: Add TRACE_EVENT_CONDITIONAL()") adds
macros to define conditional trace events (TRACE_EVENT_CONDITIONAL) and
tracepoints (DECLARE_TRACE_CONDITION), but sets up functionality for
direct use only for the former.

Add preprocessor bits in define_trace.h to allow usage of
DECLARE_TRACE_CONDITION just like DECLARE_TRACE.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Link: https://lore.kernel.org/20250218123121.253551-2-gmonaco@redhat.com
Fixes: 287050d39026 ("tracing: Add TRACE_EVENT_CONDITIONAL()")
Link: https://lore.kernel.org/linux-trace-kernel/20250128111926.303093-1-gmonaco@redhat.com
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/define_trace.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index e1c1079f8c8db..ed52d0506c69f 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -76,6 +76,10 @@
 #define DECLARE_TRACE(name, proto, args)	\
 	DEFINE_TRACE(name, PARAMS(proto), PARAMS(args))
 
+#undef DECLARE_TRACE_CONDITION
+#define DECLARE_TRACE_CONDITION(name, proto, args, cond)	\
+	DEFINE_TRACE(name, PARAMS(proto), PARAMS(args))
+
 /* If requested, create helpers for calling these tracepoints from Rust. */
 #ifdef CREATE_RUST_TRACE_POINTS
 #undef DEFINE_RUST_DO_TRACE
@@ -108,6 +112,8 @@
 /* Make all open coded DECLARE_TRACE nops */
 #undef DECLARE_TRACE
 #define DECLARE_TRACE(name, proto, args)
+#undef DECLARE_TRACE_CONDITION
+#define DECLARE_TRACE_CONDITION(name, proto, args, cond)
 
 #ifdef TRACEPOINTS_ENABLED
 #include <trace/trace_events.h>
@@ -129,6 +135,7 @@
 #undef DEFINE_EVENT_CONDITION
 #undef TRACE_HEADER_MULTI_READ
 #undef DECLARE_TRACE
+#undef DECLARE_TRACE_CONDITION
 
 /* Only undef what we defined in this file */
 #ifdef UNDEF_TRACE_INCLUDE_FILE
-- 
2.39.5



