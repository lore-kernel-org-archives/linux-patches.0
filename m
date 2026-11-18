Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034846;
	b=HHbzH0iWVau1JREg1b5Y4kwVgCW0hXAcHv/inRKLB3Hn05qs7KiCdQ5C+sMuDxt5S7ly
	 LVPRnZj8ZoIq38MTBE+WAzWlvegdbvUdwxeSNTsDrvCr+8c+xrQ+k/uPAETo/tDDNR4H2
	 Xnpci2p7nNq+20A0fCs7r06RddbPF7cjx7c7BUi0FN2KL/Y06XC8boexgbmHC/s6dG00l
	 XEndFBfuzsy96xg3+7yGKw42lsn5Li4l5kuDl8mrrf7gnWcKU6gLizXMcXFMKA86+6XuF
	 N/Gczo0ZVS+OCYG86ie5R77tPhY7SPu4HZztxI02xFFQ+243ciaG46nEtalvXBKHaNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UNmbnd0d7h1JmvHD+Q3fChVutFOekQLh6jOiNpKn9PI=;
	b=l4gtarMeUQ5QKFMZYlCO/ds90HaCPubYptFuLbs6jji07/j/vw2UNotThUL04pAbTPvQ
	 388bxvQ5o+0z4pWZhtT4OcEOYUJBiZldTpBt67d8P91/GcmfrR8QvLnrpseQr1uwLu1kh
	 gjpyRd4wCjERPkPgZ5rx4qZ7sZH/o8YPpvkIvG3HhQmaG1SnsJmcgcDjqHcHblUBkB44X
	 c3R2aY0FlIcEYci+pZnwyYDEvJzf4Ze9SdbLnVI9FACA3vonvAAVicrFiT4hyOjGg57Nu
	 rodfLm6eubHscTm7bZzl3QyUTcHZq3s7JfmkNpQvE45qpEZK6Ja1zKrZz74KrGimRPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFKve4Ae;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2047606A31C;
	Wed, 18 Nov 2026 20:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFKve4Ae
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA4D1F000C4;
	Wed, 18 Nov 2026 20:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034846;
	bh=UNmbnd0d7h1JmvHD+Q3fChVutFOekQLh6jOiNpKn9PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uFKve4AeGwZqTLJay3cq3ewn/U/1fmBXj/vUMfFKm8gqTXMzLdzeSQ1pxcGvmkI2F
	 uy2H0pFC2vrcqDzuatRAfh9qpb+x2lDKDfmNC/Ea0abruRquBBi545iVL4mnOYBB+o
	 ppcajHjShqwYB8hGE4V7XIRFvmJZ/qtBP+LwxwZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0514/3318] KVM: x86/xen: Remove unneeded xen context from kvm_arch when !CONFIG_KVM_XEN
Date: Wed, 18 Nov 2026 15:18:56 +0100
Message-ID: <20261118150332.559431891@linuxfoundation.org>
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 87562052c965ba7de6dc490434e53691fe46c898 ]

Saving a few bytes of memory per KVM VM is certainly great but what's more
important is the ability to see where the code accesses Xen emulation
context while CONFIG_KVM_XEN is not enabled. Currently, kvm_cpu_get_extint()
is the only such place and it is harmless: kvm_xen_has_interrupt() always
returns '0' when !CONFIG_KVM_XEN.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/20231205103630.1391318-2-vkuznets@redhat.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 2abb25273c82 ("KVM: nVMX: Force MSR bitmap refresh if runtime eVMCS controls are modified")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 arch/x86/kvm/irq.c              | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b2aa5b455e1d6..87b74673878e3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1130,6 +1130,7 @@ struct msr_bitmap_range {
 	unsigned long *bitmap;
 };
 
+#ifdef CONFIG_KVM_XEN
 /* Xen emulation context */
 struct kvm_xen {
 	struct mutex xen_lock;
@@ -1141,6 +1142,7 @@ struct kvm_xen {
 	struct idr evtchn_ports;
 	unsigned long poll_mask[BITS_TO_LONGS(KVM_MAX_VCPUS)];
 };
+#endif
 
 enum kvm_irqchip_mode {
 	KVM_IRQCHIP_NONE,
@@ -1342,7 +1344,10 @@ struct kvm_arch {
 	struct hlist_head mask_notifier_list;
 
 	struct kvm_hv hyperv;
+
+#ifdef CONFIG_KVM_XEN
 	struct kvm_xen xen;
+#endif
 
 	bool backwards_tsc_observed;
 	bool boot_vcpu_runs_old_kvmclock;
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index b2c397dd2bc66..ad9ca8a60144c 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -118,8 +118,10 @@ static int kvm_cpu_get_extint(struct kvm_vcpu *v)
 	if (!lapic_in_kernel(v))
 		return v->arch.interrupt.nr;
 
+#ifdef CONFIG_KVM_XEN
 	if (kvm_xen_has_interrupt(v))
 		return v->kvm->arch.xen.upcall_vector;
+#endif
 
 	if (irqchip_split(v->kvm)) {
 		int vector = v->arch.pending_external_vector;
-- 
2.53.0



