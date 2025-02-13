Received: from smtp1.tecnico.ulisboa.pt (smtp1.tecnico.ulisboa.pt [193.136.128.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2433328A2AE
	for <patches@lists.linux.dev>; Thu, 13 Feb 2025 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.136.128.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739465479; cv=none; b=p2RA3ThVdP9CfdzOb0pvb2lFOsPAERkx0vv+P9cxmSfur7+N+x/7BGny3DVxsfBJoi2EqnYfW9ev5b2ea8LCGTQlEakb/sBg6PLzBis7pORm1QdqDbXsb8nceJ8mN9exnNlvt55nLjGF3/LbpleBfFQMqUO+GSGyS30x3nGQgOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739465479; c=relaxed/simple;
	bh=Or++wAxBmTJfTqytxnx0k6YY2ypc0YGiThOE0+0mx8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bhRIz4hfF48J+PL/UfoHNl443t00j07f2v/aEqWDD5obIN4MHJsCYAH6KfvtVuxM14Uono3647FvBdEsocSbb1uqRBBTrUS/dm9oyLnbDW45/k1FJDTcvONTBedVtZYTL3PwWfxdhJc0MJg7EFwSqhDaZdcz2ajEnNdJHPCj20A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tecnico.ulisboa.pt; spf=pass smtp.mailfrom=tecnico.ulisboa.pt; dkim=pass (1024-bit key) header.d=tecnico.ulisboa.pt header.i=@tecnico.ulisboa.pt header.b=D4jdYieB; arc=none smtp.client-ip=193.136.128.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tecnico.ulisboa.pt
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tecnico.ulisboa.pt
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tecnico.ulisboa.pt header.i=@tecnico.ulisboa.pt header.b="D4jdYieB"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp1.tecnico.ulisboa.pt (Postfix) with ESMTP id 28C78600022F;
	Thu, 13 Feb 2025 16:45:14 +0000 (WET)
X-Virus-Scanned: by amavis-2.13.0 (20230106) (Debian) at tecnico.ulisboa.pt
Received: from smtp1.tecnico.ulisboa.pt ([127.0.0.1])
 by localhost (smtp1.tecnico.ulisboa.pt [127.0.0.1]) (amavis, port 10025)
 with LMTP id D_X-8oSLhMw0; Thu, 13 Feb 2025 16:45:11 +0000 (WET)
Received: from mail1.tecnico.ulisboa.pt (mail1.ist.utl.pt [193.136.128.10])
	by smtp1.tecnico.ulisboa.pt (Postfix) with ESMTPS id CB87E60020DD;
	Thu, 13 Feb 2025 16:45:10 +0000 (WET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tecnico.ulisboa.pt;
	s=mail; t=1739465111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=//D+0qXwv5Gm0YeDVVYXQrXCtiWyh/Qcg6tCR6GBt/s=;
	b=D4jdYieBlgGj0cdGpUzvaClL8gP/IjGHUNP1odAglnuYitwG8ZtYOd6oMKsnKxq6yXH+Xk
	VG7X9GbHmY3Z6SAkLpu9IZZzr3GPKZlgkG/vZo50cTCx3qZgFy1dsf1cW8iN1ylxwfFvQd
	Ut9Vvt19KWCaK1kuYlb9o+GzcxVWEis=
Received: from [IPV6:2001:8a0:57db:f00:3ee2:38aa:e2c9:7dde] (unknown [IPv6:2001:8a0:57db:f00:3ee2:38aa:e2c9:7dde])
	(Authenticated sender: ist187313)
	by mail1.tecnico.ulisboa.pt (Postfix) with ESMTPSA id A77A6360259;
	Thu, 13 Feb 2025 16:45:09 +0000 (WET)
Message-ID: <a77768b7-b4f5-47b1-8134-ca7e2bf5660b@tecnico.ulisboa.pt>
Date: Thu, 13 Feb 2025 16:45:09 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc] gpu: host1x: Do not assume that a NULL domain means no
 DMA IOMMU
To: Jason Gunthorpe <jgg@nvidia.com>, David Airlie <airlied@gmail.com>,
 dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
 Mikko Perttunen <mperttunen@nvidia.com>, Simona Vetter <simona@ffwll.ch>,
 Thierry Reding <thierry.reding@gmail.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <jroedel@suse.de>,
 Jerry Snitselaar <jsnitsel@redhat.com>, patches@lists.linux.dev
References: <0-v1-10dcc8ce3869+3a7-host1x_identity_jgg@nvidia.com>
Content-Language: en-US
From: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
In-Reply-To: <0-v1-10dcc8ce3869+3a7-host1x_identity_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

On 2/4/25 7:18 PM, Jason Gunthorpe wrote:
> Previously with tegra-smmu, even with CONFIG_IOMMU_DMA, the default domain
> could have been left as NULL. The NULL domain is specially recognized by
> host1x_iommu_attach() as meaning it is not the DMA domain and
> should be replaced with the special shared domain.
> 
> This happened prior to the below commit because tegra-smmu was using the
> NULL domain to mean IDENTITY.
> 
> Now that the domain is properly labled the test in DRM doesn't see NULL.
> Check for IDENTITY as well to enable the special domains.
> 
> This is the same issue and basic fix as seen in
> commit fae6e669cdc5 ("drm/tegra: Do not assume that a NULL domain means no
> DMA IOMMU").
> 
> Fixes: c8cc2655cc6c ("iommu/tegra-smmu: Implement an IDENTITY domain")
> Reported-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
> Closes: https://lore.kernel.org/all/c6a6f114-3acd-4d56-a13b-b88978e927dc@tecnico.ulisboa.pt/
> Tested-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/gpu/host1x/dev.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
> index 7b1d091f3c090c..5d27662019d28b 100644
> --- a/drivers/gpu/host1x/dev.c
> +++ b/drivers/gpu/host1x/dev.c
> @@ -361,6 +361,10 @@ static bool host1x_wants_iommu(struct host1x *host1x)
>   	return true;
>   }
>   
> +/*
> + * Returns ERR_PTR on failure, NULL if the translation is IDENTITY, otherwise a
> + * valid paging domain.
> + */
>   static struct iommu_domain *host1x_iommu_attach(struct host1x *host)
>   {
>   	struct iommu_domain *domain = iommu_get_domain_for_dev(host->dev);
> @@ -385,6 +389,8 @@ static struct iommu_domain *host1x_iommu_attach(struct host1x *host)
>   	 * Similarly, if host1x is already attached to an IOMMU (via the DMA
>   	 * API), don't try to attach again.
>   	 */
> +	if (domain && domain->type == IOMMU_DOMAIN_IDENTITY)
> +		domain = NULL;
>   	if (!host1x_wants_iommu(host) || domain)
>   		return domain;
>   
> 
> base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b

Any updates on the status of this patch?

Thanks,
Diogo
