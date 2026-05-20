Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA574028DA;
	Wed, 20 May 2026 18:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302951; cv=none; b=FJQ1n6GfrMpsnFMNqHgu2G5KdQFcL1KzrwEGo5CMeGzpB7vFF9vSAPzjO5Uq69l9fbgJof1u1AS3PO6LsKe4zkBJUCSl+hng+FyDw2H30CF0+9oDNVrMR6aB0FRfbtg4Gu4Ed9jzXTplF+cJp+/h5nBDFUEw5G/UzABB4biADBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302951; c=relaxed/simple;
	bh=LI/dEXyZVk1mqD9BfYhJvoPlkGio3xdXDYKSXJu9w0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQ+0ddKa5pDQ7HppKZy4yD40QJXT+SrRWZAmOWfqe2Behr/leQO+j9wkfMYvH7haxpd7QxK1SpPPI5OXE2a1FNxLPfQk1zo6MHRGnWLT+UnneUlzngQVFKYoFmUWjDw94HKPf9xMr4DGfg1Pa9WjLrktpc2k93eYoZo6IhhhjBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJnmeDPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJnmeDPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077F81F00893;
	Wed, 20 May 2026 18:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302948;
	bh=GeeH2UqhAtSHrfjTUz8UqXmByGNkYKMC4DuOryPhYqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJnmeDPL1L3XLWIqBLAS9er6XR2eb3RawmwhYPG5pIjYkePqYR9PAKTR6k24aP7Hk
	 8xCYupfbf5Q2oCfivDxOELaJGlnqOcaQ3QzVIIXEeTGbnvfneKivSNPdR5HVEl+axs
	 6VhOsuMdWLcKIdi0f43ERh1RjXjUSdSBHhMjl2T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 461/508] KVM: x86: Fix Xen hypercall tracepoint argument assignment
Date: Wed, 20 May 2026 18:24:44 +0200
Message-ID: <20260520162108.587158342@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


