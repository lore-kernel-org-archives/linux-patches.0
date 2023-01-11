Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FB533D2
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 17:23:59 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id 36so10998881pgp.10
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 09:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nws/lrJ/9lnH+CI6+ZqOmrPtXwa6Sor7KBXY1a2tRLo=;
        b=pcQG+G+sXb3AoCMPVQjPSIEMREoOMdNjdA1OEvKV1T6DbXlqBGXgzC21zLlfSFHPT/
         JOSSck60cqBx8sRMqSdKUfcWk6131zEXMN2Y+wQmIlovf5p8eLMKEfKh5twIfBOReo8K
         x7Sd5WTWFhrsYC1JAf6l8gV5zndyb+2Z/XrzCaVLZWaMY08IMqQs3WRh5iMJU59ApG3G
         cyiMxhP05Lt87ueXGo/1w0z8GxMcbHN3jkKL0YA28r8DCC9xYB0ywp5WqoEuJ+gUdPVa
         de58vEZp0sWMsibLLEMQgrQ4jSLBLzN1gSAqkDD4BKKjYzVpSsPSLy0pBOP3m5z+Zs2A
         mPMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nws/lrJ/9lnH+CI6+ZqOmrPtXwa6Sor7KBXY1a2tRLo=;
        b=5wi8vuUrg+ub/r6Dj3njxvptgNwRvzMPvhV1LBzAcAtAFM/LOZBBb6bDsfw8ldcwCQ
         4ReAW9piA0eBJWLKsytLb5DMaQ0Sc+JW7GA5fF9drOpBDgcZVJTJrWEsk+U6OJjTgZsB
         X+ik3X1jVp0DDyaal7eo4SNssoy0iIaWBUy5KT91TSUY1sAxn8JWf2I8XXHQZ0EZcALs
         l2/9o57spIN1aDDvgaOY++JNALBxzUPd+o8oCuuEQeWp5oLzOURvO4HW8u84KeEFZm5K
         G8HFd37mEUHjufRL2v4gMgoZMySi5aK61/74rO1OiNs1UdYdeNhup+Ntr50M/xXbiB/W
         1uCA==
X-Gm-Message-State: AFqh2krILdXiImZa/Sii99INHdQf/uFtZKI9FhLa1egh85ttxgVk9kID
	IJModc0PP/9GBG1HkumnuNccUMahC7sObKwLstc=
X-Google-Smtp-Source: AMrXdXuSnK+mHilhunGrKaWO+sLX2d/nIateiEydXV1J2v2T8QSOxLb3Kq3eaBJFAwl+o/JJC9d4rdl0SHe4Sl8PyuQ=
X-Received: by 2002:a63:2143:0:b0:49f:1721:c6d8 with SMTP id
 s3-20020a632143000000b0049f1721c6d8mr3243719pgm.342.1673457838609; Wed, 11
 Jan 2023 09:23:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230110180031.620810905@linuxfoundation.org>
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 11 Jan 2023 09:23:47 -0800
Message-ID: <CAJq+SaBDTgSPd+YQ3BCRgkvY_+a=3y4L9_2qcCD5huyJAHK89A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.87-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
