Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCED782480;
	Wed,  8 May 2024 11:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715167237; cv=none; b=BZnL34hitJY6C4IhZeTZqEpo467cxnInWPGaFRaixIvTeOYLb8hwLwHeDoOZLXkyt4qxGu4Fru1u2yqdXqSamE3jXqNJ/z0mkB7TXx2Wqom/sCVO+Mt5V8U0KS3q/k8zWaQlWou/uitcK0oRbLO4ozkpOrUlZyXEV7PmKg6POjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715167237; c=relaxed/simple;
	bh=UAlHpa3bsQwNDzoBazHohylYorTq0ZgDKgqJlsPT0+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l4JTOFGV9rYSmQMS+x8+LLf5DrLfj4wIpJkaEtqFnYhk4KtE+aatEXGuG25UfcyII1yzLFPF1Okx97SQITslVnYudyDqVqMiXIaSnKMgqL2yh5VEmyd3Akrl/Jt2hsg7pTOzEGip0GSzimjLDUGr48Qy32kE92KSi/4nDpsI7bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=IRjPXgVA; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="IRjPXgVA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=ZDbxtApgeJdQOoCZ4TW3ihW1QYvzq54NsaFPf3ycrYc=; t=1715167235;
	x=1715599235; b=IRjPXgVAsFD+IVVkEIblVYGWMDXYLLGrrsJqhUioetdBuSysV6evlV1L3KoSu
	K6EBza6aMQAMltilsh+9L540+QS4o5zX8qZtU8SZNpiBNi0DV5qXZRRqLysbx/EpTKdYCHtBTVa6O
	pEXI4iUYVQW/aBlL66kW6wh01A/r7Jkcx/nD7ZYwITjL4WN9iANfo3kjE0Uk7sYE5L62jNuKau3AL
	en/NYOqTWO3ihAehp5VQ6Xu+wP8wiTILJV1yQapRrc3mE3uyNtpy6ZP9r0K4RYTOJ6JmXB1eKfPMX
	JRPs8+Y2BTN/mu1N/QTGoATfQ2PDQlWmTK6zwMkJX9sqsOJX5A==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1s4fLc-0001Vw-Ir; Wed, 08 May 2024 13:20:32 +0200
Message-ID: <9e04d05a-e4f3-4238-8fcc-2db81818475e@leemhuis.info>
Date: Wed, 8 May 2024 13:20:31 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu/arm-smmu-v3: Make the kunit into a module
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-arm-kernel@lists.infradead.org,
 Robin Murphy <robin.murphy@arm.com>
Cc: Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
 patches@lists.linux.dev, Will Deacon <will@kernel.org>
References: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: en-US, de-DE
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 n7RI
In-Reply-To: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1715167236;eb15f379;
X-HE-SMSGID: 1s4fLc-0001Vw-Ir

On 07.05.24 15:21, Jason Gunthorpe wrote:
> It turns out kconfig has problems ensuring the SMMU module and the KUNIT
> module are consistently y/m to allow linking. It will permit KUNIT to be a
> module while SMMU is built in.
> 
> Also, Fedora apparently enables kunit on production kernels.

FWIW, as "CONFIG_KUNIT=m" in case that's relevant for the discussion.
The modules then are put into a separate package.

> So, put the entire kunit in its own module using the
> VISIBLE_IF_KUNIT/EXPORT_SYMBOL_IF_KUNIT machinery. This keeps it out of
> vmlinus on Fedora and makes the kconfig work in the normal way. There is
> no cost if kunit is disabled.
> 
> Fixes: 56e1a4cc2588 ("iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry")
> Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
> Link: https://lore.kernel.org/all/aeea8546-5bce-4c51-b506-5d2008e52fef@leemhuis.info
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

I didn't test this yesterday, as it sounded like the approach would be
revisited. But as that might turn out to not be the case I applied the
patch on today's -next to see if it fixed the issue. That did the trick
afaics (assuming nobody fixed this through other measures!). Hence feel
free to add

Tested-by: Thorsten Leemhuis <linux@leemhuis.info>

Thx Jason for handling this so quickly!

Ciao, Thorsten
