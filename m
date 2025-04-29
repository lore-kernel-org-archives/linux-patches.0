Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654A1BE65
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 08:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745915482; cv=none; b=mvMNmCkSZeQWWKfaXIDZtYD3UNpTB6so0pl87hMxu06yoFsPCeCr4zLq2csR3aFzqjCG8lF55I2Ho/Ra585T7XUqsNccr8E0/GYNFHcDuSRlxx9ge8tMNYwWcrqyMDj4zVSeSdmkKLozuWN8q1rMW1HFJWEouzLuCQif4uNtnpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745915482; c=relaxed/simple;
	bh=85qKaVraS+9MNdskLBxSjS9ktFkx0yQSDGXvIR/OvQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZCm0NdlNzYnTsoKIEk7/M5q5M0Cvex3uXFk9SNviP13Csn09cXcHMbyYkk0HAfI5IYcQGsjtdYL7kLrLGNnTWo2Ik0EwegMbeyilODAaxm0EAEakG29UZAY1RyDM9mD6ifEwC9S4UOZOS6jKXpQ0uY1ZRHo8C3m0TZY2rqLXbi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W91+SkOd; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W91+SkOd"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2242ac37caeso52845ad.1
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 01:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745915481; x=1746520281; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TNi2KjTVYx94VsJLpl+aLzT0MDWDcyauEZBdUwqWejg=;
        b=W91+SkOdbR2MUsVqLwRksg24B+bUke7IWWq3mm7HFp3zB2UPRskJd6CUmPtq9JNyZz
         5Z1/l41w7n3sz4LxOmtC3YSLoLvdJjCGbDrXtra3vYuwncmOLJLpnyB+SV34nr2nnwwt
         IImlUeMFFkX55rS2JhKZoFBQeM2JQX8bEQwoeZ+05nENo2c6q1idpmWVByJvJV8IIhAD
         lIjZ5OAMiSafy3E9Iu9PyZEEbTIZgr+Q59ODVZ//ajD82e0VLGptZcwuP7EbhpZe6Aky
         ApnRuaUazzRSJXslym1l7pajlofZ9IXIEYqGOVqXAmS9IS3ZbdE1jQzcx6B5KsOLPfjM
         eYJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745915481; x=1746520281;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TNi2KjTVYx94VsJLpl+aLzT0MDWDcyauEZBdUwqWejg=;
        b=wyWA6g8nqi3cuulXgaxuYIirYzc6XjY/Mx5A1vphgv/GAW+5WIw8h7FX6e+tcUZIkf
         FZjrsnkKuFAm9/CVI9MabiK/Nl8SumZToQjgkvGBSXK8PraIZ7jUZeRu5ZPnQ4RXb4Ef
         ap/Fgdps7HLygVz3+30ILRXBSuEXhtHQzCL8D0ylNsWcdFXlKCat0AyfnWbjDyKc+f9n
         VbsG1X2YY6jsIBVmL2vY03UlQ/7TmINzm1T9wIpW3hiB1GYtkOfgbtfPLltBnqoFtyYz
         sM9GR3htHAdeG7X+Uo9vhR79BVdNjmOhLRcm0i7AhRcggDQChufN5ZKbLAFqr3W/J8pK
         kugg==
X-Forwarded-Encrypted: i=1; AJvYcCUaF8BKTYucCltChdloEMqZDDvv4Crjkacer2S5ThdMv5P8zPoQSbjQ0n7u83TgNQ3h+ok/pTaR@lists.linux.dev
X-Gm-Message-State: AOJu0YwCJYXZEcKqiNx1pAAvpvKetg80w7ZGGxxirhhlKS8vIC6I4enA
	12yX2TYCeAAIXaWK12yI8FEM29i1BfLsjsKkvzL8xr62dniO2aCbuRSfAp1ECQ==
X-Gm-Gg: ASbGnctEhjvvfJCGyYn18VzRuy7BxK3OFd3+s6X1UVosXDwMxzeNJESws4Xgg/xC/aK
	CKIKn62ubPBDzSx6d6Yz/OosU2y7kPwdVV/N+KbCQhZqo1G4R9SVmkQ9zqlt7oomVnMRFBluLxp
	Tg+tgA6djkGyQjl3r8j6ULKa964ZJ9OE+apXB3tEJQkDo+Yumc3AcbCl8cAytF7TzcE6ydcuW5d
	YJ2c6h2dH47E35fSzI6OA37wRTDdnzX4K/aQ9TpxiRr1+DORWoNno+H62uhWbcT8lIdSvTzNO/g
	BncfIbsuP6jjm5A62nGmagazSBQxKbkVdCFEwg3cP2GKIGLlNAPKTqYXxvv60w2JhLFEZgvG
X-Google-Smtp-Source: AGHT+IEuwEN6Vz0nl2aEx/jObUHE3H07L74jGS/5bsNXpJR+QacDK6nh9jI6VmQObGdH+OZv4saKuQ==
X-Received: by 2002:a17:903:1cd:b0:21f:465d:c588 with SMTP id d9443c01a7336-22de6c52c70mr2586365ad.14.1745915480493;
        Tue, 29 Apr 2025 01:31:20 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-309ef124ce9sm10440195a91.34.2025.04.29.01.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 01:31:19 -0700 (PDT)
Date: Tue, 29 Apr 2025 08:31:08 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
	thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
	shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
	peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 04/22] iommu: Add iommu_copy_struct_to_user helper
Message-ID: <aBCOTDDC8--age-V@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <ca032e90c0241fe0653023fcb655185dba763f5f.1745646960.git.nicolinc@nvidia.com>
 <aA-_5FQK0uZPdGVA@google.com>
 <aA/HN2CV+0UQ4S9j@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aA/HN2CV+0UQ4S9j@Asurada-Nvidia>

On Mon, Apr 28, 2025 at 11:21:43AM -0700, Nicolin Chen wrote:
> On Mon, Apr 28, 2025 at 05:50:28PM +0000, Pranjal Shrivastava wrote:
> > On Fri, Apr 25, 2025 at 10:57:59PM -0700, Nicolin Chen wrote:
> > > Similar to the iommu_copy_struct_from_user helper receiving data from the
> > > user space, add an iommu_copy_struct_to_user helper to report output data
> > > back to the user space data pointer.
> > > 
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > > ---
> > >  include/linux/iommu.h | 40 ++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 40 insertions(+)
> > > 
> > > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > > index ba7add27e9a0..634ff647888d 100644
> > > --- a/include/linux/iommu.h
> > > +++ b/include/linux/iommu.h
> > > @@ -562,6 +562,46 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
> > >  	return 0;
> > >  }
> > >  
> > > +/**
> > > + * __iommu_copy_struct_to_user - Report iommu driver specific user space data
> > > + * @dst_data: Pointer to a struct iommu_user_data for user space data location
> > > + * @src_data: Pointer to an iommu driver specific user data that is defined in
> > > + *            include/uapi/linux/iommufd.h
> > > + * @data_type: The data type of the @dst_data. Must match with @src_data.type
> > 								   ^
> > Nit: Must match with @dst_data type.
> 
> Oh, that's a copy-n-paste mistake. It should be:
>   * @data_type: The data type of the @src_data. Must match with @dst_data.type

Ack, yes that's what I meant!

> 
> Thanks!
> Nicolin

Thanks,
Praan
