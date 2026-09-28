Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4D7399CE9
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 18:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790621086; cv=none; b=FgnJlfCI8biGL81N0OyBLZde4FmP0zMzUQoZw5OodiUfGRdmKWYR4jnbEGKjHLE+aOJVeU8Zm5BLr4tbJLS+IZ9M98K9xCEI0/dYMyZGF+0qA6Un9uK4E7alLDLaeCFFrwhlXKbnL0FrqyHtNih228VzKigjIljr86WRwVn6pG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790621086; c=relaxed/simple;
	bh=fgZb1uyHuREpfJhcxIG+6xsb2Dd9OodLn5MW9pjjays=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qULkc2TFPbFWUruNvadDwmTdueMSsVVXpPV69RT2U45iTV95ejLivRG+jUcAYXdBPhyjPCzE/PUvxEgRCEwu8wVMJn/uLn7gwypSP37orerF1k894SJIjHToxEYFesXy03MdwTndigCzLxDq0+XlfW/agTk4hyZrEQLEI32jWeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LxCfNA++; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LxCfNA++"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2db33db4de9so9355ad.0
        for <patches@lists.linux.dev>; Mon, 28 Sep 2026 11:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790621083; x=1791225883; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fGyq3NjAgVBa/imXLuFDsnsoYGS7geOe1+K5qFW3IBY=;
        b=LxCfNA++EzZgxjljytVUtJ52Nnatfru0ZBA7IrCon1CMqxyzZGahL65RGHnNGAORsR
         fwPYotPSUx/+XEnMHRBMrCLzBIiq6c7h17M31mm7GZZM6ez7t/f5OYuk893Q70Imzl/n
         rwlE6pNbAZnEnIpmwdperQZeZwDHU6rb+6skgseX/5quHbLknOcUtfchOOo4azOF6FHZ
         0/C5MGbmWm++e8XzkaXnli0Pr9ntC+bFwGy7ZyFZTVj7Rz6dhoE8hLYKLyOi2+5SKRVa
         XKvS4mcgG+A7LWruaC2uFkhwC2X78z+mQt5fDs/VdE4nUPCZCC9pIs+mAi6aSP9T3Ygt
         BDfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790621083; x=1791225883;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fGyq3NjAgVBa/imXLuFDsnsoYGS7geOe1+K5qFW3IBY=;
        b=cUxGdUm1mz6jKeF6r24qutsk8Git57JxyMJBsjpNVhjyqEEdjA9gJ0gKVORYyLj2hR
         3nKvzg5cPK/8QNSDQSiQ58BjQpqwyrBZj3l3hm+5jrri6speTBRKe51m/zcYNCPcNTph
         1HMhHxpftodZJCh48ruyXflJ+NrESOIvvuo6sCYesXSsmPoGLq8Avmi54CJG1tOsVwyi
         Qt3KDklZ4YPCLx3QaL6HaMCe+e0Uo/0LZt+DwW9mzvd1FjvXHkXwq//zGj35RaLAgJYU
         +clDWsM1bytDM7DRBiqRe4eK87fWDFqJMFjzzszfT8pYekPl/Sc76SmA0W6+AZDey7X4
         ziKg==
X-Forwarded-Encrypted: i=1; AKwUvBzk6ffSMlgjvG62NoEg5GLbssFj0dT0zwyHcaaBFLCLk2cE2ccVfebUfhw7UUWjJyzVSwYI9pwd@lists.linux.dev
X-Gm-Message-State: AFq9FYJ6cqc+b//PPHvG908Z+bGHnt+2DTqCObWYLRPNHeyvW8gMdlpm
	ZVkRnC+JzAWIQdGEcbEiRmb4GmTw24sP9vSH0zZwMeXTrJnBEjutXcvxZwyakXKdQsQVgrd7uME
	MgqclSzivb1Q=
X-Gm-Gg: AYBFou18dUvxzHhCMmrEtx3m+n/EN9RswtpjlANsS4bBB0+0gZn5JEjs4vfJWc6CX5G
	Kk3GZogveyYkZ/JB8BDBbU93QXVPc74gFBws8SQSui0qbtQTvZ4960PJoEYVxepBu77jisJ/88J
	YoQTmRF9zBGoMAVXGBiDtITSFa2nSsZgGCvGn1v+MIGAxcodgSs0qoBHlEnbu9ZpCYH/Icuele6
	LNiHUE9IHgxro1Ex8yBjhmq90TC6HWTdvzxsEnFIEkNk6RkTLkGuJ4/0YLhzaWTnErQVV2O5ll7
	qFS2iWSOQN3Kap66pG/qAmR7hS/tVfeGELVVKmrXxOs+2eOCx9MCGGXQzgTbMuwDE5YbjmoHEa3
	iXTDQXUGRlgcN8g4P7nx/zJr8KCPA9349EAyzrpNI74GYNZJBH0cieaH77QVlwgoBMkhRpEkwJ8
	/ZqqvaapdeNafJLWK5boVNXTN0Q1DuzCXMEhQLI2zfUqHn724VbxWVlZe4HrihZhVCe4F57dBL6
	VqwhhSRrP3CqRYXV8+k4LLJkxpJN7JJC02K
X-Received: by 2002:a17:903:3a8b:b0:2cf:9ec1:ea6e with SMTP id d9443c01a7336-2e2c600c613mr90615ad.8.1790621082290;
        Mon, 28 Sep 2026 11:44:42 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4986a1910sm767152a91.14.2026.09.28.11.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 11:44:41 -0700 (PDT)
Date: Mon, 28 Sep 2026 18:44:34 +0000
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
Subject: Re: [PATCH v7 9/9] iommu/arm-smmu-v3: Support the DS expansion of
 range invalidation SCALE
Message-ID: <arq1kpVwCUO8xrh2@google.com>
References: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
 <9-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>

On Mon, Sep 21, 2026 at 08:55:17PM -0300, Jason Gunthorpe wrote:
> If DS is supported then SCALE can go up to 39. Compute a scale max that is
> compatible for the entire invs list.
> 
> Replace the has_range_inv in the invs list with a 0 range_inv_scale_max
> to mean range invalidation is unavailable.
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---

[...]
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1060,9 +1060,15 @@ static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
>  		invs->has_ats = true;
>  
>  	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
> -		invs->has_range_inv = true;
> +		unsigned int scale_max;
> +
>  		if (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)
>  			invs->has_full_cont_range_inv = true;
> +
> +		scale_max = (inv->smmu->features & ARM_SMMU_FEAT_DS) ? 39 : 31;
> +		if (!invs->range_inv_scale_max ||
> +		    scale_max < invs->range_inv_scale_max)
> +			invs->range_inv_scale_max = scale_max;

Nit: maybe a short comment here, e.g. "SCALE is 6 bits when
SMMU_IDR5.DS == 1, values above 39 are treated as 39 (H.a 4.4.1.1)"?

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
