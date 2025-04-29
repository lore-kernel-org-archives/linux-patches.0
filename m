Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDB4224222;
	Tue, 29 Apr 2025 18:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949697; cv=none; b=hE6wwMgzBIHSpJ1ayG7rm+KXE9TTQHCnpXyRl4IDO3mb7jGp+9/MVP5VCZrsZCBNO9TaDc4NN4jNlVJNgE3RFIjP8SiAfexBolIHMOJXIOsbEOC+TbHOleqy/VPal86/76ysX7+auH8vp2olrkX0NzK/Lq6MGOqwbRNaJVh4tTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949697; c=relaxed/simple;
	bh=W7DLyXstXVJzbk+9bKWuZIb3os1QuCSgSJis3n3CA14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXJsWiz/dvNQcFwDruLF4RrbRVXiNAGR4PaCO8LMrKV4wm+VTiagwm1Ngmnp/NWHAXtGXxQ5Vb4LKQFE83TAExE1VEBG4MpMzkqkYz3OGPBjwTeOKgz3tgCWvZih1gjisg8+THCWSsGsk+5KdVefRTHjadOavvJy+Rrs/k0/Gns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOaKni4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOaKni4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4748C4CEE3;
	Tue, 29 Apr 2025 18:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949697;
	bh=W7DLyXstXVJzbk+9bKWuZIb3os1QuCSgSJis3n3CA14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOaKni4RU3pS7q5P9sOmxPUDCqxyhc0Jg1I0AWA+NL0cE2ftxaTg55eQma7PFMMZu
	 Gs+iMiMMqTaiBPLTCvxDRLBRyDoIHJXlPEX1jdCzgOez3cEUVeLgZwPRVc/fRVY1zp
	 izUg/F6N3vTUHwJAsf/+2ALN9ciZxhSWJlajzasI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/167] tracing: Add __string_len() example
Date: Tue, 29 Apr 2025 18:41:53 +0200
Message-ID: <20250429161051.966318846@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit dd6ae6d90a84d4bec49887c7aa2b22aa1c8b2897 ]

There's no example code that uses __string_len(), and since the sample
code is used for testing the event logic, add a use case.

Link: https://lore.kernel.org/linux-trace-kernel/20240223152827.5f9f78e2@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: ea8d7647f9dd ("tracing: Verify event formats that have "%*p.."")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/trace_events/trace-events-sample.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 1c6b843b8c4ee..04541dfbd44cc 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -302,6 +302,7 @@ TRACE_EVENT(foo_bar,
 		__bitmask(	cpus,	num_possible_cpus()	)
 		__cpumask(	cpum				)
 		__vstring(	vstr,	fmt,	va		)
+		__string_len(	lstr,	foo,	bar / 2 < strlen(foo) ? bar / 2 : strlen(foo) )
 	),
 
 	TP_fast_assign(
@@ -310,12 +311,13 @@ TRACE_EVENT(foo_bar,
 		memcpy(__get_dynamic_array(list), lst,
 		       __length_of(lst) * sizeof(int));
 		__assign_str(str, string);
+		__assign_str(lstr, foo);
 		__assign_vstr(vstr, fmt, va);
 		__assign_bitmask(cpus, cpumask_bits(mask), num_possible_cpus());
 		__assign_cpumask(cpum, cpumask_bits(mask));
 	),
 
-	TP_printk("foo %s %d %s %s %s %s (%s) (%s) %s", __entry->foo, __entry->bar,
+	TP_printk("foo %s %d %s %s %s %s %s (%s) (%s) %s", __entry->foo, __entry->bar,
 
 /*
  * Notice here the use of some helper functions. This includes:
@@ -359,7 +361,8 @@ TRACE_EVENT(foo_bar,
 		  __print_array(__get_dynamic_array(list),
 				__get_dynamic_array_len(list) / sizeof(int),
 				sizeof(int)),
-		  __get_str(str), __get_bitmask(cpus), __get_cpumask(cpum),
+		  __get_str(str), __get_str(lstr),
+		  __get_bitmask(cpus), __get_cpumask(cpum),
 		  __get_str(vstr))
 );
 
-- 
2.39.5



