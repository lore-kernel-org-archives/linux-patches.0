Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5592F2F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 12:06:14 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id h8-20020a1c2108000000b003d1efd60b65so7732476wmh.0
        for <patches@lists.linux.dev>; Tue, 13 Dec 2022 04:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gVubB98aC5su9XRgj6h31J9MjnV9xAN9J4GbCNVjdOo=;
        b=a6X/z4k4t79rIe7sQwvswoYBPhqCERNU3l8fZBlWHRzxEapq3TC8fiD7jPSIWVRnPP
         rbdS+9tnQpVfhprQyRbzqQZseu7w2XJe4SK6RZQfeZS2Jc7fWCK4niL7NstRzdacdpm8
         OST0JsKd3RKJ2dIq7DNXAZJf6MOcowClzlJwGGaqnCAr2p6ZKW8oMe+TSg9i8g6IR36y
         d+awhS87n+DlDZTrosCYGptguV3ey4YjPupDEuMF+xaSB0X18/ommGvrVj/h8+Nql/SC
         rsunzvB7nDAYhrI5Dg6tyCO+nSiIQWuqRlvkiBze3yU0Nz5LhFruUdlzQ8qyTu9CH/VB
         hpyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gVubB98aC5su9XRgj6h31J9MjnV9xAN9J4GbCNVjdOo=;
        b=vxrO1Dwr0jTdVindxxz/KRGrxJ3fHuHLPHF7wOrUr/xfFGYFF3LDFW0sRU5Kr6exHa
         bLu/jYW0ao+gLsB5tJwA7PpkipTQ/wVOReAvCjj4hfnKXy9zpknunwbBGX8sHuY1Z8lr
         zbu6Djwd9S4MWMZx1gzXUu1VEs4p4rEHOSrzTq6Pf5sfdHi0mrbc95V4G/vQ1sJB1SI4
         USFo28clFAo62IcXWuP3NZXr0MbbL5VZ0ypLOGPRB6npfIynke3axaGiGJY/SvOX8kqT
         Nl1hUPwnZYwauS3HroxVqYazh+j4F6nXOhE1sYxdefN5Z+lA+35EQMrHHHCOdjcx49qJ
         O6jw==
X-Gm-Message-State: ANoB5pm620BNjsuRstDcEflYtZdAwqq8JQKKuQoallZc9tuUirhEq4NW
	CNpNIzu2cs7sM/ZDAGBAlOs=
X-Google-Smtp-Source: AA0mqf7ruOX1+MBiqRj0uUe+3LlgQTYqSwR8fKMxdn8mBnTIsTKbbYK4cHWVmkXXdSTgJxctKo6Gvg==
X-Received: by 2002:a05:600c:538f:b0:3d1:d396:1ade with SMTP id hg15-20020a05600c538f00b003d1d3961ademr15464987wmb.9.1670933172607;
        Tue, 13 Dec 2022 04:06:12 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id o3-20020a05600c4fc300b003cfbbd54178sm3234923wmq.2.2022.12.13.04.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 04:06:12 -0800 (PST)
Date: Tue, 13 Dec 2022 12:06:10 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Message-ID: <Y5hqsggURI1Me1ik@debian>
References: <20221212130924.863767275@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>

Hi Greg,

On Mon, Dec 12, 2022 at 02:09:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

arm64: Booted on rpi4b (4GB model).
Regression noticed:
Failed to start Network Manager

Will try a bisect and find which commit caused it.


[1]. https://openqa.qa.codethink.co.uk/tests/2339


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
