Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07670257452
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 21:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745963280; cv=none; b=mJIBzxAXrZL7wplCZU/VTvGLd1t7eZoQoRT6Yn2Q5MoKLzvO3CwRrBXwTnaQIMZyzTNeKW4Cct8KsGTp7mcZ3Oplm/MBS5PmL2DvYoaj7bmAxbbBZtBQc/HLSkUQcFQwPb2pD/Zi81otqhO7MJE8lQ+Zpjt4nvO4DVsxJw1r+Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745963280; c=relaxed/simple;
	bh=Duhnxo2adP6UJYufvvUxQ7vXQx/l15K0ZRqltJQCe/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kqPCUsoEOI9mL4HML/TYWwUd+2F2Y8e1fZAFBho45oyBQ4qO6kPTWBMCLQZDCb3Mq6/Bmv82WzZlQYKnnI9h+D1x+7Qf+fFosrs6UeI3J1ymrwzrkFD+76gZJU+nylKg6rsSegISd+a3v1DDvp8WYk9KPINtBc/IjuQGh225WNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mhkicR1o; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mhkicR1o"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2264c9d0295so240015ad.0
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 14:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745963277; x=1746568077; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lCmXc+ODhBacc+4C2xK0F/Ie+nOBoW/7aTrNsgbeX88=;
        b=mhkicR1ov5ciLJhqxO/kbv521kR8r+0Z5S9/x/1oU4Zyjc5qCZvjEgE4ZjNpS1TMle
         cVEJeWqXVmYgoUZLQ3w2cnY/1CZnW2QijkKzzxULubNtWTCB8e+gUuG0sB2TheDwsiAS
         KSeinml6aRh40lUEVUTdkeIxVgLFoZlhoFUPQuc+a0UuvItPTZCqwNeybm+3nHfjZrjJ
         sL069iMqtQj19pbO7e6VONBtLu6WrSkgB0nUepUZWks2hWjD81p93oCWhRn+DdU8dKN3
         Ff+9VgSZx3ClXFe72bzkX24Ebr1+IGL1o5VEY4eXivwcTeSXkTj9iwNgiqg3hJRLcOci
         djhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745963277; x=1746568077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lCmXc+ODhBacc+4C2xK0F/Ie+nOBoW/7aTrNsgbeX88=;
        b=Qa+xgZrnbcFJxgsFFqDOHujjKUVNiZYLLV5cPCGH6gb2WERmLRIZOGPdm5CJebQlJr
         U94HikbiBrp9qgXxoIek+7T8ZDdEcaSMOn5FaOqJQUsequoKiFQsy30RQETIH84vv9MU
         4yDC/pvo4nKqAZ3AGZ136u1p+FJyM6eO9ia5eL3BPSgV8oaXPvRS/1MjKOqNLYZeDFUZ
         d022q4hovBAi9XGw1KQUTLcXW7rd+2Q2t7r+2yk6KizSdQTyIg4AiFga28FlNTzWO9/K
         9hyVMZJVBGOcf+DTz7V3yswAR48nerK1hZZOHNPxJH7lfmj8Gi3f3RvNIUXefN0CrlMK
         m+xw==
X-Forwarded-Encrypted: i=1; AJvYcCWwCMmX685Fo2cJwJOd+dKb6ckd6LZfEi/siDT3+lKjhSZGNRqWLqRmVw3RrW6TzPH1m4Hk8aoU@lists.linux.dev
X-Gm-Message-State: AOJu0Yyi1hRtdziInhHgH316v0T1qnhZ+6UTPOuUCz0VvjPUFNMOXOal
	4AeqI8WR1PXBevvxTO5sqC9XJueczjBFG7ub0uaz3+jQedXHMXmcg66Q3/lh1Q==
X-Gm-Gg: ASbGncvFarnuCUY2SHiIwhKX8CDmi17+QtD6qm8PQ4H/6AiB65qEJrC+35STOhdU8FU
	mQqaOyGkP2RU6bWWQVYwqcLP+9S4MI/bIniAGtoDWUSEchIYCpXsTxQF5cMgSttjI576b31yi5O
	14nQtNjjg0Kv6TI+ffw06MAwvI4dqfWTnGW0iAcWiBjxAWxAbao1EPOqeaNKIiVrHdyH5hs/xNj
	1Rc5mQ8DXUQmrUF8OCWAU4va6siPTtehmenPErH6W/RsJXRbcAvQi5v6SMTmCbaI/+cur8OlLCd
	eX600BKc0cVUu0II7jeL5/ArV0RyJyt7gzEoHtQ03BTgR60gTgYkKuIK9716y3F8PtJcAm3P
X-Google-Smtp-Source: AGHT+IFMqCAjaX52HtimqP3RondUOuNsl/Pw968hKtIW8LO6HydfSjoFrb+e/I5aVwqY3qXA13e21w==
X-Received: by 2002:a17:902:f649:b0:216:7aaa:4c5f with SMTP id d9443c01a7336-22df53e42e4mr308665ad.3.1745963277038;
        Tue, 29 Apr 2025 14:47:57 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a119ffsm32042a91.21.2025.04.29.14.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 14:47:56 -0700 (PDT)
Date: Tue, 29 Apr 2025 21:47:46 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
	thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
	shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
	peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 18/22] iommu/tegra241-cmdqv: Use request_threaded_irq
Message-ID: <aBFJAhpnPoUh-wQC@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <fb97e2407ebad5240f3981bbf4121a75ccd1ea57.1745646960.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb97e2407ebad5240f3981bbf4121a75ccd1ea57.1745646960.git.nicolinc@nvidia.com>

On Fri, Apr 25, 2025 at 10:58:13PM -0700, Nicolin Chen wrote:
> A vIRQ can be reported only from a threaded IRQ context. Change to use
> to request_threaded_irq to support that.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Acked-by: Pranjal Shrivastava <praan@google.com>

> ---
>  drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> index dd7d030d2e89..ba029f7d24ce 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> @@ -824,8 +824,9 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
>  	cmdqv->dev = smmu->impl_dev;
>  
>  	if (cmdqv->irq > 0) {
> -		ret = request_irq(irq, tegra241_cmdqv_isr, 0, "tegra241-cmdqv",
> -				  cmdqv);
> +		ret = request_threaded_irq(irq, NULL, tegra241_cmdqv_isr,
> +					   IRQF_ONESHOT, "tegra241-cmdqv",
> +					   cmdqv);
>  		if (ret) {
>  			dev_err(cmdqv->dev, "failed to request irq (%d): %d\n",
>  				cmdqv->irq, ret);
> -- 
> 2.43.0
> 
