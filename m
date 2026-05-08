Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AF03DCDB6
	for <patches@lists.linux.dev>; Fri,  8 May 2026 20:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778272007; cv=none; b=W6YbNDpDLEgBiS8NwDzjSeavZHAcO7jogzd6SwHVtuCo9TzBInag2zFYe/S+18CdJagtKsPScdFgSppELupj8VrZ0yBbBsrZyN/yYaa704/gWDHW67x2vOIALb5R90p+HNQiqSiyWl/fzSrTGzW6S/Ug8CR4/RU66aD4EbPkUmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778272007; c=relaxed/simple;
	bh=WlJSKH8GnQbAQDyv/X9rW3tuvBYlQ+Zvl/Deb3LwMjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qzZwNaCh3vB2+jU1aPtWv6BzY9NWFVN8rDqDIXj7kKGP4zSHfWWIBJWAvGudJyxoiuIxITwEB09hZ6NwN/GvXTDLiEvTW8qBAq4Odwvwo9LcT8xTh2Ri3IUASseiJ+L+1K9SMw+ZA04Zm5mZgQcPQ8ntm4xfawbWa1gcp5oDcTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nReuIh4a; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nReuIh4a"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ba180a022dso285ad.1
        for <patches@lists.linux.dev>; Fri, 08 May 2026 13:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778272006; x=1778876806; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ODbVXyQBYTWUs0NYAxrrYfv99hBNWpudjtexIbDyTrw=;
        b=nReuIh4afF6yAfrAI3NQd7TO5dpraTQAA5bDIqzjg1XCYzMGjV7yz2JycpPr0Hz8Gz
         Tigl2c5LbimsFvZ8ZOViKShd4haWrSoDdpDm2YXXPKV2NcQOxcLpYN5eNMgH7po+x8xr
         wWntbQ84ukc3N7+g29dV476JpcmwFznhod4Y6v49ADhh2lGojV4Uguazxgat8tWBGrUe
         PB39W3sP13Nm8Pz5O/G+4VU3MRxnzyd6KJD5SNjtvRD2PipT1ONC5fSAn23mguaIL9U7
         dDgEarmrDcCAqfNlr2NM0bpLpK60Adqq3a3LlcgeE5MXweW8J5wgUZOdO6VerKA6ZENB
         CGjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778272006; x=1778876806;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ODbVXyQBYTWUs0NYAxrrYfv99hBNWpudjtexIbDyTrw=;
        b=RHuhoQjmdbXhz57Tslwse1O3uxQVbYzTuvz78AydGxuMaI+YFybXsUVepLG77ntcSP
         b/huCCAXqsNny9DgivHWQuMtzTmnBU5XyrKA4S1kNogd+9wMJnEzJKOXIO5ZaqlITxd2
         1wiVHXXXIw2IAMN5H5klFpuxXAtBEiVbUYjHU1cLOItA9djnjPPYVmZEslUjjdz9CGN8
         NzGMobgvnuKIKzOfEiP52TP4FS+44ioVkYgk4F750jY/CgRHYfO0rMviBJlZbM+rrO6e
         7EY+kd9seDwgCD3ilcfgK/YGFzacWt9ntU5DlnP+5xvuqYg4fI6k+2h7i+/AM6TCWAc2
         +LuA==
X-Forwarded-Encrypted: i=1; AFNElJ9r1R8hSIaKs506/+A3DyTSbfbnvtHzVvsbc8WKoSTxQJ4PadbOp6xNOFV9KQ3Qw2lv/GCNbGAz@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2ROSjCia4Y3I2c+7GT0A4yvJbpak4D4AEZowXSTiZYg/nj/n7
	UIKuiCjUsUARkXpUm0lt5Epj2FtIitFQxS4oal7l7nRDoTyEqSPcaYMaK5zvh9Rt3A==
X-Gm-Gg: Acq92OGyb6XcRCSKZ5PP2jAp6tewvDbH3q41ppHBAmDnXWCvNjoTlEKeokGsVZfepJH
	giZGa6+mPnlZE4reB/b58cyWQnCRXWeFPie06FXGJxg8iO6hVLQsxJhpw5zs53dxCtwHcqAau8x
	kUfwmEuGtJ7Ji/ls89IPp/3nZZfC2g9Xv6wNA08aqWaGZ/QZVqCi4IAGSugusyuop7oCbdyJURv
	u5/loitjDH+ZSMNqoQvKRYnd8U9a/Yu1An3WHg8boXPYk0r+QwULi4OfZ9kd9B9BonOzPjDWsFl
	njFPCIRW5nCzUgI9/C7rQ5BHsZmZhYYs8nKVrUxoUQ6KPvbUepqy7UegVb9bgOy3a4m6D/C7TWc
	homjIORHBO1u6EYDCYUC9D3dkorUqEQOCo5eec2tHofexsJERdEjTXHc25b6RK3bp7GqmFKs4as
	YnyPhWgrOCl+mYc8tRU3ZTQ7atjCiDjeSWpgEs2EKm5J2zPpn2Y2duotKBlagKTW1unslw
X-Received: by 2002:a17:903:46c5:b0:2ba:4749:c9a2 with SMTP id d9443c01a7336-2bc746fc446mr864515ad.2.1778272005075;
        Fri, 08 May 2026 13:26:45 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367c23464ebsm680997a91.13.2026.05.08.13.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 13:26:44 -0700 (PDT)
Date: Fri, 8 May 2026 20:26:38 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>, patches@lists.linux.dev
Subject: Re: [PATCH v2 2/8] iommupt: Add struct iommupt_pending_gather
Message-ID: <af5G_j_Y4dUUc6aZ@google.com>
References: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
 <2-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>

On Fri, May 08, 2026 at 11:53:01AM -0300, Jason Gunthorpe wrote:
> Add a struct to keep track of all the things that are pending to be
> merged into the gather. The way gather merging works, the pending
> range is checked against the current gather, and the current gather
> can be flushed before the pending things are added.
> 
> Thus, if new things have to be recorded in the gather they need to be
> kept in the pending struct until after the gather is optionally
> flushed.
> 
> The next patch adds new items to the gather and the pending struct.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
