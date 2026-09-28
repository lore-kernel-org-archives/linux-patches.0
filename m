Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8004EFFBC
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 16:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790613553; cv=none; b=l0znuHfwjPws29b5+9WWb14g3QQDK7ioK1jJihxouBd/TkJ2RRyGzH54knsH3ugCLwVubtjEUNytk8qujxy+eILFyaG//Z0e4uizU6gVJrKAbWWfkhizHFOEG0L0O/SCXSNLBAzhJQpfd0c4zt5oSsB7W99kia27H47lTiW7WTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790613553; c=relaxed/simple;
	bh=eUfvVLZQX2fpM3flyInt6K9umn99g8n9V1ePGkoJIa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hT0XGsBtqiLyI2SyZ0TEwy1cGLA4z2olVxGBCe/XLuY58g0TngkiFaqt1AVIOV9Ya81oXxo7RHTOJRzwp7+8w1Zws35WkYYWnnqlh1LZAgJzM+0EwfkjOO+wO+Ge9IuQzCQDS/hylWbPX5NZ5K3syiYMBrwPUAg6Fl5s2GNEn0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AmflUG1t; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AmflUG1t"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2db33db4de9so75ad.0
        for <patches@lists.linux.dev>; Mon, 28 Sep 2026 09:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790613551; x=1791218351; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=39N4SJ5sD0wjIsHC5a7NtN6vI6BvpcPPu/06LAjzoVM=;
        b=AmflUG1tayAUzyuwNXfjhHDUSiTKKTZsUm6NrIRXGljWHVc8t0xKmGK3Imx4w913cD
         XSNr3GhPlnSORYWG5vAOYgn7nV6imDsXXjhbzokgygK2ofj29C7vz+66ZIoq2Tr0QQRc
         7wNMw3lIdLeKGJGyzrBCiBP0h+TUEP1PB2PPhrBqwn+msDjLXTJP39BD5jzTX/ecyADF
         NXsGHHuHo6R9ODXRaecK9SqJRJfhpJY2tS87nsSo5Z0U7BVTTxwcrJRfjGWutuxVQmhR
         AlS/uuVkmwRWff0Zh9bj3tmGQiDfzX/WZl2gdkQnc3TRCRLecPZ/F+GaoLasHpuZXJAm
         rZBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790613551; x=1791218351;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=39N4SJ5sD0wjIsHC5a7NtN6vI6BvpcPPu/06LAjzoVM=;
        b=aC0ZDv/ainRu0IUWfZ1BsS/ZkjBHCsOFurTQt7PQNXRWNuL5RwuQidjV7p/3Ug5Ocd
         /vQI2Dlqyu6Adim86yTRJS8wdhdAPfvLX0zzKzlejjjDzX+oWv1eqQWIDgPlybqSVI/Q
         oV7aagA5dKD+fin3KiR+ykMZM7kbWoksmJf7rNXDnJEERspYceqskW2mNHw1xVk/ypW0
         c/dqhNH5OBkJh3BJN5JwH4X4RojnnJoFKhjxOi/lV1LPbLn8y7wI9ZEPLrxplbf96c6K
         qSrOoHZnTm1LRXMmOmhT7UckyYGOd/8wN3wDnl7bvGgDnyk3CaSRh/kpBmkiwF0qXA5s
         hgNw==
X-Forwarded-Encrypted: i=1; AKwUvBwJDIJnaHDdrx5d5uDfow6QvKzGYyAX8fIVFR2yiqBkTTD6nCJnMi1dy0ObdNDupLZVCufGlpTk@lists.linux.dev
X-Gm-Message-State: AFq9FYIClRIBvqMCWpPy8h2jRic1eZjbO2LNQ/KzE/FXRkmFELn8TgD0
	K1pGTdiiQclfGHikQQ78eSVq/J/47eRsdupUFI597ue8AFRXFlhrhb0gD8NkRK5EEQ==
X-Gm-Gg: AYBFou306TrepznTIvDB8RIl8u9ViIQH+P2JRMYb0tk1vnyVBkBLVXCfJnRpBeegvJu
	pU3gsu5mRcHL9wNg3SsjQgRZz2RSL9jzPHUt5cuShjE5D7Ayl+2nbgpVCo64LiKTI1gls7yboPd
	gKr7FJXom+sGowVvRymMl2E9LV8CtqD2w7ryFX1HOkbgZ9KxjAyDsZGdKwuV6lq5Bc15w5f8ZNj
	5bILX0IeH/thn32+5bHeBTh7H6bk89+opmzVUUMVNToR7e/et1ZIwqqIb9VkgtMBJk17i2O+WMe
	DcGgfNTWEeNhOGydbmEaK1EbF7+riee1tnpEAHDFU0cp1O1PMmCokfTBeAG5Z6U6roVBe9qzLnO
	nNp4iHuBuUnUBLbDCFCbI5Ll0/Q4887hvhIkAVfIWhny+6svcTsCTWjrWdVOI5LIun4P07bN4Zk
	Q1wIlwfv2zFTudKcwQoYt4gtJvF7ryrK+PNE42nM/I4nbr9vjHtiLfmzRBf1npaBexAxPeXdHxr
	fACOblEzLLwUEwlwR4Csk/70shDNK0p64AVpaw5d3I0OEQ=
X-Received: by 2002:a17:903:4b0c:b0:2d5:db3d:1a42 with SMTP id d9443c01a7336-2dfa9773f0fmr7086335ad.15.1790613550389;
        Mon, 28 Sep 2026 09:39:10 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a498057a62sm330376a91.13.2026.09.28.09.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 09:39:09 -0700 (PDT)
Date: Mon, 28 Sep 2026 16:39:02 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v7 6/9] iommu/arm-smmu-v3: Precompute the invalidation
 commands
Message-ID: <arqYJgFdbcyAn__v@google.com>
References: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
 <6-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>

On Mon, Sep 21, 2026 at 08:55:14PM -0300, Jason Gunthorpe wrote:
> Store the required cmd data in the tlbi and just copy it out when
> processing each item in the invs list. The cmd form only depends on if the
> instance supports range invalidation or not, otherwise it is always the
> same.
> 
> This avoids redundant calculations for each invs entry.
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
