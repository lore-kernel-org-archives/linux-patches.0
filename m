Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89127BE5A
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 13:42:52 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3a76d882080so1289788b6e.2
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 06:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1693575771; x=1694180571; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6QiJjiczVQzfiFfrC5WsnaxKkl4rh7lmVtRGz1s0SGU=;
        b=Eq+c2oYji3zWdhRXYb+L//2FNsroBpp1cJZ4PnGgrtHMgf5yqJCW+o30lIWCHo41TL
         vJ9YxCXtVIR0U87T29urf821/un7MgMBlMzeWaYS959mduzI91Dwzr0vCPnyE0U1u/cQ
         6p0unZW9M9Mk8KlCMHEcPnd06aErcQEruj5U8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693575771; x=1694180571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6QiJjiczVQzfiFfrC5WsnaxKkl4rh7lmVtRGz1s0SGU=;
        b=AjsTPxnRaC/TdI6SKuOx7Gaa2Ge2y2Q4A6lzxZ2soOwtuJsDVaJrJoDG0HpXmVfK25
         Pln+zl10/KQp0I7f2vyxsGq0gsQIF+Bc6meZNA0p5IMo6gYTe/aO42Vyw/tO/V3SSuJB
         CymN+PO8+sirJS5ILW3Po8JWQXPSbRQKPbzJ5z2LmdpRN6gfmS7cfAeuF4fGX8HeHDo2
         cCEWIUaZd393WHjMGaAx3NeWWNuIvhT2cSh79PdZBOfAzDvJ1G5pjw2ByGdqchwZ8Sbp
         ia6UOo1U6Vl8u8+7gHdMLGq7XxLY5Io3dcyV+oj48kRHge6wzh720FPUnIvVB4KzRuUJ
         4JtQ==
X-Gm-Message-State: AOJu0YxucFCS2Wd4rPoi0wcembP3vBLz7/tT0KZq21XWZiRHs38efeLT
	hkjQ1/a8BHMVmuSr+uc5zwulHA==
X-Google-Smtp-Source: AGHT+IHgLCqgzrPR0nVjpRfCz1D4Ao0Lpg7/VPmkRQkLqdf0hOcYBYEQBbZY2SmnCx+nsTqLWJwQbg==
X-Received: by 2002:a54:4d92:0:b0:3a8:43d5:878b with SMTP id y18-20020a544d92000000b003a843d5878bmr2481376oix.2.1693575771588;
        Fri, 01 Sep 2023 06:42:51 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id be32-20020a05680821a000b003a371c611f6sm1955815oib.18.2023.09.01.06.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 06:42:51 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 1 Sep 2023 08:42:49 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.5 0/8] 6.5.1-rc1 review
Message-ID: <ZPHqWUBKX8LNJ6DC@fedora64.linuxtx.org>
References: <20230831110830.817738361@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110830.817738361@linuxfoundation.org>

On Thu, Aug 31, 2023 at 01:10:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.1 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
