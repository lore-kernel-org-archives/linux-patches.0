Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E391C6B4;
	Tue, 29 Apr 2025 17:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948205; cv=none; b=SkMXcU6Llzu4wdgYm2uQbtUBJ908ZubAqWZOcbVvLYVlW9hsQxRP0fk8/+Cd86JFdLoNOc+DfdBPm+p0us5igGsRa6n62Y6AwBPzfLxAFRekYk8BeCQJ785Y6OpdzH27/gaQQxR1GVCWZi1zN6PsmqJJZpVrpETmfrdqigb+Vz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948205; c=relaxed/simple;
	bh=VxRuh/BlPsyw6ttDLYWKx+k4H45TwFIyM9yU4xZyPkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PMacNVe+bpz5SwS8bHDfOdy8zEQ4exH0yWcvdRLUK0Gf/MMZa0D2uY292ff707WxeAsz4JqStXpS+wLk1luaTi6DlzGcyAAgfbnB4BQW45YBMKyxMcbZLfSsLlZsOF1+vo2rrkXpJumbqqueqQuLnBqrwL68IWJhAvBMNtpskxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOsuL5ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOsuL5ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E62C4CEE3;
	Tue, 29 Apr 2025 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948205;
	bh=VxRuh/BlPsyw6ttDLYWKx+k4H45TwFIyM9yU4xZyPkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOsuL5addOZuwOeACn61I++ImL39gMvKQsN6DnD27jn6ttKVLs3WtVhiEZmLAx0Qy
	 rno1pdzo4rlL5FESaimyn1nKS6L+LVIDM55ffp+Ha7CQGFSWZ60TKoQrZDm5Snwjzi
	 e8QybkpdJfkWHuoM597nQ/Yue0ai7+kE/ruj4shc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Michael Mueller <mimu@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/280] KVM: s390: Dont use %pK through debug printing
Date: Tue, 29 Apr 2025 18:42:23 +0200
Message-ID: <20250429161123.397820213@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 0c7fbae5bc782429c97d68dc40fb126748d7e352 ]

Restricted pointers ("%pK") are only meant to be used when directly
printing to a file from task context.
Otherwise it can unintentionally expose security sensitive,
raw pointer values.

Use regular pointer formatting instead.

Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Tested-by: Michael Mueller <mimu@linux.ibm.com>
Link: https://lore.kernel.org/r/20250217-restricted-pointers-s390-v1-2-0e4ace75d8aa@linutronix.de
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20250217-restricted-pointers-s390-v1-2-0e4ace75d8aa@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/intercept.c |  2 +-
 arch/s390/kvm/interrupt.c |  8 ++++----
 arch/s390/kvm/kvm-s390.c  | 10 +++++-----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index b16352083ff98..f0be263b334ce 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -94,7 +94,7 @@ static int handle_validity(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.exit_validity++;
 	trace_kvm_s390_intercept_validity(vcpu, viwhy);
-	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%pK)", viwhy,
+	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%p)", viwhy,
 		  current->pid, vcpu->kvm);
 
 	/* do not warn on invalid runtime instrumentation mode */
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 4f0e7f61edf78..bc65fa6dc1555 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3161,7 +3161,7 @@ void kvm_s390_gisa_clear(struct kvm *kvm)
 	if (!gi->origin)
 		return;
 	gisa_clear_ipm(gi->origin);
-	VM_EVENT(kvm, 3, "gisa 0x%pK cleared", gi->origin);
+	VM_EVENT(kvm, 3, "gisa 0x%p cleared", gi->origin);
 }
 
 void kvm_s390_gisa_init(struct kvm *kvm)
@@ -3178,7 +3178,7 @@ void kvm_s390_gisa_init(struct kvm *kvm)
 	gi->timer.function = gisa_vcpu_kicker;
 	memset(gi->origin, 0, sizeof(struct kvm_s390_gisa));
 	gi->origin->next_alert = (u32)virt_to_phys(gi->origin);
-	VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
+	VM_EVENT(kvm, 3, "gisa 0x%p initialized", gi->origin);
 }
 
 void kvm_s390_gisa_enable(struct kvm *kvm)
@@ -3219,7 +3219,7 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
 		process_gib_alert_list();
 	hrtimer_cancel(&gi->timer);
 	gi->origin = NULL;
-	VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
+	VM_EVENT(kvm, 3, "gisa 0x%p destroyed", gisa);
 }
 
 void kvm_s390_gisa_disable(struct kvm *kvm)
@@ -3468,7 +3468,7 @@ int __init kvm_s390_gib_init(u8 nisc)
 		}
 	}
 
-	KVM_EVENT(3, "gib 0x%pK (nisc=%d) initialized", gib, gib->nisc);
+	KVM_EVENT(3, "gib 0x%p (nisc=%d) initialized", gib, gib->nisc);
 	goto out;
 
 out_unreg_gal:
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bb7134faaebff..286a224c81ee4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -998,7 +998,7 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		}
 		mutex_unlock(&kvm->lock);
 		VM_EVENT(kvm, 3, "SET: max guest address: %lu", new_limit);
-		VM_EVENT(kvm, 3, "New guest asce: 0x%pK",
+		VM_EVENT(kvm, 3, "New guest asce: 0x%p",
 			 (void *) kvm->arch.gmap->asce);
 		break;
 	}
@@ -3421,7 +3421,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		kvm_s390_gisa_init(kvm);
 	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
 	kvm->arch.pv.set_aside = NULL;
-	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
+	KVM_EVENT(3, "vm 0x%p created by pid %u", kvm, current->pid);
 
 	return 0;
 out_err:
@@ -3484,7 +3484,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_s390_destroy_adapters(kvm);
 	kvm_s390_clear_float_irqs(kvm);
 	kvm_s390_vsie_destroy(kvm);
-	KVM_EVENT(3, "vm 0x%pK destroyed", kvm);
+	KVM_EVENT(3, "vm 0x%p destroyed", kvm);
 }
 
 /* Section: vcpu related */
@@ -3605,7 +3605,7 @@ static int sca_switch_to_extended(struct kvm *kvm)
 
 	free_page((unsigned long)old_sca);
 
-	VM_EVENT(kvm, 2, "Switched to ESCA (0x%pK -> 0x%pK)",
+	VM_EVENT(kvm, 2, "Switched to ESCA (0x%p -> 0x%p)",
 		 old_sca, kvm->arch.sca);
 	return 0;
 }
@@ -3978,7 +3978,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 			goto out_free_sie_block;
 	}
 
-	VM_EVENT(vcpu->kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK",
+	VM_EVENT(vcpu->kvm, 3, "create cpu %d at 0x%p, sie block at 0x%p",
 		 vcpu->vcpu_id, vcpu, vcpu->arch.sie_block);
 	trace_kvm_s390_create_vcpu(vcpu->vcpu_id, vcpu, vcpu->arch.sie_block);
 
-- 
2.39.5



