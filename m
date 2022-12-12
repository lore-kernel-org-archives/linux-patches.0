Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F5653A5
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 19:06:46 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id db10-20020a0568306b0a00b0066d43e80118so7923206otb.1
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 11:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bc2DPrk+jmvIB8OtsNO1XeEuDilKuTsyr5RnoWNLVIA=;
        b=eEIOe6BJqa5uLynDP14d9654wXp1J0S5TkCOQQ2gjQ+fnIii4aYlovvJ6/HlIXYiFX
         TuBCjt689w6EwitE0MRDKTSzpnQOM1yE99H/ryU3Yuhj6BhyTawgvyEuDWj6Bx1e2lOD
         9iRHncaA+ScI85bta8K1PTXz8hOJtxV/6dV1U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bc2DPrk+jmvIB8OtsNO1XeEuDilKuTsyr5RnoWNLVIA=;
        b=fKsOsu66SbB5GoL4nfeLrh+6DPpF6v7MmS9Nlji2hQ9pHm5eueYZ1SZR5I5DpF/Oux
         8257DPzYhGA2hk72yrOH7VAPcEZykoyBw4WgvvKAgKA7q00OO6rnMo7TvwoTJFT4Fff6
         3SpH7tuYA3IztP7YK1+tCHbJSaFiUKk0Nm2IJG3fQM3rOK5Xo30wIihC9DBhYbJC7nx9
         7XdAY2YYx1yp+cPuhybBbOhc1bcdPVJVuAbB+o0FwM4CJPIm40RtAO9+ehmBk6uGXZRc
         PvM+ycfqb2dg1/j8whB6fyc3AWfbnPPsTZC9WFwvAo5MzzfDCYSpor54eYC1g3NFqwwE
         IjKQ==
X-Gm-Message-State: ANoB5pl2VNYZp5wuhSEGABELuVh572VV5ePaCT3MDwN40LIiXSMDvwSw
	Mk2//PysEl7r4wEz5apmD+G9zg==
X-Google-Smtp-Source: AA0mqf6uTZ+e6jCs1WM/4Cf7QSikBIfgshTVvf1Bodz84WQeHECU3VgpoGsYu5W0f68ZVq2P5icfQQ==
X-Received: by 2002:a9d:178f:0:b0:66e:6f72:dea2 with SMTP id j15-20020a9d178f000000b0066e6f72dea2mr7866951otj.30.1670872005662;
        Mon, 12 Dec 2022 11:06:45 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id w5-20020a056830144500b0066db09fb1b5sm258171otp.66.2022.12.12.11.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 11:06:45 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 12 Dec 2022 13:06:43 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
Message-ID: <Y5d7w5OMUtKz//jn@fedora64.linuxtx.org>
References: <20221212130934.337225088@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>

On Mon, Dec 12, 2022 at 02:15:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.13-rc1.gz
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
