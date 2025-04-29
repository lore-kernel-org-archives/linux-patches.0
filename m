Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75461F4736
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 18:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745953064; cv=none; b=N3fgY6zVm10UrmkLYnTAacLil6H9oVh6GjF3cKAtdLO2t3QkZxVgbMFtiYYyFvTQvDrQ0fKN3OFgKRSp8/pl/RFKjNU43GtFTzfFjyKsgmAizqsFvTzaH+3VDTI8YXa8Bnb9Wci2XV+aA0+D+f7CP3SSOVbGhIQrkyA/8qItAMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745953064; c=relaxed/simple;
	bh=neW8JICaEEWUIk+9rBwbn5iIXjtiSl0sUhd8RTSSX8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bEnG5OTA3XjZQyPYxKD0A9xR44bTdNlZxFaVc0Nd9v9xaFmFiRVEqOp/lh/0mjUPhfgfT7H/1OsktcZXUa4hGLgyq580cVAeJweBfNrCb0S8OI2Cx2h21xjT8LiNq/caWE+HogV6n2c2iyQlBhNgs4fWPkPJm/Vlh5kDI5KUxjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TCoYvwXF; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TCoYvwXF"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2242ac37caeso53785ad.1
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 11:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745953062; x=1746557862; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fdXV/8C/yQUJ8I+wtd2Z/G5iaXapJqIY6nj11Km1s7M=;
        b=TCoYvwXFmxXPT+ficSgwU2vV3w7Lqfopg4u9YDmQ7zoDdcKaRfrlqZ5bZgqxf4lxTl
         +QfgV6R8uryU1lR8KpqmM2tlK14sEpxbsjKKA1kf2UnzyZQxgrJIGkg8y1vsiTrHwWiS
         uJlzKPT8PFePNRxL8Q2RSi1XhMfXuJrlrbNW8lVBoejgCdnqJ9JDSXbgiLbhbj4lg5Js
         5/Xwr9fpCMdcW+NRcvDH3oiu0elZoMNw7CwhiVly6r2vXyVwlLmtfTkybIWd/TCht4e0
         OSLCJPlPvEO1nNcnn8AsHpppIowHAIf+zlP4iCWTVgnBpOupURaMlL8rHjN5PVRaPJ9T
         iXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745953062; x=1746557862;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdXV/8C/yQUJ8I+wtd2Z/G5iaXapJqIY6nj11Km1s7M=;
        b=tabJp5BQQU7qusQ+wOoBHndvApssOKE6Xk9fOGA6M2Ygcz/FS01poiOKsNeE8Mzo3U
         dwHWbJe7sR44w/fd9M4AukR12jP/x/ByHiPvDSusqv/jA9Ll0E03yI0BrZKg/tCCosVA
         7sVTW7PcfOA86Q+qnhwzZpQvKCgsec8EUoHqaJHv/6UqtLtw0yeSb0MRZcEZbqaM/LHf
         bXYEoMZXhgxCZPRxnK65WtFgxx6PC5KrpruLCz9T3wXtQQGl5DdtePJDjbjnH4waXWOX
         bZHli2Y6Cm9odArYBV2yGO9eVsyOx5oVPV1TLIK23XlDbrlXtZD5gK4DPEUWVAIgw/LR
         gE7w==
X-Forwarded-Encrypted: i=1; AJvYcCUT8i+SFXs4eC4pIxQ+AIVTT0LNs8aggmeCJZ20bdRKoSf8UUiOe7DDrq3GzWwg5m1rcBIo1CmS@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7gteZJZpu/2K1iiYRVD99JExn4L3MqEpwZqpx+xdL7LdG65K8
	8uDtZ05BGAr2LaYVpASk017ZGw8lWihGXIvM2tZP7cHBK+/vg7MMSCVL31XfAA==
