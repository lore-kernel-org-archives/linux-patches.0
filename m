Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC288F40
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 08:49:47 +0000 (UTC)
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-49351972cbeso1793429e0c.2
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 01:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694508586; x=1695113386; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mD+MQJMeaBa6LFiT1hlKHLQpprHXSGsKW9Ny8S5q/Ig=;
        b=hNDnvsft/abc23mFNCJXVMhS8jDV3/gKESqSCqbFd64AG5uDzI+0bc32lX+exZ9kRx
         Q4w44swPBvhs3Sqo/AXd2/xO9dztJjtJHJeeWx1ES8mfqBCfsJPFgt9nj0HdixCb1WYv
         Nnj+bnqHBmzEFR81UGuxsvztuZTIbzaAwiTY1Qcs9xJfiuUBl4sDVaN+I9d3H55gQYHn
         iEX8h+Nol/1tLkx9+iNEB6dlDG12l39yNWRiXb44RAYw6soyW1GSnnoK9nfi1AHsVfeW
         dNmgiYY0rqv3CbOIDjyauIgnh21cpidg0YXX6SonAkX3hYsxVMkJkyEiVf7oKrjA0gD3
         7a8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694508586; x=1695113386;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mD+MQJMeaBa6LFiT1hlKHLQpprHXSGsKW9Ny8S5q/Ig=;
        b=Rut2U5IOGAENtGX0+3Fte8PFDhB/5OrWPQt5HPsBTRCXgZXekPpjkCsc0HKGV5ve3u
         fCwIJM50fGEI2d0mbFf2ZQPt3/0X9mexj5cwWe4fVYp1qgqnmQ9+pLN6r5J5UlQjkWyc
         3UmizoMbSTbOgazVeSpzz4xWxf+Co4Hvr3X1ua4bEG1Fd3QlkedY+UQs0x/CG7eb9Acr
         ntQeoY4OgSSKmY3yYhWMTQbRpf4KDP14AhyYRHgc77sDrPqOU1RC5dCZWD5P5XktB3zH
         Lgk/Yx1loMM38NcVf1uoxFMfDcNd8+c8XQ7JchnJ7vwE1cw39RU3FUEgCua/Mwj36Qv9
         NYgQ==
X-Gm-Message-State: AOJu0Yx6ycA3xfxjEaeBFgNpn2hLN/SzefkT9BUdRw+CUshpXtNjk8xz
	sRERc/XKhIwiAUWXA5Usgc+SUqDvxmktF9EjRW+Exw==
X-Google-Smtp-Source: AGHT+IElu424t/b8d80CYSFdFlzkKycfRWGMJCtpMumDMtu8yR2dpAVu6q4YzRxTCXN4YZLnuuutHif/fDOEVKbTSJg=
X-Received: by 2002:a1f:c9c3:0:b0:493:5363:d1dc with SMTP id
 z186-20020a1fc9c3000000b004935363d1dcmr9446089vkf.12.1694508586058; Tue, 12
 Sep 2023 01:49:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911134633.619970489@linuxfoundation.org> <1ffe4f64-f238-859a-ab14-7559d03c4671@linaro.org>
 <CAEUSe7_XA16yZAHA+YTbJygwaUYkU5gs=FnV9BAmQRYzwgVjvQ@mail.gmail.com>
In-Reply-To: <CAEUSe7_XA16yZAHA+YTbJygwaUYkU5gs=FnV9BAmQRYzwgVjvQ@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 12 Sep 2023 14:19:34 +0530
Message-ID: <CA+G9fYsiWEKSV0EeU0cXsJZ3U75fbdGyCmDx07ksFMUW5jouyw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/600] 6.1.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jack@suse.cz
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	=?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>, 
	Tom Rix <trix@redhat.com>, Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Sept 2023 at 07:55, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wr=
ote:
>
> Hello!
>
> On Mon, 11 Sept 2023 at 14:58, Daniel D=C3=ADaz <daniel.diaz@linaro.org> =
wrote:
> > On 11/09/23 7:40 a. m., Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.53 release.
> > > There are 600 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patc=
h-6.1.53-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > We're seeing this new warning:
> > -----8<-----
> >    /builds/linux/fs/udf/inode.c:892:6: warning: variable 'newblock' is =
used uninitialized whenever 'if' condition is true [-Wsometimes-uninitializ=
ed]
> >      892 |         if (*err < 0)
> >          |             ^~~~~~~~
> >    /builds/linux/fs/udf/inode.c:914:9: note: uninitialized use occurs h=
ere
> >      914 |         return newblock;
> >          |                ^~~~~~~~
> >    /builds/linux/fs/udf/inode.c:892:2: note: remove the 'if' if its con=
dition is always false
> >      892 |         if (*err < 0)
> >          |         ^~~~~~~~~~~~~
> >      893 |                 goto out_free;
> >          |                 ~~~~~~~~~~~~~
> >    /builds/linux/fs/udf/inode.c:699:34: note: initialize the variable '=
newblock' to silence this warning
> >      699 |         udf_pblk_t newblocknum, newblock;
> >          |                                         ^
> >          |                                          =3D 0
> >    1 warning generated.
> > ----->8-----
> >
> > That's with Clang 17 (and nightly) on:
> > * arm
> > * powerpc
> > * s390
>
> For what it's worth, bisection points to 903b487b5ba6 ("udf: Handle
> error when adding extent to a file").

I see the following commit is fixing the reported problem.

commit 6d5ab7c2f7cf90877dab8f2bb06eb5ca8edc73ef
Author: Tom Rix <trix@redhat.com>
Date:   Fri Dec 30 12:53:41 2022 -0500

    udf: initialize newblock to 0

    The clang build reports this error
    fs/udf/inode.c:805:6: error: variable 'newblock' is used
uninitialized whenever 'if' condition is true
[-Werror,-Wsometimes-uninitialized]
            if (*err < 0)
                ^~~~~~~~
    newblock is never set before error handling jump.
    Initialize newblock to 0 and remove redundant settings.

    Fixes: d8b39db5fab8 ("udf: Handle error when adding extent to a file")
    Reported-by: Nathan Chancellor <nathan@kernel.org>
    Signed-off-by: Tom Rix <trix@redhat.com>
    Signed-off-by: Jan Kara <jack@suse.cz>
    Message-Id: <20221230175341.1629734-1-trix@redhat.com>


--
Linaro LKFT
https://lkft.linaro.org
