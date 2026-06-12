Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8882838E113
	for <patches@lists.linux.dev>; Fri, 12 Jun 2026 12:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781267279; cv=none; b=dZXILBDv/8nCdLcW5tOTzkV4ED+aQUYt5ITAnh4DtmG/bKz0Wip3IdSk6c2q/oqppxCspJRfydzqFL2ToTo0VDtpYkllBYenb4RIsl+i5vd5OcymgdgC/y/1IBi+uYhAjTgLEnB65UYShX0f3Wkcfnw7XXdGYAmypggfMFkxYC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781267279; c=relaxed/simple;
	bh=IS8DAlOEJFv4Hc73lac8CfR9FTMg/4GqAwhA51yn8io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NXVANCPO3xj+YhzzdFGNYY/foTUamv63nXQCdLYWqznbREJVX7a0+wVuQ9pAWU9GAMdmuC8sJfSnRUR5pkji3HXhAOyLfV3OOKYtDTuQuutpYf2JnP2j13Ns4WwinifHVBxnHhpptFCi2qtAvL6I1XQYK/QL3FLODxoi6GtqY30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=AGj9DA8L; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="AGj9DA8L"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51761d27612so10026561cf.3
        for <patches@lists.linux.dev>; Fri, 12 Jun 2026 05:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1781267277; x=1781872077; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VdranlMERpVyxL3pgmyUxuYmzkqsJ8Ni+fhxhylfka0=;
        b=AGj9DA8Lg/Z3rYzf4Jy+6CQGvjfeNv0erwazMIdxKViJU7BqiDa35+y+sh8LgI7DSm
         HoOoifd355YFoazuP1pmAjgntYWxaBjqdUrGIERkrLDkofZ1kd0Np9g83fAmgATahr5B
         1D0ktTaKbJ4hvCwSWXbQzV1a6Vv6y4BqrUGoh1xwIkhuXE2kSd3LGdlcZwrwxD+lXU35
         dQ1OQr5IUKQCrEcbB8iPbivA/fcs0RH6KqeBspgrlSL00vxzYlVLLKPltj1r0tMhccj+
         n/mIdYbfzESUfI+LblhiMj6vYkR+tFioAhtS93B6J7tD4cjksAHN8yj/2oqmHJF3p7mF
         cI4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781267277; x=1781872077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VdranlMERpVyxL3pgmyUxuYmzkqsJ8Ni+fhxhylfka0=;
        b=oqaPne5fnZxq3VSgdARFenBQVfG4fUA1FOu0eJS98m6dgW2O0T4843WPDfNkAY0LxK
         Y0Y5TF+Yy+0SGFmdSyRW9Z07PyEoyWHsudci2XnK2T/rC/Es3hnonT86VCwi9P6mE/ry
         GIUYlH1RwhKfyEweWMrBAvPgZ1lEWHVFismlrqixob9S8e8Vu8VesO5e+TejuldhgvIL
         lLbWwr5Yh1ALKvcc9MfYzG92GPNULHsyPvKva6evuWkaozg7YF7tlueZb6j3GoPUSmSo
         hbdEJW8sDZ/mEphqckWjFy2gD6NeUP5bzP2UV6vSwdCIyqLZohQ5YHVG2z9j3TG6W2ZO
         AXaA==
X-Forwarded-Encrypted: i=1; AFNElJ9nM2QQVSzMIu0tfTG1K6vmkvj6Fpc+qBl1r/RxqWTkSezwbeGo/06lwtEAj0ZWoYJQJKOhj4fd@lists.linux.dev
X-Gm-Message-State: AOJu0YyXIZSf/vg6Pe9gCExAnfai6gmWRktuqo8OfxyyvlIxcJ9EL8Hx
	WeHVSNHuuQwoCkxl7UCjNsakG0iAP6bEtc15o7tgyLwfOE4dGz/M6hUg6nPiXl1r0qo=
X-Gm-Gg: Acq92OHUxoZWgm0g4JdC/3aHyTy0BOU4UtX06vi/WypLxriGJkh4PF6aZEaywoJOHmH
	bf4ZHvnCbZBWw/PHj1pm/gs9P7MF/4V5fQ7gR48GslDO+JrwJi+VjQDi14nufHZdN1Al6bD8JPy
	d14odFLy3C8cowyGSuIJ/P5VNigMbVTPzrMErZhqogDPQGRqYWTJrSaVD8WeCjqZLI29dFO7D2w
	ce0i/ceU+cpSSKiQ1CnKNCgJzK+SvCT7U8vDINmhN5YOdD5ENE3mIokBBQM1SPVxASURGttUEur
	2ED/jQ17whfimm9O6ExJx2gy9Jd5QWH7+sveO8HkCSSTDHlzVpped1NKEw0ZPAGxPPQ7ommFg37
	u9128t+gHskv9HPt3JC54URDqv0pQ9jePg3SliogjGuQGf5bitCeb35vEbXeVVz+IfhjvbibHTZ
	NXPyLJrOr5JUS68VWWG9RWn+FXdcJvxYCW/kxulcNoKI0usuBM2lln3TGd5oqOpMDNRjCA9nap7
	wBZyQ==
X-Received: by 2002:a05:622a:a593:b0:517:8446:3afc with SMTP id d75a77b69052e-517fe51981dmr31628091cf.14.1781267277432;
        Fri, 12 Jun 2026 05:27:57 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb815976sm19531891cf.25.2026.06.12.05.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 05:27:56 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wY0zL-00000007hcq-3XHz;
	Fri, 12 Jun 2026 09:27:55 -0300
Date: Fri, 12 Jun 2026 09:27:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Srivastava, Dheeraj Kumar" <dhsrivas@amd.com>, iommu@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH 0/5] Improve the invalidation path in AMD
Message-ID: <20260612122755.GI1066031@ziepe.ca>
References: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
 <83b8a0f3-2409-464d-a9e4-59b9eea926cd@amd.com>
 <20260611115611.GE1066031@ziepe.ca>
 <airU7xpucwkZMAo7@8bytes.org>
 <20260611163317.GA1453429@ziepe.ca>
 <aiu0kMeaSNIUKwJH@8bytes.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiu0kMeaSNIUKwJH@8bytes.org>

On Fri, Jun 12, 2026 at 09:48:38AM +0200, Joerg Roedel wrote:
> On Thu, Jun 11, 2026 at 01:33:17PM -0300, Jason Gunthorpe wrote:
> > I understood he delegated this to Dheerja and this email from him is
> > confirming the regression tests?
> > 
> > https://lore.kernel.org/all/83b8a0f3-2409-464d-a9e4-59b9eea926cd@amd.com/
> > 
> > Vasant reviewed it here:
> > 
> > https://lore.kernel.org/all/4cc8368d-3972-47c6-bd60-7fc8b9c7be3e@amd.com/
> 
> Alright, I applied it, but there were some conflicts due to
> 
> 	69fe699afe1a iommu/amd: Don't split flush for amd_iommu_domain_flush_all()
> 
> in the amd/amd-vi branch. I think I resolved them, but can you please
> double-check once the tree is pushed?

It looks right to me thanks

Jason
