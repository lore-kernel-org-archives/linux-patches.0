Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421F92AEF5
	for <patches@lists.linux.dev>; Sat,  8 Nov 2025 00:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762561692; cv=none; b=qcSu+ddzzirdDBvOnIQN9Ri3zgqsNztCrRxqQ3jlt0x+u84a5Dbs+AStDECMtqCSzAtvZf3W0EVph3c1v3xVx6mt2wVrdailiZChjyz8Ailz3C6BUwfVedp6XkWkXxOYe0NHLaX923E7sqdLwSweMLbjFlU1KvHdrmJe22Lz7gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762561692; c=relaxed/simple;
	bh=xAjaHvMSmn7zlTOcpY7YxpGaPXDu9AQfS98dU4FaJHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sy5rVRZnJrvaetLuWmC98Nci9aQzp0TLKWeBtYR+vLThSvzwCVofItHF6y+JjxQbSrWIwAp1vJ1OjmZ2fXxyP2+EMAw1yq6nT785wRc+WaVxT8AtM2r6gs8hDIo53P+a5tBSTDyKQO10H6PPpaUyFPS1XBo+K6bXwlqMx8dDfHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NecZlZyK; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NecZlZyK"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-79af647cef2so1089751b3a.3
        for <patches@lists.linux.dev>; Fri, 07 Nov 2025 16:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762561690; x=1763166490; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vfGsS2MH5xd9qjAA7YCJrfBqaEDAdeU1QGJHQOuJbsg=;
        b=NecZlZyK6GPk1mJOfDTvI515XwPvskpLLXTh7I5rdEh40SMppu8Avqb/H3c51nS211
         mb2erGZRaiqgAGpkLbyBYyduz+yDiNnfOl3TEKAYhukcv/YCkcfDu1zsThQ8HOXIuMZ4
         9w6N2SSBsC70t3MFl7vUdht8YYHl6nBMK7jnyGSD3dQRsSW+IuaXZNj3RaPS9u0y8Bli
         10sinT2C/SGPw1A/QKEbDMBC5gXnaJMuszd+OsJY4hZaR3Sh3q+2O+/NcRFkluoNKywX
         Q7tIUbkXLHKnoRQISRtUHmLafXu8O74a+y/2z6Lmlbwk+My8HoALL1OWOaI5b0Jq1ayr
         nEKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762561690; x=1763166490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vfGsS2MH5xd9qjAA7YCJrfBqaEDAdeU1QGJHQOuJbsg=;
        b=uwR9g4jPV3HvHw0gP8cNaFsDNv4J4UtPUSXxsJ57Rwgas4IpRy8TJ26Le+oLIYW8BQ
         hlsrhbx3xnIiOzfElXEKnjMX+U1ljde2I99WZwfPx//HNGL8ppyDZBMsezkfmGZDakuM
         w8xlgX+/9TQXxUj99p9OKS0RZ/17MwMTjgtVqWujLm4/OnCRVntyTPl9bP6p29SxN5En
         87dQVMOlqerBqulz7W+55/qbSgDgf5JMJdbCK7reT8QRshOLldL86E3NLqThpeRY/KsY
         q3XS2V0kij+QtJIGUSHBSUuJxR+M21D1cakZJOYeB8HZ33zqB18C3x9yyml0upJs+JpB
         Lmww==
X-Forwarded-Encrypted: i=1; AJvYcCV9B4w/+3JSh+fdHgr4CveiRMM5OZ3MIULjayPBOj/APJ2JEAuUi0cocPAkjLb8qlfZXyM9hDkX@lists.linux.dev
X-Gm-Message-State: AOJu0YwQIm9CM7w/+aP6hf2ymBy/sDFrU9Gs/1hcEM3xCmvL/VpK18S2
	cYEbGayw/MaXeQwmUL/Q4+lYnNT51a4A5tAxXcaB5Pr3SAW4/OPsjAZ8MO74s1dvCA==
X-Gm-Gg: ASbGnculyHTJL4ovl8dVKcX7zPrhqdeDAF4PxfunNw+eziq+tWJTvIszku7EuoETkJz
	c686u0X+tePyItKAOTrgnyy0H5siKmblBr5ZvsLbDUt2FgHffKj8ksGgMXvchuv7WNGYjiyR6QY
	suknbUFylAWe+FDLCV59jSPwk5PMY8/KeODPmds7+NlihsA7TRmBWIAmZKmm7964QlhoG15yT3S
	z5qqKb8E1GtkzU/5INdKETioPdYem4f7PlnTC9Iw2j2aXnV+zxa3eE0GnZUnoKCqSIM17tLowLB
	/J1CA9uGOQ3Qi83l4pX9EV3sVlt+PsAEmZ5X9Ez2J7oTm5QXqIgXhInboTE/o9RcaBZKTIsmw9G
	pieKRHAZf0iW5MxJR4qgZt44AhyO02dT94F0aRtKC/s4NuDA+kDg2MeL2mstbQf4fzq1wexU9FC
	leNvqgxpU/NHBgQ2QPCGzZpEOgRQxduTKpMZocCbFM10rbxE6R9eeJ
X-Google-Smtp-Source: AGHT+IFUSovrDS+0WRVHBlbfPfLVHwv6BMRG+QTXHnDZ4UgWakNZf0zOP9bb4qcXnqDQvHke8MZjEg==
X-Received: by 2002:a05:6a00:2e08:b0:7ac:1444:6777 with SMTP id d2e1a72fcca58-7b225b8db54mr1368536b3a.12.1762561690242;
        Fri, 07 Nov 2025 16:28:10 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0c953d103sm4148113b3a.5.2025.11.07.16.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 16:28:09 -0800 (PST)
Date: Sat, 8 Nov 2025 00:28:04 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v3 00/10] Convert Intel VT-d to use the generic iommu
 page table
Message-ID: <aQ6OlHhq4TBM6sF8@google.com>
References: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>

On 2025-10-23 03:22 PM, Jason Gunthorpe wrote:
> Replace the VT-d iommu_domain implementation of the VT-d second stage and
> first stage page tables with the iommupt VTDSS and x86_64
> pagetables. x86_64 is shared with the AMD driver.
> 
> VT-d has HW that requires an incoherent page table walker, the majority of
> the patches are adding generic support for the required cache flushing to
> iommupt. This is modeled after the existing ARM64 version and is intended
> to be re-used there.
> 
> Applies on top of the AMD conversion:
>   https://patch.msgid.link/r/0-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/iommu_pt_vtd

I ran VFIO selftests against this series and did not detect any
regressions.

Notably, vfio_dma_mapping_test confirmed that this series did not
regress VFIO's or IOMMUFD's ability to map 2MB and 1GB HugeTLB pages
as 2MB and 1GB entries in the I/O page tables as expected.  And
vfio_pci_driver_test validates that a device (Intel DSA in this case)
can do DMA, and exercises I/O faulting handling.

Tested-by: David Matlack <dmatlack@google.com>
