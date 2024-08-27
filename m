Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749BA1D47C8
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 18:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784997; cv=none; b=o3CHIXkwk/rilgKBc/pM2YPPqqrXRcaUIy63OlNVSH83eJb91kkg0cQJI5+TZbgqZeHVtt89EhiJvl20GCuWv8lnm/dDdAGjPbs1xAKfZ4dAgtbmrjQNMajImCI40YF0u2Xh85scsXtncyeviE5mjtlOdEs45zl1z73fkzpe2Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784997; c=relaxed/simple;
	bh=Ka2T5YdW6oNpZNQU7rr8zr6Y0HG4jm+2UxDZANRTCCA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e/8TP09hxyOHGgniVm2K2SZAihcr4wwgXW6TT5ZiU15rCZyNqfMhjmI0rIEv7xQuw+bCOFQzwYkFAIO2eaTO8ezfS8m7EzR+S3Wx9p9Eh+6SizNQ0xc2Fz85s5ikHhVS6KHGxrVnwfxPsj6I184djFpIyPsbMjBxD78djVCqT8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RlbrNVPl; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RlbrNVPl"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0353b731b8so10043854276.2
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 11:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724784994; x=1725389794; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7WVEg6iQOl2Kkuc9v2k09ZHppiBPP1VstSQCds7jk4I=;
        b=RlbrNVPlOdH0Qj7XbUgtgwQ8NdOSUIYz6c7bmZ30+wsYk+mtV76imZzirijmEyjUCU
         2Vuf39A9JtvztX5Bm6pEVhJoqLziOmFaRx4v59VmMV6DxA+L5MqU9bEpOjt3MBBaMjAl
         NSJiFIXVR5SIpm0n/1ei3etiYF9VLm/rC4VYfTcB5IVeto7QAy4ORbP9OCsV9gIu6t3S
         eYPYCqfbAXzeIk5+oGgXuDqm4SY9y68hE7DmARYdsRoKnFQRdKbOeRUSNP3MT0WNOhzH
         ZMMwX4aCpbvZTODDExF6PcZp8AEMOsnV+hB+c218GvsWtukI/0xCXyhcI8K7XXNIw6XM
         jYuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724784994; x=1725389794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7WVEg6iQOl2Kkuc9v2k09ZHppiBPP1VstSQCds7jk4I=;
        b=W/qFgGuPBPL2/mBAl6o9ttrE9K4y/q6hYLma/q6Mof4sFpwLQujycyDhSwIASgszG4
         MX6TQKQwSEPRyzeeywvnmxmrg0CmiSSKBDWinA/h1ViQVBQaG2kjbQ9HTlKgvTzuT2tc
         dgc3G1NAaJuz65L+KApxKN4IsynJbtT5kQ+6PhsoeXcYFbLLAk+GI6HUIQ5PZCrgUSNw
         FiLMgrNKxQIw8IMHWWzVFlhR0l1sBnZ90Bh0wLEZ9yBEcLLzedoGIhZCnuMG53VHM2Eq
         w394wLpjWZQ14RCGoBVeQdDBI+v/WFOjB96CtxO0QdYyVXTLY7FMnjK5YOrkPxMrOIAq
         x3ew==
X-Forwarded-Encrypted: i=1; AJvYcCVpYvXqYzpTGE+dYcbZs8gl5QhZd654+iAP/a3K2D9liSU265+/Vy0WKwnFewjZ68ZcCto75ha2@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7lwNITZ5eJavRxFBbUS94ispZqIr3ly6LEksZGEDAOVBibrem
	a+HC7PKCCjMMgTPWPf2RSoEAvuyRQmPwPEGn9aGaILE5CcAyQx3U5H1o70wZ1++ZS1s9tmQsxSu
	glA==
X-Google-Smtp-Source: AGHT+IF0TO61acJ/N4PuAFd2nLlAdHN6lDaWX9AJ95EYuBVufRmStWP1YlaUca9GBUj8JvN1i83vthonfHs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d6c1:0:b0:e11:5e87:aa9 with SMTP id
 3f1490d57ef6-e17a863e967mr20488276.8.1724784994284; Tue, 27 Aug 2024 11:56:34
 -0700 (PDT)
Date: Tue, 27 Aug 2024 11:56:32 -0700
In-Reply-To: <20240827143849.600025269@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240827143838.192435816@linuxfoundation.org> <20240827143849.600025269@linuxfoundation.org>
Message-ID: <Zs4hYMSkyDtUdq6d@google.com>
Subject: Re: [PATCH 6.1 298/321] KVM: x86: fire timer when it is migrated and
 expired, and in oneshot mode
From: Sean Christopherson <seanjc@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Peter Shier <pshier@google.com>, Jim Mattson <jmattson@google.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Li RongQing <lirongqing@baidu.com>, David Hunter <david.hunter.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 27, 2024, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.

Purely to try and avoid more confusion,

Acked-by: Sean Christopherson <seanjc@google.com>

as the fix that needs to be paired with this commit has already landed in 6.1.y
as 7545ddda9c98 ("KVM: x86: Fix lapic timer interrupt lost after loading a snapshot.")

> ------------------
> 
> From: Li RongQing <lirongqing@baidu.com>
> 
> commit 8e6ed96cdd5001c55fccc80a17f651741c1ca7d2 upstream.
> 
> when the vCPU was migrated, if its timer is expired, KVM _should_ fire
> the timer ASAP, zeroing the deadline here will cause the timer to
> immediately fire on the destination
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Peter Shier <pshier@google.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Link: https://lore.kernel.org/r/20230106040625.8404-1-lirongqing@baidu.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Hunter <david.hunter.linux@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/x86/kvm/lapic.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1843,8 +1843,12 @@ static bool set_target_expiration(struct
>  		if (unlikely(count_reg != APIC_TMICT)) {
>  			deadline = tmict_to_ns(apic,
>  				     kvm_lapic_get_reg(apic, count_reg));
> -			if (unlikely(deadline <= 0))
> -				deadline = apic->lapic_timer.period;
> +			if (unlikely(deadline <= 0)) {
> +				if (apic_lvtt_period(apic))
> +					deadline = apic->lapic_timer.period;
> +				else
> +					deadline = 0;
> +			}
>  			else if (unlikely(deadline > apic->lapic_timer.period)) {
>  				pr_info_ratelimited(
>  				    "kvm: vcpu %i: requested lapic timer restore with "
> 
> 
