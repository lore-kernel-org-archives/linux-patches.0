Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C139E1494DD
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 02:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729045444; cv=none; b=JFAVW2wB4bFG3S7yhz5qIaFU7myLnkIVUkATG1Uou0opeMVDv8Vpb5G+m5KU84SNyUbC21imfB54b3VeeteKSAxDaxFbR2bbXqNQHx4koxq6j+IZnVR5kiBWd8mlFkFdSHixVtDHVMV4yZPUMMmBsWSDvDpgJBX3/M5cUCa/uvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729045444; c=relaxed/simple;
	bh=+GF1oCaa4XIdm2rCPBWvV+uTROdOd1KyxDhkbhawAvc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OeCO0FH3KwngCS4fK8StQ9qizt400EoxiQng93gfu7mlBvxaM+N7R5BL3/ZQrB61o9992Z/11Tz564/iw3L2s8RMgX+I3CfGBFaK/p5Ur5V/I/rcl9v6m4Lo/prsY64WITJMi63NtryK81q7N+CfG75ciAtJGroVHeQEKaTYC/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nofvZaOf; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nofvZaOf"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539d9fffea1so4879757e87.2
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 19:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729045441; x=1729650241; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qiWvrpKzeq83YnQqOE7ISPaRFxYtddrp60dv+zolb9U=;
        b=nofvZaOfyWsBjfzInq6Nt5348snRx1WfxC8/qUyceii+muEi+UPrZLzPtbO35vJmzY
         WoOnUDYgUY7NS935HNxhPMqa738rDPNZJl9/t//bhdwBox68qoOzfS/Fb8ImybKAtmwc
         811UEjfXwKpbEJxjuTTO8k3i7bAgDdimRnn7yfZpZR22aEqHFGQ8zRn9wSyff4DH8smz
         6rI8kXlZL4ExKYnY1uvWSvhwdzMJnBP+E7ZBq20Z2hLPgjE0VDZ8M1lyFwtzYWnUatrt
         LE1Dmd6TCcljMgkSHq9Mk1us+qHMezNwxA2vfDMRJmbTJmCXu6oCpP10d4iWxNYPXkYp
         bCrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729045441; x=1729650241;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qiWvrpKzeq83YnQqOE7ISPaRFxYtddrp60dv+zolb9U=;
        b=J8o6dkVkk+DvBryPb4w8EJPEcCQj9wXocwcgT16ANE7GP4CzsNryw778w8EdXOBI69
         EkjbxJ9s4Q8dMNFVXFMOJ9/xe3TTwwe/Dziwamwg/bbEYEB7CrBeeDluYRaTa3AiuviQ
         /5ER9XisXc6P3n5Ouq9F4aKRagsQCpPq6CT19xJ4lhy0RWXETj8+vWHWQwY7tjdHn/ZC
         uHS0gGIjy/MjWCfjA0pqB6XD3cxKBcOMT8QQPGg/uJrc7OOiF7/kMNKP2LXlMW9BSwGy
         25inRPp4N1YJO9w9ou188AaDleR6t2PiQ5LL7jrGIabKa3bs8jtZorPFW5adLjiCCODM
         p5Hw==
X-Forwarded-Encrypted: i=1; AJvYcCXfL/aAMer7tfv7SKf8H2KF0/J6DQAOPukeo2XG8plwm4RTZFBPXJVzZRU3L9EwXQ+6YurXqCdJ@lists.linux.dev
X-Gm-Message-State: AOJu0YwIlPw6WlE5RV53I/QUp7JLh59Xvi2czJ1OhRbs3jXJAfggB9hm
	7katPhd7KAXnf5rHJs3JqaA6Bsb/NbwCApQjEWCU7UYsDiHPL5A8zEJr+9C+1lOwJucUcitxrkZ
	vmtb8KDK18WnCpshKubLBpFeqaNFLCKRYKpWK7g==
X-Google-Smtp-Source: AGHT+IEV/byr5lu2UsUC2RRVM2gDVA1eLiMxNLS7gT854PVdY6PhxgM/HLAZnNXx36HxSizxkKPg933nd9PyJjzpqHw=
X-Received: by 2002:a05:6512:3094:b0:539:da76:c77e with SMTP id
 2adb3069b0e04-53a03f045ecmr1718387e87.5.1729045440632; Tue, 15 Oct 2024
 19:24:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 16 Oct 2024 10:23:49 +0800
Message-ID: <CABQgh9E32c5inrn=Q5HWThuJQ4xV=EFWLGwbyxVLHQVUZ_uYCA@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>, 
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, 
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi, Jason

On Tue, 27 Aug 2024 at 23:51, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> This brings support for the IOMMFD ioctls:
>
>  - IOMMU_GET_HW_INFO
>  - IOMMU_HWPT_ALLOC_NEST_PARENT
>  - IOMMU_DOMAIN_NESTED
>  - ops->enforce_cache_coherency()
>
> This is quite straightforward as the nested STE can just be built in the
> special NESTED domain op and fed through the generic update machinery.
>
> The design allows the user provided STE fragment to control several
> aspects of the translation, including putting the STE into a "virtual
> bypass" or a aborting state. This duplicates functionality available by
> other means, but it allows trivially preserving the VMID in the STE as we
> eventually move towards the VIOMMU owning the VMID.
>
> Nesting support requires the system to either support S2FWB or the
> stronger CANWBS ACPI flag. This is to ensure the VM cannot bypass the
> cache and view incoherent data, currently VFIO lacks any cache flushing
> that would make this safe.

What if the system does not support S2FWB or CANWBS, any workaround to
passthrough?
Currently I am testing nesting by ignoring this check.

Thanks
