Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61576146900
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 14:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708612776; cv=none; b=oZsed6bGP7JCrq5RDsJQc7XNFTSX7br5RpEotTYIgrFZEnfhTd/dJnySJy3TcoHtpRvX7+rchPHelxaDvUsm4oR5uDttij3rq+SAQdVF+ioh6VWewpVboKoTXPWAD6/LcU9Uu/9sLSRotJ/15lMIePd3gnX3kuT6rbo/Ea2RbUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708612776; c=relaxed/simple;
	bh=IPIxlsnYLhicQCDz/h/BCSScCWbtJ5PoCzB0/uIKijk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HeyCbJ0oc6aNYPspsJ1E5m9kV2c6GrD6Gm9E2z9lsKjzDC2xlBzua9jl4yIUNs30AltJbyFDK65BZ5jKdEzch0cfLARloyZ5MzzR5nvmOL+korTFLMhWc0PK/HnasnvYihehGf3FaWpXEt6oklZegiyGTf0X4+aNqje3mF34OEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nwA8k4aC; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nwA8k4aC"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d094bc2244so108430351fa.1
        for <patches@lists.linux.dev>; Thu, 22 Feb 2024 06:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708612772; x=1709217572; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IPIxlsnYLhicQCDz/h/BCSScCWbtJ5PoCzB0/uIKijk=;
        b=nwA8k4aCy8Pn/HLsHYnBACfwhDzXT99GT3+RQdeJZIhgUuk85T+u2Cqge9DMOnq1+x
         cxrDs3rqD9VPulgK3wBOZLbhrccA/kys9vihJjjuESY7v4eL+B+iiWNc08R/rkkxtJBN
         s2A0e1YRQf2F4QJTur2ACyxTLOuAs/PDXI+Rox50bTsRBEJhXT+YxMSCmH1Zp22gE4Af
         qCTNdmlcPKOQHNbNCWFucGi1kDvBzKygqIWthhwpqrqZ5sifLvQ7paKAZiT1SSY7PXtj
         VBqL6UwMgv4AkCfpyS+Qp4H86biXuawzpFIrZjZtFDJMvSO96KfjMiAaGigN+/xPYGw/
         U67w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708612772; x=1709217572;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IPIxlsnYLhicQCDz/h/BCSScCWbtJ5PoCzB0/uIKijk=;
        b=jPDrcBBUD4LZEt5n68T4NdXJBqbbPsd+mMCJ3BfdIZKuiTM7f2SvANc87uAhyKFixE
         eD+3iqrdK0p+epxo1T0Brt5iihsFVVssKYq416qe+VE633QGTlItpMEgzkQLJYfTfwWO
         8l88KFB8nSWZh6IJNSB2oWjgeeTI3+yYSaGiVeAmSAlqRFpw8kVVvUcQW8p+CX1LRQVq
         5oocwdPUHAp+9A5jpo2h2iffRjMOn4PaTKI+gQhyCJm/J4wWHRlA5z3/vuWcq8cKHcm1
         rz+CWG83BpcKLnvggmreVwFhQo7bnhWDKMz3CCtY92MqJFtzK5GvmIJyARd6jpBJVPib
         eUOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMB6WRQ+BFZVks4/IHxMV34kf8EzCAK0et/OIFMozf0IvllJl/+1M7eZUlMofhHPP1OmEyAb9O1iMmL5rFt1nhA7q8LBKKPQ==
X-Gm-Message-State: AOJu0YyPZ2k8AR73nJ4AayUPN8ITjYjX1vHfIVs6F9mK98KtuBGrpT60
	FmyY9mG+ZNsoB0+pdAdUtlmoh34sNhVsMUk7VfYLiXJWj6FLZn4AbJGJp5t+pTmYNsgtZMUDRin
	Tval5pcWmrhUNSloPE3XJfAqgAyNU3fz9oARyKg==
X-Google-Smtp-Source: AGHT+IEyFaV9rvIcx6xuw5FRoh4C/yjyQ1eOXsW90NpADn6rh5Cmh2AuvdHY1EPGF20xkoR4Y1PMMX4MQZvzlgd6ZMc=
X-Received: by 2002:a2e:a16a:0:b0:2d2:3810:552 with SMTP id
 u10-20020a2ea16a000000b002d238100552mr8266770ljl.53.1708612772470; Thu, 22
 Feb 2024 06:39:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-9455fc497a6f+3b4-iommu_sva_sharing_jgg@nvidia.com>
In-Reply-To: <0-v1-9455fc497a6f+3b4-iommu_sva_sharing_jgg@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Thu, 22 Feb 2024 22:39:21 +0800
Message-ID: <CABQgh9GVTCyF_Y64AWoMfKf0NBM8R832BrwWTfzyCAA6giowRg@mail.gmail.com>
Subject: Re: [PATCH rc] iommu/sva: Restore SVA handle sharing
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <jroedel@suse.de>, 
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Tina Zhang <tina.zhang@intel.com>, Vasant Hegde <vasant.hegde@amd.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 22 Feb 2024 at 22:07, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> Prior to commit 092edaddb660 ("iommu: Support mm PASID 1:n with sva
> domains") the code allowed a SVA handle to be bound multiple times to the
> same (mm, device) pair. This was alluded to in the kdoc comment, but we
> had understood this to be more a remark about allowing multiple devices,
> not a literal same-driver re-opening the same SVA.
>
> It turns out uacce and idxd were both relying on the core code to handle
> reference counting for same-device same-mm scenarios. As this looks hard
> to resolve in the drivers bring it back to the core code.
>
> The new design has changed the meaning of the domain->users refcount to
> refer to the number of devices that are sharing that domain for the same
> mm. This is part of the design to lift the SVA domain de-duplication out
> of the drivers.
>
> Return the old behavior by explicitly de-duplicating the struct iommu_sva
> handle. The same (mm, device) will return the same handle pointer and the
> core code will handle tracking this. The last unbind of the handle will
> destroy it.
>
> Fixes: 092edaddb660 ("iommu: Support mm PASID 1:n with sva domains")
> Reported-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> Closes: https://lore.kernel.org/all/20240221110658.529-1-zhangfei.gao@linaro.org/
> Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks Jason
