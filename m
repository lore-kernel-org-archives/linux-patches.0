Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FE5388862;
	Sat, 12 Sep 2026 15:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227851; cv=none; b=NZSAGwWKZGEu50G32ph8KMi/ktrhRu6GMC90FbhwRCYqyOZxhiZOMvMcrLCwUl+U/F9fxadMYhgth6k2HX4XP81LwKaWAmRFpHP4/1/khJnPW3QnT4apPPwUnq+lAtKAz1vrX3zKBfqxx3vE/c8ke4jz/c/yyowgGYO8XlWhRC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227851; c=relaxed/simple;
	bh=tRrEXdBPSY25vXRIuU1sP+vCkRw3eCLHbMFviaqBO9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAlX1GACr6TEfT/DFVkYFQUzOElPY8tWec6x8UncKQf8aV49F28lgaNPtSgpkWS2mAo6B+3NeB9BlaWN75sZpzE/A7h+dWmXPVpp1zF6taEJq5yUbVleUmT7rSVMweiNntmJ8WsX/5iupZWman3ADPdRBOURlRwYcY0kTvJ87J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFecVIp5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFecVIp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61FA1F000FF;
	Sat, 12 Sep 2026 15:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227846;
	bh=ldhgMgQVxsK00cAfkxeo1stg1E6zBN098GH+xBj9EZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFecVIp5jhcIhg8tibdacYSVPuHlDm6IxwhwVd0R+MeDFOGdOWVf4Uzq6wdi5Jakk
	 5q7yfLv79BmMCo6T7tCes3QAF6hUYzx4Z5xAE+ViM8jRMbuvdDRQILaH3oWPCxCojC
	 CLJLpj55Z4x9zRry0TbtTYMCdxivDxooOe+rxZxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0265/1191] tracing/mmiotrace: Remove reference to unused per CPU data pointer
Date: Sat, 12 Sep 2026 08:49:53 +0200
Message-ID: <20260912065554.173513453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 6936298393d8d8bc3cec6b704f6a774162cf9bd3 upstream.

The mmiotracer referenced the per CPU array_buffer->data descriptor but
never actually used it. Remove the references to it.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/20250505212234.696945463@goodmis.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_mmiotrace.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index c523ce5aa4958..74f378fca5187 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -292,7 +292,6 @@ __init static int init_mmio_trace(void)
 device_initcall(init_mmio_trace);
 
 static void __trace_mmiotrace_rw(struct trace_array *tr,
-				struct trace_array_cpu *data,
 				struct mmiotrace_rw *rw)
 {
 	struct trace_event_call *call = &event_mmiotrace_rw;
@@ -318,12 +317,10 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 void mmio_trace_rw(struct mmiotrace_rw *rw)
 {
 	struct trace_array *tr = mmio_trace_array;
-	struct trace_array_cpu *data = per_cpu_ptr(tr->array_buffer.data, smp_processor_id());
-	__trace_mmiotrace_rw(tr, data, rw);
+	__trace_mmiotrace_rw(tr, rw);
 }
 
 static void __trace_mmiotrace_map(struct trace_array *tr,
-				struct trace_array_cpu *data,
 				struct mmiotrace_map *map)
 {
 	struct trace_event_call *call = &event_mmiotrace_map;
@@ -349,12 +346,7 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 void mmio_trace_mapping(struct mmiotrace_map *map)
 {
 	struct trace_array *tr = mmio_trace_array;
-	struct trace_array_cpu *data;
-
-	preempt_disable();
-	data = per_cpu_ptr(tr->array_buffer.data, smp_processor_id());
-	__trace_mmiotrace_map(tr, data, map);
-	preempt_enable();
+	__trace_mmiotrace_map(tr, map);
 }
 
 int mmio_trace_printk(const char *fmt, va_list args)
-- 
2.53.0



