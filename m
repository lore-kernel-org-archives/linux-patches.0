Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D2730F53E;
	Wed, 22 Oct 2025 09:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761123811; cv=none; b=JbiyMz1XPnIzg059BP0no6TY2EQv9mGe64zml1MfYx1qJRjL/Mo17FJYaFutgntv3GB9VUIgCZDLqcPNKlLxiHjG5T8XWrev2hwhye2YKgxP6cT5Blt4i9Pb7OIpLzo53fwry6CQb5kdKT4V+htgBrUl5Po+G0AV2VgTqvSYUTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761123811; c=relaxed/simple;
	bh=1AIH2AYzLPkYaHTuJ+0VCesAbN3+Q26DFihqpPIVOT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZSVuINHVYt6FkUl6tAEJ0/13LIBcFsdTDt9ZO36/l9KfU+nCdjfVa3oBvn0D+VLQzrP3HlfQhKb1+JzjkAnYP4IVQihh4MMXgeeE36/JiVvqA7CC5F/wHKiIwCMdqGZF/ayYgPVc8vPz3BFtS7UDSJgVpYJv6fqZSp0soz8kafw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWNfs8BH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWNfs8BH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850D5C4CEFD;
	Wed, 22 Oct 2025 09:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761123810;
	bh=1AIH2AYzLPkYaHTuJ+0VCesAbN3+Q26DFihqpPIVOT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HWNfs8BH3PLxKN94ZqFqGtlNDCBrhcl1ZVjiIQDgmBrd0n+tWB9nQFrWAuFYPNyQF
	 vzS+0y4KLHeQFGEx42sAJHJKu/Ir5zF36Lgh80fZCxhIz6xBvGIdYpeu+92NkszOl1
	 mb2fUylkBsJdM+O7GOTqMMYNZHFlP1cs1xBpcFhw=
Date: Wed, 22 Oct 2025 11:03:28 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 6.12 006/136] KVM: arm64: Prevent access to vCPU events
 before init
Message-ID: <2025102247-delighted-cycling-61c4@gregkh>
References: <20251021195035.953989698@linuxfoundation.org>
 <20251021195036.111716876@linuxfoundation.org>
 <aPiVtgLCCbQ9igWp@linux.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPiVtgLCCbQ9igWp@linux.dev>

On Wed, Oct 22, 2025 at 01:28:38AM -0700, Oliver Upton wrote:
> Hey,
> 
> Can you please drop this patch from all but 6.17?
> 
> On Tue, Oct 21, 2025 at 09:49:54PM +0200, Greg Kroah-Hartman wrote:
> 
> [...]
> 
> > Cc: stable@vger.kernel.org # 6.17
> 
> FWIW, I called this out here.
> 
> Thanks,
> Oliver
> 
> > Fixes: b7b27facc7b5 ("arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS")

Ok, but note that this Fixes: tag references a much much older kernel
release, hence my confusion as to where this should be backported to :)

I'll go drop it from older queues now, thanks.

greg k-h
