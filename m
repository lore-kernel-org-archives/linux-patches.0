Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482DAA20
	for <patches@lists.linux.dev>; Wed, 25 Jan 2023 00:28:09 +0000 (UTC)
Received: by mail-ed1-f45.google.com with SMTP id y11so20056339edd.6
        for <patches@lists.linux.dev>; Tue, 24 Jan 2023 16:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHRLF5EjAc/CnwpWPOx9gjB6ipIMS9QSUsPy/x1ic7Q=;
        b=wkijrdz6EwTaU8soo2pXMQ2KzEu7aHLRrbhyTgaR118mKcPEM82we+KReP8KmvG2T4
         vWUL9Y/pPM4tfLDbPZDNNl+OgZttDEc4Gl1HcLPJ8Ema8cHeGZNeA1x0XVdrUmJUVyof
         Q9ASb3cKz9Tagr9fmJoAxQmHFmjqNPTZ75L0125V3BFUwddp/Vxb0UWDktwhi/v35Ilv
         g5Cb6RBV+McOPBZJuHGCJrkBdZvihsN0A2+ynLzJ7WRcWdxi8UMC9EC03bueVxRHQcO3
         pjrjVtt6HHExnn5i26VuQKlMKJQ9VmA5ueBYjCf/2Z9Z30RisrHjGi6v5RQAo5s/7xVo
         yOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cHRLF5EjAc/CnwpWPOx9gjB6ipIMS9QSUsPy/x1ic7Q=;
        b=wYNRN+7Dm422iLnAmecb8d5wArFOYydzdoXns4FCydioeOvpCDMSU/86p3ZrJuoR7e
         Lwjeat0P3fvgeRqUsEz0d045oYxYysWK7MCgnXehKnbLXwZ++F0jFiHDDpCL6kZpTST/
         jwxK+9gLQR79VcrYLF58yATPmymk/U3+BarihUXtkqSRXs5nYAigZAqXF4uhgIyaB+/w
         p/4fxHXAw2ucgmWLkjrImMUwadvJTL6Rv8BjGDl/GPIq9J3SpOkzmUGzqOJBGn2RWCWb
         J7lDmLQULBmSK0sQ+474eWRNQyWJFUz97cXMbCcTvTmS2+AJ7sESKEES6iNlxFPG8DBl
         41qg==
X-Gm-Message-State: AO0yUKXfFbgMmFD9E1BX2u4pvRjl2pd++86lIQ58hXmNyl5eYstVhUsl
	189UGMPPbGG5ZPyKWzYLHU0SmQFPcG6eidT95Es6rt0NbWndr4QY
X-Google-Smtp-Source: AK7set9Ety8dkQYdxT1DoJuz0LpIakt9q9zcvX3X4HCobd9KzrFp42CRrtIAGOsqMELg5yR+MQf7dw/t1Kg2kbJLYLA=
X-Received: by 2002:a50:cc46:0:b0:4a0:902c:9da2 with SMTP id
 n6-20020a50cc46000000b004a0902c9da2mr492169edi.62.1674606487247; Tue, 24 Jan
 2023 16:28:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230123094918.977276664@linuxfoundation.org> <CA+G9fYuH9vUTHjtByq184N2dNuquT1Z02JDRh2GYFR96weZcFA@mail.gmail.com>
In-Reply-To: <CA+G9fYuH9vUTHjtByq184N2dNuquT1Z02JDRh2GYFR96weZcFA@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 25 Jan 2023 05:57:55 +0530
Message-ID: <CA+G9fYtAvyFUsGEgAkeTF+=B1+MySYd605Vv94BT6=1M96bwDw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Jan 2023 at 15:22, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> On Mon, 23 Jan 2023 at 15:22, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.90 release.
> > There are 117 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.15.90-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> Results from Linaro=E2=80=99s test farm.
> Regressions found on arm64 for both 5.15.90-rc2 and 5.10.165-rc2.
>
> * qemu-arm64-mte, kselftest-arm64
>   - arm64_check_buffer_fill
>   - arm64_check_child_memory
>   - arm64_check_ksm_options
>   - arm64_check_mmap_options
>   - arm64_check_tags_inclusion
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> We are in a process to bisecting this problem and there are updates comin=
g
> from kselftest rootfs.

The above said regressions are due to the Qemu version upgrade to 7.2.

With reference to my previous emails,
This is not a kernel regression on stable-rc 6.1, 5.15, and 5.10.

- Naresh
