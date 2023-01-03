Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DA0AD21
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 23:00:36 +0000 (UTC)
Received: by mail-ed1-f51.google.com with SMTP id b88so38780663edf.6
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 15:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7t0cKhaIlP1FC/fSvNTaDmX7GdHTbT3PBblRW/MDDSU=;
        b=fff3Ylyj6mA8CkFJXoYpmgV68j1IhsciHYHzS2YZKdF4MncvQXqjo+5O+cV++IxS3c
         EXbi1XpeITKKAoeV8nNNaLygVxiP0tlKbZ6BUHQYXJJzyxgHAhzM2tkaEnuNKc2B/vhz
         HyM4rpqSpUmCEBaKq9ABZBvIfHnGsEJw0AeuRJtXoCV7Q6mvLNLlyPpQXqt4/cPFcvqR
         s/B0ZSlhPx/BBUno3LbMyACAoelXq789M+fOjU+bwHamyY0NQxTSe5YHpBuJXYlZXyyp
         JONtdSh+8Q2blCH8b3yIzJSeeWOF5Ru4zX+exlN7Kwxqk6AB51u7PkyHQqh+PHDv+jQv
         MxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7t0cKhaIlP1FC/fSvNTaDmX7GdHTbT3PBblRW/MDDSU=;
        b=qlqHuZXP1PDdUvkyhs1ttwOn5cgwTGnFvMCuFH4U+UY4M38aihcyPDcnO8YGt96EgU
         B8OUrJg/hlfySqWO4frOXaVYhrKLmE7pMe2Yn+zkC+YqYT6NwBdP6WnVJSE0F5rUJJ36
         5X1e8Nc7kZSQi07oNNBrnMWc4MFgkM32wYnn5rgUv08aNCDZrhYirlBj/Tjvs7FNOL3A
         kkmnhF9kB1NXS3kpcf9bb1icvg6wGldeZf2Dx7l/q/vL3TSvOrgdKrRcYfxBWoV58YWE
         2sEKi47qZHf+ygYBtZEqz0JwTWyBjIEFqwvzxymzJHaUGwRaei7MhFuAU57PZa3y6HBF
         /LGQ==
X-Gm-Message-State: AFqh2kqEy6VPtNNTTa/xfIMcJoSFHXoPuTZmVLYTxr+8JGxhudYgU3So
	dqTOYcp7SJiglYwOT+UbJWr9OFtdkJmNqDQpHnE=
X-Google-Smtp-Source: AMrXdXtL+LrfDkGxeFJwcG6Ini1fZxJpmMYUjU+MKgEHTzJz5ibDhYKUiTE5BFKHQ9nrTplK9cTZgigpsV2gr87sH9s=
X-Received: by 2002:aa7:ccd3:0:b0:467:b88c:f3af with SMTP id
 y19-20020aa7ccd3000000b00467b88cf3afmr4554700edt.24.1672786834397; Tue, 03
 Jan 2023 15:00:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230102110552.061937047@linuxfoundation.org> <Y7QFW7O0xqSYTzyl@debian>
In-Reply-To: <Y7QFW7O0xqSYTzyl@debian>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Tue, 3 Jan 2023 22:59:58 +0000
Message-ID: <CADVatmPJrRsKTNyzWYeU10k+3eycd1bXTnwAaF7KKOR+h6mwYw@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Tue, 3 Jan 2023 at 10:37, Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Mon, Jan 02, 2023 at 12:21:33PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.0.17 release.
> > There are 74 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> > Anything received after that time might be too late.
>

<snip>

>
> mips: Booted on ci20 board. VNC server did not start, will try a bisect
> later tonight.

bisect pointed to 2575eebf1bd2 ("net: Return errno in
sk->sk_prot->get_port().") introduced in v6.0.16
Reverting it on top of v6.0.16 and 6.0.17-rc1 fixed the problem.

This is also in v6.1.y but the issue is not seen there, and I am
trying to figure out why.


-- 
Regards
Sudip
