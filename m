Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A749C2DD
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 10:32:27 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-44d3a5cd2f9so1676895137.3
        for <patches@lists.linux.dev>; Wed, 23 Aug 2023 03:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692786746; x=1693391546;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ThXAIByqVCkfjwracUVqooFzKpe/zsTo3REPCd68fCI=;
        b=IVnpF8gxq8Txsumh4crzwz78XaQgk13drDB1Yzp+MPPMJlAC7Lo8gprin2HuS7yhv/
         5gpJJClDCKpZxseorxCy/Zo0imkzlGpiC7iXWuXlh2xqfhRp53DIEx4MECW34K37XzRi
         zxxbEt+02rGrTCyG6cf8ztdL7DplQP7qodl2LfANPkLvCnHW6pbgl8ppv2f4GMnB4Ljy
         mpRtF86GyF0l7IOD8GXxWkuC8XVXK7bObya7XA+OVCKpiFy+hcEaTtD14RfjCXXZf1FG
         YLFeIi/09zIyuVrLditZbbOBX1hT88Eu2rY5azMlXzIdPdTNswARSpeBNVM9exV2L7Xa
         fVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692786746; x=1693391546;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ThXAIByqVCkfjwracUVqooFzKpe/zsTo3REPCd68fCI=;
        b=RQpG2P0aFyOrd0y9fiKOo8Sgpq+/B+PXhme1rrjV7DvBiWOKitS3Ole9c1n8gKwu7F
         cAtkDgtlk19XaZf40Q+c3cG1FdCpnIA9jjWLb/jbjZDrhdyg22eYXgaBS+KF+rkRxqxM
         eft/Bfym2hVQwjCWO19RYCF0oiuJQlm31QJsj/LT0B7kolkDxvCFpIIn+kD6F1KkRVbf
         Xh400/CcQ6Dt8Uvjtvag9yzxIs2hZmQ+6uW+7jg8p78AKq6KnpXxjhNgoPp3jNNGqdl9
         B2Ot3ips9iZVrxJViu+KrbiKk/T1fthkqzW3CiDGhL1ZGTjawr+tRxcOjcb3a7EaeJ+e
         ni/Q==
X-Gm-Message-State: AOJu0YwyTWrsAzLRPzSksi14IlB7fQl7wnoa3uYk4d4K1y8U9dKzXfqu
	qpTNgodbPlzDiTlQLMhJim5tAuYC5MQy+n9fRBjlWQ==
X-Google-Smtp-Source: AGHT+IFXiNEHNeIm0I6eRoH5Vo6bgJn8WN/p5jAXu3EpULJukA2e8vxhilxq9z+tgd0mxAZLPhg27qavDJr0SIbrQWI=
X-Received: by 2002:a67:fb0a:0:b0:443:4e7d:c8db with SMTP id
 d10-20020a67fb0a000000b004434e7dc8dbmr10239104vsr.2.1692786745997; Wed, 23
 Aug 2023 03:32:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230821194122.695845670@linuxfoundation.org> <ZOXJVamgYV1Mb+7S@debian>
 <2023082303-musky-plastic-335f@gregkh>
In-Reply-To: <2023082303-musky-plastic-335f@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 23 Aug 2023 16:02:14 +0530
Message-ID: <CA+G9fYvm-7DPuA9kAF3784DpW4BmAXa_+_NW3AP_919_UND5-Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Aug 2023 at 14:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Aug 23, 2023 at 09:54:45AM +0100, Sudip Mukherjee (Codethink) wrote:
> > Hi Greg,
> >
> > On Mon, Aug 21, 2023 at 09:39:39PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.47 release.
> > > There are 194 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> > > Anything received after that time might be too late.
> >
> > Build test (gcc version 12.3.1 20230625):
> > mips: 52 configs -> no failure
> > arm: 100 configs -> no failure
> > arm64: 3 configs -> no failure
> > x86_64: 4 configs -> no failure
> > alpha allmodconfig -> no failure
> > csky allmodconfig -> no failure
> > powerpc allmodconfig -> no failure
> > riscv allmodconfig -> no failure
> > s390 allmodconfig -> no failure
> > xtensa allmodconfig -> no failure
> >
> > Boot test:
> > x86_64: Booted on my test laptop. Warning on boot, already reported by others.
> > x86_64: Booted on qemu. Warning on boot, already reported by others. [1]
> > arm64: Booted on rpi4b (4GB model). No regression. [2]
> > mips: Booted on ci20 board. No regression. [3]
> >
> > [1]. https://openqa.qa.codethink.co.uk/tests/4765
> > [2]. https://openqa.qa.codethink.co.uk/tests/4773
> > [3]. https://openqa.qa.codethink.co.uk/tests/4772
> >
> > Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> >
> > --
> > Regards
> > Sudip
>
> One question about the warning on boot, all still works afterward,
> right?  Or does the system not work?

The warning while booting and root login successful and
LTP and other test runs are successful.

- Naresh
