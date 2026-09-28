Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A07D4AA401
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 11:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790595377; cv=none; b=PgZG5ItqryibtmK4nHxvdPrmGFXByNiF40qxK/aMPWRGDNoau+izdVkEDFFLr7/Lg5QSJSVGrCS3Xc3hMUL9/BH6TLU5eb1i1/4fX1GLwKa0RKRdPRG/TcFfwn45xVpX/8f0fSJ6n4v5ZtZJ1zN+sgymg4SQGZaHEQ3PNjXK+64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790595377; c=relaxed/simple;
	bh=szkmBZw5tkv9QIb3MfF0UTg+9Z/SIDMcAeVrvWmsXDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G57170tnF0G+xNjKJg/6f/gr2K0uSysyw4PvjsXJ8iMWzA5IgOU88DST04OsrbHITl79QsZIvJ8vb/fJ9HV18kxjXxtYxb5J58cg5X8sGd57l1MMpp3JkGY59So59gR5LOYhhZDaJL371DUmYIcUfHcZpPexbq00763aodwlW9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ux9+EahI; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ux9+EahI"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d3b445a84fso67655ad.1
        for <patches@lists.linux.dev>; Mon, 28 Sep 2026 04:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790595375; x=1791200175; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2virUEPJU+T2t2fxsSozm2l7j+QFgng63b99urpUcvQ=;
        b=Ux9+EahIg0DfsKFWVNBpa2TKrW8/xJiV/6ZdFPtZku4rY4tmCCyNZC4c/BqwG1weJJ
         GA855gGOgo6gemLHUMRKOLpnCaQq/76mV1kXs50BsZDNIuF8FgrLAdwZLyJwbz1HMWjB
         6VJda7Xq0KwUeLIvhfAK2W1HKRcauovx1sdTnjBtTATndilvcvFae4ZuZQG2gziYagnQ
         1HvlZ2A4oa4vgBgIurPADxIkLdOukf+oTnxHfWVfsC5EL6BNx6XcUr5tCg/0ikvQkDHl
         h8Jzg7jRwKOyHphX3xJynelLsdMxCI3kVt1B6RJuYpnDRSdk3JNw0Z5dfZqbibnhQuoR
         EuxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790595375; x=1791200175;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2virUEPJU+T2t2fxsSozm2l7j+QFgng63b99urpUcvQ=;
        b=eKmpo83M5uWAA8ubkMw9v3cJdwWIPKXnRgUAdnAG9oJJbtWHjxn4KVdaSAbr2k/yEU
         8JHKKJq1blTkk+W0UDSUsYKWM38tK+RXt4rJaAg42WyGtXWQwRxW78WRYitV5A+mt9Gb
         h2/e0Q5E/CFWlVNQUPDX/tyXsGuIN9UR60Hi38EMTlRGs2kOfRMLRhKs1Non0vSPWizS
         QFvwPyLc2MKZ4Ke89PXrtPR0euJ/mVWCYyb7qQRp49o4KUeoQpzdUb2VxgEje8HJfxVx
         yaO5m45LLbGgzVgyjRbkQRz9XaAqmpGy+kdSafbUxdmZnJy1dJfYqNDQsaqlJxTJ/a+3
         T3hA==
X-Forwarded-Encrypted: i=1; AKwUvBw7O+/AJfvaXVNqomNMoftdYscDK7I/bVi9c9xBDg5SjEXCKMHe5wPX6d3HNYXdEqj9pVo+Mnm6@lists.linux.dev
X-Gm-Message-State: AFq9FYKv9KMABEjYNlkuh5KUxRq+NAhz3UUujqlj2LG1cEA0D1Pi9jcJ
	3i+t+1hFYJU8B0dMrIFJGdDZrLtpF2BWZVQvTq7Sph+JUEHBeRrlm5Izn5Fs2PjD3A==
X-Gm-Gg: AYBFou3T0PfFVjFhAtcs6OuE4A2CQNNzsH4UVSE9tleTTia9KbjQbwFhNBO8k5wrEJg
	VZ6xnBccXXNsEip4bMEX7z969OethO9Qmd/7zXCwGk4qH53P0Kdy/yb7ULC2T/by5FmpM+GHSTS
	Yiv1SGeOcJjSpDxBnwkowlY42wI0VlDNCUnYJdSbVurGI23hYy4H6QILdGDO4JBBagBa632QE4S
	l6IaD1GIEciK730M3XpGvx4z7GMWvKwZQXmOoLtWutiazjjG9T6m8N4o7ZM3PWHTxpDDTvUX/wC
	RcM9W10IWmpR+FPqvOL4m/kKwt9EgelRJEHep+ULBZBx/e1zjTglCKVClMeCQQVONGv43Yen4aG
	kUgX1V9Jj4YIQspKuaJP8FEi2cIv7w/GQC5/f0DWFeNpNpqj2qqjvtM5P1VW7k7efhudE+8BQpp
	6tnH91ShEEXvZb1TqH6eKCTBZGQYYkLXnzCGmg3CAbTIHyvOXT0gAyHJvNbJ36m2gYvUOM2/tyr
	zuYLZo6OnMdKzbm9EI/E7BrS2mGw9QON0lO
X-Received: by 2002:a17:902:fc8e:b0:2df:83ce:7271 with SMTP id d9443c01a7336-2dfa624aac2mr6638095ad.10.1790595374074;
        Mon, 28 Sep 2026 04:36:14 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9142bafesm39086245ad.51.2026.09.28.04.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 04:36:13 -0700 (PDT)
Date: Mon, 28 Sep 2026 11:36:05 +0000
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
Subject: Re: [PATCH v7 3/9] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Message-ID: <arpRJQHAKMKIcX-w@google.com>
References: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
 <3-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>

On Mon, Sep 21, 2026 at 08:55:11PM -0300, Jason Gunthorpe wrote:
> pgsize is a constant property of the domain, it is the base translation
> granule of the page table (4k, 16k, 64k) in log2.
> 
> Store it to the struct arm_smmu_domain based on how the page table was
> created.
> 
> Pass it around in the tlbi.
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
