Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43460AD26
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 21:22:14 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-17213c961dfso16562579fac.0
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MR/wZWU2MfoFRQ1v+7cKSnHFZsY23JIISa7d2BB/xDw=;
        b=gnlm6qqm+pKeTnQUt25QkCdqaKjsMqxEzdxBT2onwFCGeeoU/RX6AiJvOKSNz2vu8t
         WWhTLNa71MwiwFbPcOsojyIOB93o/chFjDCOZ5emsnliYFtutOOIByme3ZvwTfS7pNi7
         1QzSQu7H5DuoLcGgRc3x35WvnGW6ZXRYykvXs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MR/wZWU2MfoFRQ1v+7cKSnHFZsY23JIISa7d2BB/xDw=;
        b=Wb2qr8ImwNRQ8Iyv4e4nICUamg7mDnmM94lxf2wqJ/X/nvOupGAjGNIUPjbET8c8BL
         Z0eAzg8JkPpdLJStDKTQmJ4kmJAqjnqLXr3v8T5BkDrEtneqsCFYoBphbIzQYBzwCFSy
         6bkOtKyqKqTAjLchjkTda5LwyfBd07Btjl2VFBNX+acG+3N5V3JQ9cou93tLV1cZyJ54
         NkQCPk+jlYwllPkPBiNj9EdiVtcsvsV1yk78H1CAnKSbfux7W7Ir1pELB2LZZBKskzzp
         T35Nxyk8nHNoFvcltDfYrRdmmkig/Bq18KLSvzBNG4fVQSNni79kFf2pPW+fEk0+Qytz
         DqfQ==
X-Gm-Message-State: AO0yUKXIKpe57+yF+fHiRTv9CtFQWNXAns6AZI8Rj06eyZCfIN6l3JeG
	5ck9LvgYWOThzyByTAHsAd6Ebw==
X-Google-Smtp-Source: AK7set/sNTT/yVsjpy2r6Q45tjgpi4iYIES3szcYTXf/crw9zO/9Jy3SH3xCxYjDgrQkEB4gcdy05Q==
X-Received: by 2002:a05:6870:b529:b0:172:1f39:2b9b with SMTP id v41-20020a056870b52900b001721f392b9bmr7747035oap.44.1677187333019;
        Thu, 23 Feb 2023 13:22:13 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id dy26-20020a056870c79a00b001723d62f997sm2386066oab.32.2023.02.23.13.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 13:22:12 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 23 Feb 2023 15:22:10 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Message-ID: <Y/fZAqSWZOpL5xPZ@fedora64.linuxtx.org>
References: <20230223141545.280864003@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>

On Thu, Feb 23, 2023 at 03:16:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
