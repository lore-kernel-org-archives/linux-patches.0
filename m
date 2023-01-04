Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFB4AD4A
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B911AC433EF;
	Wed,  4 Jan 2023 16:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849349;
	bh=wHJNlAyPP2Wn7YPgX7H3tucz7VLrm4cDpOvW54T+hXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLjDizyGpnxVGl3X4sth+ohoKSpOrLid4ffuphzZYsPFRhgUm+MNOd6JsJoqlnI1P
	 pPwL6xoJP3ouviATUQoHurPyTnnvlY+OcrtZ9cYec2l7xeJKYzIWUFQI0Wl+7MwrXW
	 3QK7ilv+Xr7mjhuYIjqCpzBXl5uGbQkwyNky5M1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@linux.alibaba.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.0 107/177] riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument
Date: Wed,  4 Jan 2023 17:06:38 +0100
Message-Id: <20230104160510.886659535@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guo Ren <guoren@linux.alibaba.com>

commit 5c3022e4a616d800cf5f4c3a981d7992179e44a1 upstream.

The 'retp' is a pointer to the return address on the stack, so we
must pass the current return address pointer as the 'retp'
argument to ftrace_push_return_trace(). Not parent function's
return address on the stack.

Fixes: b785ec129bd9 ("riscv/ftrace: Add HAVE_FUNCTION_GRAPH_RET_ADDR_PTR support")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20221109064937.3643993-2-guoren@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/stacktrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -58,7 +58,7 @@ void notrace walk_stackframe(struct task
 		} else {
 			fp = frame->fp;
 			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
-						   (unsigned long *)(fp - 8));
+						   &frame->ra);
 		}
 
 	}


