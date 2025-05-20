Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2209EC4;
	Tue, 20 May 2025 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749479; cv=none; b=hIrHaWmtw5EE5hbsczW+SKHS9TrWHu2RoFu+CJnAEwOk2zv2vrYl15jq2YSn3V0ugbP+Y4fA7gCGF0i6q2O45+UoOYyb5IJ7inGw7AmmGF6cWNAKQKzcw37A3ChOT2JkfRXVPp2wceoPZ+ua3aova7qFxU97r2nKn7e7t5Gmqh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749479; c=relaxed/simple;
	bh=sIcKH49H0s6jWp2+ZTY/em5/Knc3pd+T4b5X17eAhdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uheb9fXpHDlJHAPbC9UqCJ3zHBtsn2aV5M9f87r5JonHTF1pmvEK+txmSisaFFSKfNKUfcpPEHA/5f0jDqGXeHe48rZTNYrJh+wnzv0yTSdeyYFeAzvQJC32bVGXVw3Ez4VtC/x99/Te/aK+ATepP+P5w4WZ3F8TlbRHreUXkHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPNHHlXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPNHHlXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651A2C4CEE9;
	Tue, 20 May 2025 13:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749479;
	bh=sIcKH49H0s6jWp2+ZTY/em5/Knc3pd+T4b5X17eAhdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPNHHlXNV+wLtLfYC4CkqEAeL3mWNTM2utyC+OvqrUN/Kg7rVcI0RhqVWM4I5KO2A
	 AD5b9SFm2tXpq0svNZcjhSAZtklHY38muyQ+3MgdS7P9U6JRsooLGkDbtQlswaU0gK
	 h723olgrTTKxuTCjcFGEcmznzIvB46SSFnnIKvCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Divya Indi <divya.indi@oracle.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 57/97] tracing: samples: Initialize trace_array_printk() with the correct function
Date: Tue, 20 May 2025 15:50:22 +0200
Message-ID: <20250520125802.889110435@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit 1b0c192c92ea1fe2dcb178f84adf15fe37c3e7c8 upstream.

When using trace_array_printk() on a created instance, the correct
function to use to initialize it is:

  trace_array_init_printk()

Not

  trace_printk_init_buffer()

The former is a proper function to use, the latter is for initializing
trace_printk() and causes the NOTICE banner to be displayed.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Divya Indi <divya.indi@oracle.com>
Link: https://lore.kernel.org/20250509152657.0f6744d9@gandalf.local.home
Fixes: 89ed42495ef4a ("tracing: Sample module to demonstrate kernel access to Ftrace instances.")
Fixes: 38ce2a9e33db6 ("tracing: Add trace_array_init_printk() to initialize instance trace_printk() buffers")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/ftrace/sample-trace-array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/ftrace/sample-trace-array.c
+++ b/samples/ftrace/sample-trace-array.c
@@ -112,7 +112,7 @@ static int __init sample_trace_array_ini
 	/*
 	 * If context specific per-cpu buffers havent already been allocated.
 	 */
-	trace_printk_init_buffers();
+	trace_array_init_printk(tr);
 
 	simple_tsk = kthread_run(simple_thread, NULL, "sample-instance");
 	if (IS_ERR(simple_tsk)) {


