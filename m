Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCA37C
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 02:04:35 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 136so11959060pga.1
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 18:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BM+g2yW8tQwEmaDNgyw2ipzOWbVkTd7NC/d4eDjEaow=;
        b=XiETaPy1Kamv7cV3sL566lV6zGXthztq//TxWGhrCIyTX3LDlA3dd9yTPI880SU+vk
         2gVjUXQeMKRCGWp1DKgSfCgQLRKXU2Tp0YkkveXwAO+mYjzaFR0NRj6m0PkUniDTv+6t
         +uX83VZaEtxTKWc4Cb7ujEfSJigDcYvq53Ng4NJsgxkF5ABdo5EWRIuZEYhNgbqx9JOk
         nCmXB29GxouXPat8/IM545mXof6vX0pTA6SXy1ajToEeXNPPjMzNXdmZeuw00ZKeofTN
         2DvpareWVLcbV1mMPPryRRswJWD+siLQgggfJKbCxRUTmy7Wu7adPaRAIrurQce0bVZu
         8Elg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BM+g2yW8tQwEmaDNgyw2ipzOWbVkTd7NC/d4eDjEaow=;
        b=fdtgy27MhfHFrUKpbbqc3pMh2GIyIUH0PVO9d67hrsIfg9Ac384yTRAfwGG0ps5a0l
         0oNyXlaB5JGC+Sxe5/SQfApPr0LdVIPWd9sfFemdq+7okwOYdEUe+jBNlIFOD6Squ9Yh
         ajZDmwOiWXWDQfD0ISYgQntEwsyANcCKoyX2TFhC7nIlwihdaWSQKb6FO/W+raF/9L4+
         SutlfoMAeOkx6rqS9KDWt+0eDlC5WtJ5fVOGaygfxYWjZB1Sagpn/YJaYfuOcq9D8wIs
         2Zju9rnRGAJ0e0U38rjx/OTWZoIn/kmTnnwCL4Wn4cDepwXgI35krguzrrmVLk5AEwjt
         2sgw==
X-Gm-Message-State: ANoB5pmfDVJTWDuXXSc5cbyatxX7wBowBGNigB+2RkElodOL7VKlpzl9
	tThJFvA6iTv+Wa2ybVEMwjILvF6+L/ceb1qwSJE=
X-Google-Smtp-Source: AA0mqf5l8mX9I5vsR3m+80cKKvzc7seOVc1WKYFUsNxNP4aUZ5OwI1ibgUz/bFPlS7r0dkBzg53vMP+fRjDF512Hfe8=
X-Received: by 2002:a05:6a00:4186:b0:56b:d951:67d2 with SMTP id
 ca6-20020a056a00418600b0056bd95167d2mr16233532pfb.55.1668477875409; Mon, 14
 Nov 2022 18:04:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221114124458.806324402@linuxfoundation.org>
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
From: Zan Aziz <zanaziz313@gmail.com>
Date: Mon, 14 Nov 2022 19:04:23 -0700
Message-ID: <CAFU3qob7x7OnrcdkSi2B3UrDS74ONQF59GWdz+Nq0as7wEyxQg@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 14, 2022 at 9:56 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hi Greg,

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg

./perf bench sched all
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 0.816 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 9.507 [sec]

       9.507659 usecs/op
         105178 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
