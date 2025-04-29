Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3F140C03
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 18:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950246; cv=none; b=jHBAjhDXv8zRpWAEOOI623IKaPuGeg5DLs8PkRuX03nmU9n5PGJI5bm5Aq/N/B2v+adNiHJTKfmuCsYIjJAFTXVuJQkwTl+78V8e1VtG3YaEbgBE/zlXT/y+1b3wiWSMXQ9X8Sh6M3inlIAjlw0UzENBEnQr8SG6m6AJFWExsT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950246; c=relaxed/simple;
	bh=Ziulb9mMltIWQNEALJDPRlCWsnKPBKb9mm4o9Za3zo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N72clZUhQn7HJR9QBYLE4wXFEYIg2O+6aGNgBHlPEBHt6hWzdkAS0avJyBGw6sOvnsUv9I0jow8F06beEY8cMEKX+iVGZOJZacyHVkkIEN9GYu6HBQV7+yfNheynBCYc+IatenVEQvm1pfhzW+/aNKat4ajKVDY0vUrvvsbJvL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CxNPzkc0; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CxNPzkc0"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2240aad70f2so202925ad.0
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 11:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745950243; x=1746555043; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ftw/IjMpgU7GPfLzcouQoWIfms9GOb854vnlNb5+taU=;
        b=CxNPzkc0yqGLiN8vFiDVPlT/B66xGQWeFC04nmxk0exZBDco4A1oVBCVQCAT5yOQ7i
         YvrbBdf8oCj0s2dDjtBBDfEkBTUegJtilN9LxAerDtrAXLoNCv2wvVRLIr0V+d0+vIbJ
         wPYzkfMKrmpd19WXpVlqISSZvufk4PZ4W+HUgFKgX+dk3Hc9f4qVMazNf7Sdjry63UFZ
         4dYUWGjff04SXA7oinhY8Rh49D9BIbrVelUku4bYyoVzU/Wvk/LBlP8zcWc9rOIIzyE9
         RLfSy3vrJjQ9rlNRIT5s4KDlnjIFgf/xB9hlOtQJcz/MPBdhLs9WTJDAQavLeCJKL8P2
         QaTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745950243; x=1746555043;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ftw/IjMpgU7GPfLzcouQoWIfms9GOb854vnlNb5+taU=;
        b=JRtYDZcXl4FReNF5b/7vbJ5HAkr+W+AnjBCs7W7YlVYsmK8buVOlGRPhC72+ToiW3f
         48tMZCvcEi3Os7t3dROiF2zShC63c6vz0qhhLRk1Is6FaMir1sbarv+B/iCbnYEG1Z3e
         kpw7CDJrwN422RCUjbcLfIK7eCQTws6A93xIhDi2+N6NoGvd4NkrOG6d+blEh3KPAiaF
         bMcaYZSEIrmij78AhSMig7zSha6ewrFbVJ86eIPSrkwwxrt6gsXlJjlSzciEPYKxfR9i
         tkD/q108QXkEXFCl8fYjzYcsbUgF6n1Uiv0czprqPnPf7lm1omU89UuSvlfvuVaD8Rjd
         lNBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyKOMTYGWe/eQn1ZCmPG8jX07acqNsBcuYy0IIx/sXZIrcipHCs6IgAc3btiL2WN8dn1RhFkAV@lists.linux.dev
X-Gm-Message-State: AOJu0YyzfTYGI0tuST720XAQRMqH3fmzaBqsOWK7gGZFefvmIYceyQ5g
	b4c+LH3KFvKmDAz5QP0hs4gGWCS6c7Q0Rv1GjC6ugjDWmmY3OJDXZM8mnaHnTg==
X-Gm-Gg: ASbGncuz0Uj9hUGdYfmQIL3MedikpcJKBnvo9zWhS+JWRLfXL/zKujX3oG4x33s6Tbu
	LsFHY/NWYTpOy57ye5GrGXC+wWny3BvlqfBVdqrHjhlt0Z4f8aS85hj9lboz+zBWCCeUIrX1sn2
	WzDwW6jh4NFrkxa0ENahvsAJLWiKpvJTYsw0ffZhtQe1dpT7HdY+CpAWtuqPZSl29G0V0Nx4HqQ
	1fTEqiZYDA/XuQCVMYv3opclO8Y6nN/xTDVA4EXmMWuxe+PYHRUQqc+bgea4CaCKFXnuVRdWSKC
	nvjre3b34tqsQuzq7pb5z3KGQbEo9fzgQt3DdL3wQV75KkFyN7+pp1zW1+7fvJ5LOyYxkqWJ
X-Google-Smtp-Source: AGHT+IEGtuGPnrFdA7EnAS7AeHO3rAMJ1bXf2n0ATFrXiwa1CPLZUhde5Z8nusKLhSnrBiMW3CwVgA==
X-Received: by 2002:a17:902:d486:b0:224:38a:bd39 with SMTP id d9443c01a7336-22df406ab2dmr130415ad.20.1745950242565;
        Tue, 29 Apr 2025 11:10:42 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25912efbsm10222670b3a.23.2025.04.29.11.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 11:10:42 -0700 (PDT)
Date: Tue, 29 Apr 2025 18:10:31 +0000
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
Message-ID: <aBEWFw2wq40SHjTn@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <094992b874190ffdcf6012104b419c8649b5e4b4.1745646960.git.nicolinc@nvidia.com>
 <aA_0TV0RkVOHk7Qj@google.com>
 <aBAEuP9962XweHPc@Asurada-Nvidia>
 <aBCNkcLp6XZpjYYT@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBCNkcLp6XZpjYYT@google.com>

On Tue, Apr 29, 2025 at 08:28:01AM +0000, Pranjal Shrivastava wrote:
> On Mon, Apr 28, 2025 at 03:44:08PM -0700, Nicolin Chen wrote:
> > On Mon, Apr 28, 2025 at 09:34:05PM +0000, Pranjal Shrivastava wrote:
> > > On Fri, Apr 25, 2025 at 10:58:05PM -0700, Nicolin Chen wrote:
> [...] 
> > > IIUC, one vintf can have multiple lvcmdqs and looking at the series
> > > it looks like the vcmdq_alloc allocates a single lvcmdq. Is the plan to
> > > dedicate one lvcmdq to per VM? Which means VMs can share a vintf?
> > 
> > VINTF is a vSMMU instance per SMMU. Each VINTF can have multiple
> > LVCMDQs. Each vCMDQ is allocated per IOMMUFD_CMD_VCMDQ_ALLOC. In
> > other word, VM can issue multiple IOMMUFD_CMD_VCMDQ_ALLOC calls
> > for each VTINF/vSMMU.
> > 
> 
> Ack. I'm just wondering why would a single VM want more than one vCMDQ
> per vSMMU?
> [...]

I guess the only thing on this patch from me was to understand why
would a single VM want more than one vCMDQ per vSMMU? (Just curious to
know :) )

Apart from that,
Reviewed-by: Pranjal Shrivastava <praan@google.com>

> 
> > Thanks
> > Nicolin
> 

Thanks,
Praan
