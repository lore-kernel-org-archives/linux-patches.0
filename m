Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6226AAD27
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 17:51:08 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id h14so243120plf.10
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 09:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G41QfMy0gPOdytQyepHXV2zo+vejMnYEhBKv7ZyIXik=;
        b=OW++KfGrEpGn8vfPq5A8i5xDwR1wegEp10vqA2beJ0n38XGSdpdZcqGu0X2rVQAwwY
         3IKYYXXZLOQEm5t0q4hhnw6F0ultTbpUgxpQ9l5HJ3ZgyM3aDsLjs7/Sxg7Ptq8iND3u
         +gQ3aaJc0gYc/o8GIj3EwijUYwxHy51GyJi64mBMnB+Uc2X/2wOxhuRtzoer6ApXVymW
         ql0VLO7ksuxxCQKCkdRpoark2JDbFogCsTNYlgubSlNcKK+6u5JMbIA99Ydtx9VfMCWZ
         POD1mEQC3mqCLnlsyYjTvidu1kw6jYWPKoPSyxOkwiYdQcj1GXNSfcBMPQWMvj9KlpaA
         Z2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G41QfMy0gPOdytQyepHXV2zo+vejMnYEhBKv7ZyIXik=;
        b=ZkC5BefGRS0utQcjVLfYVuMoTQE7e0zSgd5z5yQx1p5gwWjnWtMAojlPTPU5OR9WnJ
         hN84OMaNZWFSUus8AabbIAAIM32cu8erEAlkvHVj6QWhpZnQuJ63bD4N4YKiYxbnB9Pn
         7oEcMbeqt4dJPKaibJ/h2z55l3JE/2LPv213gWKB5vqPFxnX6XXHZ6myKxdIliACRbPj
         Q1Pa14HOHxuwC5ZGypnkaN2MbrFJGEvj7k/9s1m6d+LxCcze6NAkU198bdlJNnbshq9x
         c7+7FNoB31UVWhUR/I8j0XmjM1ppOUDpqpmTLswtl15O1G9TKa5MxKZBFd8oNkVGiVCs
         7Bqw==
X-Gm-Message-State: AO0yUKWYLlFi1Y3xPPN1dQ/tHTfFo0VDRuwCyv96xWLJEITjkXR9T/7a
	snwFqz1nWYMj8JkQ38QdlZDU4QCWW9eOWLIyCjGa4g==
X-Google-Smtp-Source: AK7set8nd4ezLLCXVyqp2V+Mk/zCMObyIQmnH2HaXse63lHEHcKMPICs7gsTVmOJQoO1EkC22Z46WSTvGy/21ivZfVk=
X-Received: by 2002:a17:90b:3e8b:b0:237:ae7c:1595 with SMTP id
 rj11-20020a17090b3e8b00b00237ae7c1595mr270796pjb.2.1677261067487; Fri, 24 Feb
 2023 09:51:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223130423.369876969@linuxfoundation.org>
In-Reply-To: <20230223130423.369876969@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Fri, 24 Feb 2023 12:50:55 -0500
Message-ID: <CA+pv=HPhxmBG37wsjeem80bAK9W9wATO4DbXx09JHHLYHSVnwA@mail.gmail.com>
Subject: Re: [PATCH 4.14 0/7] 4.14.307-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 23, 2023 at 8:04 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.307 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
> Anything received after that time might be too late.

4.14.307-rc1 compiled and booted on my x86_64 test system. No errors
or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
