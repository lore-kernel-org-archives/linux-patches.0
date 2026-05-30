Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFFB2FDC5E;
	Sat, 30 May 2026 17:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162080; cv=none; b=n9icg1Ng0c3HliNYzxbe8X/cJyqToI5D5u7xQmTl0NEQsQo2UQ9AeASr3ItRW53lePEWJT/QSbaD05b5y/ly3SXp9gfXBBcDWeapZnOUudYeoczy2QVsrX23p22gJ+Rw7RO3RStPHaAEdwhp137uQ8gbZAm1u/DayVqzl1wtvpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162080; c=relaxed/simple;
	bh=z61/4VwS/L2FOkAXTL0opR8AFo8zTEmMixVYzu6XLX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJReNtxJlp6J8tUXCsfPiTx50l92UWplrNuRWMzdPBDlg7aasZc2FaNjKLp4xa/DU0ApBvYbiGWZW7RmH51IyeGaM03CFfjKDXQ/pQc60iGdSF+78WP7lQPLsgIBf+JJpsDjmmdea+2i+/ZSi1bRNGGCK45KKDRz/qJd9QRIT7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ct4z5SU8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ct4z5SU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7C61F00893;
	Sat, 30 May 2026 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162079;
	bh=Nd1Hx2b+ztFRGGAUyB8/vVIWPKvDk8vdq1S/c9xWQ/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ct4z5SU8NRV0FUckaEsKSSMwcuNSSDNMD0dEA12zb/BDWggfWqEL2KEsJv9vfw4vn
	 tysvxuH43ypsEf+r/FEMfyv/9rX2dWFBZZN9IhO8C1fd5krcm7BdZ4c8bTaRxTpMK3
	 IX1e8RMlqzfmvqk/Y+B/YbSNBRBVcWb4hQOV0nQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 814/969] KVM: x86: Fix Xen hypercall tracepoint argument assignment
Date: Sat, 30 May 2026 18:05:38 +0200
Message-ID: <20260530160323.113740569@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -138,7 +138,7 @@ TRACE_EVENT(kvm_xen_hypercall,
 		__entry->a2 = a2;
 		__entry->a3 = a3;
 		__entry->a4 = a4;
-		__entry->a4 = a5;
+		__entry->a5 = a5;
 	),
 
 	TP_printk("nr 0x%lx a0 0x%lx a1 0x%lx a2 0x%lx a3 0x%lx a4 0x%lx a5 %lx",


