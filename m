Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66962F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 09:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681291742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lqVDWElXC4Tf6NPfdeK1ubEJzR6tfLP2XsmRhS23+rk=;
	b=ApZ0wav4sd1JuU7eLRwwHTwjN12a9DnBrsmvIoLZqjrjOJBFE03CGv6TrJ4hn681sC0D8L
	+THiKlJpBbtY4rWUlqrPsHalRa/2PPZ/MOR+TTYPqmUOCaGyuaXV3e6uvWhE5yEnque9fD
	k5M91Fw2QIc+oT0DmDPOEbjnfE6bwRM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-VKLu7zJ9Mq2EAJiuJLorSw-1; Wed, 12 Apr 2023 05:29:01 -0400
X-MC-Unique: VKLu7zJ9Mq2EAJiuJLorSw-1
Received: by mail-qt1-f198.google.com with SMTP id u1-20020a05622a198100b003e12a0467easo8370602qtc.11
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 02:29:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681291741; x=1683883741;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lqVDWElXC4Tf6NPfdeK1ubEJzR6tfLP2XsmRhS23+rk=;
        b=WdEsa+onpXjCFGRAFARv4kOi8xND0Axl+eifbUP4Iu69K6avFhplAtHtOLRTzPstSV
         jo41Wqy3fJQuJFegGxANCHkdXmSrA5ALEL1hBmHmvFRLMskxPyM1iQRCaWZCQWYGWgfR
         VTaNGovjRfh0SlXT5Nj9zG+LHlDHHgoar3i0pjlwpcqbdxyZxS6DgS2K8p1NuI9ZO8lm
         K0S0U+5+v4w9gBeKNdQiHCnzn00rXA2ej0Zx8cLrSnDERURZVj81iuFGGJ463CvoN7Qw
         c9omO0QfabU1K9SKqiPaBnFsSV4QK7BCdE9rq7DsYFz7saCKncw+AVzla7tgFxrodAkf
         Pikg==
X-Gm-Message-State: AAQBX9d0+IuPtZhot2ssq0Y7cje7Fhrceo4XVteoFoUctVvVbsf0ObVM
	0xLlWycr181ot2WW0a2lvL54tjGEP9pIEtL2de0o+F00EOJq6WurPsfpVlcbxef12uaQtrEFojQ
	o1NdgHl+DKdtl3KZ5bw==
X-Received: by 2002:a05:6214:301e:b0:56e:b557:2d4e with SMTP id ke30-20020a056214301e00b0056eb5572d4emr24552909qvb.6.1681291741221;
        Wed, 12 Apr 2023 02:29:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zo3bltmTFRNw9Q5XFnc491rl/xI7eymxmZmguOq38MJbjOSY8sZcQlFzJrp/r0KPS/QoXucQ==
X-Received: by 2002:a05:6214:301e:b0:56e:b557:2d4e with SMTP id ke30-20020a056214301e00b0056eb5572d4emr24552897qvb.6.1681291740890;
        Wed, 12 Apr 2023 02:29:00 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id x12-20020a0cff2c000000b005dd8b93459asm1625383qvt.50.2023.04.12.02.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 02:29:00 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jeremi Piotrowski
 <jpiotrowski@linux.microsoft.com>, Sean Christopherson <seanjc@google.com>
Cc: patches@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 6.2 101/173] KVM: SVM: Flush Hyper-V TLB when required
In-Reply-To: <20230412082842.164450040@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
 <20230412082842.164450040@linuxfoundation.org>
Date: Wed, 12 Apr 2023 11:28:57 +0200
Message-ID: <87jzyhfnza.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
>
> commit e5c972c1fadacc858b6a564d056f177275238040 upstream.
>
> The Hyper-V "EnlightenedNptTlb" enlightenment is always enabled when KVM
> is running on top of Hyper-V and Hyper-V exposes support for it (which
> is always). On AMD CPUs this enlightenment results in ASID invalidations
> not flushing TLB entries derived from the NPT. To force the underlying
> (L0) hypervisor to rebuild its shadow page tables, an explicit hypercall
> is needed.
>
> The original KVM implementation of Hyper-V's "EnlightenedNptTlb" on SVM
> only added remote TLB flush hooks. This worked out fine for a while, as
> sufficient remote TLB flushes where being issued in KVM to mask the
> problem. Since v5.17, changes in the TDP code reduced the number of
> flushes and the out-of-sync TLB prevents guests from booting
> successfully.
>
> Split svm_flush_tlb_current() into separate callbacks for the 3 cases
> (guest/all/current), and issue the required Hyper-V hypercall when a
> Hyper-V TLB flush is needed. The most important case where the TLB flush
> was missing is when loading a new PGD, which is followed by what is now
> svm_flush_tlb_current().
>
> Cc: stable@vger.kernel.org # v5.17+
> Fixes: 1e0c7d40758b ("KVM: SVM: hyper-v: Remote TLB flush for SVM")
> Link: https://lore.kernel.org/lkml/43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com/
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20230324145233.4585-1-jpiotrowski@linux.microsoft.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

