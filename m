Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2F219340B
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 17:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740505949; cv=none; b=u+xEgqZco/nQ/W0BpQoIRLgHo5rXS2Gr08Ab7EwGWI73J4HtijUP1+JT2sE/Pn2+0vNjtmB04fBVDm1P4zmoQr6DBz7pL9dC3X6XSzluUASYWll3Sy0qQXv5C+q8dS+TRLHw+Ep9LWRulhpySiXB/1jr99f8Gp3ozEFvtSh+eWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740505949; c=relaxed/simple;
	bh=TITnbcgolKPMPksTb0kVckLbIOLQEkwI2FcyCceIkT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PDw0pqf+ekXr2rJxIvDKeTecFdrPzpQ4Ft4KU+419t8OgCY3akQkcExMTDjKF0cpxGmjfolbGafQ6IZwxUC4Ez0cv9j10oVbgD86zKWYKf/k0oOy//r+7W+9lxr+jjG0K9OmW2hE82CuBwTuaco05XkrrVkIyRPOXhUmmt9KKlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=quGSdFEA; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="quGSdFEA"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-221ac1f849fso1725ad.1
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 09:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740505947; x=1741110747; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dN8nBA+Qh6D4N+wqpSDyJLyiHWYbmS4OUKXh0N+DSqI=;
        b=quGSdFEAB9VqeJZlCaIcrqBMooOfnzFfMXN3lAqq2+EhrrL6CS8PGJAcetvJhZzGem
         QuHu87oZexktbOldgvlUZ8TMPnu6MLBZAhfBw97OTl0cQ7BwnD34c8xkbXmzm28uEVMS
         eLu9/Yz074tvfOMOY/1BZttpcn+qPpZggZfN0AP0VNtM7X1Ue+nUjyppigMP37CiOhZR
         f00bP7+K+33CSjHTN+iDJRYMxUKgJiHLD0QOJm2ynjZTR9MjFQusmyktn04xNFchzhBl
         FkKKjQkYvY/NZlUMm7OBGt8l4h010mHgXfolHz1wBNs7Rq6PF2TGRFmdB6rUB5iMVwhL
         LuEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740505947; x=1741110747;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dN8nBA+Qh6D4N+wqpSDyJLyiHWYbmS4OUKXh0N+DSqI=;
        b=tIXviM5AVAxep6U0tyFiXqbDZfuizdM2GVJRLVa46POgdb0pShR5hHseGOS2uStsal
         mLLHfub04RgX6e7LSBaI4YmvzHap9ahAkr/jNO9SZ3XikJdaVafh5TEDRv4dVD21npie
         itSgBCZovcmji14JKiL8NmXB1QJOPKTco4tMZrIuZmYRtslMg03aBPu/yUPI3VTOr8+u
         3mHWRyRgbZV10/vRYZcpSTRH/LrLU0W5ydsjTeDrNzNpx7b4wGLIjeX5un4Ajx4SUkH/
         uCl4k/1R5l8CVtDQrZ0snuk9RMTVe3QlufKZn0ayN8P8pyVeQninqN2IuLxvGhEeYWgn
         kJKA==
X-Forwarded-Encrypted: i=1; AJvYcCVe/Uh0a/AZCKmqNh3opBNPnaqwLvZLRN3WtFWaBbIAg18zA7n7I4DOTi8uExN6nA59dokBZ6YN@lists.linux.dev
X-Gm-Message-State: AOJu0YxC0pP9GhzcJqhyeq5bAx54xlquxaPA0iDE1kT5CRhfCq5XbHRO
	vIbNzs99ABUc04QJolpA6WNw8xMVzRwpnRKQIhUkfmUBbczpZ90iqviOusKkrA==
X-Gm-Gg: ASbGncsJmpZyiVOU3tR+aZhvTTLgGQeihJQvF+1/KcYCSH20tI63gKg6B3q6gfmexHS
	Hj8kvT8LO4ypy/HC2MDLaJEMq5TAXYCwMziY9M9yoXJ9gbzWno72aaiFHX04gAPMSHo1AWbXBD5
	ufyCIJM53hJ+XGBdnUnvTqoeGyCEzaLori1oZY95Tsej9LubfI+JNA6DSQblXo/zCsG4FL/tViT
	LOHqIIEOYsQJJt+fVxK+1xPjLmiUaPNzCjmMrGNat3wxPgemgQpr3HOUwxvyqUy9bcgniYgrWCZ
	8RKbB8XbX05H4vRmIogHbrb4aataEwPSgx5Qz31R/gOoK6sY8wVfE1wD3YuDeRk=
X-Google-Smtp-Source: AGHT+IHCwCn1SF2NMONCzfAyHzGrJNS1HAUTJPist+TAdk8bMDyf0wMytHFuTMKOTPJoVoDGnbqb0g==
X-Received: by 2002:a17:903:244d:b0:216:48d4:b3a8 with SMTP id d9443c01a7336-22307a60187mr3928025ad.16.1740505947317;
        Tue, 25 Feb 2025 09:52:27 -0800 (PST)
Received: from google.com (169.224.198.35.bc.googleusercontent.com. [35.198.224.169])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fe6a43ccb3sm1861445a91.39.2025.02.25.09.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 09:52:26 -0800 (PST)
Date: Tue, 25 Feb 2025 17:52:16 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	joro@8bytes.org, suravee.suthikulpanit@amd.com,
	robin.murphy@arm.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org,
	mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
	smostafa@google.com, ddutile@redhat.com, yi.l.liu@intel.com,
	patches@lists.linux.dev
Subject: Re: [PATCH v8 12/14] iommu/arm-smmu-v3: Introduce struct
 arm_smmu_vmaster
Message-ID: <Z74DUPcl9KRZcvpW@google.com>
References: <cover.1740504232.git.nicolinc@nvidia.com>
 <f205a4e2f5971cd4b1033d7cac41683e10ebabfb.1740504232.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f205a4e2f5971cd4b1033d7cac41683e10ebabfb.1740504232.git.nicolinc@nvidia.com>

On Tue, Feb 25, 2025 at 09:25:40AM -0800, Nicolin Chen wrote:
> Use it to store all vSMMU-related data. The vsid (Virtual Stream ID) will
> be the first use case. Since the vsid reader will be the eventq handler
> that already holds a streams_mutex, reuse that to fenche the vmaster too.
> 
> Also add a pair of arm_smmu_attach_prepare/commit_vmaster helpers to set
> or unset the master->vmaster point. Put these helpers inside the existing
> arm_smmu_attach_prepare/commit().
> 
> For identity/blocked ops that don't call arm_smmu_attach_prepare/commit(),
> add a simpler arm_smmu_master_clear_vmaster helper to unset the vmaster.
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Pranjal Shrivastavat <praan@google.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 28 ++++++++++++
>  .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 45 +++++++++++++++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 18 +++++++-
>  3 files changed, 90 insertions(+), 1 deletion(-)
> 

Apologies for my spelling error in [1]. It's supposed to be:

Reviewed-by: Pranjal Shrivastava <praan@google.com>

For all the other patches too. Correct spelling in [2].

Thanks,
Praan

[1] https://lore.kernel.org/all/Z73zvIbsXzJMCaNt@google.com/
[2] https://lore.kernel.org/all/Z730M3XptvDRObBp@google.com/ 

