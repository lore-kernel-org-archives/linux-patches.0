Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3ADD30EF7D
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 09:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761124586; cv=none; b=tjKhF9M3tYbzKkpiMbHmBkSHID3EeYKdFHb5Qf5oj1y7zplFHLlyT9ihtCtsLxlgSGwr/jjPoUOYFnh4ga3H97ZTuuPFDuiLJTI/oU3T/QCYtdOPe85p0CL/crnHgPdnQwaagMKfi7Kmub3EDz9dIGfl8ay6tLet/fY0PrWtFZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761124586; c=relaxed/simple;
	bh=lvFw5Nk+qH+yvB6NQFEi2D6wt9AdFQ4KBlgZ5RunyW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=USBMYvn1bEC/JjFlMJ3oKSHzmGQ46Q6Yf7/Yc0UQZimHB3kkTXixQs+GsRT1T34fGPlXWAenemdpa2OeOIRahBngply4+irOKV/COk9R6Zz7viyB8XVZv6v6HYcbY6JZS37mM0YHR7K8ilzkq5kxNkqgeFXzJPYArqAB82kQQdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UTSMm5h3; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UTSMm5h3"
Date: Wed, 22 Oct 2025 02:15:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761124569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VCr2v8NiGCG3OxJPegbScRx7+QI9iQUtCm6vrXFxJv4=;
	b=UTSMm5h37kNKIcefL/GrgyqwwYY3qvZFp+9X/VsGTruaCqg1eKxjKIv1AUpmp/5dxC40SF
	PFf785to9H+mNsOrT8zN4vvS3BxHkioHnMjTjKhhPMnRE+01kaTRMjqgB8MzKcEfODNHBd
	1s55RS46i/dDUc/1uLEoelkF9+E7baY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 6.12 006/136] KVM: arm64: Prevent access to vCPU events
 before init
Message-ID: <aPigtSKzinCqc8R6@linux.dev>
References: <20251021195035.953989698@linuxfoundation.org>
 <20251021195036.111716876@linuxfoundation.org>
 <aPiVtgLCCbQ9igWp@linux.dev>
 <2025102247-delighted-cycling-61c4@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025102247-delighted-cycling-61c4@gregkh>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 22, 2025 at 11:03:28AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Oct 22, 2025 at 01:28:38AM -0700, Oliver Upton wrote:
> > Hey,
> > 
> > Can you please drop this patch from all but 6.17?
> > 
> > On Tue, Oct 21, 2025 at 09:49:54PM +0200, Greg Kroah-Hartman wrote:
> > 
> > [...]
> > 
> > > Cc: stable@vger.kernel.org # 6.17
> > 
> > FWIW, I called this out here.
> > 
> > Thanks,
> > Oliver
> > 
> > > Fixes: b7b27facc7b5 ("arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS")
> 
> Ok, but note that this Fixes: tag references a much much older kernel
> release, hence my confusion as to where this should be backported to :)

Yeah, this is a bit confusing. The blame is correct, 6.17 added some
(correct) fireworks to the situation.

> I'll go drop it from older queues now, thanks.

Appreciated!

-- 
Oliver
