Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628E82512E8
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 18:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745952264; cv=none; b=Gajx4qOY0NGESBeXJJvFmiXXiKeYsA13LbsvZ1va+qNNhHgPZx2yYZeidO6ofF/ZlSCrEmz2V1cOHwf08si58gnjpCtyT+YoNNzmgJ6TSknW2npCxHqauzeOkvlRk3NpGvfwcGYkUiO+36zCcqmGOaLAJH9BF+0ULMy8T03aAXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745952264; c=relaxed/simple;
	bh=Yd+fxjsRydFKjO90TX3Imy2H/CCh7glVFS4yzzIbM64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cv0upAuBcMKRtxC2H5x99nWZC/IupMC3NdQ33KZKpc7e8bWQw12eo5wCXyts5/F72N7vyjUP1QdoSX7lo42Do1F7RdyaFwdxfX8LsCVnVLo8TcJHZ7oqQiL4OLRV73+Ez81mbop9XDlFOfzmyKpIndJnQbKzY666WZ9eoIDYlTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KpXSgJ2w; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KpXSgJ2w"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2242ac37caeso50825ad.1
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 11:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745952262; x=1746557062; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RbAOOUKsalrnyJTM4wor6y5G5I8sKroNDDc7YCgeN4g=;
        b=KpXSgJ2wBMMuZhsBLC1F4MEZbm8JVf3Fg+qqIxgi0k53uihpl9dyuSjkgMvbk/nv24
         kHsh/CElnm/AoncdRYqyEfWqfn+6BzKUUvSjzl+vLhohlNnjuJk0Mk9CQ9ViBBQ8nMik
         FnOn1NJNBIWcjtn5wp7SkZGJH9OzYgBx/Qa+g8NUF9GFDIvMTgAD3fbHyfgs5ztgjjzS
         P7U52WdQRJ8NHoHrWgLBcRh2svwtpFjOhCnFMzA2j9x9Nwgx9ULyYS5H+iizQ1J2e4YP
         uLWcVyz5MHBwJ08cp63tULxoUV9c8bbQX00DOsXjafUkeMlnQfPDr2XeYCIMXKCMYHGz
         Tp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745952262; x=1746557062;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RbAOOUKsalrnyJTM4wor6y5G5I8sKroNDDc7YCgeN4g=;
        b=bN3frahZrolhbOrFxZwQcM/xp0y5I8ujJtyY3z6OBZguCzxLgMbP7RIPJkRqqlbA6b
         jj3S0a97Oue5r97QJVC3+7GZ9vOz09QCxu/PQFI2f15L2zg+cyQ9eB3EeVapM4KaQNbg
         otJdPyKoyrxTFMBW4zFpBHZe3wR8PQlJe/JbnV8ycxvkwrluBry19U60CmDEl8fXWM/F
         sJRhgxYFPd0YT1mJT/kTk6s/X1Poi61aszjDKDvqPdVu8iGteDgxzXpnizcfGTk2WKNm
         Hl4+xm1CKTdr1Pw9/xWM9UC6SnNS3KjUe48lKapLeYrXdOw4e7NIuxrr4E+y620QcCFG
         zPmw==
X-Forwarded-Encrypted: i=1; AJvYcCUL9wYnZvhN7yBFOMXBtOy7IL5JiNPs4jwdZiPS8uCnLFZTN5NODsmOGIjQD2ZsDwg3X1SHIUQM@lists.linux.dev
X-Gm-Message-State: AOJu0YwbnqQ14LVzzRi+6eom94a/2qAj9tyVqFLKu3B+a9hXxkgoa9MW
	jRb3sTZ3Zn23zfD1O5jxecx93NF1KnyrISWIP347ITIYMvf1/c9i8O/jHXffyw==
X-Gm-Gg: ASbGncvDjTXwwB/k0WrZkStajjd9DSZjM33roamkm5EDLujRVxsusR3OtgOI3avBf6w
	JoVHTBIZJna1LDQoVeM4YtmbB6zHi0zdKi7NtZrZyV6HAxL2T7H+SnZ9E4heFZpsm8RHkarFA3h
	lhaTmCFfGudVYIjZiJkc0u/7YkVtEmw9/aef9gyHBfpT/YLp1tgNHvgpebhCL5F2nSJM5sbKg56
	3DwWsfl19ECZt45EJ94ctctTCj3StskaXRTRZrvHV9L9l3dmNxbBzplI36ZRINOuHQeMEy/iNvI
	Lw9fbpda/mMJaSVz1zAtjYlxBcfnzoTZNgOXlUf+PIxyZfE3Vmxmb+OuX7C9ibFZoK591MOF
