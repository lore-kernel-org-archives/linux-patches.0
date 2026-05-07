Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6D1370D5A
	for <patches@lists.linux.dev>; Thu,  7 May 2026 09:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778145750; cv=none; b=VJFyUwOHlU1yjsYI4XKzqnhG3/N7MI15bZE8lCZIEPZCBvKBKUkYLSongzZRkMdzkuApc2Ulor232FqT7TTmtEhPMvq06CzFxW9g54l8SenOxl6ltr4waj2C7i8MxuxFFrQ1BlmUGOX1RJVzLzofWOBT5qfGQk3+sO3w+9ma8JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778145750; c=relaxed/simple;
	bh=uce/fcdpqFl+5MjxJYMw8zKWV5w0xDAP2ZjzMhxpH6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lSZPXjdoZfY6E51kXgok+ywgsVmDwPHHLdcMq/HSVO5ybZLPW5pZL0d9xPsR0LmE6xd4vJ9Br6vymvMm5QSTaghea6YqrSHHuOiwGq1Uju70EO0a0jbd8+O5gIRN6sAvFt1VV4eNnMymly7Q45yi3V4oFISG2hRwDyU7/TWjaXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fg53XLus; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fg53XLus"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48d1c670255so77825e9.0
        for <patches@lists.linux.dev>; Thu, 07 May 2026 02:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778145746; x=1778750546; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ns8GiU7JpBrxm2tCxgyo0Vrbr/2PTrgnrkNgo2RuOyk=;
        b=fg53XLus2yo8HQFrVII6GiaHdcRDhP6xjGnR7EYO1xfTOqa2Fl5iI7ogPp1nSmFqcH
         4viq4dTzZTGi83RZa6DvMt6hi2uHd48l3d9oGKQM9bB92tC12g99Bm4tADRg8uuWtCTv
         Ps1BOBWdPAKxlX4jaMb0W6CgBdo440xZ2eQy5eLFch871P1aC/QY8x6sS/TdbPFhEnHd
         mOzsjPG/cqXD3ZTyESc5UqHwKoCQ2vYX39zU/DmLbmD5aUy/VkKC9DjItKxxE78aZHvu
         fGE4zeF8wAeZK8DtveH9cTFuk1DpWlox/Y8As7i397p9wMOul/c8dNumIU8hsbCWlwAs
         dZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778145746; x=1778750546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ns8GiU7JpBrxm2tCxgyo0Vrbr/2PTrgnrkNgo2RuOyk=;
        b=tEu+ulZlaUX3/Ae52L2WyXh7HduRk/ECsymgXbMrn+1b76y3xz2NI7yo89A9xjcwrW
         vP6PbitFD/dMO08AtjtmmgrGmtCoCYIkRZpcO+YOLeYY5nh6GtoK+xds1x+x7+7C9iAc
         FELOjMCYDCStEoBIn5bcliO/ueANKXswQ4U3++gcuup1ECU2gmKlyDQ9foDkdDh91H99
         L8q5IIQuryutolvMzFhKY9VUOdPpnZD/HVUQbRLDsSPQReVHAZX65HsUrClwZhS9O+P7
         2CE30+rCbIbUESTXW1CrnldPXc5KB0u5Tr5amWGxLapuv9z1LFEbTFdadVeDAl3URe2x
         PjcA==
X-Forwarded-Encrypted: i=1; AFNElJ8folj4wSwbkOstHNWys0zXzn7hOqDeMnygcj0s0Ia3rqGb0B6oC8JBWaU8rY2N3EwUYzU1E7cj@lists.linux.dev
X-Gm-Message-State: AOJu0YwSmDLSLSnVGyV6HgaEk290bKNnJOsYRMbRmyGBprHjO/4GrF3r
	38UXOIRCRPBpCIH4hEfrb9LJcIi3Hd0T//7rkjTfPV8u4ju192LpNQPg9nOjniQv3w==
X-Gm-Gg: AeBDieu+CL6qH6B+9mTc4rt/raL36UPzUwaOgBzAQ9Min3/eMiAZzNiYpQZkVrdjHXd
	yIDuJFnxeaXUciXGpu5n1IVrSd63Z3+hw+hetSXz/D/HZIOdJemF+JzRM794GB0Rrn8oO5NxhkX
	eGQHndJe0jUH+DofyVnjq/bNMFzrV2fjRmYefzi3Bb3VeB5t/gevMq9j8/NRLchNa6ECisCjkLY
	mMJT1aE2M/aAzxaIA6+n514LHXY0RRc6z4M76I6BD9jyST88sGvS/F+RxtLq4oNeraFbm4WEjvy
	av85DwuwtVV9DmBTxw5S1BQEXFYxHk8p87e6BY2HoyCrID3KQ/MO4044uZLVmaRvy+zHjQ4EIhk
	OiYdz2nlXrV5XevCNse/N4ipwAeCYRbDfySUeClVc0iq19z472ADNsB4mQ43z2JeJ2FyXuvKoVw
	B3LHFRz75hXSUOs/3P7Ns98knFhAq4d8xwxllG0Kq3ZVRdpAyQqvki4kfj6sxcnQnDpnwDpz1Dk
	LDjYw==
X-Received: by 2002:a05:600c:6c08:b0:48a:6321:87f7 with SMTP id 5b1f17b1804b1-48e5d64c0dcmr657235e9.8.1778145746114;
        Thu, 07 May 2026 02:22:26 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e538aaa0fsm135407645e9.7.2026.05.07.02.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 02:22:25 -0700 (PDT)
Date: Thu, 7 May 2026 09:22:21 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH 5/9] iommu/arm-smmu-v3: Remove CMDQ_OP_CFGI_CD_ALL from
 arm_smmu_cmdq_build_cmd()
Message-ID: <afxZzd7s2SobJwW7@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <5-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>

On Fri, May 01, 2026 at 11:29:14AM -0300, Jason Gunthorpe wrote:
> Nothing uses this, just dead code.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index b3ef001ce80d23..ef0907b1a2204f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -290,9 +290,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
>  		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
>  		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
>  		break;
> -	case CMDQ_OP_CFGI_CD_ALL:
> -		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
> -		break;
>  	case CMDQ_OP_CFGI_ALL:
>  		/* Cover the entire SID range */
>  		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
> -- 
> 2.43.0
> 
