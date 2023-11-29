Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F6A7F
	for <patches@lists.linux.dev>; Wed, 29 Nov 2023 06:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--moritzf.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b8cNswe6"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ce16bc121aso68692527b3.1
        for <patches@lists.linux.dev>; Tue, 28 Nov 2023 22:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701237965; x=1701842765; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BFBgGZHgdrEFpnu/cpKOcJzser1reIBdXzg/6fniV64=;
        b=b8cNswe6D8J/WSUbZ1kgPadgwzVJgU9Jon5LbHO+qPSnLwSxy5p05kBOCblPxJteSf
         22B3PgegSycl0BY7+ZqugMQfs0mrJsI02FqY206Oniy2LNviTP+UrCVrrYsS2KyZh+af
         LWl6FMeWlm6t589ag0KD4FDfJmR2gP114o1P4iRywnyIK/joaQ+4HWkiBWXu5iNtb7tY
         z3+lLirAUSQfQk/3OLddGwFmASiUcgdKstEM49y696DHYFVxOtRTivU4JT/8ujeWpdEO
         nl3GKKFXw18OrA1cQepGrJ/jBtnPbwavzc7JbhJ9GbF5tVed0vxzxzFl+qDgWN2pMIfA
         c3FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701237965; x=1701842765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BFBgGZHgdrEFpnu/cpKOcJzser1reIBdXzg/6fniV64=;
        b=pbWLIou006um64/UMRpEhjbitAhdHLMYQSSqr+UIjX/DMyf+m22sbSTLXDtH0MLArp
         0TUM3CWvxnQhWGrW4lKWQWC9BgKkdjrdxlhVrP3IOEgwNUixGcppMsxgrf+azd4NUSWe
         NzYVS271QcTH92ajV3I651dITH4S7+vXzcEB6upzlNTKeXEe4cw/1D54MFSuxKhv6vhS
         XG4oBM87vuZkuSObcsdNLlGGcXFt0+mt5yX/h3vrMeh0SlHUtMCR+fGvA8elkqtPxf/7
         dnnE8UV35Wlfiby8n3olffQxkHWn3qri4S46fdV4sbONaIaSaJU6jsiBg0WsCEGExOEq
         9wFw==
X-Gm-Message-State: AOJu0YyylzDqhCszV/9Y5LA0W83rqRRR9W3mIRAkSbjl04MEjZHOxVOl
	/7LyiR5m7NwdaeICoIHa/tix+xWecDuk
X-Google-Smtp-Source: AGHT+IG4ZcbE3hB8V6+vKX0zxYUr0OpHfbf/WNlvcGBdlOoo8eTYBCxtpp+7m/8KdVPZTHDTWhORx94znMfW
X-Received: from morats.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:d9e])
 (user=moritzf job=sendgmr) by 2002:a25:c044:0:b0:db5:1f69:704e with SMTP id
 c65-20020a25c044000000b00db51f69704emr38263ybf.1.1701237964651; Tue, 28 Nov
 2023 22:06:04 -0800 (PST)
Date: Wed, 29 Nov 2023 06:06:03 +0000
In-Reply-To: <4-v1-720585788a7d+811b-iommu_fwspec_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <0-v1-720585788a7d+811b-iommu_fwspec_p1_jgg@nvidia.com> <4-v1-720585788a7d+811b-iommu_fwspec_p1_jgg@nvidia.com>
Message-ID: <20231129060603.hxtmbsefxurxnwkh@google.com>
Subject: Re: [PATCH 04/10] iommu: Mark dev_iommu_get() with lockdep
From: Moritz Fischer <moritzf@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Airlie <airlied@gmail.com>, Alyssa Rosenzweig <alyssa@rosenzweig.io>, 
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Danilo Krummrich <dakr@redhat.com>, 
	Daniel Vetter <daniel@ffwll.ch>, Dexuan Cui <decui@microsoft.com>, devicetree@vger.kernel.org, 
	dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	David Woodhouse <dwmw2@infradead.org>, Frank Rowand <frowand.list@gmail.com>, 
	Hanjun Guo <guohanjun@huawei.com>, Haiyang Zhang <haiyangz@microsoft.com>, iommu@lists.linux.dev, 
	Jon Hunter <jonathanh@nvidia.com>, Joerg Roedel <joro@8bytes.org>, 
	Karol Herbst <kherbst@redhat.com>, Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Laxman Dewangan <ldewangan@nvidia.com>, Len Brown <lenb@kernel.org>, 
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-hyperv@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-snps-arc@lists.infradead.org, 
	linux-tegra@vger.kernel.org, Russell King <linux@armlinux.org.uk>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Lyude Paul <lyude@redhat.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, nouveau@lists.freedesktop.org, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Sven Peter <sven@svenpeter.dev>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Vineet Gupta <vgupta@kernel.org>, 
	Vinod Koul <vkoul@kernel.org>, Wei Liu <wei.liu@kernel.org>, Will Deacon <will@kernel.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Christoph Hellwig <hch@lst.de>, 
	Jerry Snitselaar <jsnitsel@redhat.com>, Hector Martin <marcan@marcan.st>, Moritz Fischer <mdf@kernel.org>, 
	patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
	Rob Herring <robh@kernel.org>, Thierry Reding <thierry.reding@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

On Tue, Nov 28, 2023 at 08:48:00PM -0400, Jason Gunthorpe wrote:
> Allocation of dev->iommu must be done under the
> iommu_probe_device_lock. Mark this with lockdep to discourage future
> mistakes.

> Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Tested-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 2 ++
>   1 file changed, 2 insertions(+)

> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 0d25468d53a68a..4323b6276e977f 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -334,6 +334,8 @@ static struct dev_iommu *dev_iommu_get(struct device  
> *dev)
>   {
>   	struct dev_iommu *param = dev->iommu;

> +	lockdep_assert_held(&iommu_probe_device_lock);
> +
>   	if (param)
>   		return param;

> --
> 2.42.0


Reviewed-by: Moritz Fischer <moritzf@google.com>

Cheers,
Moritz
