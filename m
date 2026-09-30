Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE078518154;
	Wed, 30 Sep 2026 17:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788067; cv=none; b=U0tL7arXgCmbIie0NlJFGvOMz/NmdYYpzEfwW2/QMSwxLsdjSErgPUqLu26IWiwCQARZHGIjcLctWnUqLhuR7IUPKXqeh6t7kQdPOC9HwcoWtSDWv7CHyrQDhDNd4kWGmqf7CQEb9FP4r0cadMBkiMHDY9djrMP2s1VcsVhzDhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788067; c=relaxed/simple;
	bh=iP/QkU4beJxBizc50DoW4zB9S6Borht7ld/6UzL32Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRUnUDtdSXACQC7e9sQ2R+m/IXi7oYMJG+EPyG8CssQHzPq94qE6qFzG2PVIlmYkaXOa0OxaXjzY+tfU93gzmZ+wUaGU9XjCGQOYGWlN4DB6v+vidJphvZTB6c0+XAt+EwVN4Q4fBiSa8bAbuvayWcgo2DR2E/ya5U0Fy5Gbth4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oY0eyfXX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oY0eyfXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BBC1F000FF;
	Wed, 30 Sep 2026 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788066;
	bh=VRpB0d9iCb+qqzC6pcK6bSFIULuNz/NtedgMtTdTRFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oY0eyfXX2UERTzBwPO9pJZUTWQ+TZ1Asl3IMqRPW+JWnkpeOlkjCo7VGgJKunwZwD
	 S7LeGvVSFlYaeI55f5rYUHycyZvIgQzvMT+KW47J5QgjaANMMNXtWQ3J7IcG2J5iuD
	 lqr59qnn2F8HmJkV/7ela0IQjGrPNw5JdokpGBtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 453/457] KVM: move TSS constants from kvm_host.h to tss.h
Date: Wed, 30 Sep 2026 17:29:18 +0200
Message-ID: <20260930152355.782341183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 35fdfa632e7cf8271189c7ae6f97e7c4b55f7f80 ]

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 10180a277549 ("KVM: x86: Re-pend GET_NESTED_STATE_PAGES if getting said pages fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    7 -------
 arch/x86/kvm/tss.h              |    7 +++++++
 arch/x86/kvm/vmx/vmx.c          |    1 +
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2433,13 +2433,6 @@ static inline void kvm_inject_gp(struct
 	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 }
 
-#define TSS_IOPB_BASE_OFFSET 0x66
-#define TSS_BASE_SIZE 0x68
-#define TSS_IOPB_SIZE (65536 / 8)
-#define TSS_REDIRECTION_SIZE (256 / 8)
-#define RMODE_TSS_SIZE							\
-	(TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
-
 enum {
 	TASK_SWITCH_CALL = 0,
 	TASK_SWITCH_IRET = 1,
--- a/arch/x86/kvm/tss.h
+++ b/arch/x86/kvm/tss.h
@@ -57,4 +57,11 @@ struct tss_segment_16 {
 	u16 ldt;
 };
 
+#define TSS_IOPB_BASE_OFFSET 0x66
+#define TSS_BASE_SIZE 0x68
+#define TSS_IOPB_SIZE (65536 / 8)
+#define TSS_REDIRECTION_SIZE (256 / 8)
+#define RMODE_TSS_SIZE							\
+	(TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
+
 #endif
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -72,6 +72,7 @@
 #include "x86.h"
 #include "x86_ops.h"
 #include "smm.h"
+#include "tss.h"
 #include "vmx_onhyperv.h"
 #include "vmenter.h"
 #include "posted_intr.h"


