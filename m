Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A8537C911
	for <patches@lists.linux.dev>; Fri,  8 May 2026 07:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778225391; cv=none; b=QHgNXnksGknq4o0cd+Kpp6HGMldp3DP9seVHwuRW28IMWihCXyn4TRhofEPFYdwiPYgbVqQ66R9p26YO1jledkg4DYsa8cbLUzZqFRgVSP1VLyQ8oq9dHkrZhCbB2/e8tLRToLdWdn1I4NhCTYSnfSfBIBwYdrlBJYOTqPmSV6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778225391; c=relaxed/simple;
	bh=QA9hR0bSYIQ5D64x8sjWe6pmUWzl9IwQcukTQJ+tl4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bqVQ7yP+46Zoq6j/eyvSMVTFoJoHGrXhMr57dmYsBIF+mVgaj+ajwqP6Tz+ZCPG/cfOiVmYUf8YBOSozoSyZtQOkx0bPASu1PFHRln+GxaiJZg+o5Up50pNJSANxsAFRkYZM/Myh5494J4RPYL0Umfayuguq69+zkBZhC1RHMQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KVuE53YF; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KVuE53YF"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b46da8c48eso57965ad.1
        for <patches@lists.linux.dev>; Fri, 08 May 2026 00:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778225388; x=1778830188; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gtzgOVlx3+XiZk8bPWEWW2C41hmZeWg0/ZKf/2wFHh8=;
        b=KVuE53YF7yMwqCxUP5eDGRuofjiCkddWYBWzjsERFEA8UcrzcqjDC+nmgOU7J9ZZn8
         xsvlJO5hLSdJ7OXHywutl+x3TCZxa2dPRV/CXWKjsEkLm0pgYnjmbSxu9fMkQ4J1z4V+
         3t8AczqMsFoKdfrE+FpNx74GJmFLa5TrRFLjBHykhplhJSeWlGKR0yKn9ovfVw3E+Onm
         rl9vbA71f4ZrUbE/zPeJLP6kHfmEif5XtHBFrB6LYPasOhu7gYxHLnCxBEOpFjCOClQ8
         i7IqYBNvjrbv+tqAi6SGXaajXmSrxl94I4d7wLWdsxQrFT2jO1AEh9I1OLU8MYc6XW31
         +98A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778225388; x=1778830188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gtzgOVlx3+XiZk8bPWEWW2C41hmZeWg0/ZKf/2wFHh8=;
        b=EZnkLmN5bHH2iB80LDh0LoWsDIbYbGWeWAZz2nzBMlvZTpAPmJSPl/0A2iGJU2lOI4
         pHYakuVY6s+QQqLL7svIQ/Iu3RrqXgiHSnAZTjbceJdibzGI2Gleh6WUV//1I4raRsLe
         3U8XfTirXK7y73PsQCFoFt5PbEzqlXllKPgLU5/6KXL/qKEt3VKJEMyONyoedY4+OwbU
         9+1rtIth1MNn8LZTWvDUkqi6uYmMLlisj3Sq6nTzTmBAcMNfq93gwI6CTkuWEnVShEgJ
         u4ibW2Y1vCZFMFqrSmqlWWHvAfppilpGcwYN7Zier6qUm4b+xcy4k3gerWMNPdBgkHLt
         LI5g==
X-Forwarded-Encrypted: i=1; AFNElJ8DK7w7Qr3aAzilR2XVemheLhSnrFO6xaE3tNeWZkBo/Sc2UmVavhknVDtidDVmGtgEep0H1i/1@lists.linux.dev
X-Gm-Message-State: AOJu0YzAtgvIZ8BjdLb9SOADZqzWsbXg/ph8z+BqNN+4eVoPlZEq0jM8
	c26I/L0VpWyfNnSrYkh9SLuS7iM2gS+jSjVikZ8gFR46ZdDi21KIlxs01QE9AJjdQA==
X-Gm-Gg: Acq92OH5tJOJ7E+O9wlW1vwjXnkV36or2bgTItJBDju3fDUmA2ZrjImpMmau8wy7Ihd
	aXSy5Ub5ty0L6ZVDrpvQuIo2AS2I6upwSxSuf/F+Iq9uUNtqlce4lHX1JljVeb1SnW/kBn+NL5J
	9BUgIaK8Imz8IeRTE2nm0jrTSSjV89ogb+I1yTT0VHXJ4V46LMX0f0xNVULq97WuCT3ecfwnrOK
	z43azjDPH9XN4aJ/9Yk1IiHNhc96FD2YCz/UAu7LknTOdy4oVfZdmfiXugMAH5Dr+MaC2XUDKhe
	4hPfW66VVzmlBdCsgrVNlrfohEQYe0n91YlgMaBRnmFcVQhHVhGmwDCqS1lVRX0lmhdBMAmJah6
	NX7cjmty8vhmPGCkemToQbEJ/tdTIsqMVaBz/wQE2D+48M6K6it/9g+opKgMzuDUaJju2YlSL30
	Gb2p7zw5r6lzGUTbUiTaLS2ERWYz7YAvlM41/+lFc36W4/VUaCxabMZJ+kPqaOfSqPeuF5
X-Received: by 2002:a17:903:3c6d:b0:2b2:70ba:305c with SMTP id d9443c01a7336-2bae9a8bf41mr2914125ad.8.1778225386989;
        Fri, 08 May 2026 00:29:46 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e9fd64sm10355055ad.69.2026.05.08.00.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 00:29:46 -0700 (PDT)
Date: Fri, 8 May 2026 07:29:39 +0000
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
Subject: Re: [PATCH 1/9] iommu/arm-smmu-v3: Add struct arm_smmu_cmd to
 represent the HW format command
Message-ID: <af2Q47MaAECnRzvY@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <1-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>

On Fri, May 01, 2026 at 11:29:10AM -0300, Jason Gunthorpe wrote:
> Like STE/CD, add a wrapper struct around the u64 array to represent the
> already FIELD_PREP'd command data. Unlike the STE/CD this is a u64
> because the command submission path will have the swap to le64.
> 
> This makes the API clearer when a u64 is referring to a formatted
> command and makes the following changes easier to follow.
> 
> Move the command constants out of the struct and into an enum alongside
> the rest of the constants defining the HW format so the entire HW format
> is self contained and independent of struct arm_smmu_cmdq_ent.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
