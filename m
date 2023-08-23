Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FA3BA27
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 14:38:12 +0000 (UTC)
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2b9d07a8d84so89350591fa.3
        for <patches@lists.linux.dev>; Wed, 23 Aug 2023 07:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692801490; x=1693406290;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f1+ZllnE3NbofBa3yUXNVhhtAoB7pOoNIr9xPlAL2nQ=;
        b=F9Zz1Q+FMq1u5azSJ78JrOh/du6sYU23KN/am58NG3uX8jVDJvqJjviC+cKhkemZCO
         1M83BojLnh/YGm/VTde+j+ZwzKgYbthMKufFSf8gbcMCYplecIOyKrII4aYMDwPMoY+4
         r2SAukydHxtAnGhBSDAreBzt6odrH9XKeWLqna4we1ja3ij1+aoOtnQoEKiKopD5JOn+
         ZIsU9kQgL7OaOfb2VEOWOonR+5BQvKnQYmjTQK8hUQnYJm6j4FoithtSzTOxrkgUrhP6
         fEH+ZAWjTzXZgu9VANl5mE8Tg7i1AotWQvfCh0oD8QHTh3AJOdRU/bBifC3W7wvgAyVG
         rDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692801490; x=1693406290;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f1+ZllnE3NbofBa3yUXNVhhtAoB7pOoNIr9xPlAL2nQ=;
        b=LLxRfEHvjR5VyY4FIryGAjtLYOvurEo4H/D4X0ub0Hol33AGK2SEa7vM3Y+U+vDtqt
         VSIC4nFi/yTiHoMQWa3UTnxNsszFzO6tf8rfSAf0JgRxZkSpCZVjy2gvvEJ5xtu1EBsy
         yPwLwGQIQ9rD4rfCWoRAESuwmgOaxNAid4gbihIAZ/uFT5PczwVNB+3ZwYzEztMzh6+q
         cPhzmNs7w6eMdqYGmpqvW4ddc89ecfnV/SrrYyDdc6xo+GxKhCeZ/P3smdj1rc5CtsKt
         l1fo0JB5LwhsLFokPeGYAkfIIR54OK4BMFPpYLBkYfUZB8ef/6PMJKmBEiv+I+YSeZa6
         wMMw==
X-Gm-Message-State: AOJu0Yzec2ysYwEC8FYsV8DsiFToGPbQBmyTjL95mpOobtZjugI2iRkc
	QB7ycc2oYZW2iDPNZun2SUbh8ygOMcrL4HGBwC0=
X-Google-Smtp-Source: AGHT+IHpt8TANhM2/9N/N8ppybLLJeWThUz4SEZ2Rh9Ro03P5XDBnf0PiL904TERN7Cywz4PqqO/arp4oPjTXdlgXGc=
X-Received: by 2002:a2e:9649:0:b0:2bc:c28c:a2b8 with SMTP id
 z9-20020a2e9649000000b002bcc28ca2b8mr5711315ljh.27.1692801489970; Wed, 23 Aug
 2023 07:38:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230821194122.695845670@linuxfoundation.org> <ZOXJVamgYV1Mb+7S@debian>
 <2023082303-musky-plastic-335f@gregkh>
In-Reply-To: <2023082303-musky-plastic-335f@gregkh>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Wed, 23 Aug 2023 15:37:33 +0100
Message-ID: <CADVatmMDcbkeo3DLog8TRQ2BNbgN=DzK6=OgfB-eL-Ruchu_jQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Aug 2023 at 10:26, Greg Kroah-Hartman
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

I did not notice any problem in testing after boot. Only the warning.


-- 
Regards
Sudip
