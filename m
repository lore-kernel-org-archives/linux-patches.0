Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213240;
	b=bXU4XOliUrUHecmcq0qGy+CwXOFbDZxdHVf6kS/nics2GIEMEMu445AL2wXNTkdk1fU1
	 aqV2w7xDtuGeyLgf64oIB9uMVY/gsXpU/JFUbE79xwIwkz/Y/xx1B5QV4qEem+VKHno2O
	 SMDcfm5azqad+BYRqB9GXeI37oP3/vJ1zHxIjCG6QZK7ayTmcxkVCqZdQTqejsRL1znbo
	 LBW94SqP/80s4aSo2SAMqV07fq5a4+r9KinKF0pq0Vv74JPNaP6/d+vlTPS8ffnwRYUe7
	 KOK2WbG+/gB1lkPmEHxXGjm/b+xpaRNT7GuMoX5EVaJb6EscE3in03jLdtK1re6em0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XMkKECBfv6kDBDLly6Z0DptbGwn8xfECBO6NVR8qcfU=;
	b=aVrVSrov2+Hh23PTw09twg5tiFLcdmszXQWB6ZlkwTQ34C2ZNYFmtm+oVk7tRYaJd8hM
	 FLB3jdb4YVtwdi/7qx1OUh3MmCgLIiWmxpTx3pDlh2RmhE7tC1vsHGzLu6sTJf1gmBCrP
	 PnUDBtMBEbRNAgPHu1b56ItTuR9TQxtc8fIhi2FN9N12CLTpS6h1W+svw0JX/bdefJRiT
	 C3XHuK3YspI0cZA5oK+hqWi+0vNvstHiyFufs3vRRX3zU+97FNyi+cdxALhvD4VBL2v0w
	 uY8HX1/hEVMKMmq/g3BRfQe0lgW9SWUYsaMKdGYt55zTB7NAw25Y9VQB7sgk+zdbjcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uF/v1ymo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667AC606A31C;
	Wed, 28 Oct 2026 18:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uF/v1ymo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70111F01825;
	Wed, 28 Oct 2026 18:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213240;
	bh=XMkKECBfv6kDBDLly6Z0DptbGwn8xfECBO6NVR8qcfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uF/v1ymoEWmj3awugACAwD8ic6flQltlgo/vgoN61XFpHS9GmKi+IB8/ntZ004sXY
	 xai/Th3DMPnUstbLkPYz8j/+S1o92OivcYHjQk990aCyOGXFwkT9JQPAEkZTT5bCNN
	 Z9Ngk/X+4zgWw+FzlqBgBW27R7GSm4BYS6alNMQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 0434/1887] arm64: irq: exclude the softirq stack switch from KCOV
Date: Wed, 28 Oct 2026 17:42:10 +0100
Message-ID: <20261028170509.109722179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit a9cd14bfb0c113f1cd77be4349784663bec71bb4 upstream.

On IRQ exit, __irq_exit_rcu() drops HARDIRQ_OFFSET before calling
invoke_softirq(). The arm64 do_softirq_own_stack() wrapper and its
____do_softirq() trampoline run before __do_softirq() establishes
softirq context, so KCOV records their PCs in the interrupted task's
coverage buffer. They also run outside softirq accounting when
local_bh_enable() reaches do_softirq().

The IRQ-exit coverage makes the KCOV boot selftest fail even after
the scheduler and timer coverage leaks are suppressed. The generic
softirq.o is already excluded from KCOV, but that exclusion does not
cover the separately compiled arm64 wrappers.

Exclude irq.o from KCOV instrumentation, as is already done for the
arm64 entry code. This covers both wrappers even with compilers that
lack the no_sanitize_coverage attribute. The softirq action functions
remain instrumented for explicit remote coverage.

Fixes: 8eb858c44b98 ("arm64: run softirqs on the per-CPU IRQ stack")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -25,6 +25,9 @@ KASAN_SANITIZE_stacktrace.o := n
 KCOV_INSTRUMENT_entry-common.o := n
 KCOV_INSTRUMENT_idle.o := n
 
+# Softirq stack switching can run outside interrupt context.
+KCOV_INSTRUMENT_irq.o := n
+
 # Object file lists.
 obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   entry-common.o entry-fpsimd.o process.o ptrace.o	\


