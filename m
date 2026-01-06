Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EE5364E89;
	Tue,  6 Jan 2026 17:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722024; cv=none; b=W1BEavAvK+jY4qC3/95QYmzg7n4eBrZrJV/7TqVUtsxPUeTjFd2jMbVCMsetpfunp6vCwMzkeHZsrSizTW8kAf2SXPFhHQbNp5pyFdkgykmTWeq0nwxjK8QdVVQwxw2Gc1JxkjNaTWvc9zSsAErBODTP4mW6dODGcJqwFQMzfts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722024; c=relaxed/simple;
	bh=lbcQRH7pvMkqdW5WCsYNO0Kn6uOpoz2lvehG+MI3DZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUQEX81sokMYMi22/uH2jMuYEPyJ7pTteJJo0j9dIEfh5Ms4FciZ/O/bae/b015rR93GkkT4R1Tv1EToOehBvIywtMFNQ8n/bK5eWrBW04hiiyUYMxwqPStk+XUyCAzZt5z441NH6Is9Nev+yRO6yTjTjREdylcmuz/G0xs57hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKSSVRUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKSSVRUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660DDC16AAE;
	Tue,  6 Jan 2026 17:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722023;
	bh=lbcQRH7pvMkqdW5WCsYNO0Kn6uOpoz2lvehG+MI3DZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKSSVRUeWIscaKVWhWQAPGHyf3oD36lFLh0BMrfSjXwTa1OToc3TNz5OcCHHqtglE
	 TXSfRc+Fo3xDZf6Ihf88jtkIO86a2HPdBPgs+URRzGbCtDOpLlwM+qaB+UPhUXM3fU
	 ZVNiw10EyQL0ErxdMs7aH/6U2p0eRcDyn6HidPwU=
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
Subject: [PATCH 6.18 125/312] fgraph: Check ftrace_pids_enabled on registration for early filtering
Date: Tue,  6 Jan 2026 18:03:19 +0100
Message-ID: <20260106170552.366326434@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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
@@ -1377,6 +1377,13 @@ int register_ftrace_graph(struct fgraph_
 
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
 
@@ -1396,8 +1403,6 @@ int register_ftrace_graph(struct fgraph_
 	} else {
 		init_task_vars(gops->idx);
 	}
-	/* Always save the function, and reset at unregistering */
-	gops->saved_func = gops->entryfunc;
 
 	gops->ops.flags |= FTRACE_OPS_FL_GRAPH;
 


