Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212561;
	b=4SO5hZcD6Cx46TzALogXd3qAaLfNMm4aWH+UsHCO8+IpvoeHDxmg63ehD2guaZ2U3XA/
	 fiCjqCdFH4rGezEuqotfIHz6A9dCiVn7sc+AanteLoDflerf4iUImy0wmNITN2GSgcR3m
	 D3Pw3owNmiMq4Vzm2rN6eP6skxOn7bLfbvb2Gc7LRdc5zcw72sy+Wy9qlpRlS9Oo1sO+r
	 N3tdsLoHTbyAut/GCeohidgqQRem90jA3k4A3ch92btGlE8YS5Nk7boOW+mHhDfWlLuND
	 Fq70rj/xUDbpdk2l/nUpkFgSERZHxSCSkc2i1FvswjpEpbJc63dvDGUmRnBSEyCpttQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h31nhHppWxMkGNM4yIuPbcoC5TpkpYdoei6Ci6Y+Fbc=;
	b=5tUY2MFL2TUf3e/q6scruvtS8r3Pkrf7AVf1Z9SjNEXUd370nGIIhxCqBm505+sitJDb
	 d+rQyPBq2ehAQ2hRn7XaAVJTXL5WS89T7wLVq8lYjL+aLIpe0w0BWazt2CQ9aeeeCkY0L
	 v44hLA5RLwLwporlbQbtgCwg0Zg4OwQF4Nxu+Pb8s/c34ZIPxanvhjRUQZRf1ayLWxXTX
	 Tk2kJs2YnMHsuJPWixWRI1Oqm7P9JW/f0L2apbJs3IAGlDxa4Zcp0lylgegBLswMhOq0H
	 heJOXdsq4n+Q2LMUFzJk2z4wWWPd+MRRXtGuUGgG3KwIgWCOE+CB34uEZcEMpZCh+NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gpKijs1C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DAC606A31C;
	Wed, 28 Oct 2026 18:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gpKijs1C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5991F01825;
	Wed, 28 Oct 2026 18:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212560;
	bh=h31nhHppWxMkGNM4yIuPbcoC5TpkpYdoei6Ci6Y+Fbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpKijs1CEhm8b0UiRiOckYVxx0NSBdAFGczOyKFKbm9UJEfos25wkh4u0GZ/fLSkF
	 fdyU3puFy7CfYEsd3lUka0b51kvsok5O+zRmgExtqeSZ9rwKbosUwqDFUzAUFiYCj9
	 fbOg3nzMM4e2dmJ+pp2APh2A06Z/NAt73J5IXecU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Schlameuss <schlameuss@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0195/1887] kvm: s390: Reject memory region operations for ucontrol VMs
Date: Wed, 28 Oct 2026 17:38:11 +0100
Message-ID: <20261028170503.673434735@linuxfoundation.org>
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

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

[ Upstream commit 7816e58967d0e6cadce05c8540b47ed027dc2499 ]

This change rejects the KVM_SET_USER_MEMORY_REGION and
KVM_SET_USER_MEMORY_REGION2 ioctls when called on a ucontrol VM.
This is necessary since ucontrol VMs have kvm->arch.gmap set to 0 and
would thus result in a null pointer dereference further in.
Memory management needs to be performed in userspace and using the
ioctls KVM_S390_UCAS_MAP and KVM_S390_UCAS_UNMAP.

Also improve s390 specific documentation for KVM_SET_USER_MEMORY_REGION
and KVM_SET_USER_MEMORY_REGION2.

[ Backport to 6.1.y: omitted KVM_SET_USER_MEMORY_REGION2 documentation
  because that ioctl is absent from 6.1. ]

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Fixes: 27e0393f15fc ("KVM: s390: ucontrol: per vcpu address spaces")
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20240624095902.29375-1-schlameuss@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
[frankja@linux.ibm.com: commit message spelling fix, subject prefix fix]
Message-ID: <20240624095902.29375-1-schlameuss@linux.ibm.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/kvm/api.rst | 6 ++++++
 arch/s390/kvm/kvm-s390.c       | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1bc61bf804f1f..1f0f84501e59c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1382,6 +1382,12 @@ The KVM_SET_MEMORY_REGION does not allow fine grained control over memory
 allocation and is deprecated.
 
 
+S390:
+^^^^^
+
+Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
+Returns -EINVAL if called on a protected VM.
+
 4.36 KVM_SET_TSS_ADDR
 ---------------------
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 9b9d8d37bcc41..0d4a05f3cdd93 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5587,6 +5587,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 {
 	gpa_t size;
 
+	if (kvm_is_ucontrol(kvm))
+		return -EINVAL;
+
 	/* When we are protected, we should not change the memory slots */
 	if (kvm_s390_pv_get_handle(kvm))
 		return -EINVAL;
-- 
2.53.0



