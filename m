Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044706;
	b=xRkmH7oTAp8V3PjSclVPyXi5S/M1kG+I4lNLMByOOX7rqStejnotFDfGki5UiaHEbCTc
	 63kWYgx31ZHhwKj7r7DHJZLzRi6ehpZxreQuAREW8+rzyH783kTl3Io1tj5Kd/YlsOaQA
	 ovr5fG20zkMaC6YWgsHI1u+3fimfQaLkvQ/8LJt7Fl17U+2CwLD7jiNRXbb6v4fyNmgJK
	 GaQwoZn0dvap1IQzdMmrITY05pBFzCSfhFbUSAgOfafUPfFD3MVbcJZIHgjF6rqIh9tBC
	 9u3MKKMND53Kz1h+qGQFnav36H6/CEm2DfFyfrV531hhp6dSbPwSWOAMvZfrYdLVNOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RlkCeHn73yHBHGAn+fY6MNjjs9ASqPpKb71nDx+n79E=;
	b=xE2BmCVZNKs4lF9Z3rw+OcRRyGEU3VCpdbaw0ALqRToN4xenA4iJZ2aVlKkclQip7hp6
	 MoiFHIA61fairUFyYDpyqn31+8T/D+jpke0R6f4+DnpffAhLNQZCUGtmGBt+q9g2oVtjv
	 OZmS052/nBTOs0kvAYpuFQF6xjuFBNcM8RBBrYQQR4Cel9EvPtGofhjdAKeBRjjQmoS2z
	 huSIjeaEIgqyCQaJWymp2UeXTd3Epmyepi/WOmXTvRN81DefzHtpdwXwuXLsCnf2NW3Fs
	 vc0bjkaS8MFBXntE8hNSpfAV/ym0h2eqol/rsR23FO0iH54RXmM7phYy7/zP9WdyP5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CsM61K/p";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE0A606A325;
	Wed, 18 Nov 2026 23:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CsM61K/p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A2D1F000C4;
	Wed, 18 Nov 2026 23:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044706;
	bh=RlkCeHn73yHBHGAn+fY6MNjjs9ASqPpKb71nDx+n79E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CsM61K/pN5v1JxRiIR1A3S61xWW8ikS43Lr2ZDXlVz5Rb4CZkR4UbFb3TjdvbyFcG
	 SzzjD1aRYbUTV79yuPbefCDGEe3x95qAxXk7DVeCNN7jhLLg9PXdgKWhZqc1kDHvrc
	 3rgCbbAeWTm9lnxDA6wRrCtIkfqNy8pFvFqRfUZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loc Nguyen <loc@ryzome.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 0626/2857] KVM: x86: Request event processing for exception VM-Exits
Date: Wed, 18 Nov 2026 15:27:40 +0100
Message-ID: <20261118150224.039005225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Loc Nguyen <loc@ryzome.com>

commit 88b23a2e8286b7016c3b58dc10093cf28c22aa3d upstream.

Request event processing whenever kvm_queue_exception_vmexit() queues an
exception VM-Exit.  Most callers reach the helper through
kvm_multiple_exception(), which already sets KVM_REQ_EVENT, but nested
asynchronous page faults call it directly.

Without another event request, vcpu_enter_guest() skips
kvm_check_and_inject_events() and re-enters L2.  A subsequent VM-Exit can
clear the pending exception while reconstructing vectoring state, losing
the synthetic #PF VM-Exit.  The APF reason remains PAGE_NOT_PRESENT and a
later regular #PF can consume the stale value.

Setting KVM_REQ_EVENT in the common helper ensures that L1 receives the
queued VM-Exit before KVM re-enters L2.

Fixes: 7709aba8f716 ("KVM: x86: Morph pending exceptions to pending VM-Exits at queue time")
Cc: stable@vger.kernel.org
Signed-off-by: Loc Nguyen <loc@ryzome.com>
Link: https://patch.msgid.link/20261002053723.3275202-2-loc@ryzome.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -631,6 +631,8 @@ static void kvm_queue_exception_vmexit(s
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception_vmexit;
 
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
 	ex->vector = vector;
 	ex->injected = false;
 	ex->pending = true;


