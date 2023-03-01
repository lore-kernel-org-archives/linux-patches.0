Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7C92F3E
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 23:43:30 +0000 (UTC)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-172afa7bee2so16340872fac.6
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 15:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BhW2gSdbv5vMwTEl6x4Xp05rj+HEUyPIAacoa6OCF4k=;
        b=E35mtK6/8sAjkRNZ2FP9bXdH50V4kdqOmdYviyhAKKLQXPgKfuRDUD8W3tIqkjbJoi
         H85Bgi+n442XfOAms5NNRYP001Ea+Z/Qfq84NxUNF6SracCH4YCNxH2AbsPb+mPEClSH
         HTfJBWINAC8ws2m/moqnXhbsKj9KPdqCITrxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BhW2gSdbv5vMwTEl6x4Xp05rj+HEUyPIAacoa6OCF4k=;
        b=lJSV9oPKs2ZF81tI1zDsmw99GKeS2MCLCggz++qyoOKldALczm+Y9Hqr9qZYsqN2xF
         cbPCErC46juk3YuNs92UoM7CCh0E+u0Gmf6Oyj3FLQcbrP9IooZ8NbjoFf3B8C7cKg7F
         nQCO8Voq361Pph8XkgfGAO56ChlA60WuBPz42ldDtcS3JpPsdZb0r7hKWFX9CvWvT5qe
         JG+PuWBOitVta4bs4ZU3dYCbkvnvQ1ZaBDTRKo/+I1r/Yu+9zEvI/oZtUOJ/Vk7KKXPG
         m21+zX/20YWB9yBXR4CTNO5wMY/pmO85f08xgCWuywgyiXBN3r2x49k2/OzOW95p/nwc
         lVmA==
X-Gm-Message-State: AO0yUKV7oWiAMWx8FxP3Si8PtBcRk0M18PeHtVMKyc3GDdL8bIxcFUl3
	fDpNMohQmmPXfYOoOrGs2Veuaw==
X-Google-Smtp-Source: AK7set+978mFlFhzy0VxpuZmK0F+YK3Y1dBCQ1diTXwLhMGmdVcnUWQuvcCagDvjz5WXR5jfSlsqDA==
X-Received: by 2002:a05:6870:c192:b0:16d:f28d:3094 with SMTP id h18-20020a056870c19200b0016df28d3094mr5022083oad.53.1677714209004;
        Wed, 01 Mar 2023 15:43:29 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id b5-20020a05687061c500b001435fe636f2sm4830336oah.53.2023.03.01.15.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 15:43:28 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 1 Mar 2023 17:43:27 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <Y//jH9m03FZZzjpD@fedora64.linuxtx.org>
References: <20230301180657.003689969@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>

On Wed, Mar 01, 2023 at 07:08:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
