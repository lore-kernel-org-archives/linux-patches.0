Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D48345EB9;
	Sat, 12 Sep 2026 16:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230245; cv=none; b=JoyMHjSbkrCKwIlqz5oQGw5sQJjJNZve+W3GRBwA1XD0xo3wOoPRBQTytyDxlw/OVidhzd+3x/62VP5Y0fgchBH9CSOaJIfSR+AYviykozaRs8ph6WuLPhLTmala9cHj3rGTXrCpfPc4k0rIm4B+NxZeUMa5Z8C/ts/paMyFDW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230245; c=relaxed/simple;
	bh=+XhP38IR3aUu1Y8FlB9rUBodHyuqTg+LLmgJcZ1UvK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyzid00prITPHiFIR6wl/5wEvM7tVWLVI2hZxCq5IzGBIFaB9MDJ+V9a7TEjRdi6Os06Qa5mnXYbnb2vWqe2CXXeOd3zsu7CThUL9WDtHPeKeRhnLJc9gXgYEOiHlLz4kEAmhyWPG9qyqHWZYHWpV7dQk58KcSf4COG4bzqMyDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GL7FLPpK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GL7FLPpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE061F000FF;
	Sat, 12 Sep 2026 16:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230243;
	bh=+Bk3nUKSDJjAStNTw52BYtpz0tIXgUDiHYWoGimoSLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GL7FLPpKl6aJK0NsBFRLFExtP+hZgDd7657qDTfnRrCtQgCwn0y3NY3bUY6lirDh/
	 I/tkNYEykN6mHIJd56IXTdcy1QpC7F5Kz0tlBwWJeOblfMkswgqp9GPuUm9oRJray8
	 UqZnOHV+Q7GyrVn8/C8KZs9iU0kH4xvq/YqN0Jdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0755/1191] tracing/osnoise: Add PANIC_ON_STOP option
Date: Sat, 12 Sep 2026 08:58:03 +0200
Message-ID: <20260912065605.237081193@linuxfoundation.org>
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

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit 1603dda47714cebe8a29b2154407da7a929d13f4 ]

Often the latency observed in a CPU is not caused by the work being done
in the CPU itself, but by work done on another CPU that causes the
hardware to stall all CPUs. In this case, it is interesting to know
what is happening on ALL CPUs, and the best way to do this is via
crash dump analysis.

Add the PANIC_ON_STOP option to osnoise/timerlat tracers. The default
behavior is having this option off. When enabled by the user, the system
will panic after hitting a stop tracing condition.

This option was motivated by a real scenario that Juri Lelli and I
were debugging.

Link: https://lkml.kernel.org/r/249ce4287c6725543e6db845a6e0df621dc67db5.1670623111.git.bristot@kernel.org

Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 27d73e81195b ("rcu: Mark accesses to ->rcu_urgent_qs and ->rcu_need_heavy_qs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_osnoise.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 3319f940d78e6..37653a871d75d 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -54,10 +54,11 @@
 enum osnoise_options_index {
 	OSN_DEFAULTS = 0,
 	OSN_WORKLOAD,
+	OSN_PANIC_ON_STOP,
 	OSN_MAX
 };
 
-static const char * const osnoise_options_str[OSN_MAX] = { "DEFAULTS", "OSNOISE_WORKLOAD" };
+static const char * const osnoise_options_str[OSN_MAX] = { "DEFAULTS", "OSNOISE_WORKLOAD", "PANIC_ON_STOP" };
 
 #define OSN_DEFAULT_OPTIONS	0x2
 unsigned long osnoise_options	= OSN_DEFAULT_OPTIONS;
@@ -1271,6 +1272,9 @@ static __always_inline void osnoise_stop_tracing(void)
 		trace_array_printk_buf(tr->array_buffer.buffer, _THIS_IP_,
 				"stop tracing hit on cpu %d\n", smp_processor_id());
 
+		if (test_bit(OSN_PANIC_ON_STOP, &osnoise_options))
+			panic("tracer hit stop condition on CPU %d\n", smp_processor_id());
+
 		tracer_tracing_off(tr);
 	}
 	rcu_read_unlock();
-- 
2.53.0



