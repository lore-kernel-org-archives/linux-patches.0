Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035471;
	b=GAH0K8a8BUb5pxuIGChFm4M6JsL+sdo3YQD4sgpxBrKtNT7/KG6ZCzmodeGC9kB/6ICt
	 +kDjY1mUmtblGNhSbb+0dhLI5k2cmYD/ddV3MwF5NGAPUm4lN4OZyGXuk/gVQ3Xsfbm9m
	 Nmts9L9xT8rpS06VPyh6kunUB6j1p+8TJQ+ZfHMKwd8xfdfZ/AZb3m8LOaV3+Jvgg2M2h
	 gs7NBNfidM73arV4+7zH3ThUM6GmQdjxkOgNEDjCv92Bq5mYthsIuaOa+2Kc1jKJ3JpSH
	 HkeBqXb4viHN73rAq2pRhoQvxK7C+CTk+pUSVND8oL1kXOSERVvlptmrGlfudGTUYnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s3WijUcUQt/nCSLYQwT6K3XU1YGVAX8rdjz9UerFC1c=;
	b=Nq46TAuKGNpW6ecowpy/Fi1EDhKhbVyWDSGt/lCs934E5i70UAc/YAsZ8/KyUFdV631Q
	 vGIrF7PT+I1y7r0MXmvWGvkwfalhBLhsVZpId0Af1LroPhBOcHTbEca2ZoLbZwnfkd63C
	 JrKqQXpMJ5vs8VioIqIxQoxexOC5CpxDYkzd3xUfLakbERLzNFQSjQLFZJ6rcAu1cQNNL
	 l+SIbh2hWRvL0WKqeRVCGvFvxEAjFUsIClijDOPclOQVZ6FpeVTIgIl+bcvgBLN4JYQ0a
	 kfRqVFTFPF2AKJTiJBH7qqC2ubbAClW+Fi1egLWIqYFCwAwWY3jRat9FcA63Rh7chHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zr1i8Al/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4BC606A31C;
	Wed, 18 Nov 2026 20:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zr1i8Al/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A070D1F000C4;
	Wed, 18 Nov 2026 20:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035471;
	bh=s3WijUcUQt/nCSLYQwT6K3XU1YGVAX8rdjz9UerFC1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zr1i8Al/upG+BmA8SEor/LOWj/fbmYNir6dkYwu/FH36HoukOlxIWUIHr7qBuWLps
	 h/Y7ijEDaNcLCjgqykYqmVC10w3WoR9G2JyQ1tken6z2ZP6XN//11Ww5Y8afh1jii6
	 3dUwAQrKv9gnHCoaS8P7JGOW61aercv2QdMRqAlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 0716/3318] KVM: x86/xen: Take kvm->srcu in __kvm_xen_has_interrupt()
Date: Wed, 18 Nov 2026 15:22:18 +0100
Message-ID: <20261118150339.937672744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

commit aa8ad943f242ef14d136c5440b1178de77466c9e upstream.

kvm_gpc_check() checks the cached memslot generation against the current
one, which dereferences kvm->memslots and therefore requires kvm->srcu to
be held. __kvm_xen_has_interrupt() does not take it.

Most callers do happen to hold kvm->srcu, but not all of them:

 - kvm_emulate_halt() on the VM-Exit path, via kvm_vcpu_has_events() and
   kvm_cpu_has_extint(). vcpu_enter_guest() drops the vCPU's SRCU lock
   before entering the guest, so it is not held on the way back out.

 - kvm_vcpu_block() -> kvm_vcpu_check_block() -> kvm_arch_vcpu_runnable(),
   which is the case the existing comment in this function describes.

On a PROVE_RCU kernel the former produces:

  WARNING: suspicious RCU usage
  include/linux/kvm_host.h:1092 suspicious rcu_dereference_check() usage!
  ...
   kvm_gpc_check+0x344/0x3e0 [kvm]
   __kvm_xen_has_interrupt+0x83/0x310 [kvm]
   kvm_cpu_has_extint+0x1ff/0x370 [kvm]
   kvm_cpu_has_interrupt+0x16/0x100 [kvm]
   kvm_vcpu_has_events+0x4ce/0x690 [kvm]
   kvm_emulate_halt+0x52/0x1f0 [kvm]
   vmx_vcpu_run+0x988/0x2630 [kvm_intel]

Use guard(srcu) so that the three existing early returns don't each need
an explicit unlock. SRCU read sections nest, so this is harmless on the
paths which already hold it, and srcu_read_lock() does not sleep, so it
is also safe in the atomic case which this function already handles.

Fixes: 7caf9571563e ("KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_info")
Cc: stable@vger.kernel.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Assisted-by: Claude:claude-mythos-5
Reviewed-by: Paul Durrant <paul@xen.org>
Link: https://patch.msgid.link/20260831213632.81023-11-dwmw2@infradead.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -571,6 +571,16 @@ int __kvm_xen_has_interrupt(struct kvm_v
 	BUILD_BUG_ON(sizeof(rc) !=
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
+	/*
+	 * kvm_gpc_check() checks the memslot generation, so kvm->srcu must be
+	 * held. Most callers hold it already, but this is also reached from
+	 * kvm_emulate_halt() on the VM-Exit path and from kvm_vcpu_block(),
+	 * where vcpu_enter_guest() has already dropped the vCPU's SRCU lock.
+	 * Taking SRCU does not sleep, so it is safe even in the atomic case
+	 * which is handled below.
+	 */
+	guard(srcu)(&v->kvm->srcu);
+
 	read_lock_irqsave(&gpc->lock, flags);
 	while (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
 		read_unlock_irqrestore(&gpc->lock, flags);


