Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE09033261F
	for <patches@lists.linux.dev>; Fri,  8 May 2026 11:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778240809; cv=none; b=pPcryCQvow/zE50yye+c1yaOmYOs1Fnoxt+CVLMXXyJde8NDexUHrI3pM04nmVcsK0SzyszsJfIYaLH+ScG9OV+K62yDrwWhccwKrLz8Z920UBU4+Sb1sQop//ZL+IfV+YIJl+m/EIyBJkt/JkLBGBfWtjgKfOHTLxR1Jsc1jD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778240809; c=relaxed/simple;
	bh=DYoySGWvwhGOll9MsWpRxB+eEde5kCmNkA4iyDMusGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ofFxsmvTSesovPGIuYF70autVchJ3RDGnjxMKsLGgtNmOhoxMf6JeFcV9yqo4aUAkUEllw6FEZ5u1240vSR6yA/5A7ZeBAWHbtlO15a1oHmw/I+xPXmKV6wPTRcNVfsrPiiySQXRX6gnfmz+Mlk0GvP02dkv0lM5OYQRrXyfBkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UrkIKMvt; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UrkIKMvt"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso75065ad.0
        for <patches@lists.linux.dev>; Fri, 08 May 2026 04:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778240807; x=1778845607; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yk+VF2UUzCSCg/RvIE6fW76wSTl5BC3qMVjRSFknw3M=;
        b=UrkIKMvtR0Pv7xK0dvGl6W8XywaqdCz9QaEvjUo9rRtsAYYpDJu1tH5xw+zTNdxk7c
         ktMcokK1PLSslQZIrlF6N+PeKIc50Bu71Pc71yYJr+RPKTu/e6MD1ifDdxgAC13+d3X2
         xNH0ZGM5ZxGSml7Nzy6SRjAc90ewdVF4FF6wxrjnUrxpCUm9gZRNQ8EnY3XCKnSZ3E9n
         8UpqIoWi4oybgqII+yGGYy7IDpL54V9B7bu72ozlwFqWiVfv8Ol6j4K163UhccvaV2dt
         wGLFXK5s4nEMcU10eiCuIDchra5tKdN6vT7mV5x74FxN4YoZ3bGfvE7fLlLtTKpLdSVX
         OX5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778240807; x=1778845607;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yk+VF2UUzCSCg/RvIE6fW76wSTl5BC3qMVjRSFknw3M=;
        b=VXw1+XtOELPR4Sjaox0vGiyTvF2trknhB+gzP5BDMezlvmrejztAd7Pqab6pNPhYPT
         rSyG5g+ckcj+Qg08vrTp2ZqHZa4y1HQOubaW4prna61R/gJ7F7bHXFcdMUgaCLJDZqJc
         N9o9B95OE4VYYx/GDSrQ6hFjOpzoz/r5D3GhENn9S85E+u6rxh6Ba/39ghIobUkwwmQH
         FVmRUE1xgh6xs3J1XKD8OOFiGqd1hZtzbuo5coRo0E6uFdiO0jB/9b01S+MPxPgRSvTF
         IiTGWHIo0N+ouRnwg6JQyHlyszgGD0o6b/nNK21z4IoH7rjVGrRyYAq0VM/10aTohy2N
         uhwA==
X-Forwarded-Encrypted: i=1; AFNElJ/JjwckDLLy/GKq/ZINrgp2LIcvHtvktJDXSWAOLLf8shlCHVKA2q2i83/xj8G9eDAxoW2MxI65@lists.linux.dev
X-Gm-Message-State: AOJu0YxnfJZ5dkgZq6ofVr7n1tbBUlL6g0xrpS3NPd4abMNTWfFh3jOP
	Zm9eYVRRrFcx02RVGIKhX3N8yJd8HO7qKGtFfBPTKSXubMSncP5YlfhcR+vhJLou/g==
X-Gm-Gg: Acq92OGvrWeCJYB5QYzXeupIfWnPcC2aqNkpQuWGcXzfSv3+aMjXvHPdG19m/eWgyOq
	Sv8YZKSU/EM8Ba6cfgSo2oVFi4EpJyiv3xuX7H5EbUfp/Zxfx79SZSwmUMZ3aCp0TDCJaEeU/tT
	Rm/cRCYniLYZ1ufdMEnG3Z1tOssigoROzA1UC8tRru+oewp7Uo4goUJ8UrkG3biNsn7qDkAd5yC
	J06P2F27sVN/9nKTeK0rW31WH5AmSHyrQMqZoQo2Qlow/RmDGpj69bm9vXCR188wFOOdoxAqUog
	XRR7NfhYLJB9qBB9WCqIe/+aIg9LgnxSkEFub35GFspWReQkI+qSy9Kq7ws8rjctHsoKbhsO7bB
	36erJbBMzCp/BlR3p7mQSE88Hl+JFk2CPLLnS/eqofrsybM2KFsvUOePcyEDBNLJPsm5FOFwBj4
	RAR88rKCcGooGyV8Cr6mvksPjc7eLjlagNup9lUgkAXHiXbBIME0Xw1MgOBpOhjFvBxajt
X-Received: by 2002:a17:903:1210:b0:2a7:87c2:fcde with SMTP id d9443c01a7336-2baee8320bbmr2253775ad.15.1778240806820;
        Fri, 08 May 2026 04:46:46 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965d36c10sm15031850b3a.25.2026.05.08.04.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 04:46:46 -0700 (PDT)
Date: Fri, 8 May 2026 11:46:39 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 7/9] iommu/arm-smmu-v3: Directly encode CMDQ_OP_ATC_INV
Message-ID: <af3NH0cihPUQ8PST@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <7-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>

On Fri, May 01, 2026 at 11:29:16AM -0300, Jason Gunthorpe wrote:
> Add a new command make function and convert all the places using
> ATC_INV.
> 
> Split out full invalidation to directly make the cmd instead of
> overloading size=0 to mean full invalidation.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---

Nit: I guess it's worth mentioning that we remove CMDQ_ATC_0_GLOBAL as
we don't set ent->atc.global = true anywhere in the driver anymore.

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
