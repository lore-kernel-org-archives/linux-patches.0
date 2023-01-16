Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A6A6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BCFC433D2;
	Mon, 16 Jan 2023 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888250;
	bh=JQf0IqK/UUjIMQkfOPAgLiNOGmSML9GSjaBgvjKwn5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDRSlBP9ni3Yq7MhTb/pcP9bJft3dxVnqzI/ESSWsaYF2WQrKVqx78lqHYtATmdnw
	 0TAdpheurW+YRWivtR6J2rYjnj7Iw2ZVRi1Do7Ek9nQnr+SE0fBLm8e9WkgPrw5qJQ
	 ch34tK+4H4nIQr9kdYSXcHwav52tS2BVqtLrkwE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Palmer Dabbelt <palmer@sifive.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 428/521] riscv: remove unreachable !HAVE_FUNCTION_GRAPH_RET_ADDR_PTR code
Date: Mon, 16 Jan 2023 16:51:30 +0100
Message-Id: <20230116154906.270296874@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 877425424d6c853b804e6b6a6045a5b4ea97c510 ]

HAVE_FUNCTION_GRAPH_RET_ADDR_PTR is always defined for RISC-V.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
Stable-dep-of: 5c3022e4a616 ("riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 74b2168d7298..39cd3cf9f06b 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -64,12 +64,8 @@ static void notrace walk_stackframe(struct task_struct *task,
 		frame = (struct stackframe *)fp - 1;
 		sp = fp;
 		fp = frame->fp;
-#ifdef HAVE_FUNCTION_GRAPH_RET_ADDR_PTR
 		pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
 					   (unsigned long *)(fp - 8));
-#else
-		pc = frame->ra - 0x4;
-#endif
 	}
 }
 
-- 
2.35.1



