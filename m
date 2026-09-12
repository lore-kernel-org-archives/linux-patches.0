Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0290F2EC09B;
	Sat, 12 Sep 2026 11:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212584; cv=none; b=SliLoeOWbaWRyL/LGYJ7MyNqAKobNzT0es4iShgffznjwhQA9KZhDXf7LJNvLDvCKmnv8KcRJECHlX5S819ijyju52UYVmCnTferzt0Nv9cbCw+ilcUbTqp99/W8Zx1lEOJvuWKfz8Hd7cPScsrUDr32uDAzEugdKxpHYtg8z4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212584; c=relaxed/simple;
	bh=OhSq3WrbfZJwQ/19LwnXIo6mHc000a7KG6OvPA0/Auw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vfl5VJwiYWRxZVt11sT8AZBCrg42T4b7DAZKGUebSFCrpHYfAoQWzzndgtUt9XKnBpz86VXhRdHe0UB3Ktjn6JJxiqdPM4tGpZsIzh8xI9bi9sYbtt0W6Rp4GpoNNW7juSeIjyHuHWIOY9+b5po8KZOvH1HdCaeDNR7aPV5rfsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qaO1ezb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qaO1ezb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCFB1F000FF;
	Sat, 12 Sep 2026 11:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212582;
	bh=VTjZGMdGAEiS+TN5pBRmIcJijckCL8SYtEmwbR0/pJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2qaO1ezb+DfVd0XA6z1oZx03MI+DKcW7B7D6LiwgzeKMNyOSJeQBz0Nn+OrHNpBwe
	 R6R3m98e/7UfpwiJsN1QCch+B/K+xOg/CxAROPCFhL18KAKZsNigvAN27dMwWpNnfW
	 hpEA6CO3pZeB2wbXDg2BSl7oDeEz8lDwZOhGARmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	kernel test robot <lkp@intel.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1464/1518] tracing: Move d_max_latency out of CONFIG_FSNOTIFY protection
Date: Sat, 12 Sep 2026 09:00:33 +0200
Message-ID: <20260912065656.672282736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit b4bade506b18eb2e5e34ac84f915d7ee6156d4e2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 89e4d619e64b9..729b1921f9554 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -346,8 +346,8 @@ struct trace_array {
 	spinlock_t		snapshot_trigger_lock;
 	unsigned int		snapshot;
 	unsigned long		max_latency;
-#ifdef CONFIG_FSNOTIFY
 	struct dentry		*d_max_latency;
+#ifdef CONFIG_FSNOTIFY
 	struct work_struct	fsnotify_work;
 	struct irq_work		fsnotify_irqwork;
 #endif
-- 
2.53.0



