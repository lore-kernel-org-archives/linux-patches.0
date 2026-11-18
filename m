Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035457;
	b=h2LQJrjYE0b6+sSJxnXzVpAjBzVA2XD9VO1rWokandQ2xbAUi31Oq1pHOOW2JZ+vekqZ
	 OE0VUT8YEU7z0Dn95TXI9SeqqI2HWr31oAQiEgJhbJ3nkWV43nJWe9g76BZfh9GBItpCR
	 IRuInGxnCMk+9RrDLncAW1dKpR3VR5T2kxE7vn37CGXIWhItXBJMj6IQzzx1QfXnrpfJ+
	 OTN5RuF4brLjEmhWT4p4X0ZaeQ0nJRFwixny1MRG2jZGCO0KrOaxD9gmvNKDMegrKb4Dq
	 sXCbrerqjRZG1Pg3tUGmKBb1/Tc83/NJTWlrTyCP0X6oaoXEQ+eDXHPYs2xDIlL046Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VXMBrJ3vxr8WTTk+3MsO5sQobMWprnYi1QD3M0Z6hko=;
	b=lL7Aw6gH1+tLkosybMy6OhtY6xWJP4mY8XnBoDEvIUAUbydm0HEmByF6pyjJTyDqyjbW
	 YwUd6cIKsudSrpbGH8DZdk0rG43P8mHz/aV11tVLOBpcc0np+IHd4vWvlyUj8fs8rsH6T
	 3MJwE+k0bQ7MPkyAYDo696n+3jcAfsiLHsw53K64Tfbp4icqWBTMvtFeUFdWWcJOinwXk
	 Y/Yo1BYXtUm6BkLm3O2nzdvBC0cKcMcriXIB8MN4lURiqCKujjJGHS18gPfF+pi4rJeZ4
	 jXz/KSwugHWd6ZV22kW1Myd+KmnScnayZldc9C9lHGr2swj6IUSX7xltDNCrqiX6keQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y84AKnEU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47063606A31C;
	Wed, 18 Nov 2026 20:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y84AKnEU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965091F000C4;
	Wed, 18 Nov 2026 20:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035457;
	bh=VXMBrJ3vxr8WTTk+3MsO5sQobMWprnYi1QD3M0Z6hko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y84AKnEU/b/WYZHZT+ucDtbFvPC5nqSevANA5SpZxJT9MS4wgew7HESSmKX71KWOO
	 WJ/+9Jea+O+xTtaeJsgfv7NjmWoyddfufag5iF9d+RRbKSHaVfNQY8rsD64CR5rIee
	 46G5YElklt+LnbpMCBagac15ThVmT/+xXbhgG6zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 0712/3318] KVM: nSVM: Ignore EFER.LMA if EFER.LME=0 when preparing L2 state
Date: Wed, 18 Nov 2026 15:22:14 +0100
Message-ID: <20261118150339.800178231@linuxfoundation.org>
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
@@ -592,6 +592,10 @@ static void nested_vmcb02_prepare_save(s
 
 	kvm_set_rflags(vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 
+	/* SVM ignores EFER.LMA if EFER.LME=0 (instead of failing VMRUN). */
+	if (!(svm->nested.save.efer & EFER_LME))
+		svm->nested.save.efer &= ~EFER_LMA;
+
 	svm_set_efer(vcpu, svm->nested.save.efer);
 
 	svm_set_cr0(vcpu, svm->nested.save.cr0);


