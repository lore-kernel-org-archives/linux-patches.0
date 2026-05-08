Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7AE3E5EF1
	for <patches@lists.linux.dev>; Fri,  8 May 2026 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778248848; cv=none; b=H9MzBKYMnjgCKcsfe/N+jabwVmy/6IvL5mejEVVrlskYOFdBtF+f1m4cS80sT2xDHtkhZN0jAdoPLawX2JaSJqZz4apjDUi2Be9PKv6P07eFKBYKhBm6NJDYNas0zcjicXPe81AEq7jGsRlIJydQi70LNa+nsljNRuk0SiSd/Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778248848; c=relaxed/simple;
	bh=iqJu+r0ruvrFT+na7AA+zYV2nNkMq2VB8UiCghLRSWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hXswYXgKBL9DeYypX1h1IkSi4QRY0SARxc6QYyR5N4SCvZBUa6S3ilpV+wy6ETcGgA4ZI9wFgO6nYZPaqRhXFzkZoy7bIZugJkMsscIZKCzL9C0+6BjQQA2zQU94HZJGI/34vkxN6ng5xUgTUXra6O6m2wBXFzzzSm0l65aSRKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NUl3dC0N; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NUl3dC0N"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso87805ad.0
        for <patches@lists.linux.dev>; Fri, 08 May 2026 07:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778248847; x=1778853647; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rg6wbnYU6IxqikudtR5uG+CUKtmNxQwde8y0MusXhEI=;
        b=NUl3dC0NrzXhCqMYOWMpQ20XXKhigrOKtBAJHhoulN8jOLrwh+PDaUYHbytV0y1356
         WF5/DtZ8dV4cAqZaDOqdldqkJ7XqbWBt2GBwHc45TIwsEr4XPriAJj94yJJYSr2CJDpI
         68nk2Ax++fzTMtT6/SFhHPIS9LBCUP9VkdRVmCiBidDKXNYRRP0uGCzdorvOUXC9dXsU
         uPXURY6G2xXdvOSSxDB9CMbIgniDQ2BpmmQLyAE2lCK3wFesVgGTfj1pV3UDSIMsr0WU
         29mUh9TFDw1i6t+F5aF38HO/FUV+yyMe57cbXhC/rZd026uDF86n+dAvLOsiLwyEh/uV
         V99A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778248847; x=1778853647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rg6wbnYU6IxqikudtR5uG+CUKtmNxQwde8y0MusXhEI=;
        b=ZUqGeb8mJjpVhgTo3MHzvmVN+UOgrj+VT5w5IDw/8t9wqIsXuhXBs62S0tTvvdsuH+
         zMyAi119+WjsIeEl6qp+MNyP+k81Ru9bS9xVZrf0vpRxsjTzN0ibyHcP/tCYmnzXlxh8
         0Zy+/kpwMSKklWJx1zlBATQ5HQjzAbCRo77P1fIdEIv6H+InYZb07oKkFserflw2s0K3
         xWeOdWLmtvhraV5C+bnl4g81PMsXYVgdHe4HHkgVsy80BQ1LdNYyWcwH6/rkrthBdUT3
         KXjrY47oinfWrTnmb0oSZuoO+TBAIaZhafUfie+9KPaIUa6t7JjEeNgkKeOQFihNCuDc
         9UWw==
X-Forwarded-Encrypted: i=1; AFNElJ/jaBOrqk/ugpo5K05F7ZhEiiXWh7qJU3GVfb+d2NWnaqgGXwvAe4Z7pCNO83JR4CxaZBAIJt3d@lists.linux.dev
X-Gm-Message-State: AOJu0YwSo2bj6ZPehJPtsvmKzUU+lZyQxiip2PzmeABcNu/hugZa6NGZ
	NAhw+ybzF9C8bPMpWmHyo7oPulxQ4+Ln2QmGUsY8ZTOHjGq/O8MTbxovhNKBJWmcNg==
X-Gm-Gg: Acq92OGyCwEc7qMA27LxN+H9Ta29lSKIwBfQVfZ9ypKdqS0lYasQQk/iz/8Q+bAQYlZ
	nNHuVmn0rTrF6sjTTljSD/2pAK0GTf18QyZ56qbMe24Vj8UQlH6wB5XRvq5yDU4pCEGaOUgLKDh
	dNI/0EPIPULSZHEMA05EvNgIz1u6N3k9yHfz4BU08lG5MpLaFvbg0dp8JYwIgRvhwgtRx0EDQJS
	+OwJHGUUkP0Sfd84dC0k5u7Fvm+5YTgO9bf0epYC4qdyySBt5mQNtqJg1Gql857pNx0yoXYkP8F
	q11Cmg+qMFdmmxBOtQq9Haz1BUpW/4+1lhRcSMk+itKRhWi/wqVBHtCmvLIUEJt3SRHaowc5OPH
	gqzGcseZYa3gzsSMM8decuhCVy1JfQPwpJYMuQyYnmlrqUEoeJaHhuvKTZUgpPpSoq1JHWrffEZ
	ixeZGJCeRslJyejnT2UrBYhdRXSd+6x+L8PCjw/ejn6DEMo1Fo08whpJ3K/5Yg3405PTQz
X-Received: by 2002:a17:902:fc87:b0:2b0:5c88:51e1 with SMTP id d9443c01a7336-2bae9e67750mr3727515ad.14.1778248845874;
        Fri, 08 May 2026 07:00:45 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d405adsm24217865ad.28.2026.05.08.07.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 07:00:45 -0700 (PDT)
Date: Fri, 8 May 2026 14:00:39 +0000
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
Subject: Re: [PATCH 9/9] iommu/arm-smmu-v3: Directly encode TLBI commands
Message-ID: <af3shx9ETdSzwPhq@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <9-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>

On Fri, May 01, 2026 at 11:29:18AM -0300, Jason Gunthorpe wrote:
> TLBI is more complicated than all the other commands because the
> invalidation loop builds a template command from the struct
> arm_smmu_inv which is then expanded into many TLBI commands for the
> invalidation.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
