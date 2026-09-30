Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113B5509EF1;
	Wed, 30 Sep 2026 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790567; cv=none; b=FcizNo6E++YRrwcCM5i/hlKKFBbuEgKdmMOc2nKPMNGVJ7mzgRMxvBrcHHrW5cRXh6tSTPX0MBQCz3ZQvb11PM+j+mfa1jzIJZrvhTu0aeXSwxbydI1wNdt6XF4UjxdgzH8ZNZlm2R9OYi4cLpEdJFxZQPWv0zfVhbNBrqtal0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790567; c=relaxed/simple;
	bh=jvqxrBC294uemm03yp7wHM0M7ACBw8CKgpDT7/HUX6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzS0p8qZn4eB7tuJ0oeesje2uUvSLcePFsiMos2kgY4Qvt8kAHONziWDNLi4RjRSr2DmLf8hsF1FO6NDq3sPKZZ/btv2yYu7M0CniFK0RIajY2vZ5eSMZp2SE1GhQSAwDkK9SOsUnqfoTXTJLF+vNPyUilncB/lakR01GQ6ZbjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAAvgEAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAAvgEAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F7F1F000FF;
	Wed, 30 Sep 2026 17:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790565;
	bh=MzMHzv8Nmp4ctdewhcfvBVm5OKG5+eaoZLuup5DEEOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TAAvgEAy6Jxp2NfECQRd8klVh5YQUXXkwHo+GCMh2CSGUh3MCpYdM9apJZhqEv16E
	 iwHxdPvU1odHzIOxsGNOs9X4xrtkBQwh9GdExKpreLtYAUXxmuE0gABLeZaXT/dpQr
	 9Tczd+zKfPt+6WpQ8piqsmUAW2IfiagiNltxg+VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	kernel test robot <lkp@intel.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 872/877] tracing: Move d_max_latency out of CONFIG_FSNOTIFY protection
Date: Wed, 30 Sep 2026 17:29:43 +0200
Message-ID: <20260930152433.551411151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit b4bade506b18eb2e5e34ac84f915d7ee6156d4e2 upstream.

The tracing_max_latency shouldn't be limited if CONFIG_FSNOTIFY is defined
or not and it was moved out of that protection to be always available with
CONFIG_TRACER_MAX_TRACE. All was moved out except the dentry descriptor
for it (d_max_latency) and it failed to build on some configs.

Move that out of the CONFIG_FSNOTIFY protection too.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/20260209194631.788bfc85@fedora
Fixes: ba73713da50e ("tracing: Clean up use of trace_create_maxlat_file()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202602092133.fTdojd95-lkp@intel.com/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -341,8 +341,8 @@ struct trace_array {
 	spinlock_t		snapshot_trigger_lock;
 	unsigned int		snapshot;
 	unsigned long		max_latency;
-#ifdef CONFIG_FSNOTIFY
 	struct dentry		*d_max_latency;
+#ifdef CONFIG_FSNOTIFY
 	struct work_struct	fsnotify_work;
 	struct irq_work		fsnotify_irqwork;
 #endif


