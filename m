Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365CA2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F549C4339B;
	Tue, 18 Apr 2023 12:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820723;
	bh=iCsUvguUEwkeNA8jPaNX22SgIr+QYWwHXsboPHBEcoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4iVhVByxUzXGPnFXfkO5En0fL1//iSKTakZ9XoSvw3ZhqAUkhC5xTJdDiSHR8KMk
	 9a0WuqqJxn1bG3QJFFm/XYHPlwfOLPK/wmu4Fycd41CU5KTDmhEjQFu0DLEHRAJd+U
	 gV0WM4F8WwSnagleAyruMkvPuey7oL1NTypP3UgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	John Keeping <john@metanate.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 14/37] ftrace: Mark get_lock_parent_ip() __always_inline
Date: Tue, 18 Apr 2023 14:21:24 +0200
Message-Id: <20230418120255.165399138@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
References: <20230418120254.687480980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Keeping <john@metanate.com>

commit ea65b41807a26495ff2a73dd8b1bab2751940887 upstream.

If the compiler decides not to inline this function then preemption
tracing will always show an IP inside the preemption disabling path and
never the function actually calling preempt_{enable,disable}.

Link: https://lore.kernel.org/linux-trace-kernel/20230327173647.1690849-1-john@metanate.com

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Fixes: f904f58263e1d ("sched/debug: Fix preempt_disable_ip recording for preempt_disable()")
Signed-off-by: John Keeping <john@metanate.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ftrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -723,7 +723,7 @@ static inline void __ftrace_enabled_rest
 #define CALLER_ADDR5 ((unsigned long)ftrace_return_address(5))
 #define CALLER_ADDR6 ((unsigned long)ftrace_return_address(6))
 
-static inline unsigned long get_lock_parent_ip(void)
+static __always_inline unsigned long get_lock_parent_ip(void)
 {
 	unsigned long addr = CALLER_ADDR0;
 


