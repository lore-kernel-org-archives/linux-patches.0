Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946E1168C4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDEEC433EF;
	Mon,  8 May 2023 11:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545475;
	bh=VsRCM+Vk5hWR0iQfMAkv7FU/4cUfkFfZbh+aLmCtIKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIzEnYFTzYKJPkPvR2mh0RZzk2HWhbTa/MHCTxc19uztc2UZ+WbNTu5AdP0hcCSpv
	 vzGt1IuIdFRLqdYxZoGnF0SbWwEbng6D8Kh/lkhyUm779T7TVxLBrJMqxeDY67XaKa
	 NqMROL+iXm/1yQgZF0WJzHiBpu8Zt6vb1n+mPX5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 051/371] tracing: Fix permissions for the buffer_percent file
Date: Mon,  8 May 2023 11:44:12 +0200
Message-Id: <20230508094814.096796092@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 4f94559f40ad06d627c0fdfc3319cec778a2845b upstream.

This file defines both read and write operations, yet it is being
created as read-only. This means that it can't be written to without the
CAP_DAC_OVERRIDE capability. Fix the permissions to allow root to write
to it without the need to override DAC perms.

Link: https://lore.kernel.org/linux-trace-kernel/20230503140114.3280002-1-omosnace@redhat.com

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 03329f993978 ("tracing: Add tracefs file buffer_percentage")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9565,7 +9565,7 @@ init_tracer_tracefs(struct trace_array *
 
 	tr->buffer_percent = 50;
 
-	trace_create_file("buffer_percent", TRACE_MODE_READ, d_tracer,
+	trace_create_file("buffer_percent", TRACE_MODE_WRITE, d_tracer,
 			tr, &buffer_percent_fops);
 
 	create_trace_options_dir(tr);


