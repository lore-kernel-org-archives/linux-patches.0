Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793862304;
	b=ctOeajmhDe69qOWdDYGl1XObO1Q3KR+skblN3te1P4lFZmngeGpWqgrsBoM43SO04JqL
	 4yhGBtqP1wz6CSE7eNNwYNL111/seSbbbMRE43oPglFMlAEc0bHzulbqt9kT7MjVEBH//
	 1eWdGCSJL4R7dXAGkJ9G0fvJW71KuopINtocEQt7bmMGa36ISHoKD3KEj0KyeLjW9SUHJ
	 duk41P7zQfRGIukJXRafnns+aGtx+IAvKyBwEy3B/xaX5ewzpkMciltbcIsBH9zet9jqG
	 2+eZoTlGd0fFTygYtecVfjcg4flzjvUjkuFulnb0Rs/uutFbPX7dNGeQm+idNCRESQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793862304;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=QlIEuET91IH3iKQpMTAuGC8sBpbpkS1ruiNQt1cF4Q0=;
	b=bZ+c5KUrLshLJ7E0b2pabHQasXFEHX8vAWnqEvR4VsP5yTL+2vZ/FTyPKAjvwhfpEPyq
	 doH8E8HaQvOmNUxDP5huPzy2Oo0Da4lmkXbt6LzOVRL64UFW/dn9Ly2lxGrZ52YFfC6ir
	 TEEgezzZ7HtSSwvT+NPeWidwy90hXzwI+UHq/zIygpzGHn1sUB65+5MNp6L0tiXNsqoho
	 LNMelchFrlogl2WJ/nK5C34DzVJ9bLM6h6UEZNOVuwlG1LlBC6o0BFRgWPuCPcx45EsOx
	 Y2PLQPZfgeVg5NlhjnI8pFrOb0TfIipeOo/WVwdsisBii2UfX7VV9KM3lU0sTe5tzPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lwioWRqQ;
	arc=none smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02328606A31B
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 07:05:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02328606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lwioWRqQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793862302; x=1825398302;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=McgwgcpuKSeUPehU0yM05wGhCrOsl3CTnR9MbzE07xA=;
  b=lwioWRqQNWpmdH+HjeD+9HUdjT4ckV5ZLcypRY9fYE53/U1FDRImhRxw
   krEJ9AYEfrHmheMo2i5yhIPQ3SivdP2jiN7wPmUiTBXBiBonPQ+LGcnUr
   snifna0DGvaqydyxz0JbR5Nnj8j+AOQpBrHSrMs0yawyHbI5DHtxgq72+
   QQS+TI/y+0pGYE3Z8BIuIijj6sIvjS1hSni7h3KCBl55hOYuya+XM0iLq
   OHceg/wCTgCEBXqC8UijIy9WL0t1qwvobqtO2FA+WBODQeHhnxQNAPHz9
   qv/fq7dUVyAqGWSSGcLuQjMv3bz3OlCUE7yMILdVfh4I4+qr0wlwfPDCA
   A==;
X-CSE-ConnectionGUID: 1QGKr7zhT/ijptupwz8Ixw==
X-CSE-MsgGUID: KQDlfZ8+Sj2+iq9XoT2KyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2674189"
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="2674189"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 23:05:01 -0800
X-CSE-ConnectionGUID: ZMrSdDUEQjmQYyR8ZsLkSw==
X-CSE-MsgGUID: YeWVfUnDSX2I1h6ejbK4BQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="6996656"
Received: from unknown (HELO [10.238.0.97]) ([10.238.0.97])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 23:04:59 -0800
Message-ID: <dac4e304-98e6-4e61-93f4-8d971069d936@intel.com>
Date: Thu, 5 Nov 2026 15:04:56 +0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0942/1005] KVM: TDX: Enable Bus Lock VM exit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Nikolay Borisov <nik.borisov@suse.com>,
 Sean Christopherson <seanjc@google.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>
References: <20261104211043.516122098@linuxfoundation.org>
 <20261104211109.504581890@linuxfoundation.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20261104211109.504581890@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/2026 5:11 AM, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.  If anyone has any objections, please let me know.

There are some dependency patches failed to be backported [1][2][3]. What is the
preferred way to handle it? prepare a separate series for 6.18-stable with all
the necessary patches?

[1] https://lore.kernel.org/all/2026110415-porous-slather-09d5@gregkh/
[2] https://lore.kernel.org/all/2026110443-stage-reproach-62d3@gregkh/
[3] https://lore.kernel.org/all/2026110444-external-riverbed-0f47@gregkh/

> ------------------
> 
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> commit 63d196e2e20429de5ba501f1b6059d9b93140007 upstream.
> 
> Enable Bus Lock VM exit functionality for TDX guests.
> 
> Bus Lock VM exit is an existing feature supported by KVM.  Userspace can
> enable Bus Lock VM exit through KVM_BUS_LOCK_DETECTION_EXIT when it's
> reported as supported.  However, KVM reports the support of this CAP
> just based on the hardware capability but doesn't differentiate between
> VMX and TDX.  This leads to the issue that userspace can enable this cap
> for TDX guests without getting an error, but the feature is not actually
> enabled because KVM doesn't call the TDX module API to program the
> relevant TD VMCS fields.
> 
> Enable Bus Lock VM exit for TDX guests by programming the
> BUS_LOCK_DETECTION control in the TD VMCS and by adding the exit handler.
> 
> Note, there is no enumeration bit for this feature by TDX module because
> all TDX modules support it and allow to set the TD VMCS as long as the
> hardware supports the feature.
> 
> Fixes: 161d34609f9b ("KVM: TDX: Make TDX VM type supported")
> Cc: stable@vger.kernel.org
> Originally-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> Link: https://patch.msgid.link/20260819094903.3060020-9-xiaoyao.li@intel.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/x86/kvm/vmx/tdx.c |   24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2042,7 +2042,7 @@ int tdx_complete_emulated_msr(struct kvm
>  }
>  
>  
> -int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> +static int __tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>  {
>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
>  	u64 vp_enter_ret = tdx->vp_enter_ret;
> @@ -2143,6 +2143,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcp
>  	case EXIT_REASON_NOTIFY:
>  		/* NMI blocking state is handled by TDX module */
>  		return __vt_handle_notify(vcpu, vmx_get_exit_qual(vcpu));
> +	case EXIT_REASON_BUS_LOCK:
> +		return vt_handle_bus_lock_vmexit(vcpu);
>  	default:
>  		break;
>  	}
> @@ -2156,6 +2158,22 @@ unhandled_exit:
>  	return 0;
>  }
>  
> +int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> +{
> +	int ret = __tdx_handle_exit(vcpu, fastpath);
> +
> +	/* Exit to user space when bus lock was detected */
> +	if (vmx_get_exit_reason(vcpu).bus_lock_detected) {
> +		if (ret > 0) {
> +			vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
> +			ret = 0;
> +		}
> +
> +		vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
> +	}
> +	return ret;
> +}
> +
>  void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>  		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
>  {
> @@ -3151,6 +3169,10 @@ static int tdx_vcpu_init(struct kvm_vcpu
>  				vcpu->kvm->arch.notify_window);
>  	}
>  
> +	if (vcpu->kvm->arch.bus_lock_detection_enabled)
> +		td_vmcs_setbit32(tdx, SECONDARY_VM_EXEC_CONTROL,
> +				 SECONDARY_EXEC_BUS_LOCK_DETECTION);
> +
>  	tdx->state = VCPU_TD_STATE_INITIALIZED;
>  
>  	return 0;

