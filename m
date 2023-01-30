Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5CD160
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 22:57:34 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-163ba2b7c38so5351297fac.4
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H4C3LLRe7XudZxVhxF9djT/1jzCGZdm6sY4sPImvKLY=;
        b=C5HOxKzbKCXsAxmhxxStBrxA7KmKH5sorHz15rcY/lnCedBwFHiEl+vphFvneNyL+F
         Atc/qUJx4oN90L84rpFKpJMDyy/k/dSYdHB+FX0Z49nYSU+z/2lgSfllfG46LFbYfQqQ
         I8mRCuZWWL845ITNtKlsGDOydPj6zB1VzCSCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H4C3LLRe7XudZxVhxF9djT/1jzCGZdm6sY4sPImvKLY=;
        b=GwAz4bsCsUnCouEGvIaxL9ApM6U9ad3cjfVw/6YFb57SzFyA/1SvHWqb2DObeLLHp6
         UfRuzWq6Dyx8Wz5dc1NVj2BYZGMCKAhdSRJ2Uv60MtaZPvu1p9l4s6Uj2VRedNFD39LX
         bOpg1Mys7Rs8pK6hA4le30W05kPnVaKD6UJb6HzmWrDiMWr4lx5UqgTMi2mqrWNt0lMd
         5wpx1k6BZUWgWC6bcdBAdZdAK0jCKsLrYVwjo/ySJXoWs+KIXdEOh13EsyBbGX2ghhxy
         dr09dkLfKYrrE227gEm9Ua4X4TqDZdy6vvjw01EDlfohrq0A3GnABIYYJB8IZkMpFRjI
         sUmg==
X-Gm-Message-State: AO0yUKUAKFW6dqX80/FVKTOWAQ/Ic4s93fn2F9icQIT02/nlKQexdnNi
	iE2hC5ZFycWWEr2qQY47qWOsgw==
X-Google-Smtp-Source: AK7set8YyE0Ax5BBAeYzcYcOqGbn0g4cxVDxl7J238q/i8urKB9VuhYDVNT0IzxlWYf6K7hppB1Jpg==
X-Received: by 2002:a05:6870:20d:b0:15f:1c2:230b with SMTP id j13-20020a056870020d00b0015f01c2230bmr5569641oad.43.1675119453368;
        Mon, 30 Jan 2023 14:57:33 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id nr9-20020a056870dc4900b00140d421445bsm5769855oab.11.2023.01.30.14.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 14:57:32 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 30 Jan 2023 16:57:31 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc2 review
Message-ID: <Y9hLW3Rl8b8iMS7D@fedora64.linuxtx.org>
References: <20230130181611.883327545@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130181611.883327545@linuxfoundation.org>

On Mon, Jan 30, 2023 at 07:24:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 18:15:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc2.gz
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
