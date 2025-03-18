Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4801208960
	for <patches@lists.linux.dev>; Tue, 18 Mar 2025 10:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742294787; cv=none; b=MisEzsm4eWBqVK70y6iO9QRrnDm0lUWhN8Nmu4PJwlJ4xgcNIJBVdTFjqo8U+C6jPPtfuubEjcAch2Sr7JuI66aHCmMlrG/+slOcgleMrZN31esFHVo//irsAy0dT/O0o2ZDlZa+g9T3k5G/osT0gbKhj4us9CxS+9DoeO+c5Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742294787; c=relaxed/simple;
	bh=BH/02l/7jfK62esHmL2nQqidEObr1IPIfhlBILiTzRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ko6uZYlLyWvnOj4KX8M/X3KvatEDsXrLQMaGBY0+uBGwjM/brqvofB0JwzZqbLwdRGdMP050Mp7QK59pZwDngiI70PCYaU8m3hu+kMeDxkmG9zVQXRFS/9mNnBtDbQ0zC0zbTTndfaRqsedI6EHfy+bBwyt4EmZSpyhdoczgROE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MXe/Cxhg; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MXe/Cxhg"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cf3192d8bso32955e9.1
        for <patches@lists.linux.dev>; Tue, 18 Mar 2025 03:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742294784; x=1742899584; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/+Q9jlO5xuM+dGNN5vOy/zKLThOd0aux5Q2kg9METOQ=;
        b=MXe/CxhgR4YPfXnkNhk2z1cK8G0CgjsERaz3ggQJR5D2FaqIqvXWsvhlq7E/6DNwvA
         2+ZxFFk8DQ5cHnp+wakfRu6aYQ872X0ek9Z5uNkyTUwnlKuaTM+4nIugNOw0f4u0B81/
         iq4JIFDWZM0sx6kE4pIcVmmXuyOUcPIiIgtfCAsw7AxD7SYST9J681V6497UfSJj4BIa
         24Xz91uTgLT+AlyNTYqWYFQgap9ggxyie0F+8lesgl99E3OTpbSnszc4Xl+vv+2UyqY/
         qpZxRd4qJJv1kTZ2XZ4P4Gs8GOorU5QrO8pWVbJsNcTYABRcrTWHSm0bP2uGcN/A7rom
         MC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742294784; x=1742899584;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+Q9jlO5xuM+dGNN5vOy/zKLThOd0aux5Q2kg9METOQ=;
        b=FOgdrOo8x0gEYRZsErG4M3c3iWyfPNG9iI//+e/OzR3HPsNgW1tXM4ADuzU2xTyVOI
         fxmt+EMHisEiUXbaMno7tYWDnA+jfkXz7a2ZlUuRuI0b26pRwtPe2tXiQKd9RP9K65+d
         98CoJCHEAp7hyINgKPwcbfG7qJYAaHSyGf8meJ5LkPMEF7OBrxIZC/eCLhv/2YGl4KSN
         t37IxJubvlFwxQyTbNjBADeNNXBdzjM1QY2/Zz5lEZYxHpHyQjLa1G/xqZFDroNIVo7W
         tLCeaVGfg1h1E5B0gLBVdwKmFtJoMncx0hRfNeYpewbM1aPnpd4XbpOmQzbFznUaDlku
         ACWg==
X-Forwarded-Encrypted: i=1; AJvYcCWsRVV9N7OpNGLqj/3MKQz5XV0HxGENm+/Q1fxwVrh6pCZP+UdEyLCvQ58fn87nThEwr0HJgFI6@lists.linux.dev
X-Gm-Message-State: AOJu0YxUDg5efab0n486u8PMU7iiaQe1DHoPSGY+8uuFnxqooHhjjgvl
	HMJonXU5OSphjVwJOEGZamEY9aa3vYWne3jh6FnFUfkO2+HEisMMvrmUddlH3A==
X-Gm-Gg: ASbGncs2UKYvmkCYlTDEgXKBU+3gs4ZgVMTxLaOnMXfMk/734URdyuiVksslqkGyESx
	6WVKc0ZhTqMqS9A4MPFrdrPJ0EJfYC2qv4DvbXRPjBd5JlWqvzTaAjqDFHzQKG+nueC82of+f62
	PN0yM0XlF3IQ9aPCYJWceXwph93YYdmDfp9S+AgQb/qnydsHL0jPYcAQk/aJSgSoIIeDmDEPYFe
	nxBlqjIOUoygjxuUBz60jOsBzKY0XqwQwXiD+XfEs7ANFumeFArIkpmHsyROjRRnWaY3DnzbLvk
	tHN5T5gWgrfjaLpyqmXvmlPKOtc81SwVsObAKH5Jzv9+bi6Rr0z+1SQS/x/2ZCeF4Zw+xASVmsW
	EdLjg
X-Google-Smtp-Source: AGHT+IHJJJKc86lCeSfkPHpB/CtXXs0Prp3Nz9+7FXSfTlHmKZ30/6jEnzkR0iwoq3j3jwsYbn5hfA==
X-Received: by 2002:a05:600c:1d20:b0:439:4a76:c246 with SMTP id 5b1f17b1804b1-43d3e14f871mr474575e9.6.1742294783884;
        Tue, 18 Mar 2025 03:46:23 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1ffbcf00sm129988595e9.10.2025.03.18.03.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 03:46:23 -0700 (PDT)
Date: Tue, 18 Mar 2025 10:46:18 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hector Martin <marcan@marcan.st>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 20/23] iommu: Update various drivers to pass in lg2sz
 instead of order to iommu pages
Message-ID: <Z9lO-viudk9YGakl@google.com>
References: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
 <20-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
 <Z9GFFBvUFg7a9WEg@google.com>
 <20250317133500.GC9311@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317133500.GC9311@nvidia.com>

On Mon, Mar 17, 2025 at 10:35:00AM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 12, 2025 at 12:59:00PM +0000, Mostafa Saleh wrote:
> > > --- a/drivers/iommu/io-pgtable-arm.c
> > > +++ b/drivers/iommu/io-pgtable-arm.c
> > > @@ -263,14 +263,13 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
> > >  				    void *cookie)
> > >  {
> > >  	struct device *dev = cfg->iommu_dev;
> > > -	int order = get_order(size);
> > >  	dma_addr_t dma;
> > >  	void *pages;
> > >  
> > >  	if (cfg->alloc)
> > >  		pages = cfg->alloc(cookie, size, gfp);
> > >  	else
> > > -		pages = iommu_alloc_pages_node(dev_to_node(dev), gfp, order);
> > > +		pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp, size);
> > 
> > Although, the current implementation of iommu_alloc_pages_node_sz() would round
> > the size to order, but this is not correct according to the API definition
> > "The returned allocation is round_up_pow_two(size) big, and is physically aligned
> > to its size."
> 
> Yes.. The current implementation is limited to full PAGE_SIZE only,
> the documentation imagines a future where it is not. Drivers should
> ideally not assume the PAGE_SIZE limit during this conversion.
> 
> > I'd say we can align the size or use min with 64 bytes before calling the
> > function would be enough (or change the API to state that allocations
> > are rounded to order)
> 
> OK, like this:
> 
> 	if (cfg->alloc) {
> 		pages = cfg->alloc(cookie, size, gfp);
> 	} else {
> 		/*
> 		 * For very small starting-level translation tables the HW
> 		 * requires a minimum alignment of at least 64 to cover all
> 		 * cases.
> 		 */
> 		pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp,
> 						  max(size, 64));
> 	}

Yes, that looks good.

Thanks,
Mostafa

> 
> Thanks,
> Jason
