Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74874D98EB
	for <patches@lists.linux.dev>; Wed, 13 May 2026 17:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778694153; cv=none; b=nh0CEJC9cRB4f9BzLKwJUd7I65eibRvXc5+lInr0NY0VboKx9nSdr7+pfGIKncwtTF7SLIfK6ppDGbJGmAh7i6cX0pGX3b5dE82qnaVk4jBXy1tnsUebhxX+qW+BSTggmTr/XQlM6wrjDhqzFZMD4fJ+qg/eV2b8UFuXEJZBG84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778694153; c=relaxed/simple;
	bh=Z4DQx2lSeg373FycVPY8LgB/ufohedZhPA83y4EaBOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVSV3OdAE9XF2Bq/K+y2xSaO89KYkO/LEU6KJg7nNVA98SvkNLWAaBKmP7xys3OgRiwY7qoUidKXdIQFcME8WdD81UMjiDu24L2MRQ9yGijF6v1OuUA4SQNmMPXXRh4/ZWxYUyAiO8AneQ3ex6stBudxGpmuWNl3eiND+I0gwR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nBqZDYlF; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nBqZDYlF"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ba3b9bcf69so505ad.0
        for <patches@lists.linux.dev>; Wed, 13 May 2026 10:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778694151; x=1779298951; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pcBA9DAGtJkPWnf5c2GL3hdpA6y9KY9keSOmEQ3FPfc=;
        b=nBqZDYlFyDJm8tYq2bqX75tLDhhGXjV1WgZeIzqbjFRm/Mu3oGZjiKvstoMN7bjHwe
         OS21eYMi6Bg9NmE6cLKXADxY8DloBfgQq19EKy5BhszyeiT5kAoo86OLRsEafoqDaxpF
         RB6C1X379BHZVnrRdx3HLUzaCR23zTQSYab+nLu5S5xzxkopecqEkuOOH5JTt2XdREdl
         8oz0MJAa8+mxU3UiBjcWdhpqmUDNg/TCGoaL8y0NHgRZV4BNniAUgkoKHTyIWTHMz5UX
         IBh8JNvAmK3amwZPW9Qhkdwksyz9ifdAwSK99aOZggl9MwZHk1IJc066S94D79RBLd59
         8mfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778694151; x=1779298951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pcBA9DAGtJkPWnf5c2GL3hdpA6y9KY9keSOmEQ3FPfc=;
        b=TCE0QGkQRHvOOy0XdaCO2nf2MeZ4TzZcPyY3UstcHeF/xOQFwbgKs4z4JWQqX7slnB
         31bjcYDquk16ZqlylImIdVBVnZ7tmIzdVG47SllrpOIlCcxdvu5s8ZuNGHuHV0QoUiVh
         ztMJc0a7z0sxsTFesegsr1IGX8BJKlTBdMl8rMznSSXJKPN1D8lHuU+oEcFHYtB1Elhf
         Ze5OIA0CjHdENpLJEeOc6DTDEZSNZ5fQhjUbKQTTO+kBm2typGD2gYefO1GIiwET7qPa
         Ok2EDJYDKQTfWhvGmub+kTC35f5uSG1YoPEICJ2vMrzn+HcHPFuu5zESyVC9XJnD66C2
         hI9A==
X-Forwarded-Encrypted: i=1; AFNElJ8N8JEfGoRtN2KyFx1gPw/T1Owq381Z1ME0lOj4G8Nfq5AoD5XIUQxvpj33Amvyd1diDE1DU3uG@lists.linux.dev
X-Gm-Message-State: AOJu0YxJ8zOj7g/D9ZvTl9vDKzFxsf2dr4qR/FfEF357pu3rHwt8tADc
	0KHUibxPQxtMmGhGHQx2dH6iPQh00Yq7D5xjD3xCzNt80VlRe8yN2UwcW0iFoT1JvQ==
X-Gm-Gg: Acq92OEmCuwsjpQyDN8QhlfTjzZZGBHdCDUGQrfaG4WlkYhbGUe9S0gm/1Z76qIAqcx
	jnF4i8EFTVAte+TcA4U/hpT8t0nn6QEveQoMM1w2730u3Ii2x31HXumYRMfe8lneahCMepL/U0D
	3WTg799O4Ryf8nB38gZgYMNKITQBK7UO6iKzCrshgu9HiHvhNbSEm4c0hrcjbmQv6ai7WB5uYEc
	TGWSJ1OSE2dNYEGogss/D6rJk+Oq8fOvluhzhFa9vEnfPcvRFvOoQ+eQikZNNHv0NZRSnU0cWGh
	v+rdF1dk6Je+AIMmsnCIMobYKls025FcxHS+8t8YVY8IodSBDxAYaqyNQD0XDUTzpVUy6hzJy7e
	btOA7Gttw7nPE5zzlfoZmbEauJuBGssJKLCep/8ssNcOWNMJIhU/T6jknobqVW393hRKBlp+g6l
	lES21fflJLMahz7NaGu/CLxPZRkDf410qdFVgMfHKRAPqgL0PXjbiupe0dAtbxgSx5UA+H
X-Received: by 2002:a17:903:3c2e:b0:2ba:3b89:c3a5 with SMTP id d9443c01a7336-2bd55e46765mr226415ad.12.1778694150405;
        Wed, 13 May 2026 10:42:30 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-369224d2f4csm151787a91.0.2026.05.13.10.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 10:42:29 -0700 (PDT)
Date: Wed, 13 May 2026 17:42:22 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Josua Mayer <josua@solid-run.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH rc 1/5] iommu: Fix loss of errno on map failure for
 classic ops
Message-ID: <agS3_gZOW3AjAAhL@google.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <1-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>

On Tue, May 12, 2026 at 01:46:13PM -0300, Jason Gunthorpe wrote:
> A typo, likely from a rebase, inverted the condition and caused
> errors to be lost. Fix it to be "if (ret)".
> 
> This was breaking iommu_create_device_direct_mappings() on drivers
> that don't use iommupt and don't fully set up their domain in
> alloc_pages() (i.e., SMMUv2). In this case the first call of
> iommu_create_device_direct_mappings() should fail due to the
> incompletely initialized domain. Since it wrongly returns success,
> the second call to iommu_create_device_direct_mappings() doesn't
> happen and IOMMU_RESV_DIRECT is never set up.
> 
> Cc: stable@vger.kernel.org
> Fixes: d6c65b0fd621 ("iommupt: Avoid rewalking during map")
> Reported-by: Josua Mayer <josua@solid-run.com>
> Closes: https://lore.kernel.org/all/321c2e57-6a17-4aef-ba42-d2ebd577e472@solid-run.com/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
