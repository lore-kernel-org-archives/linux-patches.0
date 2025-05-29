Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2242B22DF96
	for <patches@lists.linux.dev>; Thu, 29 May 2025 20:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748551583; cv=none; b=o3ty1T6QNoQUgm3CvY8CpzvHEVnwP4e80mm2uYUZRMzZ1rRxmZ/iN0It0jW1GWlnoLOJ6HBSpV9X2AswDG90v9gOOIauSnJqg/mgbe4jrO9MFJ340iItJTLGKFYhv8u12YS5zZEn3y3NDkzanYF6LZn5ke6HvLeZSgjSHyjnxZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748551583; c=relaxed/simple;
	bh=/6z1v/qNBfUFOoxicD1V48QdZQfp4IVH4S3L1yiqKHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NCRIfkc60LXcfdo0AQ5i2CDxZZCjCZF48bB7J6WHrhz9rIxbK+Tw4rNp4nzKy8nYe9LhXokIUyOYk6pvZJDAbJjaMcHDKK3sKAyON0yx7+4IzCm6ZvipVuGymbc5hOcIPXeOm5Ub4tTMFtzP8rkIkO0LH7Pwa5jIytws/UdS0fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=I0t6PiXS; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="I0t6PiXS"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-879d2e419b9so1279228a12.2
        for <patches@lists.linux.dev>; Thu, 29 May 2025 13:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1748551581; x=1749156381; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6TtaMd1HywfsuyRcNH/42AXM3iz/qus8mLnXbozVUkA=;
        b=I0t6PiXSoZrBF9J5KO5c/+TWwhbLPDqzCbnETq88BbHJPm/JDwrvmZ/8E/8s/2vcH7
         ghjD5okdEGDLVyuLJxOJp4VGX+y7J0PyeqPWffzJWl92rDOnFCFoVs4tVNd/41Zqw25x
         o57NpwVM74chDLx0+ulFXTGCKz23JhENKaFX/IKV98gYVzM0pq4aOT1jj5wXCM0OFShr
         60bbKWMLDPMpCO0YTzObVuWqVuqxAQfYxw0/vH5B0lF8EOdavfcmaRhb/9Xh78ZdfaVF
         1kaV9VTGps6KzYs55kZh0lPj/GmBF7ugYQjgukohSYZyElelLr1CTl4huFDqY+sDpdbv
         hzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748551581; x=1749156381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TtaMd1HywfsuyRcNH/42AXM3iz/qus8mLnXbozVUkA=;
        b=nlXzm5Wy4bT/pnJ7hlEv9EcikpZuf2pcg4TYa/yrftl8qQGq82eBK0nyCU1M3RQR3o
         RK26qJviljZS4dHp+1hOtkMChFF2ZhWqrTLoGVrj5obK8JoPN94qzuoCfTBDo7l76l/5
         jNRfIiv86UfueUdKxggMNa9y1cND+NyQ3RvKU/ZIYvxdPAHouc+afFhNYy++ALVMKlKh
         snf4c0fEdITUTO3b7/84b4nV9ej7Np1KpnMEwpUrTE4RkcxP7rt4mXzZQuIat4QVIcmc
         kQ1X4liq8h6tqYCbN1QoAiAW2FoVVY+V5KBdDEyogcDQwd55xK2kICbZkpTptXmHUGGE
         dX8Q==
X-Forwarded-Encrypted: i=1; AJvYcCU3nOZw2qwWjAyZ8UAfc1eXwGI5LDopMB0lDi6n4B44m0KxRs21fr9KY+N+RytqSePrxqdH8sXj@lists.linux.dev
X-Gm-Message-State: AOJu0YwYSH6J942G4yYsPYOslDwSgn8lVHLQ1iwZ6bHt7uDtrcbf8SX1
	Uti33Y8tUOSIRxmlcESbM21X+DCdrYMmljJcGPtPxIsbIopR2AFHL/Gj/JsdcubXZjo=
X-Gm-Gg: ASbGncvfi73MtloKZCvrMwabdAi2245XO2vZ42HEUIuwg2eEI//V1C7i80iv0dmEdao
	B6WeUwxc663K6DAWMrsiD4LueVe1Qo5HwQQ8mi6rXDXtwVnt32Sgom9MbUxwWTWGbge7IbzUE8D
	BFjxp2xdZK3Z0ksMc08rBA/2q+dOqJKss5al0NBnGhTyM3/vByxhzUVFS0vJrTBdEFOUwqbb2/H
	72i4tzehtmll3PfubF0qXcg2CJu2KSTkGEz0oy6qHPQYAtLbr3hDkooNZr5xGm++wy02By+LJEf
	DlCGdOMrzqrl5NCG5F7M/70tc4ikgjG9Jx25inIjb/dG4HSi1PRqwOJeGX7nTApOB6vpEg==
X-Google-Smtp-Source: AGHT+IEO8HwssTrnrLL8DGNfi7UDT2JfkJIUURFRStahz0gCmflYidew8g3m8w3QvBPF+GZDsBP2sw==
X-Received: by 2002:a17:90b:1d89:b0:311:f99e:7f51 with SMTP id 98e67ed59e1d1-312415329famr1432137a91.18.1748551581341;
        Thu, 29 May 2025 13:46:21 -0700 (PDT)
Received: from tjeznach.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506bd9486sm16245345ad.67.2025.05.29.13.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 13:46:20 -0700 (PDT)
Date: Thu, 29 May 2025 13:46:17 -0700
From: Tomasz Jeznach <tjeznach@rivosinc.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
	linux-mediatek@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Neal Gompa <neal@gompa.dev>, Orson Zhai <orsonzhai@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Rob Clark <robdclark@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Krishna Reddy <vdumpa@nvidia.com>, virtualization@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>, Will Deacon <will@kernel.org>,
	Yong Wu <yong.wu@mediatek.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>, patches@lists.linux.dev
Subject: Re: [PATCH 3/7] iommu: Remove ops.pgsize_bitmap from drivers that
 don't use it
Message-ID: <aDjHmR7ZVTbsSITO@tjeznach.ba.rivosinc.com>
References: <0-v1-7c5282b0c334+2db-iommu_rm_ops_pgsize_jgg@nvidia.com>
 <3-v1-7c5282b0c334+2db-iommu_rm_ops_pgsize_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v1-7c5282b0c334+2db-iommu_rm_ops_pgsize_jgg@nvidia.com>

On Tue, Apr 29, 2025 at 11:34:13AM -0300, Jason Gunthorpe wrote:
> These drivers all set the domain->pgsize_bitmap in their
> domain_alloc_paging() functions, so the ops value is never used. Delete
> it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/apple-dart.c       | 1 -
>  drivers/iommu/intel/iommu.c      | 1 -
>  drivers/iommu/iommufd/selftest.c | 1 -
>  drivers/iommu/riscv/iommu.c      | 1 -
>  drivers/iommu/virtio-iommu.c     | 6 ++----
>  5 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
> index bb57092ca90110..2d0d31ba28860a 100644
> --- a/drivers/iommu/riscv/iommu.c
> +++ b/drivers/iommu/riscv/iommu.c
> @@ -1533,7 +1533,6 @@ static void riscv_iommu_release_device(struct device *dev)
>  }
>  
>  static const struct iommu_ops riscv_iommu_ops = {
> -	.pgsize_bitmap = SZ_4K,
>  	.of_xlate = riscv_iommu_of_xlate,
>  	.identity_domain = &riscv_iommu_identity_domain,
>  	.blocked_domain = &riscv_iommu_blocking_domain,

Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com> # for RISC-V

Sorry for the delayed response.
- Tomasz