It seems issues are still observed even with this fix, right?:
https://lore.kernel.org/kvm/959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com/

Jeremi, Sean, do you thing it's still worth it to push this to stable@?
IMO a small patch disabling TDP MMU on Hyper-V would be better for the
time being...

> ---
>  arch/x86/kvm/kvm_onhyperv.h     |    5 +++++
>  arch/x86/kvm/svm/svm.c          |   37 ++++++++++++++++++++++++++++++++++---
>  arch/x86/kvm/svm/svm_onhyperv.h |   15 +++++++++++++++
>  3 files changed, 54 insertions(+), 3 deletions(-)
>
> --- a/arch/x86/kvm/kvm_onhyperv.h
> +++ b/arch/x86/kvm/kvm_onhyperv.h
> @@ -12,6 +12,11 @@ int hv_remote_flush_tlb_with_range(struc
>  int hv_remote_flush_tlb(struct kvm *kvm);
>  void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
>  #else /* !CONFIG_HYPERV */
> +static inline int hv_remote_flush_tlb(struct kvm *kvm)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
>  {
>  }
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3718,7 +3718,7 @@ static void svm_enable_nmi_window(struct
>  	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
>  }
>  
> -static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> +static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> @@ -3742,6 +3742,37 @@ static void svm_flush_tlb_current(struct
>  		svm->current_vmcb->asid_generation--;
>  }
>  
> +static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> +{
> +	hpa_t root_tdp = vcpu->arch.mmu->root.hpa;
> +
> +	/*
> +	 * When running on Hyper-V with EnlightenedNptTlb enabled, explicitly
> +	 * flush the NPT mappings via hypercall as flushing the ASID only
> +	 * affects virtual to physical mappings, it does not invalidate guest
> +	 * physical to host physical mappings.
> +	 */
> +	if (svm_hv_is_enlightened_tlb_enabled(vcpu) && VALID_PAGE(root_tdp))
> +		hyperv_flush_guest_mapping(root_tdp);
> +
> +	svm_flush_tlb_asid(vcpu);
> +}
> +
> +static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * When running on Hyper-V with EnlightenedNptTlb enabled, remote TLB
> +	 * flushes should be routed to hv_remote_flush_tlb() without requesting
> +	 * a "regular" remote flush.  Reaching this point means either there's
> +	 * a KVM bug or a prior hv_remote_flush_tlb() call failed, both of
> +	 * which might be fatal to the guest.  Yell, but try to recover.
> +	 */
> +	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
> +		hv_remote_flush_tlb(vcpu->kvm);
> +
> +	svm_flush_tlb_asid(vcpu);
> +}
> +
>  static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4747,10 +4778,10 @@ static struct kvm_x86_ops svm_x86_ops __
>  	.set_rflags = svm_set_rflags,
>  	.get_if_flag = svm_get_if_flag,
>  
> -	.flush_tlb_all = svm_flush_tlb_current,
> +	.flush_tlb_all = svm_flush_tlb_all,
>  	.flush_tlb_current = svm_flush_tlb_current,
>  	.flush_tlb_gva = svm_flush_tlb_gva,
> -	.flush_tlb_guest = svm_flush_tlb_current,
> +	.flush_tlb_guest = svm_flush_tlb_asid,
>  
>  	.vcpu_pre_run = svm_vcpu_pre_run,
>  	.vcpu_run = svm_vcpu_run,
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -6,6 +6,8 @@
>  #ifndef __ARCH_X86_KVM_SVM_ONHYPERV_H__
>  #define __ARCH_X86_KVM_SVM_ONHYPERV_H__
>  
> +#include <asm/mshyperv.h>
> +
>  #if IS_ENABLED(CONFIG_HYPERV)
>  
>  #include "kvm_onhyperv.h"
> @@ -15,6 +17,14 @@ static struct kvm_x86_ops svm_x86_ops;
>  
>  int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
>  
> +static inline bool svm_hv_is_enlightened_tlb_enabled(struct kvm_vcpu *vcpu)
> +{
> +	struct hv_vmcb_enlightenments *hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
> +
> +	return ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB &&
> +	       !!hve->hv_enlightenments_control.enlightened_npt_tlb;
> +}
> +
>  static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>  {
>  	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
> @@ -80,6 +90,11 @@ static inline void svm_hv_update_vp_id(s
>  }
>  #else
>  
> +static inline bool svm_hv_is_enlightened_tlb_enabled(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> +
>  static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>  {
>  }
>
>

-- 
Vitaly

