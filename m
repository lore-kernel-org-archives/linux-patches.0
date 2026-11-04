Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831812;
	b=2YLcHX3tDU8LEblcG86hEMov1Ye1yOS/rEs6DaFeRcWMHjET9uJCBxHMHI5wN/NQWCVn
	 0quIBAfSyIDZC+A9HLUFLNQgnwM3OcSYVPWSByq0hYjq7sHMJiNN99/JWy5CIG0juuUOp
	 J+c599jAWBAJ1ykjZBJW77xaHjgAo2Bg73wj45rFofE3tgoeHCnikEeE0gzm9hbG6wcV8
	 t3nBHi2INR4+tNGjrrQ+j2tCr2b0vMRg7UxCraKM3hppchpvSy0kq72fvpa08TMVlAYiU
	 FzJx22Y1WJ1Lj/8xia0sIh4p5EdcVkNUUoRqh3VKyuOyB0pW+lnOJzl1FKvO7JlXibw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0857d9FV4bbO3/WUXOKbdq/qWvU4Znl+l8g4zrm8yPM=;
	b=ogmuEbWIQXcdXwYtiD9HETpGxHlrBBYPYF0ZRIa8cJHD74hIWOWPBhDD/Xb2iGwB2SdY
	 Bhf3AbP/VTfPgFXQg6a2v4UtlVu6WxID+4+Qjz50uMh+HrU/AlzQ2vK01WUIaManZHWMK
	 Gx7DRZudW2GC78BE174ATbe7qsDPTMZOa4sB/8DORP8mqz/1Ff51J980WgzemRw17xlDl
	 abrcMlha0LNiIZuVLhr5sMy/KSukn1rlO/w/SpZiKekNiq45kp+8HyfCnVrE//gIO5yT2
	 ByGQbQj7uaddx00q1XCkWEuz/+k0YioA3tguDivoFSmna1dtNh9DOyJO0HxgJQXQRxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TaYc6vhq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F15606A86B;
	Wed,  4 Nov 2026 22:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TaYc6vhq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E171F0093A;
	Wed,  4 Nov 2026 22:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831811;
	bh=0857d9FV4bbO3/WUXOKbdq/qWvU4Znl+l8g4zrm8yPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TaYc6vhqmv1RC/iyzr1URrMK6qWqtRRa8vs4qCJjU+OBf8rtSSAEUd1tf6pvLxfT/
	 hB4frnH+mD8sQd7GGh45ALTjQACdvdCGXRQNPkerjuOkWTMIuHXngq7PufyQUnYdlO
	 lkujMqnXG8P1RdR1RX4NJ8kxUcY5qxItxyBAVMvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 0926/1005] KVM: nSVM: Ignore EFER.LMA if EFER.LME=0 when preparing L2 state
Date: Wed,  4 Nov 2026 16:10:59 -0500
Message-ID: <20261104211109.077476331@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -671,6 +671,10 @@ static void nested_vmcb02_prepare_save(s
 
 	kvm_set_rflags(vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 
+	/* SVM ignores EFER.LMA if EFER.LME=0 (instead of failing VMRUN). */
+	if (!(svm->nested.save.efer & EFER_LME))
+		svm->nested.save.efer &= ~EFER_LMA;
+
 	svm_set_efer(vcpu, svm->nested.save.efer);
 
 	svm_set_cr0(vcpu, svm->nested.save.cr0);


