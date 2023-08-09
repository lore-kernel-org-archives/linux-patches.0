Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F241BB23
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 15:51:29 +0000 (UTC)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-1bfce114ef9so3173840fac.1
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 08:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1691596288; x=1692201088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lzEMa2xi1YHE1YCoFHllP02NIOrQ2JqY6Z4i2GNEvKA=;
        b=JREU2qwdrGKaOLF7DEkk+0a7FTW3TnWUQZybq26KM5Ttn9XP/o1JZq2j9lATYRiupm
         N8AsPminfb4+emBT3n6alpAYwKyoFVb9H6lI6G9+JhQyGsgftfuiDfiZVV1FNzfV1SbF
         IAmrva3UT1hIBKdTT5VYhFdDJ8nLqvHX8CZFY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691596288; x=1692201088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lzEMa2xi1YHE1YCoFHllP02NIOrQ2JqY6Z4i2GNEvKA=;
        b=EfG7EYrehPKKuthPXNbEYT7tTQ3mAwci2Hpc/dVfgpNkZwzu4LYvhtF1TwSX8o2HID
         rBj9WF3UX3OhcIV9AvD6Ixda4Ylpvs+9QNU8kdfHP4/xvO/PW8DPMxzhMJpepHKk8wJA
         XqcCi3pO+kcSOWmy6Wx2U1S3GBBm+YGn+mv6YF/cmvMmhTH7duEztwgWeKHzt2WBOvV1
         bDtvOx6vvS/lrc5sSLE6wfnI3dKQhEMyBTlPwk0Ik7ShNtlffdKgZlfLaeGXJAd36JjS
         sOb0Qts5q4HafC0jWfEmravsikdkSKrFOR8dE4+juQ90N+A8SDT5N4OhfIBmrURSYhAV
         U/jQ==
X-Gm-Message-State: AOJu0Yymf9hdVdAL9770w5/bztQcxmhHyFGXHQI1T20/wevoY82Y3/ew
	oT5tWrybgVO44QbJRpjczWAHqQ==
X-Google-Smtp-Source: AGHT+IEXa9hX+zGrGRLhTmQcnBjAWVIlo+QyRqclBP/uRgPtWl5gGR3XE8xfr3gDFkmGMpxb5iaxZA==
X-Received: by 2002:a05:6870:b293:b0:1bf:2ab5:3ae7 with SMTP id c19-20020a056870b29300b001bf2ab53ae7mr4074035oao.50.1691596288546;
        Wed, 09 Aug 2023 08:51:28 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id xv9-20020a05687121c900b0019e6b96f909sm7230769oab.22.2023.08.09.08.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 08:51:27 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 9 Aug 2023 10:51:26 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.4 000/165] 6.4.10-rc1 review
Message-ID: <ZNO1/oJe3OwRG5gb@fedora64.linuxtx.org>
References: <20230809103642.720851262@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>

On Wed, Aug 09, 2023 at 12:38:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.10 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
