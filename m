Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEDA110B
	for <patches@lists.linux.dev>; Wed, 26 Apr 2023 01:47:01 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-38e27409542so4615105b6e.0
        for <patches@lists.linux.dev>; Tue, 25 Apr 2023 18:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1682473621; x=1685065621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ZsskTH5BhlaFFaEUUgbGihRjISLqNevqRfw2SlM6dk=;
        b=KXn5qYVKMdtOdTO4P68ZvepK9XiPUB7jDwoQlDGOEOiJ0de7TrRx7it5k9knGL5HmJ
         1F9UKdPzL2L1peyYkIO5AkUmWMWeJIDCBxVNCPXO2ZsuDgWbwQzn4V4Qqu/37v68tiqx
         KCF1p2hFO71VaFyeSynXu7Tz8ybtYfOCknL7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682473621; x=1685065621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ZsskTH5BhlaFFaEUUgbGihRjISLqNevqRfw2SlM6dk=;
        b=f0J8QdMe1WeANMK7tFI0foBd+qRJ97mPW1N8rBYDoB1WwjQd14awNKI2oRNdPTf/mQ
         vGOlWbyP5ta23SoRtjBWHCK+edrk+OSo9AvGkpkBymi6n3Vodd03lCzj8zn/cxylmdhR
         7OK0cS4Nf5rzu9F91JzIeA+8iLzrHVPmh5LQ90f0fGYwd33EGSJWUFDdb5TfMSnMnyHl
         ZsNJcTzyrxfIcvCmTn1W7ytT/+gdnYTBk80TDXBV13esUjFsHPHAznD/0SBmILVmRu9H
         hv4l4eF95nYoncCXzc2tXyNBPZY6aQ1bXWXyzEj2Oo4iL7QwxiRC/KdsoA6RKfHVc5Or
         TIug==
X-Gm-Message-State: AAQBX9fa7AGb6foiCTh37KH0JR3h8X1dNS18wYayoz08Sg9+Nbf9lSHT
	OUuJfY7Akeh79QgwFibAEA7cyg==
X-Google-Smtp-Source: AKy350Y/k8gNDuC5ESi/KZW7Z0umdtFs+W28PYRjoB0A7+wtl9gzKvHW8TA8ZqeLvwKUclvLiZJuwQ==
X-Received: by 2002:a05:6808:2389:b0:38e:2993:be7f with SMTP id bp9-20020a056808238900b0038e2993be7fmr12170976oib.38.1682473620818;
        Tue, 25 Apr 2023 18:47:00 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id o189-20020acabec6000000b0038c2e1bdf2asm2844138oif.36.2023.04.25.18.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 18:47:00 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 25 Apr 2023 20:46:58 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/110] 6.2.13-rc1 review
Message-ID: <ZEiCkmdPVfkRzwkq@fedora64.linuxtx.org>
References: <20230424131136.142490414@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>

On Mon, Apr 24, 2023 at 03:16:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
