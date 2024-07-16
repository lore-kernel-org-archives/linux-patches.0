Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186581DDD1
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 20:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721162739; cv=none; b=dqE303Is/vV9N4f63KUjektm+ue9ypI/Jv90gXe1XgcEOdk0mxwpOmay7j46Sswe+eDR5kUOujFTIseqqK1Kphj+gLBhO1iZNd/KAhATwwhHHjVGlJC8cp/ryZfxINGwUf2AgzVGCx9BhLXTY++GqnU0JBFVI3XUZ+LVlVA4I2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721162739; c=relaxed/simple;
	bh=iW0FGJyWPUMoCTPJ87BeXQntpaZoDXyTNW9HRfL2Gm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qsFhxOEopQVbRzvko1zPBhkTBUorJSZ2Ovt7+Og5dJ21HvMYQBjXePmEMjquB1o+8C/1FR4GxnKBxqyIrVJtnk6eMo2fFSEqU5Q7zWR1wl0LiDGeZMsPU7+LS8CXGG4SX+HKxQKjpaHzwzLfZzlrRHxXZf+7jeY5MZGC7SzeMwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v66bNudV; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v66bNudV"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5c9fea3b566so83897eaf.0
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 13:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721162736; x=1721767536; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JacPEkGGGsxMEwr6rUWgBfgGlLH9sSrjcqgHkLxEgWA=;
        b=v66bNudVLq7rJ2SYEQ36PKXK+zJS24gJLXzAYxnb/cR3wa9Eken7fSrWi+D+vgiMgX
         jSQeTkf3HuLs8AXM9+ow3yviozdXPVlrwN8go0FUVEg+41c+IHuznI0IKYxzfwGmBgRq
         otzxQAeYzfFCAHunylOlrW6cedloe76hiyRzOt0+FsCXYCeV3xwJk9xZt6d0ZqFleoW8
         I1CKtLqZbIy06LG1ThFromZ7TPO2U/yqx4kpIFSS/STirIxK85jgVJZkJOeVMezgakpD
         IDNqXU8KjkmBq47WdwlXbRJDUbukBSGm1ojh9+VEAmsaloeIbpSM5HdVwLxV84yoFxjn
         Pb1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721162736; x=1721767536;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JacPEkGGGsxMEwr6rUWgBfgGlLH9sSrjcqgHkLxEgWA=;
        b=MWahxYdnU32WHHr+9R8kx8FV+JK3w+AHyTZzR36GAvqU4CvqLas22tflskfnzb8HbB
         RSZ6MHHdxNTpTnRLcSGUbjDJ5dFHm01zypBVoFP00WksNW29dOHlQ9VTZLgj3maFJ3ij
         LtJCLEwjiP/GY0BE67/t4LRZ/JVkugEHPuK8ACHHJs1/ku5/1/7S5OVNVZpBryOlkcgp
         OcP4+zW4WPsjZ1ndhrEB+bsWqC5X1krOwc8SoMQseUNc4i1Mdf2PdGkZN4qPyxxFRy68
         8lqi7RRyx2pZ8TrkdBlPmGR8vxZl7igFd03gzV/rWt2u945PLU2Cdl5KLYfAQ+KTUX6b
         BbWg==
X-Forwarded-Encrypted: i=1; AJvYcCVXjXG92Om8hnjbRMtEMYiGocQUKnKsJ3QX/asQPKq54OQJG4BSpNJ3KviJEjV/LTdV/63sraMWBFSZePlSXH/s6kD7oh3uZw==
X-Gm-Message-State: AOJu0YznV0CbxAHQUl8xUjyQLw5RhH9pIOBsNeIRBBAFmIdQw9bpQLlw
	3RToT/a03rev7P7trzfB/QPiVqm3T/3E/vSMm42wybhi1oFt70gcy+yQdbqnzwc=
X-Google-Smtp-Source: AGHT+IHCjy42xDuBC5UQWJtltJ9p82Idts+EMBtihlCpniaKr5WerzVsRCSCFN3IA2e0wGXoOszWmQ==
X-Received: by 2002:a05:6871:5c03:b0:25e:2b75:1f89 with SMTP id 586e51a60fabf-260bf549d30mr1278907fac.22.1721162735984;
        Tue, 16 Jul 2024 13:45:35 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:b5d2:9b28:de1e:aebb])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-708c0d1f628sm1424013a34.67.2024.07.16.13.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jul 2024 13:45:35 -0700 (PDT)
Date: Tue, 16 Jul 2024 15:45:33 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.15 000/144] 5.15.163-rc1 review
Message-ID: <c7beb899-91dc-4fcd-816e-fa7ba6f956e4@suswa.mountain>
References: <20240716152752.524497140@linuxfoundation.org>
 <CA+G9fYvVaSX9Ot2vekBOkLjUqCx=SbQqW4vWhypCnGwwBmX4xg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvVaSX9Ot2vekBOkLjUqCx=SbQqW4vWhypCnGwwBmX4xg@mail.gmail.com>

On Wed, Jul 17, 2024 at 01:49:12AM +0530, Naresh Kamboju wrote:
> On Tue, 16 Jul 2024 at 21:37, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.163 release.
> > There are 144 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The s390 builds failed on stable-rc 5.15.163-rc1 review due to following build
> warnings / errors.
> 
> First time seen on stable-rc 5.15 branch.
> 
>   GOOD: ba1631e1a5cc ("Linux 5.15.162-rc1")
>   BAD:  b9a293390e62 ("Linux 5.15.163-rc1")
> 
> * s390, build
>   - clang-18-allnoconfig
>   - clang-18-defconfig
>   - clang-18-tinyconfig
>   - clang-nightly-allnoconfig
>   - clang-nightly-defconfig
>   - clang-nightly-tinyconfig
>   - gcc-12-allnoconfig
>   - gcc-12-defconfig
>   - gcc-12-tinyconfig
>   - gcc-8-allnoconfig
>   - gcc-8-defconfig-fe40093d
>   - gcc-8-tinyconfig
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build regressions:
> --------
> arch/s390/include/asm/processor.h:253:11: error: expected ';' at end
> of declaration
>   253 |         psw_t psw __uninitialized;
>       |                  ^
>       |                  ;
> 1 error generated.

Need to cherry-pick commit fd7eea27a3ae ("Compiler Attributes: Add __uninitialized macro")

regards,
dan carpenter

