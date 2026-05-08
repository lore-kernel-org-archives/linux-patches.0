Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F1D3DDDDB
	for <patches@lists.linux.dev>; Fri,  8 May 2026 13:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778247696; cv=none; b=K13hb7PB7r0zL96AORkTG6r+sDsC/2TOOCMFRJzDVY0Lceb0zcvQQkC80n8f6EDDSYTfYWSh9BfXD+5qj/CNWzdkc6Zclj3S5hEpTkA4BEIGO/ITrjv7kvbNMnzlPqWjDXl1Hlk7ZZwDokgadEW94HR5xp8L59KAdXb47ejYXKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778247696; c=relaxed/simple;
	bh=znsTVaBtPyzPupvWVrvhRnQZJGVi5v1mDow9DWL5Osc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5E4k99YfGHmtnvYCekWh4jyMdoSbE1y48RNH8Z4+WZ6+1gamI4Qb2ThkEmva9/uiaHyCk8RzAr2OG+CCr1MkG4Y23Dkyv7plPF+Y1zqoCzWlxId57ECrQbsc/RUHqq2TXosbN+TtRu2H8Wvooq4VEJ6ywftjzA8IFYuJ13KcZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=knerfWdF; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="knerfWdF"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso85655ad.0
        for <patches@lists.linux.dev>; Fri, 08 May 2026 06:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778247695; x=1778852495; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kn3HnEGpfsinsQczYQb+6skEifl1bNdoE4T6rMB6rKk=;
        b=knerfWdFEhJbMuV0qSxS82RRawCW/zse1ajNQL4bIAxU+pZITXenf3gHfCDHUa5WGA
         vSx8n6F9L3HFWRLsr+MpyIpnZmpV2MZfB0HoH7XCSiAML+FavLhyiSITXKqfdvvvut9a
         NFYEbYe/tHjf8mvX+A+6aeKRvJoGt3arRf/A564UOAv0N+VyGZJc2NEY2lDaoEiFC1l+
         YIm7ZB4b43nAv0/DSpvg2QxX+VAbEGWzDHXO21juAgRdm6FNON+co58DLLVGknoI+Gbg
         2vOraOw4QJgraxM2bFQspd79CV63qFCNImlcx6msj8w9uGksObo3JthifIskyC6f1woj
         4OtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778247695; x=1778852495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kn3HnEGpfsinsQczYQb+6skEifl1bNdoE4T6rMB6rKk=;
        b=htpPZXWk+nhxz4bS0pfBXE2OXU52HI5cMe/vz0P6TXROCmiqi+1aM1hF/6I/8kdpdO
         hOtBBMSQt8awfTzEwarGPY8F41T2QxYmgA75BTlRiqg/nQgtMKVZmA6DCh3/5IYYgEoZ
         xqZzoU3rBTgnLIRsVGJD9BWeNDrCEYp5DlHMJ9XI8lKRAfEPL8iUmYaFjtJEU45xbLrM
         QbD2JorAsoS3Tg6KCvzJveQ2R3uuVFHRfxg9fNHq5ykDslsUCxKlV3zpzXpCg255ncZR
         5THQFD91dg4VDImrrxEQNO3YQONLs1GRhxq8VSWs9MvHv6n68PCMaGNkXWt+3KDT3si4
         v77w==
X-Forwarded-Encrypted: i=1; AFNElJ9tiSESMFjLtvcXkHsK0bvjj9AXP9JEl9v+HHrmOR9/ldSTL/k6P/wmD2H5j6P4c9YTmYo/grIj@lists.linux.dev
X-Gm-Message-State: AOJu0Yzcqo2fmkrD3puP23cZxgGHZK0rJOBFZ47TKRyHRZLa0bna0Cs6
	ubEHcUFdACG9P4MsCGBdcsiE521XAa9tkM7dQAyrxcG4egLFB0H3V7WNJS6nDWA+xQ==
X-Gm-Gg: Acq92OHdf6QqYcNmmgtULiumhO3O5yfk8jq+auN6xsbfJOj1Y3+9wawZ46UdgTzDYvg
	l247hoycrYHvoLGt4+Se1svhJrtlkHdLid6HO4z7pNC9qSVBkaz6JAUTRMycatN1wIccv534UJR
	qPw1FS2ziEXlPsnNOcDh/zn+BsChmfHgVGzYNFolsXN81Cw2WqkyucWs8UeKxK1+c+E7NJGDIwL
	Xc4QbwWir4hRytu3gVs2rHpPCLDqnZe94L3zmfbrC6C04KR7sjt6bD4cKIKW7wF6kcxpgwDNY8t
	zkT+5TplRSTQXyo5Z6lD1OxC2ITi5LJCg1OignrlK2G7IOlsnl1j0JUNFO8UnidF0/ZH8dToAmP
	MfHowbjPhsYZN65eLhWO+DUMKBXuCdtOh0DtQtyl0fpUe7N0FKsijeIXkTHHF9PMEFL+zZZ0Fzp
	qfP8ymZl0OhMVnzGK8MJJu9/9dMGbK1dH7IOAwSEdNT26YBZhESDdWuvViVAW92BPviEJh
X-Received: by 2002:a17:903:198b:b0:2b4:6529:7bae with SMTP id d9443c01a7336-2baee842030mr2436805ad.17.1778247694198;
        Fri, 08 May 2026 06:41:34 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3664da1f5d6sm2479705a91.3.2026.05.08.06.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 06:41:33 -0700 (PDT)
Date: Fri, 8 May 2026 13:41:27 +0000
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
Subject: Re: [PATCH 8/9] iommu/arm-smmu-v3: Directly encode CMDQ_OP_SYNC
Message-ID: <af3oB0efZjr7HZi9@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <8-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>

On Fri, May 01, 2026 at 11:29:17AM -0300, Jason Gunthorpe wrote:
> Change the flow so the caller controls the CS field and remove the
> weird u64p_replace_bits() thing to override it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
