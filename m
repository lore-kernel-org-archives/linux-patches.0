Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F1C7B
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 21:13:22 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-13c2cfd1126so3954201fac.10
        for <patches@lists.linux.dev>; Thu, 27 Oct 2022 14:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zB1AivzTtphajm2G2kz8RRsMJzIbfs85BmIuGSD/wO4=;
        b=Cs7EMiWvFfqIHlpwJIWb8dnfR+OPKolPehJFBdEPI37HKANFjQg4Vh8VgrNrxt3sCk
         oFFs0Sl8MK83e2Omspild2lKSBgMRVmT8UN0H0AO9hSessdQFR8VsiRatoJ7zsA5h9eh
         BAVd6Gson13f26Dc669Hp3Ks9LhvMtHBpTxDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zB1AivzTtphajm2G2kz8RRsMJzIbfs85BmIuGSD/wO4=;
        b=a+0uBMjJb+NJCRBT1xkLReD6tvTGEIeOBCUj811P7Kfl2vQGXRbxtfueQbCN+z5Mv/
         o874Z5FHZbcHW4/hS1l3Wx6Jx0Xd+L1Z1YDLkk2c65ctxzI+oP0BhfSe8VKIjA2JKIHk
         KKyk7a9Trrlqb0PK4W2y/OYLCHJFVCHSUWwSqMxAVtGGdG6Cqwj2kTTCo/oHkojGzlzH
         8AU0KyLnDCWK2yb/bwgZxZQH+7s8teyfDYvtPislwvSwPHZWG2gbTyCgyVhmhmkp53JE
         1uc71zGI3F+e/v/qlaaLjicyTkQ+7T6p+dMTGkWYWHKHvLmnsppftsPuUkRafrB7Gaby
         aoPA==
X-Gm-Message-State: ACrzQf0I8xOwvGwxnzJtcUYd4xkZqOA0H5OFO5dvoe3qZcledqoNW0OK
	9AqTIFUE47kGz2cHUkgKSs6kGg==
X-Google-Smtp-Source: AMsMyM7Eh2UuyqOlvlVZblNkItAMD7RsWn4BGRCJD8ET8t+7dRjsDLusY6Du1gJRq/5ltsz9b9gJpw==
X-Received: by 2002:a05:6871:6a4:b0:13b:a056:f97f with SMTP id l36-20020a05687106a400b0013ba056f97fmr6383939oao.38.1666905201958;
        Thu, 27 Oct 2022 14:13:21 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id y4-20020a544d84000000b0035485b54caesm824888oix.28.2022.10.27.14.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:13:13 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 27 Oct 2022 16:13:11 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
Message-ID: <Y1r0Z3vdXuOcAjX9@fedora64.linuxtx.org>
References: <20221027165057.208202132@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>

On Thu, Oct 27, 2022 at 06:54:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
