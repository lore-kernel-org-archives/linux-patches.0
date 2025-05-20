Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5818F2472BA;
	Tue, 20 May 2025 14:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749984; cv=none; b=RP/NK0qRPrkdwcd5kY7FSbRp+Oh8HSFKagJ4D5Q7toPEApcopephVYKq5BGB+tLgAe/VFwsEGBabUW5effwg7sdT6vIrKVDw9R58mvCSbKsZNpqBIXE+wdip8hNKvKdzbYjGUtQE+wXVAVgunOn4veif4kNl6uG7a3SwSeHZF44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749984; c=relaxed/simple;
	bh=FNhHK+vIU626XLH9xWgj5KHoVOtz0RNejOxNugX8W3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2hk1X+EaJsDTeiLHM2jq2+sOxTgz9r68uvSIBJICIeCkJ0QxwxNHXEdlXPQ001ACg+U+lJWtNiM31KETeUIRJUTyYbpJBS6we41dxjrrNpOYi4WsR1li6cfh7szi9I28dOksx/22dthqoMQ7ZjgeejwSLlbl6C4k1QLU+/zxTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDpeh/jK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDpeh/jK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EB5C4CEF1;
	Tue, 20 May 2025 14:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749984;
	bh=FNhHK+vIU626XLH9xWgj5KHoVOtz0RNejOxNugX8W3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDpeh/jKnX3KpNAzgRyR+h0aL7unk3RNa3tmTXThiT4Y7qNqAJDBzMQKYq7sU82Q8
	 bqxfRNkVbWqDTJFXEFRZwSdrkaHX32ly2Zr/f6yxZcy1lz7+opWmpuEy/eGrxYkOct
	 h8iXlzS8Si08FTNV1k60zdMwdKJ3GmLCn67FKyIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Divya Indi <divya.indi@oracle.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 082/117] tracing: samples: Initialize trace_array_printk() with the correct function
Date: Tue, 20 May 2025 15:50:47 +0200
Message-ID: <20250520125807.248591976@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


