Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E401D5CCC
	for <patches@lists.linux.dev>; Wed, 12 Feb 2025 19:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739387743; cv=none; b=qKuTkvxFR6H2NMLtGay1PeF8HMeVchtzt0lbimCRnrHuUB42+2owocWjlldpi0YpJ5p2Wj2AUYt5mNU9zKMhcDcP4kahkbLXbiEWyD26Tt+s3yAf8BuJKYvaTs8dDOP+wusSy+bPvB1OqfajkmNW/gBl51VD5ZtncKWM+PcwYh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739387743; c=relaxed/simple;
	bh=j/MRe+mq2tPhTDU1WqstTBB8ACCVQAqwnxs28dXhnl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UJ6SSskKrQUshr+LFrnMI3L+Fps0+ROXi4y7R4lJjUghGpGTXycQcrRBn7DVVv/FDnxC8nvkktvi/7rDbldLc1HohjhtroSJjpz15M8jftyVAMpnqeOaK+2HUzJ1g1SumkOe0wVC56m0cbjeRaJ2xR3MHprTkuvROAXjyaQJJT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Kx7oIH3i; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Kx7oIH3i"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4395561ab71so943345e9.2
        for <patches@lists.linux.dev>; Wed, 12 Feb 2025 11:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739387739; x=1739992539; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HqNd92Cgc359wI1YLkJzjmHs2FZOPIccP/HZnTPHBgs=;
        b=Kx7oIH3ihwcKIn5LUll9lvpZpie65OeGeQL5/K2MJjZrYI1cPv2cGSoSU4ApEJGA7o
         TWgWsCkkxEUWLexkiAwlUrsEk5XS0+GGSboZWS5KmzyP2sX7rtUpKNaQKglquBQL6cmO
         v0TfWNZ8yA53UrhxYb7idFrAMgPR6/oZOJFBMMr+7YbQk5gzX1aYXzVkn6/Me+VKkyft
         /ahHgxDLwSHzw+oEqYpU5kQdmwtFyhZiOQnCtIU9y7hHADaNJQMr9kveh+zMkigihzhg
         5+9xyRiG0OUijc9R40qMAfoKdbtC4M+SQzRE0J1Un07Ot6nS+uE/7wPX4SodfQ2J1GMe
         wB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739387739; x=1739992539;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HqNd92Cgc359wI1YLkJzjmHs2FZOPIccP/HZnTPHBgs=;
        b=rzcp/b7h/VQAvXixhUKVWofFDkgx0k+Pmcpp2ZOe2Hi/E304TEy7Boyi74e16kBMAg
         YTyVP+xi6sTJHXOESkPjJjNizEGvw0gq7hiOnSt+vKeU8GW7EMpX5YC27vq0pn8oiGtQ
         d30BX/DBlRryWpcnEtHGHmbZleeoDx9b4S5wqnEKvIWh8UiByo4nVLdePPC9ihrEqe5F
         0PptrOoYsb74vnKWTl6NvM1q3W5y+hQaYZwDkZWNutOpCNF8sPnhZPRj22MWhLe0kYgu
         JXZSJ4Tvj05XVzY1vlOFTGPYNIyPglm5+p4DO5OrmY1x1S3ldMAQ6BkMqhW0T4M+2G25
         POIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL5HEGQakekdYbu+z/RFfwhvOXjXbV6u5VxdYQ4zHp8a50xbgiKsoXzj9Nmu4DO7piUsqF5Gds@lists.linux.dev
X-Gm-Message-State: AOJu0YwCq+0IGbNcBNbRJuvApSQpmJJcNxCWQZu+j7yUNIvVGMox99zB
	t/lQIaZ8xZK/UBsFxRAu8T3yXyzaFBMbD5fM1ZVbPMgVoukTKaosRZSEGZW0fwc=
X-Gm-Gg: ASbGnctphUGWF8UU/0Zdg5DhwgHTSQYaPO16JQqNLmtfBjhJ8kl82EvErnDDcqaL0ss
	79pWt/4JI6VoQTdSRHIayvBFqNyZ4FzEDFBqmJ1FRvd3pyfyT4M9H6pMXrbxZhlDRlGZTbUQrts
	dPHf/Jz2j2fq0RwhORnHZxqS1ShoRg6S3Dk76K+0klZ3xnna4tSC2QTNJdC5VH1hNxmF9LQ6nxe
	khXk3xDeD3Mtkw8O/T50chh6ujxl5hKDB8d1ZQW5fBlRvFDcRilbip2gLm0r2PhLpEnqmlMRDF5
	Pz2Vd9h7SlZb2w==
X-Google-Smtp-Source: AGHT+IGkzecCOJkuqQbBI6huzDaIBc5zvDDm9U/5OMf0bnMDKXZpSgMYgPel+hUwbay3rx6H0lyECA==
X-Received: by 2002:a5d:5f48:0:b0:38d:c9da:d0d7 with SMTP id ffacd0b85a97d-38f244da097mr707581f8f.2.1739387739336;
        Wed, 12 Feb 2025 11:15:39 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a053f46sm28934625e9.14.2025.02.12.11.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 11:15:38 -0800 (PST)
Date: Wed, 12 Feb 2025 19:16:03 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
Subject: Re: [PATCH 0/5] Convert virtio-iommu to domain_alloc_paging()
Message-ID: <20250212191603.GA4085684@myrica>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <67abee53.170a0220.154671.ae28SMTPIN_ADDED_BROKEN@mx.google.com>
 <20250212115845.GA1627174@myrica>
 <67acd4e2.630a0220.365aab.e098SMTPIN_ADDED_BROKEN@mx.google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67acd4e2.630a0220.365aab.e098SMTPIN_ADDED_BROKEN@mx.google.com>

On Wed, Feb 12, 2025 at 09:05:35AM -0800, Jacob Pan wrote:
> >  Does reproducing this require
> > modifying QEMU or Linux to disable support for F_BYPASS_CONFIG, or
> > just passing QEMU/kernel parameters?
> I only modified guest code to pretend F_BYPASS_CONFIG is not supported,
>  a couple of places like:
> 
> -       if (virtio_has_feature(viommu->vdev,
>   VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
> +       if (!virtio_has_feature(viommu->vdev,
>   VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
> 
> Is there a QEMU command line option to disable
> VIRTIO_IOMMU_F_BYPASS_CONFIG?

No, but I have a patch for testing that didn't seem worth upstreaming:
https://jpbrucker.net/git/qemu/commit/?h=virtio-iommu/bypass&id=ab2f435576a95914d2939ef4f0b190548721fe7b
With it I'm able to reproduce the issue, looks like I only tested this
case with virtual devices and not VFIO. I'll look for a fix

Thanks,
Jean
