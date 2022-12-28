Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE8F2586
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 17:46:03 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id j16-20020a056830271000b0067202045ee9so10216559otu.7
        for <patches@lists.linux.dev>; Wed, 28 Dec 2022 09:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hktmi1mDWEQ8qwdg9mZzks2OK4SXe1q5Hw3gXYtRiT0=;
        b=efYaS8Fb6JfjjHYihQk5LcbjU38l8jbbQiDioE6MlxNVntrWk2F9tskuUcNzcAZJ8F
         GRX7cgEVBnjRmzFE8vJMdXx4+3Q0zG1GjArOxpwb2M52ewTUAX5xsKbGZWOJw2MqXr+j
         15HQ8Q06QRJXrt0Qquj0whAGUf3zETIk9nwdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hktmi1mDWEQ8qwdg9mZzks2OK4SXe1q5Hw3gXYtRiT0=;
        b=EvkF8yYukanMbME1h+mvItLIF20wweejpuAwZJAM6bm9Ykzz7eLWaKwTkFPoVBWewM
         JAf1javufa5FT5Ih0m9uxRQ7MjK6muOH6wY0ICmZmu8ZWV80KrQHL2AAoEf9UBrP96tN
         9hDLriyfVVfQ3ajDVsq+lYcd+hzkFOlag8P2764IwMz96HdOkQO67/YlifCnNoQsQHA4
         /wIAMHg1qn+05SDwf+mUmpfYhrY6s8MSWL9amHgIkxGFLUkhxhGbbIrE2iSrBIQIIQZM
         YeMNGn0RhV1Pg09atovpJ7ht6bjPDTIpWDJvrvfky4pyZVAPF5o6ZOG5fEF5BA9epv/q
         s1dQ==
X-Gm-Message-State: AFqh2kqApTrcN4PQ5Ix/VIVaR0xtzKaOSkhzIbMdmf8kpBcX07Ruy3Rl
	308SwiZCTPs6XGb/fvu38eCbAw==
X-Google-Smtp-Source: AMrXdXvG33jK51PPCn7jtwiS4DBfA8WEOTNGAGMmunkhu3PBsPJwaoWBVocUK52y7GkmHIMBx1l1jg==
X-Received: by 2002:a05:6830:562:b0:670:8270:1292 with SMTP id f2-20020a056830056200b0067082701292mr20257024otc.4.1672249562148;
        Wed, 28 Dec 2022 09:46:02 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id e26-20020a9d6e1a000000b0066b9a6bf3bcsm8016802otr.12.2022.12.28.09.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 09:46:01 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 28 Dec 2022 11:46:00 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <Y6yA2Pc+9xBjChlQ@fedora64.linuxtx.org>
References: <20221228144330.180012208@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>

On Wed, Dec 28, 2022 at 03:25:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
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
