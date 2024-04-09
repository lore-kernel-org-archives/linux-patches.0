Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75946158851
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 23:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712706957; cv=none; b=CtSiADxu/raz1WCeM3FVZQUJF6vXoHVUsfiJRkvuvKaWkbG6+ePLX6CIaaxPfEYNQPVaAlvLQGZEDZvv1wBrC18AyNF5XCZOAQsFg/lqWpI/FspvFSikU5Gw9tqLgx1tIJA5e6ClBDrVbcv1Xoh209DpZO6gY97BQZd73BuuC9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712706957; c=relaxed/simple;
	bh=321TzPyHJOoa7QwEruJfOZHt+XT8j4jg+EEfdfywmW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nWxyNUaIMVcUly3o2dTALga632N9f9ja7vDFzckfe9psFeJQ5no5Q1evdr2k9AfF17cLjRBFmYsCf4jNXsBggF/I5BHuMpGmaujlam+XEZ+Paj2iyXhWeW9j6nK7V/27YvFBAxVx1IM/zieR0rQrv3C5UqOcZxMKr7izUv+K7o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=OACxO0xY; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="OACxO0xY"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-479de65e08fso1367774137.1
        for <patches@lists.linux.dev>; Tue, 09 Apr 2024 16:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1712706955; x=1713311755; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xfUNEVtV0yx/ZQ+K5WxkeBL8109QuuNv0IDRponNoQ0=;
        b=OACxO0xYwU9QpuWfOvlzlL1hKTafWgrRuSphYWNZgvZassw6dCFpBQbQO3UHKJmRAK
         s+Phb+VfjT5yOCFC7CTPcZleicdAzRfNEKbvNmypCMbqMoU9rpFVrEtCLXijSOyfVBdg
         VF6MECwtIiYmL6x0Zqy1/9hkp3Wb9vn8pTYfXQdWDG7lzyMsCrPM63WkBA1wIIDCjRkg
         8dy//0zDMKpnJX/x68KAQNkjcbZZr1WbgDRdUispPJmK5N4jewFNOHowD8nAgJNwjFD6
         eAFKDM3EUVmgRWoVRsRHLJrIKsEkn1CxH+0CreHKL5Hak1/iE15vzc0NxGMZpshbZ3p9
         hL4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712706955; x=1713311755;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xfUNEVtV0yx/ZQ+K5WxkeBL8109QuuNv0IDRponNoQ0=;
        b=DTqX7kV4EptxagdiljWcNeN/7B4PYG/JOXuV8UqROEz230uHtbEnqAu5NGrRVTJUJV
         ySP4lYzTafPVJBV7CzetQ0GpSMuLBQ6IVoyEJnHYfkQc/VayN2McC0c/u4utTGvp6idI
         35C5ACv7y8pJWf/+cpEfhSMao0yfTn4t79pqJd8FASAlMylNnMcWCcpnzbukxkNKzTIh
         n011Cp49fIieZqd3YbClP0O+9B9twuOHyZKL8BXxrz26I9dNpIAz5yt/TB5oHJJkzdLF
         7lrxiHWw66IHf6UFjY6GljxHedITgvgctwsmxxIV8tlRr8N+0d9w3jIqO2I3txMEMxkg
         tSgA==
X-Forwarded-Encrypted: i=1; AJvYcCUAfVfvtqjFwwOLG3dnZqPw3vCxnUEmKBzs86scUaEJALgmRWa4b9ngDvpLLP19E35JU08d+XQEa9nRRzw4YF/oe141FfovbA==
X-Gm-Message-State: AOJu0YySmRd1EWJ+pK3UpP8s5upC+tIRj9RlLOrby0sNh8XlZ8fvkP93
	h2hVSBZFEQZ/Y3Nfp+tZa1uWoIEzXBdNIfasNPKByKl3gA54uCtPomENr5DF3ns=
X-Google-Smtp-Source: AGHT+IHCM+hZR8ArA2JpZ0mrLMCJxtFfNrlM1FvyYPtyphykyiqNIf3P1dO+1u2Sqb81u+sEchyXgQ==
X-Received: by 2002:a05:6102:3582:b0:47a:247c:f714 with SMTP id h2-20020a056102358200b0047a247cf714mr365854vsu.8.1712706955422;
        Tue, 09 Apr 2024 16:55:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id fo8-20020ad45f08000000b0069b1e2f3074sm2083947qvb.98.2024.04.09.16.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 16:55:54 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1ruLJi-007Gn1-9k;
	Tue, 09 Apr 2024 20:55:54 -0300
Date: Tue, 9 Apr 2024 20:55:54 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, catalin.marinas@arm.com,
	kernel-team@android.com, Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>, Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v6 00/29] Update SMMUv3 to the modern iommu API (part 2/3)
Message-ID: <20240409235554.GE223006@ziepe.ca>
References: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
 <171266271384.1465008.12517206202208996339.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171266271384.1465008.12517206202208996339.b4-ty@kernel.org>

On Tue, Apr 09, 2024 at 01:54:59PM +0100, Will Deacon wrote:
> On Wed, 27 Mar 2024 15:07:46 -0300, Jason Gunthorpe wrote:
> > Continuing the work of part 1 this focuses on the CD, PASID and SVA
> > components:
> > 
> >  - attach_dev failure does not change the HW configuration.
> > 
> >  - Full PASID API support including:
> >     - S1/SVA domains attached to PASIDs
> >     - IDENTITY/BLOCKED/S1 attached to RID
> >     - Change of the RID domain while PASIDs are attached
> > 
> > [...]
> 
> In the interests of making a dent (albeit a tiny one!) in this series
> while review is ongoing, I've picked up 3-5 as they look ready to go.

Great, thanks!

Jason
