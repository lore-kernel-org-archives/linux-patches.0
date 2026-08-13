Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCB1486621
	for <patches@lists.linux.dev>; Thu, 13 Aug 2026 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786633932; cv=none; b=hYMAe6wNdRkxtyqWkZVGJ2KBs9Ow+EvxAyWfode/1XasxvVJFr40kGLI71eUTzxD/wQTiqSKhbAAmU0TjkVobzanVOtcby6sILozZu/u9NUdCtXesCW8lDHp010MCmCK0ZBUVgMjaXqAKwnBzanAcDjN+1g4kUX9MEAhX4rsQ+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786633932; c=relaxed/simple;
	bh=kh4zC29toRXjwtuA0yBHRcNgVKlbLvrLAXcDzghJHFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hLhqqGaUeKykD+qi2q7WDZ+zUNxcnLZVbQSwnXwwosZodT43vKJRfokTrVpFaoKSXicMEWdylAIQdgZM5XbYUNKoEJwAQzUbWv+zjXdFcLPGbyWFKLI+WWAg8Iyn4wbnmvNEal3r2P1MUrwN7NfSDbGHQ+NQz+QKVQLYq/yoLzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qp8FXydi; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qp8FXydi"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-495509b08ebso48195e9.1
        for <patches@lists.linux.dev>; Thu, 13 Aug 2026 08:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786633928; x=1787238728; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jIiI9SltfPrXcp9GxH8c00S+yO98PCAJKDJI9QVodgA=;
        b=Qp8FXydi6QhTptiIqN+KuKoZEUxSHOrwFVRyZ6hp5Zh7VutuGuQ4xBm+IZsv0bbkI3
         oSdz4MdTysXV/jXAZTo3P8WjIKFquRLyBbA33kdPGSCx91BhiKvm0PVA2R9OQsY2jmMj
         xYFJJKnGga751Eylar9+6ifvBjewHMmnoUSTygsb1pQg6H3/sFgCaqtUqYBgbfR11++O
         TraKEOUzeL8WzI8DWiIxLBgL1p5xrl8JVJkTA0TXXBnvQQf6pOJ0Z4ApZyuEtokbwpXf
         9fsN7OOF3dA1VhqPGClfMw8tGgb4c+zAqTnWvJff6Axr8h7IvktH0MZ2u14B0COwwmzb
         burA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786633928; x=1787238728;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jIiI9SltfPrXcp9GxH8c00S+yO98PCAJKDJI9QVodgA=;
        b=aYc2cNpnlqJ2MBjObFH0GlPeDBh1oinUV6WtdMMjeyZd4qBGUEYRlBOsE+IQ99I9Zh
         qvuCdvydhGOitzC1ZW0cfluYl8Drs/thpSWDv9b0x28S/gEU7ys4wIw86EqdLs4pSfF3
         J1ppFp/XQ6Rmez5dXyUGjRUp8SEXfS5WAj7uSNv9X+NvjWfABRphmKXksZgMDq0uBX0T
         48VWvjXvst114mRL4c2iyyUv/sC8J1Jj6oCHZyR7TafwhOZbuNaNlCzLzH4J1kmOuenV
         Gr7r1RHFJ51XaN4P6aJOrEZ3DtoGdf4KADqfmpH+I85QvZ5GcuWhZFUnRyc+Ma5h4sVf
         tayQ==
X-Forwarded-Encrypted: i=1; AHgh+RryFNlgEOY+K8JDTa81ynETCId45H9IxQJqlpbxYEkIM02L38aJHsjPyxmsJoqynGzhIMir0Wy7@lists.linux.dev
X-Gm-Message-State: AOJu0YztX0k8VRUIafUhUxsSBiGVzm/9+Q3bg0YrgseiPi41Mhq13iU9
	zH7MiRRF1TGzbSOJcNUgf2eiCsXdI3NDRQNV64Kt+Ram9PcuXpXzWFVhMudQjyxDzA==
X-Gm-Gg: AR+sD11f7hABLQsq66BfZVxQ9gZZltIziwIQDvcMmJoMlAPg05MPvTCrvoSqbwLkxdH
	pJM9+DtD/DooDmhgopVhE442BaFQFLBB/vW36W9o+s+qhHOAxz8rDC4jOh67cE4XrSQlHeFEaoV
	sufkyMVE+JXaJ3wTah8XxUkIfjJtdEAMWioEYz/T0q6K9KxtobnjyWvOfhSOyt3Chg7AZqqBlND
	N6rkWJKNyg+TJmr33ZFcbCp/hJmhP5fvhZNl3E3gfpisRATMj3VLyZh4Vg1baoK3IUYHFfSFyw6
	iaIvbMXkCVsT94tcEk4zw+sRA/x82a3nW44ZKxiQNZhRCoWB36Vvp0bAafi5Tri8zd0+vuwqITy
	GU68DCV1XKHQLmVY3DBZJJuzmy02iqMem094XbsUPbujwQWXjzL0xY+SuEgOn113J1rX4LCdeXz
	JvzjesXzWPJYXbzG0BCzaB061m4c/Mz2YKGvTCHEy05jT0Fw9Gf1UAxVsKlsk4UqBPcq/L+W1is
	Vjtw3+R5ju9ebnaA+oljOFk7dM7MQ==
