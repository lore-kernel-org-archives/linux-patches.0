Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E93F26AF3
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 04:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740371914; cv=none; b=KRzkz8cTKL4FaIEC8lmOfrMt1fW/frGT8tPSF+wnzWvcz1cUHF6aXO35C1OFuB51zgh2qyyEb596It1uaEvXRxhkkMAWobubKusoIXZhBtw7E/fFVulOOTKNwXjpSS8xUr4a6AeFu0KZ5Y6IJPcE3IovDHCUgzK3ffrs6a9wj0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740371914; c=relaxed/simple;
	bh=Kxoqux8ig1bneZc8TPbOtwtdCXGrWd1siptghYniyZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S4G4aj5+zcyk0JSh+vvWzR3E9wb7e6kNo5B2dppcUpsmPbS6dqnfs2Kq7UOjVsKwRtYX+gqD7NooDJKlHRQDQ0DOxzWkSeCaEvorWpYQUzdwaBd+AASvUvc9fDEh5QVPv5EGedg75mzZeNaY520K9bqzvw4r9g7q3FQx+984Lrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nE18YxXO; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nE18YxXO"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-220e0575f5bso256105ad.0
        for <patches@lists.linux.dev>; Sun, 23 Feb 2025 20:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740371911; x=1740976711; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QXOPbjowj6Hzwuap/XS84BFQBW4l8rdr65xne9mv6JE=;
        b=nE18YxXOOaC8szMw2NnJoM85RcvyV0EpGhFAqyYpNxBuD4VKy23Z+92Fwn9AlFR3lv
         yAAUzXZ4ZPFLv3R0gj4/YV3mBaAmxAmHWSVpWpAEWje1ydqz3vEbGkdBgGrwI0SJm/Ch
         5HMfJfCbZKm/aC8klXSM2n9Yt+mnlp86Oy7kjHB8026Z8hBX8p0F36tsj323r0FuqqN7
         TJL3Qe6p7thihKHfCVZbATP0nFd2bhCLarrbfeQgWcdmowUd+TnJr0rNyQmL4SLoo21c
         VdhMDrbNDDBtMtVsoKG6QOpSesk1F6cH+kmbz9q/pPLxnBAhr2bY8/BJ8UrnCX9g3n8q
         vtsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740371911; x=1740976711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QXOPbjowj6Hzwuap/XS84BFQBW4l8rdr65xne9mv6JE=;
        b=iMI5p3sQoH6H4+lC+xP6tG8cYerm+OEqWsVXdJRFLNuvhubvboSGzDmuqUscqnlx93
         /kPalVXJIqx34vNdp+Q7rp0bqLN4S7204u4uHOYVMi6oRtjuKt74zDUMXzd491VW75bF
         KCFlgcERokxN+DlB3uWYqsGcKrR9lMi64xKKM1YwRGX9teAZoYm75XiHsY+28XAOueiA
         Oi+JiPkiQ2N0KfrkfaKjFLI9HSN8XjzNBc5O+kcuZuu9d7MkU2sR6gzLVCPz0Okj2Zuf
         Sc6dwhJ4HW29ICIb7SLhzgl9fQ+8a5xG6inZi3GIOHiO7yZZdixOlyuckI0vZysXTNVq
         1hBw==
X-Forwarded-Encrypted: i=1; AJvYcCWHQSckxtfTGAFBltT6dH/lvhhb0IJmGmF1/viLFJcAD/ohwsItQC4vGJzvvRdfodUC3Q+Xhg3r@lists.linux.dev
X-Gm-Message-State: AOJu0YwJini4Puk0O9zq3Ru34auAkFTvTZ8l2BefQ5TFqdNn4F49yoJW
	MQ5p7mM/EF/by1/hrQLKm9OtMUFGhLokg+k0Z/TM+vBQa+kSLJsZdIw0LUpfrg==
X-Gm-Gg: ASbGncsc4hO2qebRCRM8VZDb8eHiDYqAwXK+B0KqFrFzIzF+lrF6xxRZ8YXCsak9eCW
	RfwemfcvHuIYYppBIPtn2VF0nE0/FUg9effXNZAZT7sD7wvi9bGbEW/y9ECeiNTho7uduXF9JRe
	+0sUQCZM/yvQDWVDDu95VkFxQwMSIWW9PFz/+Y1n3/zKdcU3YRDK8rOhkwy6R62Gezs8+cWTXoc
	BqTEt550o4ucN5shNqHmSLWk286meM4ZjN9LX80E2FHcokZe9/dl/cGZd6kYpCVWV/1syr1Iynz
	E3jWGs4w6lOVXfF7XmbSJ2MWrYi+L3F7Gec1tzAd1VmpifyNilI9w6vjzKyF8KE=
X-Google-Smtp-Source: AGHT+IEdLGzG2X3YEfsIyog+f9j0aXsArsFeUuMcB+n8G7DuxjBKyqLer9ZGTISS6pMA8Im0wRP9Ug==
X-Received: by 2002:a17:902:da8c:b0:216:21cb:2e14 with SMTP id d9443c01a7336-2226cc46c3amr2333105ad.21.1740371910429;
        Sun, 23 Feb 2025 20:38:30 -0800 (PST)
Received: from google.com (169.224.198.35.bc.googleusercontent.com. [35.198.224.169])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-add540f75f7sm15349070a12.46.2025.02.23.20.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2025 20:38:29 -0800 (PST)
Date: Mon, 24 Feb 2025 04:38:19 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	joro@8bytes.org, suravee.suthikulpanit@amd.com,
	robin.murphy@arm.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
	shuah@kernel.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org,
	mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
	smostafa@google.com, ddutile@redhat.com, yi.l.liu@intel.com,
	patches@lists.linux.dev
Subject: Re: [PATCH v7 14/14] iommu/arm-smmu-v3: Set MEV bit in nested STE
 for DoS mitigations
Message-ID: <Z7v3u55JNDqveAuD@google.com>
References: <cover.1740238876.git.nicolinc@nvidia.com>
 <2b088fe8d2c7e692426b0d1f58d4f2c12ecb907e.1740238876.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b088fe8d2c7e692426b0d1f58d4f2c12ecb907e.1740238876.git.nicolinc@nvidia.com>

On Sat, Feb 22, 2025 at 07:54:11AM -0800, Nicolin Chen wrote:
> There is a DoS concern on the shared hardware event queue among devices
> passed through to VMs, that too many translation failures that belong to
> VMs could overflow the shared hardware event queue if those VMs or their
> VMMs don't handle/recover the devices properly.
> 
> The MEV bit in the STE allows to configure the SMMU HW to merge similar
> event records, though there is no guarantee. Set it in a nested STE for
> DoS mitigations.
> 
> In the future, we might want to enable the MEV for non-nested cases too
> such as domain->type == IOMMU_DOMAIN_UNMANAGED or even IOMMU_DOMAIN_DMA.
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h         | 1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c | 2 ++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c         | 4 ++--
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
