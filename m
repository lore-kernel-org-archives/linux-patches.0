Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7373AE707;
	Sat, 12 Sep 2026 07:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196765; cv=none; b=rvGZg2v3CNjbwy2BWvyUswq2JBMEjrkicMFj+TB7LnhyFMLX5rM7l5rZiJbojzBgXYtoJaeMBaiwrUcgHA9OdJ9tBB5YsPzC8iXiYUGHKTcgMosKJgS+1RUgXotpWwAy74qf5iCAuSmZ/k63beIcRsuibMofLNWYIwNnAQY/FAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196765; c=relaxed/simple;
	bh=8JUVxz0dQJ+9ysMcx3lf36ycYdl92Z44MVir4gDvJrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMRWMwmxSrtcoZhBdjNY6B2fmD/QWb19Db1Y6kKwL0DsGe499CAYtpi0iSaunstkTJKF6Okx6Pu87wZaM3HYH7WigJuUvKZSprCBM/YqaiDv/59ZCeHO1089sRmLWnhFpZQofD5BUTC9kCDNYnqmc9B/VsSHr3G+Z7fQRDiLd8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDiYL3+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDiYL3+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259FA1F00893;
	Sat, 12 Sep 2026 07:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196762;
	bh=+fuZWKC8cEfWSBf1FxQHNFuOJfCzAJQRYvoiMPpNWdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDiYL3+gcUR5UPIUa5Hvbh7NrMF7l4KB91aQHX4wu6jlSBSJrOtqyuZhldwtdaHMX
	 UD7pJvgD0/r129bsoVQsR1Zfqa/BvWDe1GvSuqV/qBAEPqzwe0sgS199c302u33hWL
	 paMCqzH6sbGHIkul4RABbYRzIXkXhpBEFRwO9zpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0031/1815] KVM: x86: Rename __{g,s}et_sregs2() => kvm_vcpu_ioctl_x86_{g,s}et_sregs2()
Date: Sat, 12 Sep 2026 08:29:41 +0200
Message-ID: <20260912065649.741324492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit bd130c8d72a1c7dde5523b3f3fae9867eafaa1dc ]

Rename the KVM_{G,S}ET_SREGS2 helpers in anticipation of moving them out of
x86.c (while leaving the ioctl dispatch behind).  Having globally visible
APIs named __{g,s}et_sregs2() would be "fine", but ugly, given that
__{g,s}et_sregs() will NOT be globally visible.  As a bonus, this makes it
a bit more obvious that the helpers implement newer versions of
kvm_arch_vcpu_ioctl_set_sregs().

No functional change intended.

Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Message-ID: <20260613000329.732085-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 184bd464bdb6 ("KVM: x86: Check EFER validity on KVM_SET_SREGS*")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -133,8 +133,10 @@ static void __kvm_set_rflags(struct kvm_
 static void store_regs(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
 
-static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
-static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
+static int kvm_vcpu_ioctl_x86_set_sregs2(struct kvm_vcpu *vcpu,
+					 struct kvm_sregs2 *sregs2);
+static void kvm_vcpu_ioctl_x86_get_sregs2(struct kvm_vcpu *vcpu,
+					  struct kvm_sregs2 *sregs2);
 
 static DEFINE_MUTEX(vendor_module_lock);
 static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
@@ -6623,7 +6625,7 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 		r = -ENOMEM;
 		if (!u.sregs2)
 			goto out;
-		__get_sregs2(vcpu, u.sregs2);
+		kvm_vcpu_ioctl_x86_get_sregs2(vcpu, u.sregs2);
 		r = -EFAULT;
 		if (copy_to_user(argp, u.sregs2, sizeof(struct kvm_sregs2)))
 			goto out;
@@ -6642,7 +6644,7 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 			u.sregs2 = NULL;
 			goto out;
 		}
-		r = __set_sregs2(vcpu, u.sregs2);
+		r = kvm_vcpu_ioctl_x86_set_sregs2(vcpu, u.sregs2);
 		break;
 	}
 	case KVM_HAS_DEVICE_ATTR:
@@ -12221,7 +12223,8 @@ static void __get_sregs(struct kvm_vcpu
 			(unsigned long *)sregs->interrupt_bitmap);
 }
 
-static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
+static void kvm_vcpu_ioctl_x86_get_sregs2(struct kvm_vcpu *vcpu,
+					  struct kvm_sregs2 *sregs2)
 {
 	int i;
 
@@ -12489,7 +12492,8 @@ static int __set_sregs(struct kvm_vcpu *
 	return 0;
 }
 
-static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
+static int kvm_vcpu_ioctl_x86_set_sregs2(struct kvm_vcpu *vcpu,
+					 struct kvm_sregs2 *sregs2)
 {
 	int mmu_reset_needed = 0;
 	bool valid_pdptrs = sregs2->flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;


