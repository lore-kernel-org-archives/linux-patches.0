Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B33D2BD11
	for <patches@lists.linux.dev>; Fri,  8 May 2026 20:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778271880; cv=none; b=YzGJroBL1l8OFwbIUK3M6bJ8qoLhha8hsbgzP+hXGI5fDaQuOadjnsdjjlBWvNhicLd507PNABK64VQq+4l7BwmdgrLaGAomLWn8V1F0k5dYgnjE07T5W8sYjXKujObl7vZzdxEdzP1J00iept9lA/gOyxz8hTAD4ZqNyi4Bjz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778271880; c=relaxed/simple;
	bh=kp8rSN7aw4Y1OKNbD2bQGxjOJigkUnTB7MvPDsPxF0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H3CJlw+sEOK/pjRHv+ppZRkQ8kfNMaRXA3YJp5qf+0r7nogpmESWJ93fBFMi71iBnv+vKk7CA7t23epBeWpIsyJpABFDG6Y/g6egpctFCpcELU5DrOFkrTJRbtXb2m9pffAvq66Z9W3MfNMghl9aU6xf4KWaNQajs+gB72wVuaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EyWPjcXt; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EyWPjcXt"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso1165ad.0
        for <patches@lists.linux.dev>; Fri, 08 May 2026 13:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778271878; x=1778876678; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ce+YnMBE0LJf/ZEN+RPq6mW2l9lqvy12xVD6Nz1p8bo=;
        b=EyWPjcXtCnXY60xLUMCcAWPHy8UM81ZlpbMbdLQFwY4u3HWixvPjx/inmumET0KtAv
         Vu8dptDgzvUJCZPia7tcmSk6o6s4R6p2ZowBwZoOE1YFiZiftvRLFuCuF4G5ouErnAmj
         i32xMG9oQXIJTFlWoMTqYDHqtiFTUxx/hGW6vqNJoX1F3DT8Tg9EqvKQ0C/U+bWTtaa5
         Vi1FuSrFL3I6Rk9aXHHKQ84YChsl8bxYaAJE7BRCH+J9UWNUxyjEIkLFaBZrVEYY4aNq
         P8IlCgEXCdP550E8xPrStAEuKQ5z3w1B+fqg9+LpRCH77pQ6G6kuyIQHwdByaP3n27nu
         nvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778271878; x=1778876678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ce+YnMBE0LJf/ZEN+RPq6mW2l9lqvy12xVD6Nz1p8bo=;
        b=OVcztTZPhtFVdv6OZHJo5Za6pC1USVok+TqPDh2m3l2wYzVPLXrPhMjg919rSMQNBR
         r/BcdYArJi/yZHIRQ61h0LY6erZeQg4MjVCTlgAymHBSASUQ7/EMNSiGHtYgTZCTZuTn
         vZR5TI8rUYH1XpJ8YcObPSzbEKUU5W2pdFZAeRIEmQZkBQVElk5TeyoN0G2gbBBE6Hwr
         +1QHgpHsIn5FjGDbCT7Jk88oSMyYQVHftMOJSbhb4j4aqY6bIf75nBkW4EYkuiDe8l/X
         a1kS9ybZ/5mLaK3AMNXk42qrVg17zbTdcA6LaZ6ZTtmOuEXPjc563gvjPRvzj3YMMGMM
         LhtA==
X-Forwarded-Encrypted: i=1; AFNElJ9UYLdkfeHAOVd+1K5LlcjYtCj7HEIE/x1M0WS3/6sPffiewH/bXMx/aHULNmrovBR3vs3ppEW9@lists.linux.dev
X-Gm-Message-State: AOJu0YweqLm/pG8+i/AifQc2V0LMIUea78Sp5jddrNLMHYGvw/OZHso1
	Mgoc8neY5MTIyTu9V7vl03vKEfcv0FJrJCdRrw7CsY6QZZjBkX3uHtCzK+Ily5ji4A==
X-Gm-Gg: Acq92OG/fHjd1NUpnUyxLRJZyhXsXwNcGXqJDqQXZ7tmzdy0KL6AnclJWffCgJGg2db
	alvkV113WIbGX+NBuSsrPPwUIb8guY3tlCQbJGQjHSi8Gq3M9mt9jYBadB/Fb3pXmATiwTFuC1x
	8ORull3a9Xyzb/omfp0hKpgBWQI9DDle1UA4/saus0tcFpf+laW132vJvD+X8KZ/fguKWOgXDa1
	2RdBOK48hsDcUvgShe2zmyY4jpp2C/ycpkeVNg7B/Z+syIvL1pPSAEMgzX87NBeRpWbYEtWpntH
	O98nTORkxslgLebbezBDz57JtzIu0BRbW1Ia+//EEpYq5si/ArZxaj2+FKGDIOh5J1tn7IyrETw
	qA5HAXke7TlxHYdyF7U8WD2SD/AoqYKbmkQYGuHj4eBvyDs8bJxcJgQlYJydi8mjplEl6EXtPIo
	DhwbRzBxPrTY2g9D5nooc5dSfQCNXRn4VNJNAYFQtHgEytbVbdqeg5R+qWf4PrSkUpsk9z
X-Received: by 2002:a17:903:1666:b0:2b0:5c88:51e1 with SMTP id d9443c01a7336-2bc747c1c17mr760485ad.14.1778271877978;
        Fri, 08 May 2026 13:24:37 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c826767be0csm2827343a12.2.2026.05.08.13.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 13:24:37 -0700 (PDT)
Date: Fri, 8 May 2026 20:24:31 +0000
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
Subject: Re: [PATCH v2 1/8] iommu: Split the kdoc comment for struct
 iommu_iotlb_gather
Message-ID: <af5Gf10IujBbDXij@google.com>
References: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
 <1-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>

On Fri, May 08, 2026 at 11:53:00AM -0300, Jason Gunthorpe wrote:
> Use in-line member documentation and add some small clarifications to
> the members. This is preparation to add more members.
> 
> - Note that pgsize is only used by arm-smmuv3
> 
> - Note that freelist is only used by iommupt
> 
> - Reword queued to emphasize the flush-all behavior
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/linux/iommu.h | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
