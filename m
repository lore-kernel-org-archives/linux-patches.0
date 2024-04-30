Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B41127B70;
	Tue, 30 Apr 2024 10:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473734; cv=none; b=uw7vG4KErbrxENijzvao2FJIxw00JhgZ3baGsGYKFyrd0tzcqwr9zrk1RdcbwJEuHgC51jAAVH4QSUd/YydkRv51joY7J7Z8ga7hCKgKW0ZyBNdyFbuRWwj847OUwFMo8CIeY4IkUYH1W2sdKad+Jc/ZAZgf0kRYYHZr6z43stA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473734; c=relaxed/simple;
	bh=kOxIqRD/O+3VSnI4BCB9E0otHSiLmg5IpBB96fxW1d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uo8j3++PegS7Az2ixR/g3DHpZWYr+jXDUoL+vkMXuuX+sYyOpWeqDOGUAb4sdrhFYI/gLsYUqGlxwNg/z5iFiO8761HZzuEs8jRkXaYB2Ky9QbG8c+9l5+53dpu9Su6VKihKlpp6JuVPG/4+Tmgqgw91/AbPgQEKDyB9WJSWiBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0idgx68c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0idgx68c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9117C2BBFC;
	Tue, 30 Apr 2024 10:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473734;
	bh=kOxIqRD/O+3VSnI4BCB9E0otHSiLmg5IpBB96fxW1d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0idgx68cc5CC0amEAs1h9qhdlecRGn1Pk7Mwz3jz0UvtZ3yss1D7gWYT6LkwOJNyA
	 KVIW4NV/qraL+pA0LKBkazZi3FR7rT+PMKqMMwnY+6gkG49yM68avfuUcnp/HYzM+3
	 wICwDu5WlfkPgXEmASyUa+UF1P/2F/Y8UzhGY6Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Kees Cook <keescook@chromium.org>,
	Ajay Kaher <akaher@vmware.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/77] tracing: hide unused ftrace_event_id_fops
Date: Tue, 30 Apr 2024 12:38:48 +0200
Message-ID: <20240430103041.395760584@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5281ec83454d70d98b71f1836fb16512566c01cd ]

When CONFIG_PERF_EVENTS, a 'make W=1' build produces a warning about the
unused ftrace_event_id_fops variable:

kernel/trace/trace_events.c:2155:37: error: 'ftrace_event_id_fops' defined but not used [-Werror=unused-const-variable=]
 2155 | static const struct file_operations ftrace_event_id_fops = {

Hide this in the same #ifdef as the reference to it.

Link: https://lore.kernel.org/linux-trace-kernel/20240403080702.3509288-7-arnd@kernel.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Zheng Yejian <zhengyejian1@huawei.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ajay Kaher <akaher@vmware.com>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Clément Léger <cleger@rivosinc.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Fixes: 620a30e97feb ("tracing: Don't pass file_operations array to event_create_dir()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1309,6 +1309,7 @@ static int trace_format_open(struct inod
 	return 0;
 }
 
+#ifdef CONFIG_PERF_EVENTS
 static ssize_t
 event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
@@ -1323,6 +1324,7 @@ event_id_read(struct file *filp, char __
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
 }
+#endif
 
 static ssize_t
 event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
@@ -1727,10 +1729,12 @@ static const struct file_operations ftra
 	.release = seq_release,
 };
 
+#ifdef CONFIG_PERF_EVENTS
 static const struct file_operations ftrace_event_id_fops = {
 	.read = event_id_read,
 	.llseek = default_llseek,
 };
+#endif
 
 static const struct file_operations ftrace_event_filter_fops = {
 	.open = tracing_open_generic,


