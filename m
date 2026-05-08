Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDABF2F8EA6
	for <patches@lists.linux.dev>; Fri,  8 May 2026 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778260644; cv=none; b=LmYNBNn8OVfM3QO+txCMmHEiqnG5hb/UfWouQeGXwXuET593qNSqP5LpUkzs58gyaukd38kSfYfBc4UYRpt8yCXwQdp1tjihh/r4aIUM/REI9f2AzBAnARctq/3jW3XUMdqFTaiLlAXXlpK6jpYzHRh+iz2m+3YQyWvY0y6OiG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778260644; c=relaxed/simple;
	bh=QvqG1+1JxnbU/5V2L4JChPDrJZMs7pfUYqcMmN79wGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rdh0e9Tsv5Y0v82Ht/32d4kpSeRPys7iE3bg0ANSBFzTFsdFUYZ39T97qzKJlAKMwd8zxnB0n8DzJiY74AmcfMt4rWp99E2tFbPIndrdTYzP26cnkE/rbzBq1ShCOmqXVbdI8S/pPEwdWIkJfTvR9RBUwM/ntpYceutS6ES0Ry8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pBaHG8dT; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pBaHG8dT"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ba3b9bcf69so315ad.0
        for <patches@lists.linux.dev>; Fri, 08 May 2026 10:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778260642; x=1778865442; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TI7X52J6aApGzF9MwcE5Wp5s+0QmxzGTZI8IYa2JNaY=;
        b=pBaHG8dTJLGJ94M9DF/nhWGXR7zVEM3Brov5dkQ7svUhVB2mL3W8urHNTLaWvlSCQZ
         hX6q+P1HpmfxVbo08Cs/GjAslLrynj7gfq19EqE+UFAkgP8q9lYMoBhSLCXwbXak/8gK
         knTMtWPSFCBr/Iqowt8kHCrUbqjwmlFcgKbP3dTkGP6eWR37ZDeZ977QPo3wwdbUuyve
         T/lnYQlHfFGip9hB/Ou/tLATGQrvAiCmjnYAc/D2NlJcliO+qMJcDfJyHuh3GfJ6gLaT
         NL0j8qSStDPD5pgBIQXyd432x/M+NCATgtrZkx/xOF8Nnoch8KeON50Y085manoG3FOn
         BTvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778260642; x=1778865442;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TI7X52J6aApGzF9MwcE5Wp5s+0QmxzGTZI8IYa2JNaY=;
        b=AM4XjcQrpy/47A5Y6ObfOiillXacwvJMZ4psU/pSewXiEfT3eCIani3U7j50UdrRHA
         oiHiyylqlB6zXpz6AYA2DfQChqhNkkI3KJ/r3UFYAM5petVJ7VwSRXCQzAAgzAWxQvUG
         DAapvrrwaRZXER7XWIWyQDIiWvZ9iWsNyT/znYI2NYnE+/w6BM+5QjGxZp0CS4RGPcPi
         T4K5omaArTN0dv6tActSyHY3lXBD7+qcwWtZpw06/ARkEJRWOTDHr4u25OtkJETiCcny
         Kr4lorQTZa4nUGeLzYDjKLUZ6bvU+R01Or3afzOzwNDTVgCWyVmHQ0J+xc7sCj2gbDsC
         9B0g==
X-Forwarded-Encrypted: i=1; AFNElJ/CekTrhANYiCSx0yWzOHqMWqVhONNLtXix8y0iBYMrd8W/vXq5NTc6hE6wuNAK11rS22BkNvJS@lists.linux.dev
X-Gm-Message-State: AOJu0Ywm7n4hQKcpF8fCsbnw3xTw7/an1jS/NXB6//uqIXX8Lxrfx16f
	Ay83H4rFTgTXS1IFusURPcJXUeQJXwy0P9WXjpBVzmozz/m2/y2NQ6DgS+eVfOmpQg==
X-Gm-Gg: Acq92OFQ1HwMjpMgHvNwJEytKrBfqV6MpEZk+QdJPx7KGR7qoVNX+yfxsu3q7SGeRxG
	PEVBFPkaKyrBTOzzUcdvyjSc1zyEjErPpUkECS7aUb6jdybPrALLC1p6mtnulITZtHBaCr55HtE
	Kti03HMRS3rvIYR+OUF9azYqr9Kc71sgA0pS+c9vKoTBBSVGhkv/5oqKTbbKoD50hSjQGvyzpdc
	/y4VoJFloasc4u1vUsUnxpCDQcKFwLBO/Bat0shYpwUqMrU/41n7OaJUiuSgwC2S0/LxeCEahq5
	wYpxV1gbcAx8yxJ41R40lANVkqvQXiX3qHOBCBCvZwG8xMH9JRArOx8R7cSy/FtysbEZFWkW01W
	DIxtMyQTtNsx3MGF0tFsGMCq5qqZR3wAMwLpn3u/LqylegVGBMiNxHfZw+LumIe7dwCla9PoV+S
	s0O7kHQjcirVtOaqIfQawPWdLZmyXGuAYNLCG3TifhWNNjBSaDMEjIzmMGXqv4qBiA/qwB
X-Received: by 2002:a17:902:cecd:b0:2ae:45cc:aeb6 with SMTP id d9443c01a7336-2bc74753517mr64435ad.6.1778260641297;
        Fri, 08 May 2026 10:17:21 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367c2ccfbeasm311186a91.13.2026.05.08.10.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 10:17:20 -0700 (PDT)
Date: Fri, 8 May 2026 17:17:14 +0000
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
Message-ID: <af4amt7Pzmq-xpLf@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <5-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <af2w01YI01Av0Wg5@google.com>
 <20260508160236.GG9254@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508160236.GG9254@nvidia.com>

On Fri, May 08, 2026 at 01:02:36PM -0300, Jason Gunthorpe wrote:
> On Fri, May 08, 2026 at 09:45:55AM +0000, Pranjal Shrivastava wrote:
> > On Fri, May 01, 2026 at 11:29:14AM -0300, Jason Gunthorpe wrote:
> > > Nothing uses this, just dead code.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 3 ---
> > >  1 file changed, 3 deletions(-)
> > > 
> > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > index b3ef001ce80d23..ef0907b1a2204f 100644
> > > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > @@ -290,9 +290,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
> > >  		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
> > >  		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
> > >  		break;
> > > -	case CMDQ_OP_CFGI_CD_ALL:
> > > -		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
> > > -		break;
> > >  	case CMDQ_OP_CFGI_ALL:
> > >  		/* Cover the entire SID range */
> > >  		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
> > 
> > CMDQ_OP_CFGI_CD_ALL is also present in arm-smmu-v3-iommufd.c
> > I'm wondering if we should remove this from the iommufd.c file too?
> 
> > This op code seems to be unused since 5.15, if a guest is running the
> > same Linux driver, it will never generate this command anyway.
> 
> Yes
>  
> > Unless we care about Guest VMs running non-Linux OSes, 
> 
> We certainly do :)
> 
> And who knows, Linux might start using it someday!
> 
> Guest emulation has to cover all the commands a guest is allowed to
> execute, and that is what the iommufd code is doing.

Alright, it makes sense to keep it in iommufd fir diverse guests.
No further concerns.

Thanks,
Praan
