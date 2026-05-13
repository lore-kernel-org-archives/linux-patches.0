Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464FA4968E2
	for <patches@lists.linux.dev>; Wed, 13 May 2026 17:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778694462; cv=none; b=d/P9sWXC0lGFpM1nO/g6BpuGR9Thdr4x9djhFsvgCNscABJBTPp7mEhop2S5gwsCrJoacE8sYHv34aEiXC7Zjj664oXQ4jFo7TleNM8w9gNRvoxroIovk74Ru85L5VVwLng6jUxFthAmZcU7xx3wbjEPuw57wNaYwC4fouiZ8tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778694462; c=relaxed/simple;
	bh=/d7ugw8j3llT+i0xpw6oKwmdDsEr5lQSNXVbHHx7Bbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WTXIWU8PRChXHrpJiUyfz0TAR1qzL7fNQmlPJHQuLx1Bid9opJPTldDH5NB/G9ffoW9vM8OV81wSFK7HJsLdXqUxySMnfCSgChkhzPH0U4hkwtDC8QS+78E2FXqj4/H/uv2h+akCuBlvugbE+p+CZABxrmesNOE93jj/tA5vKM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HIbRyatq; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HIbRyatq"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b46da8c48eso4575ad.1
        for <patches@lists.linux.dev>; Wed, 13 May 2026 10:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778694460; x=1779299260; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UD9g7VTOeXYFNZR2QR68/VBGy1DjrVre8yBvcooH1jI=;
        b=HIbRyatqt3mooVc7FGe7b61HMev9AaRpWXyNyt3yu56mb63qrWR24RHss4KtrPdXn8
         P7MR4ymLpth2iQjLhzLoURbaqApvGLiMFCUBLgh4MnY60hMVQqmOFVyqrcdWXAJzvVvS
         OwONnkIY9vZsvvkfNtYx6eNaMPUfWyvA5Wywef7ifrdKNxXnxBGJwefhiSfo33dDNIDD
         pTMPNkuJnVK+4mHJjHFfhXF5ohBt20j5wr0wEV1+PLWtTrU8ykHw6MfGgZ432C8g3unI
         wSJdNldtl1mhkn9JQNd5fzV1NOZE2DBOq4UmgrvL6kWkyHBdaDVs02a4NAma4vvTG3bw
         Apnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778694460; x=1779299260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UD9g7VTOeXYFNZR2QR68/VBGy1DjrVre8yBvcooH1jI=;
        b=Tz4wZm1Or4U+6Ids9Ci9vTAa6V6SAdhHGq+0OgS23OiMuOQy6V4ZGc2/GLG34oAeH2
         mSNbJmwnP9hmFOLELhRj584Rg9t7FhiQ/OyJx5b9EFX7uyShRKYWSwu581Jw8lcr1dVO
         jzfvXmn4kTuBwWx9gv+mz1epJUbGwievaKaMyBYJhPLYTxIGN0PqAb7KXoy/SyuKVY7b
         JhGjvBZjqDDNXdX5vZ3BjAzlkQg8pu9Lqjw00u7/xy3Nqsd4jPKlBAhK8Yzh59VkgXkc
         Lm6G7MBhzLIznFElYpQi7DZ36RAYu3P7N9+0RqyRqluUFxEX6MtVyz66sBkWEdMjNsXd
         F9Bg==
X-Forwarded-Encrypted: i=1; AFNElJ9J+XDmhKBGF2dPFu2beshxRJ6uLHpVVH0ykDf2s+GaBdG19JzLVQdu48sKEMenrgE7Dv73WvTQ@lists.linux.dev
X-Gm-Message-State: AOJu0YzFVJWG0yXJUs13LBPhBpPpngZZyxF9IzhN9FhXhtQoyO+relo8
	6Wu5rIuCPWCapplkAR97AhEQZ3O7Urpp2eBCL4dCpd2rtrJ6oQH4U4kYGdq9FmJRRA==
X-Gm-Gg: Acq92OE0/Iqw9OPXLeZOvIGky+VNHdEdqIVRqanCzaDQHJ67mnTDiYtCiku+LWUNmoE
	PTaYcg8Tcou96HFbtepzWnYfZbLPjMdjbuKbRMieZtjrvoB8iHgTaM5H4qU20N/UEuMkP333K8r
	Q6WOXL0axjiuXZfJ9aYpFPqHx71uCww9reCucoNK2GUBuuidNBWwHCxzmQxy3adGYEGLWA8ibB8
	ajuOadOI3hyea6imIayM6CL7Y4ilIt/2rKjCTTKQKMv+KYXtl+/Kc+jgF5UQHCzKc3eE4wLvHyl
	Y0QeqgtDSm4z5Nn5mqj1YlTxt/eh9YI+UgBHoN+teMyB9l6KXK2qzE8YMM8SyynRCeCnqwHg5y1
	xOQ2ycHt9lExDyKXtl8HGzM4njwIu0ObIBNsQ5MRLw9f8ZnXYtNcbe+LwVDF4EQG3XFpxox3ZLi
	bBRwoISvQQygf27vBW7iOoZgsWKA8NwrJMhYWJU6a3SenDwtPRhD19jPw5CVLnkcJDb4Iw
X-Received: by 2002:a17:902:db09:b0:2b4:58ad:e987 with SMTP id d9443c01a7336-2bd568f44a7mr144265ad.17.1778694460069;
        Wed, 13 May 2026 10:47:40 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19f7cc8bsm117708b3a.55.2026.05.13.10.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 10:47:39 -0700 (PDT)
Date: Wed, 13 May 2026 17:47:32 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Josua Mayer <josua@solid-run.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH rc 3/5] iommu: Handle unmap error when iommu_debug is
 enabled
Message-ID: <agS5NHNCAwmTesf2@google.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <3-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>

On Tue, May 12, 2026 at 01:46:15PM -0300, Jason Gunthorpe wrote:
> Sashiko noticed a latent bug where the map error flow called iommu_unmap()
> which calls iommu_debug_unmap_begin()/iommu_debug_unmap_end() however
> since this is an error path the map flow never actually established the
> original iommu_debug_map() it will malfunction.
> 
> Lift the unmap error handling into iommu_map_nosync() and reorder it so
> the trace_map()/iommu_debug_map() records the partial mapping and then
> immediately unmaps it. This avoid creating the unbalanced tracking and
> provides saner tracing instead of a unmap unmatched to any map.
> 
> Fixes: ccc21213f013 ("iommu: Add calls for IOMMU_DEBUG_PAGEALLOC")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>
