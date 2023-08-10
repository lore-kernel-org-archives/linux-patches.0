Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CE822F02
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 21:54:22 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6b9cf1997c4so1258629a34.3
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 14:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691704461; x=1692309261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdmd3L8sQaZfmKOlh78OtU1Gse7xZrYcyHA92fE3hM4=;
        b=FFa1+I3haHlL1/+HcMEoxPyw0EeUsbVDi5SRuDPQNvuytf7mCyoQ/51X1YUS2QSrsk
         aJPx+zHdz96vvTDE0pqP1ZOFXCHbMRDol+iodLI7ycCb9l5V+PiXWglBVcmCZKfQ+KUH
         7RGesjrFOrbQ0q58YCKoHfaBs/NzacUyQfKyYYLMMtPpNQAvcs+UumPfaNgakiuScVJj
         vXikEyp7D9OW2vzwvdvG9ydPYD3G7P6Cf2gWjhj0WE46nEm1Wm8PU2rR0/U8f1eVcofM
         gwFTVXUoYSIVS6d21ib80EJyfBWimDjyym2DL+WeWX+7Cqs+hr2q0o7zVZT/Xrvzno4q
         5o/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691704461; x=1692309261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zdmd3L8sQaZfmKOlh78OtU1Gse7xZrYcyHA92fE3hM4=;
        b=WA8pK3iSzc6wVVnZbzdo3BXkeeo75Z88ewNRjxyjr/rLf675N6AcQnybkIYzf+EZ64
         8XNnYdWeMbWndx6wwtY4O7i45cfs5OiaH6QGZp85OG5GCn6VYbi7tdIVVfIb8NmEu0c5
         PFhiXJNSwvTSvBcj4fkK7irHeNIgUFaOFfo8Hm5G5TgL9iiGiqgJKH+S2DowUcnxAp1Z
         Veb/YwLiNv3dUGcDo8qNwNy2x+bzMl1KmkLN4AfEuC3wFncax0uRYL+RrcXO8YvFvdb6
         CwCCuWj8mxInfGYfPyPgXmUv+B4MBnOuTDM720Tr59OFbeI7fP2pH0BST0oM1fayw+tZ
         hVgg==
X-Gm-Message-State: AOJu0YykQKT+749qMCjL80TDn48EMwhicKYcDN3rn/JuBc8nJ9etIjlg
	KXKFgx/qpzTdr29fSt4Grb4ZHJuX2HFORHV+7m4stQ==
X-Google-Smtp-Source: AGHT+IGtfaHZvpQYAoURixzrs6m8DYXk20z0dVjoIRoRWYDAgUXKwqbZ6rkttWpcf/8QXpNNipo1EPgClrgTMf9Y9eQ=
X-Received: by 2002:a9d:61cb:0:b0:6bc:88dd:4f0c with SMTP id
 h11-20020a9d61cb000000b006bc88dd4f0cmr83605otk.20.1691704461759; Thu, 10 Aug
 2023 14:54:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230809103633.485906560@linuxfoundation.org>
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Thu, 10 Aug 2023 15:54:10 -0600
Message-ID: <CAEUSe79ibvfBR6epj=BhysfrKV47zBAFLZr7j=ZP+-Lf4NzuTw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/92] 5.15.126-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Wed, 9 Aug 2023 at 04:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.126 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.126-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

We are also seeing build failures on Arm and Arm64, with Clang 17 and GCC 8=
:

* arm, build
  - clang-17-defconfig
  - clang-17-lkftconfig
  - clang-17-lkftconfig-no-kselftest-frag
  - clang-lkftconfig
  - clang-nightly-lkftconfig-kselftest
  - gcc-8-defconfig

* arm64, build
  - clang-17-defconfig
  - clang-17-defconfig-40bc7ee5
  - clang-17-lkftconfig
  - clang-17-lkftconfig-no-kselftest-frag
  - clang-lkftconfig
  - clang-nightly-lkftconfig-kselftest
  - gcc-8-defconfig
  - gcc-8-defconfig-40bc7ee5

Failure is:

-----8<-----
/builds/linux/drivers/firmware/arm_scmi/smc.c:39:13: error: duplicate
member 'irq'
   39 |         int irq;
      |             ^~~
/builds/linux/drivers/firmware/arm_scmi/smc.c: In function 'smc_chan_setup'=
:
/builds/linux/drivers/firmware/arm_scmi/smc.c:118:34: error: 'irq'
undeclared (first use in this function); did you mean 'rq'?
  118 |                 scmi_info->irq =3D irq;
      |                                  ^~~
      |                                  rq
----->8-----

(Funnily enough, this was reported by Naresh [1] before this RC round,
but we chalked it up to GCC-13 on an older branch.)

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org

[1] https://lore.kernel.org/stable/CA+G9fYvTjm2oa6mXR=3DHUe6gYuVaS2nFb_otuv=
PfmPeKHDoC+Tw@mail.gmail.com/
