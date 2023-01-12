Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7F179C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DA3C433D2;
	Thu, 12 Jan 2023 14:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534130;
	bh=ImpJ5Ma5yRxB38pco1XNWpfo5aDPEMjz3RvoEPfzQ5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJ5HOySoP9e2Pge0lXE2rYidgWVcbSvyBXxVCY33qkmEZNVOSkwn9aL6iLWETn3+D
	 E4y4bhWWX/OLcJHX6P36oOUREXpaFvUYdV7qNahahHXfxuFxVP3dJqPy9GHjn1xqIT
	 hvQOvlY2BTd4s9UiuO/9oBSqUxP5zkIts9++l+O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@linux.alibaba.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 706/783] riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument
Date: Thu, 12 Jan 2023 14:57:02 +0100
Message-Id: <20230112135557.090086495@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit 5c3022e4a616d800cf5f4c3a981d7992179e44a1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 6cbde6b43fd2..1e53fbe5eb78 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -63,7 +63,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		} else {
 			fp = frame->fp;
 			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
-						   (unsigned long *)(fp - 8));
+						   &frame->ra);
 		}
 
 	}
-- 
2.35.1



