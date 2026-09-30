Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9773B71B6;
	Wed, 30 Sep 2026 17:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789966; cv=none; b=Y8nF28Cde47PQcqQOL5wSy2c/e1v8ii8HdQQw82om5DwOZ0mYMyY0g/F8JKXcXujR3l/PTSHBOo4sjTOfKH5manjQpIeuy6QJM9wrefRd0IEveNs9ZQJzo8FGpFk0ae/UEE5X1XdY2caD63PEVkzY/8NPqIP1Gpg6yIdNWJi0Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789966; c=relaxed/simple;
	bh=wkc2tq0Dcg913uB7qHcUu+7J1Gr3dBg7JlFCwZNt3V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkauurKSteySuf6Rc6YS95TO2YqlAElUNlw7qu84yY1qvuYOayYSe7Lf8fwnL751ht4pOuwgCMmNuZBkEGoMOmQLh6GCIdYAEVdEL/4XEINT+pNgdUzoARq83VQGs7vSUwIsRQPs3WB6GbRw6f8fXox+D04zOOAuLjbBCPomIPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Peo+yh9D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Peo+yh9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582291F000FF;
	Wed, 30 Sep 2026 17:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789964;
	bh=puf7r5/A5VYcZb5wuZFHFCQk2rlk02Kwlbydoiz/OR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Peo+yh9DLUV9VOUyfPti04zrZCzIev+5pR/Eg1HM3HOH2FEQOaPjuynwWSSWBLltz
	 oOu1SxZL0xpK2Hq7oMZXEtidKJYVlEt1nGyZScywm926fxgQjcL6Oldcg91+D5pNc+
	 iewLoHz+teAtajpCJoByfK2M+ug7Z2jZJZZUkC8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 663/877] KVM: x86: Rename __{g,s}et_sregs2() => kvm_vcpu_ioctl_x86_{g,s}et_sregs2()
Date: Wed, 30 Sep 2026 17:26:14 +0200
Message-ID: <20260930152428.971487800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -135,8 +135,10 @@ static void store_regs(struct kvm_vcpu *
 static int sync_regs(struct kvm_vcpu *vcpu);
 static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu);
 
-static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
-static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
+static int kvm_vcpu_ioctl_x86_set_sregs2(struct kvm_vcpu *vcpu,
+					 struct kvm_sregs2 *sregs2);
+static void kvm_vcpu_ioctl_x86_get_sregs2(struct kvm_vcpu *vcpu,
+					  struct kvm_sregs2 *sregs2);
 
 static DEFINE_MUTEX(vendor_module_lock);
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
@@ -6304,7 +6306,7 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 		r = -ENOMEM;
 		if (!u.sregs2)
 			goto out;
-		__get_sregs2(vcpu, u.sregs2);
+		kvm_vcpu_ioctl_x86_get_sregs2(vcpu, u.sregs2);
 		r = -EFAULT;
 		if (copy_to_user(argp, u.sregs2, sizeof(struct kvm_sregs2)))
 			goto out;
@@ -6323,7 +6325,7 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 			u.sregs2 = NULL;
 			goto out;
 		}
-		r = __set_sregs2(vcpu, u.sregs2);
+		r = kvm_vcpu_ioctl_x86_set_sregs2(vcpu, u.sregs2);
 		break;
 	}
 	case KVM_HAS_DEVICE_ATTR:
@@ -11845,7 +11847,8 @@ static void __get_sregs(struct kvm_vcpu
 			(unsigned long *)sregs->interrupt_bitmap);
 }
 
-static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
+static void kvm_vcpu_ioctl_x86_get_sregs2(struct kvm_vcpu *vcpu,
+					  struct kvm_sregs2 *sregs2)
 {
 	int i;
 
@@ -12108,7 +12111,8 @@ static int __set_sregs(struct kvm_vcpu *
 	return 0;
 }
 
-static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
+static int kvm_vcpu_ioctl_x86_set_sregs2(struct kvm_vcpu *vcpu,
+					 struct kvm_sregs2 *sregs2)
 {
 	int mmu_reset_needed = 0;
 	bool valid_pdptrs = sregs2->flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;


