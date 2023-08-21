Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365C91BB39
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 23:35:37 +0000 (UTC)
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2b9a2033978so61290281fa.0
        for <patches@lists.linux.dev>; Mon, 21 Aug 2023 16:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1692660936; x=1693265736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mx9AKTmHyiYkR+pZw1dj3ToXvjTZEUPg3otq/0WD5no=;
        b=2AGnNtqff+ZWmokpQeEa7ADE1+8GuF6+rZiOq5kY6DxPXWWOmIHBSiYOQlSaffyTR1
         RJoEh3DBFSlH+EyzJpFjX8mG01ogvODDFUhh76/2ahZfypnXvyHSD+NDscb0Va6ns81d
         +B1Tc75s6MGilPnKSA/h5CzH8DMDJKvgaQI7AppyUfaDMYm2vKVsJuemuWvwETDTt8L0
         v4FuKtYhjZDTfNhYTSd8Ik8PhUH3V4HM26BdXQtk5T1bkC7atHS9vf7G8rkb/svoPWEz
         RxWhsYbzHF3XdlWMk7BddnJXxg5u6GkbOmSZW2ajVwvw4n0aTW9bLCOpBawa8xRsYwVz
         KWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692660936; x=1693265736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mx9AKTmHyiYkR+pZw1dj3ToXvjTZEUPg3otq/0WD5no=;
        b=LfSNKL/+/mqepWH3F9SMTlU9sLycK8wZcyEnJzRS/0VUqMOKJxGR5O4eZ08rMkqArR
         uJ2sRwh9+/hvFLdfuMZ+ks00BmirqgM/YtPER6W9q//bj6DvlQ+HWFVDwrfVywCN37LM
         U6nat6yqMNv+ghigAdR2HZNH367sOmWmctj0Kf2KONYBKZ1Y142HHRAawwZkXOEMdASP
         Xd0+VKYdUuz0mBpgKQFhvPuQVqwomrqJ77qkjH//OixBAy0alX7bpscpTwuElFbayUFy
         b2UgpFfvVHmwhJeAFLiPt4D32pZHA0MwZ7itLfk258I1MTDVZHlG1QbZIxoKALc3Gem4
         nvYg==
X-Gm-Message-State: AOJu0YxH1gZybiBeK5bKv6Fue74ATJgGJO5tGAYovO2D0zCdSLYOxUHw
	hdc2EcWyi35JC8PmM+m0c5e0n2V28bd3m46Y2QQCnQ==
X-Google-Smtp-Source: AGHT+IFuIpIP+zU9e2puhTm4zRVQTuLSgihXGhhi96HB1MdcB4cr8OyUgqRu+u2wHys26zZcoU3w01BbxCAl03mbruA=
X-Received: by 2002:a2e:8295:0:b0:2b9:f2e8:363 with SMTP id
 y21-20020a2e8295000000b002b9f2e80363mr5611062ljg.51.1692660935632; Mon, 21
 Aug 2023 16:35:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230821194122.695845670@linuxfoundation.org>
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 22 Aug 2023 08:35:24 +0900
Message-ID: <CAKL4bV45LpjnrXyNFW=Rgu5R6UmmV1N6B0qM0LfKh5d=FNJeTg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Aug 22, 2023 at 4:51=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.47 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.47-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.47-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