X-Google-Smtp-Source: AGHT+IHAAAZnrzfCTnyRFSrfgzM7EUKVTFf0g+y/q4rYabIT5b7Fav3BwFROBr2u073eUGpUmQ9SUw==
X-Received: by 2002:a17:902:d2ca:b0:216:21cb:2e14 with SMTP id d9443c01a7336-22df41fb4admr245055ad.21.1745952261334;
        Tue, 29 Apr 2025 11:44:21 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740399415bcsm362b3a.73.2025.04.29.11.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 11:44:20 -0700 (PDT)
Date: Tue, 29 Apr 2025 18:44:10 +0000
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
Subject: Re: [PATCH v2 11/22] iommufd: Add for-driver helpers
 iommufd_vcmdq_depend/undepend()
Message-ID: <aBEd-kacX84dkUuf@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <a25c9454c17663f9e79b37bc2908bf3a99856be6.1745646960.git.nicolinc@nvidia.com>
 <aBDIpz7w8wxIn_AF@google.com>
 <aBEIBKdjuecVHgpU@Asurada-Nvidia>
 <aBEThP2Bn0YDgXfu@google.com>
 <aBEVboMt0OtZmt4Y@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBEVboMt0OtZmt4Y@Asurada-Nvidia>

On Tue, Apr 29, 2025 at 11:07:42AM -0700, Nicolin Chen wrote:
> On Tue, Apr 29, 2025 at 05:59:32PM +0000, Pranjal Shrivastava wrote:
> > On Tue, Apr 29, 2025 at 10:10:28AM -0700, Nicolin Chen wrote:
> > > On Tue, Apr 29, 2025 at 12:40:07PM +0000, Pranjal Shrivastava wrote:
> > > > On Fri, Apr 25, 2025 at 10:58:06PM -0700, Nicolin Chen wrote:
> > > > >  /* Caller should xa_lock(&viommu->vdevs) to protect the return value */
> > > > >  struct device *iommufd_viommu_find_dev(struct iommufd_viommu *viommu,
> > > > >  				       unsigned long vdev_id)
> > > > 
> > > > If I'm getting this right, I think we are setting up dependencies like:
> > > > vcmdq[2] -> vcmdq[1] -> vcmdq[0] based on refcounts of each object,
> > > > which ensures that the unmaps happen in descending order..
> > > 
> > > Yes.
> > > 
> > > > If that's right, Is it fair to have iommufd_vcmdq_depend/undepend in the
> > > > core code itself? Since it's a driver-level limitation, I think we
> > > > should just have iommufd_object_depend/undepend in the core code and the
> > > > iommufd_vcmdq_depend/undepend can move into the CMDQV driver?
> > > 
> > > The moment we added iommufd_object_depend/undepend, we already had
> > > a blur boundary here since we had no choice to handle in the driver
> > > but to ask core for help.
> > > 
> > > The iommufd_vcmdq_depend/undepend is just a pair of macros to help
> > > validating the structure inputs that are core defined. It is quite
> > > fair to put next to the raw functions. I also had the notes on top
> > > of the raw functions suggesting callers to use the macros instead.
> > > 
> > 
> > Well, yes.. in that case let's call the macros something else? The
> > current names suggest that the macros only setup dependencies for vcmdq
> > and not any "two sibling structures created by one of the allocators
> > above" as mentioned by the note. Maybe we could rename the macro to
> > something like: `iommufd_container_obj_depend`?
> 
> That's the intention of the macros: to validate vCMDQ structure
> and help covert a driver-defined vcmdq structure to the required
> core field, as we only have vCMDQ objects using them.
> 
> If we have use case for other objects in the future, we should
> add another iommufd_vxxxx_depend/undepend macros.

Thanks for clarifying the rationale behind the VCMDQ-specific naming.

On the point of needing new iommufd_vxxxx_depend macros for future
object types, I don't think that would be required because the current
static_asserts within these macros validate the container->member.obj
embedding pattern, not the struct type of the container itself which
makes the macro logic inherently reusable for any other object type 
that adopts the same embedding.

However, if there's  a strong preference against making it generic,
I don't have any issues since we only use it for vCMDQs right now.

My main point was to keep the core code seem generic to aid other
implementations in the future... today NVIDIA has CMDQV, tomorrow maybe
someone else would have something for vdevice or something. Anyway, I
don't feel strongly about this. Just trying to help :)

> 
> Nicolin

Thanks,
Praan

