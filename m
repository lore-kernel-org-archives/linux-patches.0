Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26D52C9A
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 18:34:50 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id e26-20020a9d6e1a000000b00694274b5d3aso9495061otr.5
        for <patches@lists.linux.dev>; Wed, 08 Mar 2023 10:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1678300489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6HXu+zn3eatDx7SiKI+A7GuE649xBYJGEVkrHC7L8Zs=;
        b=iYqDVfy0UzImC//dOpuGVlY3DI6nDDqsO7KE3PQ1VTx8a637g1OJAfT20rs8PeGTwx
         AzZx6/g0Pgp/WMA9MeqWBNcjUPQP/1+QRyZYM4vTwExf2xTfg98q8Du9/oqDRF++m6ID
         CWip04CouQ4kvgG32aI43QtdqAbPC7+2YDdSQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678300489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6HXu+zn3eatDx7SiKI+A7GuE649xBYJGEVkrHC7L8Zs=;
        b=aDBNJ0xsdhUV3mWroB2aQGzfepaiFHKkcFx3fDCOQPaMWyjRDd8K7Qg0A2FWsIuwT8
         6sjVihsaO2QbvQvnw6A+2zokYsooQwltFui8wbkpykcxp4TG8Thsp7t2JfcIuPvqMrkb
         bzV4wN8q1AZlvrL8ndcYqWnq5dl8bv4O1yNO5B0GjzDd1xQ3nnpwYAi52iHOXlxVKS4T
         rSycpLnmzzRiaKhY9Zr/NFJYdUHvtW2rJ22a6pSvJem10qvkdAXNq31Y9rm02BMt7hIi
         PCMa6BJ3OQnu3JEO6m8UViRWAtZTe+ZmSa4FPr44iaUm5wWUGManpENO1EquL4Y53Rft
         VP/A==
X-Gm-Message-State: AO0yUKX/U1QaiFPR9/BSNpZS3EIugzSiGcXXceQ4qsDH1YAyrWj88wdP
	fjEeDGZ688e1hpdRlrVJDO30mA==
X-Google-Smtp-Source: AK7set94m1RyIbOc5A8vmr28QhexJdFoJQqMmbmsL/+zIeZ7bAG7RZtVGdu2zfe8Qzq0/gOabCUV9g==
X-Received: by 2002:a9d:610a:0:b0:68d:a0e5:d31f with SMTP id i10-20020a9d610a000000b0068da0e5d31fmr8643186otj.3.1678300489667;
        Wed, 08 Mar 2023 10:34:49 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id a16-20020a9d3e10000000b0068d752f1870sm6730328otd.5.2023.03.08.10.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 10:34:49 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 8 Mar 2023 12:34:47 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Message-ID: <ZAjVR1XpOYVZSMDh@fedora64.linuxtx.org>
References: <20230308091912.362228731@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308091912.362228731@linuxfoundation.org>

On Wed, Mar 08, 2023 at 10:29:21AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1000 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
