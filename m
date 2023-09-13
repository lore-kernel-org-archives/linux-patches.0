Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F5F1A718
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 13:55:46 +0000 (UTC)
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-44d48168e2cso2297317137.2
        for <patches@lists.linux.dev>; Wed, 13 Sep 2023 06:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694613345; x=1695218145; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bHOWKgoMJ5vIrHEwzYhikdH8Nfh2BsBh7d3nokFVIcY=;
        b=hTmvSR1FJyyHEEXO54kym0eDM0RFAdUS/+csrWkye0057nTLI/LkWevMwepyQjsi/I
         We2W5T4yjxgHUViIaO9NA+f84N1Sklj6YnhD5sJuQ1ejzYYqVfvxXV2nTEhyW7NhujUZ
         d9ImHBPhNw1Rm55G93EcxLaBrvO2tgvlAAYmIA5i5Pe7Ew2HK056qGN/GjKTgO1foiti
         E3tfRrSmv+Av7EWkn7FmcmuJ95+Ji/ey7Z7gYl6L9LdY2f+/wCGpG775U6h5kbX+UgsJ
         L8D8WRG8HEzZsQDnZjiokUcT401LFosTZ/8DEhA9uDGWOmezWkXdEoeNiasd/+wB0tCE
         6AsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694613345; x=1695218145;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bHOWKgoMJ5vIrHEwzYhikdH8Nfh2BsBh7d3nokFVIcY=;
        b=c4RtDsoHdR75U/9e5VEkgIlGB0lJBZp/p3ba9kU+2acbX+qvHPhHViEY/uljUTzhld
         EnqM6PukfBMRhvh8/w1pZmfaf2r8MsYcSafjx1MznGNNBjpko7OvnXjgKPAXxLVKkjkA
         9kmWBHU5Ey/nuRZXyzrlZ9f5UL846TbH/+k8on1LImMAXK4KIl2A79g1FJIBNs4VCWQF
         DkoeZbTxZX5WoXN6iPraVYVsGnAKdJ+qS/d0mIJvOHY+bNak4mip9nGSybog3J0Hp3lC
         nF6s0PEQ1c6ttgfknXwicE1o0k1wPJATbgUkxWMfu70P7IpHOuTywP8nwycbF4MH02Nz
         UxYQ==
X-Gm-Message-State: AOJu0YzbNujlSubs8bjG3nRJDmT8aUjtMXJZtSicDzPeEdNjfgejU/w7
	prq5souKG2DaBMf8veSJcQLQDj3ra9TgX2qRrsdd1g==
X-Google-Smtp-Source: AGHT+IFf5imTqug/zcRG1beR5iQXSQEFra9TlGRP6+/+gjc5RTxdHFSFJ3q0U7S4Vcw7LNDBmZUTS5F2jEkEzXHOm+M=
X-Received: by 2002:a67:e203:0:b0:44d:3bc0:f1ba with SMTP id
 g3-20020a67e203000000b0044d3bc0f1bamr2601874vsa.26.1694613345099; Wed, 13 Sep
 2023 06:55:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911134633.619970489@linuxfoundation.org> <1ffe4f64-f238-859a-ab14-7559d03c4671@linaro.org>
 <CAEUSe7_XA16yZAHA+YTbJygwaUYkU5gs=FnV9BAmQRYzwgVjvQ@mail.gmail.com>
 <CA+G9fYsiWEKSV0EeU0cXsJZ3U75fbdGyCmDx07ksFMUW5jouyw@mail.gmail.com>
 <2023091233-boots-line-a3d4@gregkh> <CA+G9fYt2Jnxwvpzcd66HCqkPi6CNistHfmxQYAzX22OWHUoUSA@mail.gmail.com>
 <2023091213-awning-driveway-4671@gregkh>
In-Reply-To: <2023091213-awning-driveway-4671@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 13 Sep 2023 19:25:33 +0530
Message-ID: <CA+G9fYtY7_-JgVizZuVJZ3RX0e3eZ3ri8AxDpkkPdP-uYfZ1ig@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/600] 6.1.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: jack@suse.cz, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	=?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>, 
	Tom Rix <trix@redhat.com>, Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Greg,

> > > > > For what it's worth, bisection points to 903b487b5ba6 ("udf: Handle
> > > > > error when adding extent to a file").
> > > >
> > > > I see the following commit is fixing the reported problem.
> > > >
> > > > commit 6d5ab7c2f7cf90877dab8f2bb06eb5ca8edc73ef
> > > > Author: Tom Rix <trix@redhat.com>
> > > > Date:   Fri Dec 30 12:53:41 2022 -0500
> > > >
> > > >     udf: initialize newblock to 0
> > > >
> > > >     The clang build reports this error
> > > >     fs/udf/inode.c:805:6: error: variable 'newblock' is used
> > > > uninitialized whenever 'if' condition is true
> > > > [-Werror,-Wsometimes-uninitialized]
> > > >             if (*err < 0)
> > > >                 ^~~~~~~~
> > > >     newblock is never set before error handling jump.
> > > >     Initialize newblock to 0 and remove redundant settings.
> > > >
> > > >     Fixes: d8b39db5fab8 ("udf: Handle error when adding extent to a file")
> > > >     Reported-by: Nathan Chancellor <nathan@kernel.org>
> > > >     Signed-off-by: Tom Rix <trix@redhat.com>
> > > >     Signed-off-by: Jan Kara <jack@suse.cz>
> > > >     Message-Id: <20221230175341.1629734-1-trix@redhat.com>
> > >
> > > Wait, where is this commit?  I don't see it in Linus's tree either, nor
> > > in linux-next.  Where did you find it?
> >
> > Can you find this commit id ?
> >
> > Commit id: 23970a1c9475b305770fd37bebfec7a10f263787
> > subject: ("udf: initialize newblock to 0")
>
> Yes, that is in 6.2.  Where did the id you used above come from?

While looking around for the fix commit i found this on Linux next,

$ git log --oneline next-20221226..next-20230106  -- fs/udf/inode.c
e86812bfac97e udf: Detect system inodes linked into directory hierarchy
453bc25de0a55 udf: Preserve link count of system files
6d5ab7c2f7cf9 udf: initialize newblock to 0

>
> confused,

Sorry for the confusion.

> greg k-h

- Naresh
