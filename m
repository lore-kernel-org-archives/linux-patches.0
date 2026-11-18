Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044033;
	b=ZOop25jQsX/+5Kj0t4OwJ3mNnaLDJr9G6J2G3oKSwDfEN36qipTgsDRLRU1hHSR/q++P
	 QSUeLioysNt4dYIQR0v6UjKY3yUT8vb0u7nn3uw9gAPBN9USLg2xc/PWppfTHfjxkPvVV
	 MRIag4LigLPIvTne2UtApGbhRJp72A65lsT92mxeYp1dSM+COQFmi8F49GKpJclNbEjZ9
	 h/S+2YGtZtF/uNhxJ+yxrEfO0ZQ9KgaozCG/ImcIxRclBk1l3m4cOz9Rm1Ffa3YdJxuah
	 LakAKzfZEH4U3oacGFh7y4AcK5/q3oM/sA++Kzh4/5f0wJ53GxbBDOz1xUj3w/Sff2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q7mfJ8KPZ91fWLDXGc+fRomsU/iprOG64yLU3jmW7Do=;
	b=E5T+K742aNk6GAKSpcD//IiT87Lu4JNXHshcFyXKiQUWEe84d7jGoSx+DoozPp31cg/B
	 etixyr04Ioz6krTgRGwWFahLYGX8UCfYkBjSYEx0Wj83rrgE6O5X3LQkcJOayCS/pQT6q
	 2yO/CQfnRR6119ZD9n3A0ZW+v6NhkB7kBplEPcXAc2VqBvVfgX89lJWxnA313q0IgwlmH
	 4JwNePwXpwBt0e5IgRQfTDYGRVpVvk693waXN0hj/uXjbddkvdsH2NrzrpsHDd0k5zBnw
	 T7ltkcDdxWYvZZPhqkm9jRYMdD5wnLa0c+xdKEwzKQeXUU91v5msCsm4EW4Mh6QFCng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FTfSpf5C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF4C606A31C;
	Wed, 18 Nov 2026 23:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FTfSpf5C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE24C1F000C4;
	Wed, 18 Nov 2026 23:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044033;
	bh=Q7mfJ8KPZ91fWLDXGc+fRomsU/iprOG64yLU3jmW7Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTfSpf5Ccg0R5iAx/cKy8Saf6WEX/D64Z4XeCWWyLWOUnCu9ghFiUulxSDvGtTNW0
	 0zJjORKAman9VvLrpXpzE7k4Eh0tiL5ee0ycqVqvyEZvMRBx9rILnDWdlSG1Fu4mkw
	 wN+fifEjEcRunjqPCuoRQc5c2sDqEfQvuXMwEsDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0424/2857] tracing: Take trace_array reference when opening a tracer options file
Date: Wed, 18 Nov 2026 15:24:18 +0100
Message-ID: <20261118150216.651580951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit ed0aff60f83a9bdc2f6556376ac79c96b3ce7e80 ]

When a tracer option file is opened, it is passed a descriptor that points
to an element on the trace_array's topts array. This element has
information to find the trace array and other information. It uses this
element to take a reference of the trace_array so that the trace_array
does not get removed while this file is opened.

Unfortunately, there's a race condition where the element itself could be
freed by the removal of the instance the trace_array represents causing a
use-after-free as this element that is used to find the trace_array to
increment its reference counter is also freed when the instance is
removed.

To solve this, add a trace_array_tracer_options_get() helper function that
will take the address of the element that is passed to the open function
by the inode->i_private pointer and search all the trace_arrays under a
lock to find the one that the element's address is in the range of the
trace_arrays topts array elements. When a match happens, that trace_array's
reference would be increased.

Note, there's a race where if an admin was deleting and creating trace
instances at the same time and the memory of the old trace_array's array
matched the memory of the new trace_array that it could in theory open the
option from the wrong trace array. But we do not care because it would be
stupid to perform that kind of action. As long as the only thing that can
happen is that the option from the wrong trace array is used and doesn't
crash the kernel it will only make the user confused. But if they are
doing something stupid like this, they are already confused, so no harm
done.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260910221209.62dad8d3@robin
Fixes: 7e2cfbd2d3c86 ("tracing: Have option files inc the trace array ref count")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-trace-kernel/20260902121918.5a9e9d1b@gandalf.local.home/
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ sashal: replaced the missing __trace_array_get() helper call with an open-coded tr->ref++; return 0; inside the already-locked list walk. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 48 +++++++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace.h |  1 +
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bf8f3ca9df076..1d9625a95cc8e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8919,12 +8919,57 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	return cnt;
 }
 
+static bool tr_option_match(struct trace_array *tr, void *topt)
+{
+	for (int i = 0; i < tr->nr_topts; i++) {
+		struct trace_options *tr_topts = &tr->topts[i];
+
+		if (topt >= (void *)&tr_topts->topts[0] &&
+		    topt < (void *)&tr_topts->topts[tr_topts->nr_topts])
+			return true;
+	}
+	return false;
+}
+
+/*
+ * The topt is the address of a trace_array->topts[] element that holds the
+ * the tracer options descriptor. But since the trace_array reference has not
+ * been taken yet, it cannot be dereferenced as it could have been freed by
+ * a rmdir of the instance the trace_array represents.
+ *
+ * Search the list of trace_arrays and compare the topt to the address of
+ * the entire trace_array topts array for each trace_array in the list.
+ * If one is matched, then take the reference and return it. If not, the
+ * trace_array no longer exits.
+ */
+static int trace_array_tracer_options_get(void *topt)
+{
+	struct trace_array *tr;
+	int ret;
+
+	ret = security_locked_down(LOCKDOWN_TRACEFS);
+	if (ret)
+		return ret;
+
+	if (tracing_disabled)
+		return -ENODEV;
+
+	guard(mutex)(&trace_types_lock);
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		if (tr_option_match(tr, topt)) {
+			tr->ref++;
+			return 0;
+		}
+	}
+	return -ENODEV;
+}
+
 static int tracing_open_options(struct inode *inode, struct file *filp)
 {
 	struct trace_option_dentry *topt = inode->i_private;
 	int ret;
 
-	ret = tracing_check_open_get_tr(topt->tr);
+	ret = trace_array_tracer_options_get(topt);
 	if (ret)
 		return ret;
 
@@ -9208,6 +9253,7 @@ create_trace_option_files(struct trace_array *tr, struct tracer *tracer)
 	tr->topts = tr_topts;
 	tr->topts[tr->nr_topts].tracer = tracer;
 	tr->topts[tr->nr_topts].topts = topts;
+	tr->topts[tr->nr_topts].nr_topts = cnt;
 	tr->nr_topts++;
 
 	for (cnt = 0; opts[cnt].name; cnt++) {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f86b6f263ddf6..c6b3eba6899f6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -202,6 +202,7 @@ struct array_buffer {
 struct trace_options {
 	struct tracer			*tracer;
 	struct trace_option_dentry	*topts;
+	int				nr_topts;
 };
 
 struct trace_pid_list *trace_pid_list_alloc(void);
-- 
2.53.0



