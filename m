Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F931397
	for <patches@lists.linux.dev>; Fri, 16 Oct 2026 01:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792114446; cv=none; b=Y4ThF4YG79PenM8uK7DVccplo5P3k5bOaguOuIikfmzC8uitdEjLR4OAU4Fc7Qr16QULFAWo5SZ273VG0v9Nx+YKP5lXUObpySvpBHYFS5B+afbnDH5RzmKvhH2zghY73EukqeJhi3hI9e9+ktzMcNiVyXHiHMa0oP3YDX6k2k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792114446; c=relaxed/simple;
	bh=nLgPiYbSq45fhcCwaebsJ2SjYmzyaWlhxU4COKBBfmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Camyrl5pYE5Z+3ZsC7Sb+Uagman/73aYpHhFKTO4ZA8fGMtPhzwDc8tv0BMxZdvGYr8urHBdS2sBggdLbF7fHU7s758nflu8wzBVpsJkuzJQ4Gni6G/+DZgUDR12pFd8vjXDTtwTWM5w2xFoUDsNJboFeEgd95bHFRYsQJlBx38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ksLJOq/a; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ksLJOq/a"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so16455ad.1
        for <patches@lists.linux.dev>; Thu, 15 Oct 2026 18:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792114443; x=1792719243; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sdPpN9Xqdtkh9zsXDM/jJFMTNd+EOKXTasm7UxE7C4k=;
        b=ksLJOq/a85igf03T3u9oirfpcqwqtDaTenXkqSFC+LSSpmyLanRmV5+6npCFZMJett
         jlKDB50bk9NzMDJeyDVMpnB9S1einyCUuX2jQ/JTwH9oC0CYN2X6kPmRB7DvItTw9rbu
         A1rePEksFIz5UWHXvE/1/mQrwIVynkL3M8vZfFZKXulYutodtOCCmATxdUBhtoA6HN5a
         vk6mKWlwr4aXjzF1itrPl9b15CT1k0TCBdqVq4fHdzoatVRBL5GRPJFK2ipLmHN9UlrM
         JYyo1lcpD3T031p2clCp7QNKIJxpH++2RtB+aObt5e7z2kg3QLZhL+ITXrk6ioe8tQWh
         iVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792114443; x=1792719243;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sdPpN9Xqdtkh9zsXDM/jJFMTNd+EOKXTasm7UxE7C4k=;
        b=QbE+L+wuPsvyMxlScOruPh+bYdmX8lXsCm55l3GDZvjuncVN+PWBftyA2QXOq/kY8d
         s2+KU9FtiywhJamLOj/5t/C34g38XVcs9ADZ6ZbgBme08HsnDKxpq8n+O6JqFCSSDpeB
         /sXwR5/PS6lTNyaeDNjDKZcouVVX+eEJ2bIbcsIRhpG+0oF8SPRhM6H9HrFATGQCTIED
         6PI8VBBNkCvUdR+k6B4cZjnnVZ1YI/1ratJLnGhJd5coBXwAGnPRVnm3Ipg9TtHmBT53
         FeVlytOMVCelhZ6FQS80AURDzWjYqgK5QSUBtFTGinROAQytElwOXVve5EnZXJrTyMwr
         Y47w==
X-Forwarded-Encrypted: i=1; AKwUvBysAchCywsp+2MAqhY6ZbPoTw/qbaoIDhuIdOcanZ4z132FpZg1vYA8QKuTKspXmEDnR2zzXkj0@lists.linux.dev
X-Gm-Message-State: AFq9FYIj1y6jVPb10pMqpVOoOMHwrT7s1u5adgxGJBAZQSeqx8BwXHRV
	Qle3v33doDafgV42Xg0UFCkbAJ1rlIYOsEi70e8cn3EM18IHNwIE2BlZdmyUW/r6kQ==
X-Gm-Gg: AYBFou2O9ewGF/t7PvgtbbJpxuFEHN7AKc/Uj4No9x47qhVYl9K89+iaOUlckDNNrFC
	k0muEG/m+kcbJQeWpqaZkruAcTwDn49RDoH43x5wXZtFPCgfffYlqX3mlrsSc9hI16T44UbZxFf
	joo3H36ajFPiHx74SARYoJ2JBV9j2G4USMNCUH4FKeXPmATAZkx+2LGXtNtF6/nbTQPP9uofSOu
	iToCDIWrFGB+YeXCiD9vjbceC+tXiRsYi4tM47MGckJIW+b0tcdajKzJDooZxYlqEuJQMxNruMr
	SDxfkYtLQrA+T5xAxICf38rNT1jB8rotMO9UtCcNTj/5zM6Eip3ZpprDp1smo3iBoAUH6bLnMZm
	M5QlYWJUoC2JNlNzmIvzNC11YswGpUMlOJ/DyI0TgrkR29ZWpvAc2FTxQkSII7p4V84+NoClBDW
	hE8yP2h2esMBUPEGRkGvJW4WTdOoqmZJrZMlmcHMXKgw74b0E5zoMScvSp2PhQPLQ2nGvR5KRJ/
	NZB/zpHJJkgQJdOnLnP2wF3ujaHp7MZF+OrD2DcUZR1rDsql1wMEncbpNEVkl1eGm4=
X-Received: by 2002:a17:902:ecc3:b0:2e6:1013:ad57 with SMTP id d9443c01a7336-2e9821d5bafmr1820355ad.12.1792114442559;
        Thu, 15 Oct 2026 18:34:02 -0700 (PDT)
Received: from google.com (163.1.145.34.bc.googleusercontent.com. [34.145.1.163])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd05c9255sm407564a91.2.2026.10.15.18.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 18:34:01 -0700 (PDT)
Date: Fri, 16 Oct 2026 01:33:55 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	linux-kselftest@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joerg Roedel <joerg.roedel@amd.com>, 
	Kevin Tian <kevin.tian@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	patches@lists.linux.dev, Samarth Narang <samarth.colleges@gmail.com>
Subject: Re: [PATCH] iommupt: Do not allow PTEs to be split when dirty logging
Message-ID: <atF8QSyk2TK7wlvH@google.com>
References: <0-v1-5bb926ff73ec+576-iommufd_dirty_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0-v1-5bb926ff73ec+576-iommufd_dirty_jgg@nvidia.com>

On Thu, Oct 15, 2026 at 02:20:10PM -0300, Jason Gunthorpe wrote:
>If a single PTE cannot be stored in the current bitmap that should be a
>failure and reported back to userspace. Allowing a PTE to be split creates
>a possibility that dirty memory will be reported as clean.
>
>The gather must also cover the entire PTE that is being cleaned, not just
>the part that fits within the bitmap.
>
>Fix both issues by computing the full IOVA range of every PTE and using
>that to update the bitmap and the gather. The bitmap code now rejects
>ranges that don't fit in it, and the gather always combined ranges.
>
>The selftest quietly relied on a bug where the CONT was split, that is why
>the half page size for the mock domain saw alternating dirties. Increase
>the dirty test page size to PAGE_SIZE so it still works as intended.
>
>Cc: stable@vger.kernel.org
>Fixes: 4a00f9434891 ("iommupt: Add read_and_clear_dirty op")
>Reported-by: Samarth Narang <samarth.colleges@gmail.com>
>Closes: https://lore.kernel.org/all/20261013165814.309255
>Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>---
> drivers/iommu/generic_pt/iommu_pt.h     | 30 +++++++------------------
> tools/testing/selftests/iommu/iommufd.c | 10 ++++-----
> 2 files changed, 13 insertions(+), 27 deletions(-)
>
>This relies on other changes in the iommufd tree so I will take it
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
