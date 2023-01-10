Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABAE6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B091CC433EF;
	Tue, 10 Jan 2023 18:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375242;
	bh=LitOQAqDf6xYpF3xx9I0UAMH8jwSx6PXZnV7i2zHhdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6CTTIyQLVwqltK9Vdz/QqI/c2PnOWw5rx1mKh3UG1tPO1xA72KwZH9y+mVdv58Uz
	 rlqy8jZ0q7QjQcsfJLfvuDnjVCYTfjP/3acR83gw3gzQNnLyRWYiOeLYRGgPO6kUnb
	 CEWuymcA1T4Y1rPk65bl1+8yPaDQeEeU/FpuzCPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@linux.alibaba.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 125/290] riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument
Date: Tue, 10 Jan 2023 19:03:37 +0100
Message-Id: <20230110180036.130507942@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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
@@ -60,7 +60,7 @@ void notrace walk_stackframe(struct task
 		} else {
 			fp = frame->fp;
 			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
-						   (unsigned long *)(fp - 8));
+						   &frame->ra);
 		}
 
 	}


