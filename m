Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E10629B799;
	Sat, 30 May 2026 18:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164871; cv=none; b=MPuRl9VQAVwD2zbNwnyC2lrIj0RjQcubI2ZpndQoYfd1kNBS0kUr9MQBE1NrDdrdeLz1xm1VKS+CcAdGNY9b1Q6GCKEet+0pLOh4xsIzo0rwmHS8duEtFFLPacOdDqCOyWpLnbgwVPc+unAxk/Sfsdf0CaHgP9q4XxDOmJ0F9OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164871; c=relaxed/simple;
	bh=6o/m6NwFufGvZ/IReU/0/DpIRMwK7d3LU/Jz1xMdGmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWcdZJ8MVfxNApDZvmXs58YMcIpz2XzlXRPh9918VrnJ9aHZxK1Vn3UlPl0rG3GsOB/WAQ2xzwuNbNZM4eke5NaoxLPZfZ9Qh1X6Ctr0GRWgTv7ix9U2hkvyJKIXM838DKotzeKE7gDZ5oXRyjT6obatjccaGRrmLfVGT5o6/zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FArwyfn2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FArwyfn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90461F00893;
	Sat, 30 May 2026 18:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164870;
	bh=zgBaQA+VGY2GCO65TvAPJ0cZk+xBkzkjnt1+0L26MEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FArwyfn2nkCGEicxkgJeRAWhfvqiCwriSXH92A1V4f3gmHN94Pwb++8x7qoyXgOQ6
	 jdlQ4C5mK3uNh3auuAEwS1z/EUJUt4qTugwniknH66hZnPJji9ZMqQxno2yp7T9IdS
	 LSj0L5YAE9gl9cZtDzYQcXuM9KaXdTY0OqRG5PGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 654/776] KVM: x86: Fix Xen hypercall tracepoint argument assignment
Date: Sat, 30 May 2026 18:06:08 +0200
Message-ID: <20260530160256.815644399@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -133,7 +133,7 @@ TRACE_EVENT(kvm_xen_hypercall,
 		__entry->a2 = a2;
 		__entry->a3 = a3;
 		__entry->a4 = a4;
-		__entry->a4 = a5;
+		__entry->a5 = a5;
 	),
 
 	TP_printk("nr 0x%lx a0 0x%lx a1 0x%lx a2 0x%lx a3 0x%lx a4 0x%lx a5 %lx",


