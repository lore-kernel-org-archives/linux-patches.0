Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2DA340A57;
	Wed, 20 May 2026 18:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301611; cv=none; b=pGT48j6RxHQCkb+uO7uKIt+Ejy8SqTavu+KHa2cGWveq1eWg8+FmckYzJgobtOZLwcHfKI2SECr3giomhbnDo+Ax539obmYFns5SvEh2TlRPYQ5IQEETmQEEKrTjlC7DOpceDsikNo62uSjW0giqWggjWHwB0+ny0dVOsDCTZZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301611; c=relaxed/simple;
	bh=QGFxto/Cs2Qd3jjj2gklC4g+87Hp5lgXHWhintGpW4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSJc4kLwUO4ja7DK6hHxFh5WbwJFQQ/gdIl5o4caw2zSHsXp8E7xYPJr7usTtLVTMMoH6XuNrq+qZnalT3lubm6G+UjiK8QU75syq/ecvCNHTuVJvV0T6wIxU3q4gLZ8L7UWVIkMpiRnvKchHTpsNo4LCNqfCmbqnJsjrlX8WMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aq7coeu5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aq7coeu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6FE1F000E9;
	Wed, 20 May 2026 18:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301609;
	bh=OTafZLmGhDhV2Wh41niC7+bEeQMsCZOQJCzoHfHFnW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aq7coeu5cISVkK1Zlndcxy+s1WJBq1sFpGuE+PytJCFdQc1VeHiLVkUCDbvbc2Zow
	 rmD3ikTxANBiggAj5bCNnZAcupKhkL4ruUyK3jD6Z1ia/rHoVhObACZxhMkf3rHHZR
	 t8HmIwRMLLCmiWboHwIBZHlvZIWVhUrbjLYtHTsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 621/666] KVM: x86: Fix Xen hypercall tracepoint argument assignment
Date: Wed, 20 May 2026 18:23:52 +0200
Message-ID: <20260520162124.731306965@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Ma <maqianga@uniontech.com>

commit 2b72f1674e427c56e3772c5ccf785fdda2138820 upstream.

TRACE_EVENT(kvm_xen_hypercall) stores a5 in __entry->a4 instead of
__entry->a5.

That overwrites the recorded a4 argument and leaves a5 unset in the
trace entry. Fix the typo so both arguments are captured correctly.

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Link: https://patch.msgid.link/20260512015313.1685784-1-maqianga@uniontech.com/
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -140,7 +140,7 @@ TRACE_EVENT(kvm_xen_hypercall,
 		__entry->a2 = a2;
 		__entry->a3 = a3;
 		__entry->a4 = a4;
-		__entry->a4 = a5;
+		__entry->a5 = a5;
 	),
 
 	TP_printk("cpl %d nr 0x%lx a0 0x%lx a1 0x%lx a2 0x%lx a3 0x%lx a4 0x%lx a5 %lx",


