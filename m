Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061756;
	b=RiptNrSMOD2+xb6lfkDD/rmityiTabxoTnsLcSx7d/Z/I1OoLtbHu9ZdKMYLheeASJ8D
	 hmOxMnoFVwB2OgPMl6SWAUHeqzsp/e2SlaTa0kHuq8NUhOwtEghxhMPigEEAVRu+BMQiX
	 h4EuHamNrGPcEsjhbABymZNM+Yt65LVdSfk5vtb7vis6EwdnINqyHKxbTaRDwHmvh4/r+
	 rV7fifBpt821t2NilUYE6JIS67VubboEa0+CY0qwJUhO48+99IfY8G+Ai/jiztHJZ6O2m
	 a7j/KbskBz90hL7yJ5GVYzLNph7U4nHSues96GZRZfY5f7zHCH7fhx+fucx80+JCQkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HFkfkZk5asyHjjLv6sI7yZU2uUTArrtorewn33N06cw=;
	b=O7+Q1fJHLjHCOVOkvgpgZm68vfpL6454J+JBKA+wMbXMGGKoZ90sJDqEsF/sHq0vUFT2
	 s05QDOY42Tm+PTePF9yRKi8OqCU+eyKj8AZn5NyD0enA/KcZT1STpabHqutEBJ4pjS/rI
	 vPtNg+xIVpCOL4A3eH25WV1vvPuM3fNnb/Ydkel6YVgUnpT3XxZfMMIEEXSjvzHpB9EwP
	 tqlP+gcCi0LEYDz71+8BiEibDTYcOz6SJQWsQvDZldh3V1wQroVV9Opoi4c3Y2mTKawZm
	 JrCJk0PMsO7JdEWjnF9eFdAEOdlpqlNSAgX4W20J0bHTw7ZZSL6By/a0sDGRrx18DCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yThakPoZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22405606A32C;
	Sat,  7 Nov 2026 14:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yThakPoZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC2E1F0089F;
	Sat,  7 Nov 2026 14:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061755;
	bh=HFkfkZk5asyHjjLv6sI7yZU2uUTArrtorewn33N06cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yThakPoZpPJ9a56VQIDI/DHyFC8GghianvHCBrVDT5Ukxt05ZYscktaz7pRLbdV1c
	 4o8idnJXNN/nW9z+kq85HweLKuO9/fXi8MTwRqTvRquBMx734+GlSw5yge9pRAF8/S
	 fW6kOU7ovi7h+1hhnw4LRBoXnQVAXSC+dnpSXaRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0794/1536] KVM: nSVM: Ignore EFER.LMA if EFER.LME=0 when preparing L2 state
Date: Sat,  7 Nov 2026 08:46:50 -0500
Message-ID: <20261107135019.848965598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 1c4c84a643b704e473cb171f7b61359ff29b12a4 upstream.

Force EFER.LMA=0 if EFER.LME=0 when preparing L2 state for VMRUN, i.e.
mimic real hardware's behavior of ignoring EFER.LMA if EFER.LME=0.  VMRUN
unfortunately allows the nonsensical combination, i.e. doesn't fail, but
KVM itself has an invariant EFER.LMA can be set et if and only if EFER.LME
is set.   Breaking that invariant can lead to a variety of issue,
particularly in MMU code that keys off EFER.LMA when determining whether to
emulate/virtualization 4/5-level paging versus PAE paging.

Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260902232028.2767071-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -588,6 +588,10 @@ static void nested_vmcb02_prepare_save(s
 
 	kvm_set_rflags(vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 
+	/* SVM ignores EFER.LMA if EFER.LME=0 (instead of failing VMRUN). */
+	if (!(svm->nested.save.efer & EFER_LME))
+		svm->nested.save.efer &= ~EFER_LMA;
+
 	svm_set_efer(vcpu, svm->nested.save.efer);
 
 	svm_set_cr0(vcpu, svm->nested.save.cr0);


