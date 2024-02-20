Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B54151CEC;
	Tue, 20 Feb 2024 21:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465306; cv=none; b=XABa2hizkyNzFZzrYmQ9+Rrq94oK88IbIQip0a7u8UOC6QGynS/f6Kzcx4gviTEv2l0nLuiT2jP+1yecQRwE75s8QjpcQRzOVnec1kQEUHDI6yelcWwjbYJyKAi47l2Bs6jgvedd+06kNNIbSu7+vnM+fUZIj09aBp3stFku+mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465306; c=relaxed/simple;
	bh=rsFicNA44yhb7ZAW5IVLydx0FYhknrmYpGf0uEKUnxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sr2oFPPuhIJqMd1V798huwze2Oo360NTbYayjYnK6Dk2JO/dK/Oo2xknJfUY+OiT7KE+mED3PiU9k6kJ1kKPrUcZ/IYuyRqI7Kx8+CmKfyml5+tjvPfdgT2dEsGtnMktNL4nt7VeWdyWzHaGU/ax7DSG7KBbks/4wXrwaVD2414=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYovKp21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYovKp21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9B8C433C7;
	Tue, 20 Feb 2024 21:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465305;
	bh=rsFicNA44yhb7ZAW5IVLydx0FYhknrmYpGf0uEKUnxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYovKp21u2Ah9BXJk9JRyN7P3mqmIoIwjNHaQzjcGNRBdCHN5786q8NQ87Wion3w7
	 ZOYa18BPQ1/Slpon1wISIJhLWaVObJrKSk0Hmonl1vkjdbvWty8L2VKMjnHqydFmwJ
	 YMX9G6976FhgvYj/GPjba6bKU1pm+qLLyewBu5HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 302/309] tracing: Fix HAVE_DYNAMIC_FTRACE_WITH_REGS ifdef
Date: Tue, 20 Feb 2024 21:57:41 +0100
Message-ID: <20240220205642.544760592@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Pavlu <petr.pavlu@suse.com>

commit bdbddb109c75365d22ec4826f480c5e75869e1cb upstream.

Commit a8b9cf62ade1 ("ftrace: Fix DIRECT_CALLS to use SAVE_REGS by
default") attempted to fix an issue with direct trampolines on x86, see
its description for details. However, it wrongly referenced the
HAVE_DYNAMIC_FTRACE_WITH_REGS config option and the problem is still
present.

Add the missing "CONFIG_" prefix for the logic to work as intended.

Link: https://lore.kernel.org/linux-trace-kernel/20240213132434.22537-1-petr.pavlu@suse.com

Fixes: a8b9cf62ade1 ("ftrace: Fix DIRECT_CALLS to use SAVE_REGS by default")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5331,7 +5331,7 @@ static int register_ftrace_function_nolo
  * not support ftrace_regs_caller but direct_call, use SAVE_ARGS so that it
  * jumps from ftrace_caller for multiple ftrace_ops.
  */
-#ifndef HAVE_DYNAMIC_FTRACE_WITH_REGS
+#ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS
 #define MULTI_FLAGS (FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_ARGS)
 #else
 #define MULTI_FLAGS (FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_REGS)


