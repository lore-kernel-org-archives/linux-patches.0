Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178A67E9
	for <patches@lists.linux.dev>; Thu,  6 Apr 2023 02:47:00 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id ja10so36272495plb.5
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 19:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680749219; x=1683341219;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uHA5gOYuEN9+cwpsK5Jf8OpixnKs1IAW1nJs78pOjkQ=;
        b=hCuWgBHIPql9uxthjwmU6uWR1K/B6v97ekkhp3pbSOLqrD6lCwKpLhl1smWtki1AOM
         K80q50qliBzAoIpFx5etvmQgwsIkxWot734Z/EJMhPtmwqR9qAllizzBJc1oVlW6FfN4
         nQfrTdX4gugjLklP97/XBJOuVBDOuW4nuDvQUdbct5ytmLxoXB8ImKfwXAKLphTZocLL
         Ew4d57p6eH7kzVfl43WQA4E5BqD2LDC6+y/yGmPdsurHXGiGer+Nh7q2WNcYyA4PNS1u
         Vw5dMFgLHNj5YFp/A/VR+ZeBwA4PQPb+xBvcondGlK7kc797voNokVLIPbc2f2zt1MG7
         vpRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749219; x=1683341219;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uHA5gOYuEN9+cwpsK5Jf8OpixnKs1IAW1nJs78pOjkQ=;
        b=psr7oyFN9FAP9TN3fj5vmsbKbPcUHmTzlXB8ACV8SukCANVR78bqT5aB8FQWto8qVL
         3sYefIKKXue/ijkAriXWVrlMWu04uu27weHMSnOgJVoDZDpb9SUDA3QHd/bB5z8+Crjo
         MF4T98umpK0i3YG6gfpgf6r8uJlUgem5j46eibLbbQr/m+9gj7yGhBrSVgGklzCIsYml
         BpsKN67Vo+P61M7xQNGItSSuWOchGiWR60PrSzf9HrD3EbTtuiyW4D6Fvmr13bKMf5fU
         oL5AXvzEfhY4ri62kkwR1Ll2dLadUvG2+qQ90TQPLsbtPoYcBcgUfuZjviZRiwP4HZVj
         P20A==
X-Gm-Message-State: AAQBX9c7yFI47dNCcJCbARnhBupMxL/jcRe6gxfAoYH9jMlcrlzzx+bN
	oI9F+aPBKH/WmsCzFy0DOtrHs0G8i6CDCB9MTvsSkeearis=
X-Google-Smtp-Source: AKy350b5Hyez+XCFm4zwuGJSvWVUJWRnBYp0HXwmgeqw2yrQga6spQZbhjMTWPgRiJrPWfSVykUmADgiGMmDap/makw=
X-Received: by 2002:a17:903:1c4:b0:1a1:b318:2776 with SMTP id
 e4-20020a17090301c400b001a1b3182776mr3653414plh.0.1680749219607; Wed, 05 Apr
 2023 19:46:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230405100309.298748790@linuxfoundation.org>
In-Reply-To: <20230405100309.298748790@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Thu, 6 Apr 2023 08:16:48 +0530
Message-ID: <CAJq+SaCeiSguHSztp_ufOeK-QKG--LAa_p+j5hVKZJLkPvcZJA@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/185] 6.2.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.2.10 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Apr 2023 10:02:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.10-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
