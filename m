Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39CEC2DA
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 09:34:10 +0000 (UTC)
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-4871e5dbe0cso1085455e0c.1
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 02:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692956049; x=1693560849;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NkOXDPx/S3uX0LGrWHhqDuzgnalOjRvvuzfXBDquIJE=;
        b=ukX0Pnuivh/o6xISkXG2MwEK0o1GsQV27v/wL8PCYr3K8rw4rCQ89pL5zDucAFhMcb
         YskOrO04SlvsfelPwM6wi6bo33kueI9hAzLSHaH+rO3C/KdletWIMPRTOYoAyAI3o5Bb
         gwe8YbDTEL9VB12BM6LBCliW9FWhwvSr325DZcjSigPSeB9JpebjY5rhdU88q9fnhEcr
         bO6YXtDqCkq7TIBUj7afnMs8Ik0gKHvbzTGASsEDdGmUvf5tgRjCJeHx7rzEZgS3e+cq
         5wBCW0y7FKsG5YGqd1KFGnDwwJz8ywHAaQLG/7SL+2BGaFhCrt7m2jYp93piNMTJfTI7
         5ZGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692956049; x=1693560849;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NkOXDPx/S3uX0LGrWHhqDuzgnalOjRvvuzfXBDquIJE=;
        b=bSXQmU4vzGutHHEOs14mXvOcieM0li9xC6V76r5gNYEGkrp0SUexTbK8N9oJX34VU0
         GgEmt0P+ObO9NtySDzOt/yW6FQYUoW8m0y/hGQw8de77gkv5GIVgyqqcEzogCPBRRXWH
         3EXa8QxOIZejXHOFZeZeNJM2WTuG2aHuMJ8/niOVvkZAI/8F4S6q5d/VxnukzSxg8YR1
         3bMLKtHbMZco0PTa7iDXBO7ZBewy9STpVVmDhjRF8WTMkZ4qcn6OCreKu5h8ULglbw9h
         IIM0AybXSb8ZRJlcd7OGvLWmakafb6bH2kKHY4ZU0y8DhMs7JyYyDkGPuGcix/SUUK97
         /EVA==
X-Gm-Message-State: AOJu0Yy6ysaK9Z+OgV9BmIfVubRnILDc62GGGGPeN5U38ASURLz25oIN
	zCpt5x0ogWQMRC3pwQrcYZnlGsMU9EraKyB1NC8sNg==
X-Google-Smtp-Source: AGHT+IHYxHlYu/b9jq1hZYwDJBTUYSSDdzBlVxG6txEHWSCkNIMRdBra+qgQir4lLTbNjKOfAbjN9wZa5rm8CXm04BI=
X-Received: by 2002:a05:6122:2527:b0:48d:969:af8b with SMTP id
 cl39-20020a056122252700b0048d0969af8bmr10536527vkb.1.1692956049376; Fri, 25
 Aug 2023 02:34:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230824141447.155846739@linuxfoundation.org> <CA+G9fYsPPpduLzJ4+GZe_18jgYw56=w5bQ2W1jnyWa-8krmOSw@mail.gmail.com>
 <2023082512-amusement-luncheon-8d8d@gregkh>
In-Reply-To: <2023082512-amusement-luncheon-8d8d@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 25 Aug 2023 15:03:58 +0530
Message-ID: <CA+G9fYsxAgRcvc4G_mU2LW+bw3aUVgTNGd+zmkhkoaXUsWv67Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/15] 6.1.48-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christian Brauner <brauner@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, linux-nfs@vger.kernel.org, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, Sherry Yang <sherry.yang@oracle.com>, LTP List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"

On Fri, 25 Aug 2023 at 13:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Aug 25, 2023 at 12:35:46PM +0530, Naresh Kamboju wrote:
> > + linux-nfs and more
> >
> > On Thu, 24 Aug 2023 at 19:45, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.1.48 release.
> > > There are 15 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 26 Aug 2023 14:14:28 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.48-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> >
> > Following test regression found on stable-rc 6.1.
> > Rpi4 is using NFS mount rootfs and running LTP syscalls testing.
> > chown02 tests creating testfile2 on NFS mounted and validating
> > the functionality and found that it was a failure.
> >
> > This is already been reported by others on lore and fix patch merged
> > into stable-rc linux-6.4.y [1] and [2].
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Odd, it's not a regression in this -rc cycle, so it was missed in the
> previous ones somehow?

I have re-tested with newers and older versions of the kernel and here
I confirm that this is not a regression from this round of stable rc review.

We have made a couple of changes to our infrastructure and are investigating
the root cause of these two test cases failures.

- Naresh