X-Gm-Gg: ASbGncuLBOncGWjvmvo9HqjNPYOjhWkpH8+SNnfJZESk9Enzie5a7YMGKDZ7NFmG081
	M00Vi2RMnalSHa2xTr0SvvG++Y+mp3gC9wHQI4PYirVvoE6YEN80TrARNUq5Ljm2/u6eZhUmICh
	OXkECQPuh3huFun5XbNJ/8086Vw32pQRGdzO217evxHAfmzD0qwcGJOp5qN4ugsvYMq67eZiv5W
	4a5V8L7xNh35cExcRACP6VSoBqaHTGyo0OXhIC6c6Pl0xQ4STWgbFl3RURx/7u4slbBfV/67VES
	nf1xk9dIU1beSApNZ+Z5SlaFMEmKIncYHc9iS0X3zCRtJrL0jdYuE2SP1p79c/3ToW9yThUZ
X-Google-Smtp-Source: AGHT+IGgXGpqrHCfuif7QcKDzCUp9vTefuXFD3aLx4LdLjCaDTVmYgt+1uOwojrpCvF02XNkiYlVaw==
X-Received: by 2002:a17:903:248:b0:215:7ced:9d66 with SMTP id d9443c01a7336-22df3f77b8cmr333515ad.10.1745953061819;
        Tue, 29 Apr 2025 11:57:41 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-309ef097e0csm11594174a91.25.2025.04.29.11.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 11:57:41 -0700 (PDT)
Date: Tue, 29 Apr 2025 18:57:30 +0000
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
Subject: Re: [PATCH v2 10/22] iommufd/viommmu: Add IOMMUFD_CMD_VCMDQ_ALLOC
 ioctl
Message-ID: <aBEhGmoh0E865PxF@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <094992b874190ffdcf6012104b419c8649b5e4b4.1745646960.git.nicolinc@nvidia.com>
 <aA_0TV0RkVOHk7Qj@google.com>
 <aBAEuP9962XweHPc@Asurada-Nvidia>
 <aBCNkcLp6XZpjYYT@google.com>
 <aBEWFw2wq40SHjTn@google.com>
 <aBEXJFnLalIh788i@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBEXJFnLalIh788i@Asurada-Nvidia>

On Tue, Apr 29, 2025 at 11:15:00AM -0700, Nicolin Chen wrote:
> On Tue, Apr 29, 2025 at 06:10:31PM +0000, Pranjal Shrivastava wrote:
> > On Tue, Apr 29, 2025 at 08:28:01AM +0000, Pranjal Shrivastava wrote:
> > > On Mon, Apr 28, 2025 at 03:44:08PM -0700, Nicolin Chen wrote:
> > > > On Mon, Apr 28, 2025 at 09:34:05PM +0000, Pranjal Shrivastava wrote:
> > > > > On Fri, Apr 25, 2025 at 10:58:05PM -0700, Nicolin Chen wrote:
> > > [...] 
> > > > > IIUC, one vintf can have multiple lvcmdqs and looking at the series
> > > > > it looks like the vcmdq_alloc allocates a single lvcmdq. Is the plan to
> > > > > dedicate one lvcmdq to per VM? Which means VMs can share a vintf?
> > > > 
> > > > VINTF is a vSMMU instance per SMMU. Each VINTF can have multiple
> > > > LVCMDQs. Each vCMDQ is allocated per IOMMUFD_CMD_VCMDQ_ALLOC. In
> > > > other word, VM can issue multiple IOMMUFD_CMD_VCMDQ_ALLOC calls
> > > > for each VTINF/vSMMU.
> > > > 
> > > 
> > > Ack. I'm just wondering why would a single VM want more than one vCMDQ
> > > per vSMMU?
> > > [...]
> > 
> > I guess the only thing on this patch from me was to understand why
> > would a single VM want more than one vCMDQ per vSMMU? (Just curious to
> > know :) )
> 
> It gives some perf gain since it has two portals to fill commands.

Ohh! I'm imagining concurrent invalidations / commands! Interesting!

> 
> Nicolin

Thanks!
Praan