X-Received: by 2002:a05:600c:6094:b0:499:83b9:4e4d with SMTP id 5b1f17b1804b1-49983b95116mr892995e9.0.1786633927802;
        Thu, 13 Aug 2026 08:12:07 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815f2cd7ecsm7938f8f.36.2026.08.13.08.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 08:12:06 -0700 (PDT)
Date: Thu, 13 Aug 2026 15:12:03 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <an3ew9xbnLe1dr5g@google.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzm5BoV0rToJ7ij@google.com>
 <20260708001058.GA422027@nvidia.com>
 <an3MSKEj7VhT4WkP@google.com>
 <20260813141320.GF730363@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813141320.GF730363@nvidia.com>

On Thu, Aug 13, 2026 at 11:13:20AM -0300, Jason Gunthorpe wrote:
> 
> > Sorry I lost track of this thread and I just saw v4.
> > 
> > In the mobile space, I haven't seen an SMMUv3 that does not support
> > RIL.
> 
> Oh? That's very surprising, AFAIK none of our embedded chips support it
> yet.. Even the server chips are only just getting it. Are you sure?

Yes, SMMUv3 is getting more and more common in moblie HW (opposed to
custom SoC IOMMUs). Devices that I have seen in the market in the
last couple of years have RIL. For example Pixel-10 which is currently
getting upstreamed. Also, I have a mini desktop with QCOM X1 which
have RIL.

The only SMMUv3 I have seen without RIL, is an old morello board I
have.

> 
> I gather it wasn't even available in ARM IP until recently ish?
> 
> > However, I have seen workloads that are really sensitive to translation
> > latency (display, camera...). And I'd be concerned about those
> > regressing.
> 
> Yes, those exist, but again, they are already facing these problems if
> running without RIL.

Yes, but my point is that those typically support RIL and that change
regresses them.

> 
> And, for the common case of putting something into a carve out region
> it is not so likely even an expanded RIL will intersect with a
> reserved IOVA that has a high alignment.

Not necessarily, those devices can run with a small IOVA space to
reduce the page table walk length making IOVAs quite close.

> 
> At least the things we have built are calibrated to handle a TLB
> reload occasionally. The isochronous TLB's are not even sized to be
> never-miss for all cases because things like 4k media require such a
> large amount of IOVA the area cost is too high.
> 
> While others can do something else you are reaching into a pretty
> narrow condition to hit a problem:
>  - HW that must have a never-miss TLB to work

I am not saying that, but we shouldn't over invalidate TLBs either
when it is easy to avoid that.

>  - HW that doesn't have a carve out, or has a badly aligned carve out

I do not think a carveout will help. But it's a very strong constraint
to enforce carveout on all devices specially media which are quite
complex and composite by nature.

>  - A SMMU that has RIL (non RIL is already worse)

This regression only impacts RIL, otherwise it does not matter.

>  - A non-isochronos workload that regularly exceeds the RIL/single
>    expansion thresholds
>  - Unlucky IOVA allocation that places isochronous near other
>    workloads in the IOVA space.
> 

It is not just luck, it depends on the IOVA space and access patterns
of the device.

> > There is a clear trade-off here as you mentioned with TLBI latency,
> > would it be make sense to make that behviour configurable from a
> > module param?
> 
> I think it makes sense for a driver to indicate to the core code that
> it needs isochronous and we can do more global things like change how
> single works as well. Having an isochronous flag on the domain, for
> example, would be a good overall direction.

But according to what? It makes sense to optimize server chips,
but that should not cause over-invalidation regressions on other
hardware.

> 
> I'm inclined to leave this as is and let someone come with a specific
> problematic HW, rather that try to badly guess without much
> information if it might popssibly be a problem.
> 

It's not really a guess, I mentioned some examples above, that I
have seen problems of translation latencies on them.

And why not the other way around:
- Which uses cases can't handle few RIL commands?
- Why those drivers does not unmap memory with a granule/IOVA fitting
  to RIL?
- Why those systems does not use FQ domains in the first place?

Thanks,
Mostafa

> Then we will know the HW and can mark the driver as I suggest above.
> 
> Jason
