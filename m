Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B2D2D839B;
	Tue,  6 Jan 2026 17:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720880; cv=none; b=gYtvQ+8VAWKBLvOs4ETZfNFzDBj3Wwfay5Ixb1ES7Dks+qWyGGgvKN/Sbd0jwmTP0f0PEYgEwbUte8QsaZcuCe8uf/qplZ02wCuYZhoWvQjOFRX7dPLCf6w9iGOQ/2fYlSKk26xferv0wFPH2+KJkipYe/HK3mV97XxRJNvTlbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720880; c=relaxed/simple;
	bh=Mj/8vridAY/MrysGrd39HOn9yM6nonty8mbrxdpbndY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlRlmgLzFIgqrq5s4cLBv4uRAVUhK5A74l5utLF/+WGyKqBwfH8kQTL5BJv3uX27iJshb9v81m7v1cgljXLaLIKwu1lTUgsA7whf2GGJgZLOf0M17tNk7ALG74wacAcitNd4IpDj8qX+E7W3siArrlgVDi7cPb7Y6LhFrHFRRm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrnZKKSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrnZKKSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB18C16AAE;
	Tue,  6 Jan 2026 17:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720880;
	bh=Mj/8vridAY/MrysGrd39HOn9yM6nonty8mbrxdpbndY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrnZKKSOye9+gGgwm6A/rHm5pt66acJNUfx4E56PzhsBL8XfPBbj6bhAylJrePtiO
	 O30ad3t2UeBHXavNJ1KgHvL/RjJVN8iG7p778GuDAb/+WlBJDJE+7IskNp9Mo/ZvKc
	 Nuqp0grbEGnVsSEAf1324kgc2tdgEUnakhojF9Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wang.yaxin@zte.com.cn,
	mhiramat@kernel.org,
	mark.rutland@arm.com,
	mathieu.desnoyers@efficios.com,
	zhang.run@zte.com.cn,
	yang.yang29@zte.com.cn,
	Shengming Hu <hu.shengming@zte.com.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 369/567] fgraph: Check ftrace_pids_enabled on registration for early filtering
Date: Tue,  6 Jan 2026 18:02:31 +0100
Message-ID: <20260106170504.991306646@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Shengming Hu <hu.shengming@zte.com.cn>

commit 1650a1b6cb1ae6cb99bb4fce21b30ebdf9fc238e upstream.

When registering ftrace_graph, check if ftrace_pids_enabled is active.
If enabled, assign entryfunc to fgraph_pid_func to ensure filtering
is performed before executing the saved original entry function.

Cc: stable@vger.kernel.org
Cc: <wang.yaxin@zte.com.cn>
Cc: <mhiramat@kernel.org>
Cc: <mark.rutland@arm.com>
Cc: <mathieu.desnoyers@efficios.com>
Cc: <zhang.run@zte.com.cn>
Cc: <yang.yang29@zte.com.cn>
Link: https://patch.msgid.link/20251126173331679XGVF98NLhyLJRdtNkVZ6w@zte.com.cn
Fixes: df3ec5da6a1e7 ("function_graph: Add pid tracing back to function graph tracer")
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fgraph.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -1286,6 +1286,13 @@ int register_ftrace_graph(struct fgraph_
 
 	ftrace_graph_active++;
 
+	/* Always save the function, and reset at unregistering */
+	gops->saved_func = gops->entryfunc;
+#ifdef CONFIG_DYNAMIC_FTRACE
+	if (ftrace_pids_enabled(&gops->ops))
+		gops->entryfunc = fgraph_pid_func;
+#endif
+
 	if (ftrace_graph_active == 2)
 		ftrace_graph_disable_direct(true);
 
@@ -1305,8 +1312,6 @@ int register_ftrace_graph(struct fgraph_
 	} else {
 		init_task_vars(gops->idx);
 	}
-	/* Always save the function, and reset at unregistering */
-	gops->saved_func = gops->entryfunc;
 
 	ret = ftrace_startup_subops(&graph_ops, &gops->ops, command);
 	if (!ret)


