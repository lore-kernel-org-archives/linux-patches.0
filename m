Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7613C1996
	for <patches@lists.linux.dev>; Fri,  8 May 2026 09:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778233567; cv=none; b=j9zfeYlk9uu23bfgqvpXH5iX+cJUy6Kxz9Zqtw7gpmkHWj7Aw+bS9zWZbipoxJsVkbsLzg9S/jKSomqtHg3ub+W3vSLkkO8RkL8iC8NIGruF1mTE746i/Hb8AaiTg0ok6aorCY8KnoUmRuygboOpD4kl5/CEXJni6gOOuEWomvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778233567; c=relaxed/simple;
	bh=28WD+GanvSlqlE4kskyOHuvwJirkuIyfWK1K37ilNEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fJ/G0MBRLIBk5rxg0MBV5SKkxjHvCPod2A25u8bzDGxzPIVLdolu7f3ZbthWZFq5AoFeXSazdVFdeMmp2l5eh8Oq8d+nQLSvIp9oY2x9HwYkT8m8OZ+pKqC6Wh1Zz/jS+A9iKxdPRCo7p3zZeQKiQovqxQ65sR0AOKjRycto9Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PdNDSFlc; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PdNDSFlc"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso65825ad.0
        for <patches@lists.linux.dev>; Fri, 08 May 2026 02:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778233565; x=1778838365; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HALsDsAQa8BlgwZadqAF4txAKJki3KeCnTRDOv4wNSI=;
        b=PdNDSFlcLJXvfR1DoegDjYo/VzmDLOm67eOaUgsPCnda97uFzx3y6YPN/QMyC+SHMf
         v4mATxUHchsHoj0KUPqidFw/0vYpUcM7TZZHpQa+ciGUfi3FDOwBe1c2Kw2SSxfhxxM4
         IqlXw+b3ephxsrcJbCyKTtq2/t52xrkGmnLk0JzAOpiKcNpJvWsLBc4q2JvunqU68fxT
         LV2PIRze/OzIaDW7jUUxTmxgvx1fj4m0E5tbkN7Ml2//vC5cJaPjibmG75xrpw6dpEyx
         cuVd7rXXbL1QryrofXzCtH29+Ffj9tszNsksgzl7VfhN3UZBF3/EqkKmbIsmbxfMi4tK
         xbJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778233565; x=1778838365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HALsDsAQa8BlgwZadqAF4txAKJki3KeCnTRDOv4wNSI=;
        b=sbxUbPRmf5GLNckVleWEsjMafIVaJaxwUcRA386+65oUpq0AWIl4j029sHCmcEXBpX
         HUPpYd3fnpHhaITO48eCQuP7YvNg7hc/ba/XHubsYKMtdM5NSV/LDTTEXa/iRTS4zHij
         qV03HlQDPWlJINyJyAgH1xooDBoKOumkM4mwXKYUQ1TIo4vKLowBIo8ukkmZqcTByKD/
         0aGL1tEr9bSr6PaedtpJfcza82NopFPDO5zKXSVtni2aNC7eK74N5djFezWoSCE0IKaw
         oHcXRl8wRtyKR6PkI27DhKy8HgkAHPDslhvtUE9igsGnzVGVbjaBNiJMDupXrSrClFCT
         cqug==
X-Forwarded-Encrypted: i=1; AFNElJ/djbjcRXch5f8XiNvKTlsMqFdFd2SDwzeSogxiuoLJurvZ9lyjOWIoMatIO8whrbrsKkgLydY/@lists.linux.dev
X-Gm-Message-State: AOJu0YxjYj8gF69DeHlW/BGKaS+2h0ayDlDAX3xmw+4u4/ojnsXx99We
	U7yuS3H000jVJcVbTD1cKMV5yxP6jMYCbmqFGMiIaZ1ijhwjoNc5mRH988B8V9I8lA==
X-Gm-Gg: Acq92OGsXj6BRKnv9d9pOTX+4Sf8NuBowE/QpMwKmEVE6Ibn2LVxi3rodIizA19OwNQ
	Z5QXcr8/7h/JFM08d0tnuIlPygSrMLN2SZzbl/+bITiD9AvajJxrUtozf59DX4rRkIUwCBtfvna
	Q4kV4m4LSm9BR8D38gzqYLj7rleCgrdaRGJchhQmgnjx9JeBQm7j36XEpS//l4gqHQpQ2kEeW0M
	Jfo3qO3MXMh9ZmwxfrWGh6yj3ZFUE6JeT9wQG4CUOVyIZFTKZuWCP38nx0sTLdrIUWYAxJxu9wl
	oOTjBK7HjNE5kDUYlxR2ZEkPqs78/V6e5/0OCsBVYCpOzmnYNODOtlphQta4DdOM8SFHDbxF0CZ
	FFBASGhdvHBV/oejpWYYWNGlaOiQILnMtrVFzf/dkIXQmswzlsSRh5oyae4S4pOf0sXTZIehBX/
	uDCNd9h4ShL0qYjRBvc9WiYQ7kPKdPK87jTaySpCo3vtJonXq8ye89heqkqgjkFTGyfK8O
X-Received: by 2002:a17:902:e549:b0:2b7:b03d:9dce with SMTP id d9443c01a7336-2bae9e98dafmr2720055ad.18.1778233564632;
        Fri, 08 May 2026 02:46:04 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1eac6bcsm14904885ad.70.2026.05.08.02.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 02:46:04 -0700 (PDT)
Date: Fri, 8 May 2026 09:45:55 +0000
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
Subject: Re: [PATCH 5/9] iommu/arm-smmu-v3: Remove CMDQ_OP_CFGI_CD_ALL from
 arm_smmu_cmdq_build_cmd()
Message-ID: <af2w01YI01Av0Wg5@google.com>
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

CMDQ_OP_CFGI_CD_ALL is also present in arm-smmu-v3-iommufd.c
I'm wondering if we should remove this from the iommufd.c file too?

This op code seems to be unused since 5.15, if a guest is running the
same Linux driver, it will never generate this command anyway.

Unless we care about Guest VMs running non-Linux OSes, I think we should
be able to remove this from iommufd.c too.

For this change alone (preferably along with removal from iommufd.c):

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
