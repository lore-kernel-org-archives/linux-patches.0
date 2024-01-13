Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A69521365
	for <patches@lists.linux.dev>; Sat, 13 Jan 2024 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Py97svbm"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-28d2c1389e8so6205441a91.2
        for <patches@lists.linux.dev>; Sat, 13 Jan 2024 06:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705156198; x=1705760998; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EVg40E4XeqqJS5SMyAUeTLAJhHVnIRgLTwa/mm1S4mo=;
        b=Py97svbmyct1dWqREhJTddTmHw1y23DVLx2kBNSFOIxbLqMEIrhrPlIXLkOEoAfCdg
         0yvsq0GXwnROLNZMJc2sCQRKLkXHsnD8bz8haRrjkrk+ws30Dk0khqkxr6qzxiG/bhBJ
         0hz2EIgSLXkUyd7gBYnYviKxddGtFfynjbyzx5WixrclezTIoN5wZRswP9eRbbg1JNhj
         cdOMxApDYgEz024eDTctm69m77Gwm0BSVOpSTLwbr3W8MOzIJTVj2iKuXFvdY2H86c/t
         hsCtD7ankKfOyaMJpFIZXAfXDMaoZXOq/ffy1jP2MFNFWAZ4RjReFwoB5S/iW9cEM9cf
         lihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705156198; x=1705760998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EVg40E4XeqqJS5SMyAUeTLAJhHVnIRgLTwa/mm1S4mo=;
        b=my8B5iVFd0JcaS8DDi4JJ69jvkT1ijTrjvd9NAJfvD2bVMqBI10XWXTD8iebvTO0XE
         zOl6GR5XxrJoghB0zuA5dHPtEwR3Dvq6q9fsrf1Iyo1d8VXHkQEI7w7GdXz6iNLH+e3h
         dQ9Hf19CXCj0Y44H5iN4v9naRYaukQDa2L8KCEM0/9EfYmEd88BRr3V8UaMn6UMy2QUE
         omP/lgc074BEi5nFX42G8fhCF4OnmjH7RfljFMFRJOScx3+taaGRxIZkP0HOANwXoUSw
         Od/nle4IA6Acczi6Xff/ziyJ2eQosLA5QZVs1NltLCGnqDGN5oLbN+O1Sx9CjLRn9qa7
         wtKQ==
X-Gm-Message-State: AOJu0YwaieKW6FbKVPAwlC1J232rZynf7PVFUW3hsy11saOJN1A6lPo9
	GYNhz5GTDQutqv+DTN7vtPwXFJXuJNSKmV7zn0E=
X-Google-Smtp-Source: AGHT+IFwO6yKJkGhDveSPCt4cYpW/amwmDt3tr43kd1fTgkArl7JjdOlewpOPFtotjVBg5stIReUpjzodTdWASED1os=
X-Received: by 2002:a17:90b:1241:b0:28c:5a10:f31d with SMTP id
 gx1-20020a17090b124100b0028c5a10f31dmr2524393pjb.45.1705156197692; Sat, 13
 Jan 2024 06:29:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240113094204.275569789@linuxfoundation.org>
In-Reply-To: <20240113094204.275569789@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Sat, 13 Jan 2024 14:29:44 +0000
Message-ID: <CADo9pHh9biZyxKTLU37ArKp4RvqvebkP5XGPekz=bTpdtj0KBg@mail.gmail.com>
Subject: Re: [PATCH 6.6 0/1] 6.6.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Works fine on my Dell Latitude 7390 laptop with model name    :
Intel(R) Core(TM) i5-8350U CPU @ 1.70GHz
and Crystal Linux: https://getcryst.al/site

Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den l=C3=B6r 13 jan. 2024 kl 10:02 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.6.12 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 15 Jan 2024 09:41:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.6.12-rc1
>
> Jeff Layton <jlayton@kernel.org>
>     nfsd: drop the nfsd_put helper
>
>
> -------------
>
> Diffstat:
>
>  Makefile         |  4 ++--
>  fs/nfsd/nfsctl.c | 31 +++++++++++++++++--------------
>  fs/nfsd/nfsd.h   |  7 -------
>  3 files changed, 19 insertions(+), 23 deletions(-)
>
>
>
