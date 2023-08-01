Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB21111E
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 12:46:22 +0000 (UTC)
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-4fe383c1a26so3247379e87.1
        for <patches@lists.linux.dev>; Tue, 01 Aug 2023 05:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1690893980; x=1691498780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Is8zYpLKksJYkV9dheJoep50WM9TZKR1lDw6gL7yZ/4=;
        b=VENwXiH+kNawpRU7bMwjho9x40IIabsTdfetP3ui5b4yX4YgEVaAIaUXY3IGyGZvEN
         Z65EwE6GjliIEKWHyxSMC0m1WvO8ZyrN4VtAMmOmuZkgxMKe9NXVR2iT2EdH+q8kKwf2
         JekAkKzutCDb/nY4MprijzMC1HkDqQJXEJYKyRZs7ihHqBHC69/PHSV3YkMGVRod8V6+
         iEq9CAeGgHfiQsMASuHVmnZdmUYjo4VdaFvUpWNSjeQiyRkbcElM7xZQmqUx3+ClJE5S
         XX3g8HvmSYlM5AuQUA9gXg01QL5fCKCgrxbR7YW2duQx2/U9p8ZG+T8V6oY2kp9JKX2I
         7org==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690893980; x=1691498780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Is8zYpLKksJYkV9dheJoep50WM9TZKR1lDw6gL7yZ/4=;
        b=WNXVpc2Rw982+fvKEn6M1DK/S2zezD+1gJcuNjVtk6/aqRzf1suH9oheM2ZDJiLGw5
         ocglP0/8lxQsk3xVOweB4IvlSfQwzWlIDkiz/Yic8fTNsv1XIbnejD5Yx+mJc4iMpn2k
         tsz6yC5w0bVltVZT8I/BKHtrExhnCp6tpFw5gwnwkxYRRVCKQbMEYMQANBFSc5OKm9kR
         HGBeBas+5sTsrDLiua49OwE6bqvVAlt/9/tmPulQInrevEcubJqfXLYu5TZjBex9uayy
         336b9BoIU37Y7rM/Wu8MZ+GaqjS8EQUCRG2vKF2Ab4UTAOiN2uVmm8LTXrao4BXCm2u/
         yYpw==
X-Gm-Message-State: ABy/qLZDDmRSK/2S84w6d4By54dk7vIF22tF7L5imW7AOfv905VTTvGl
	GYXLyF3ClzJkQ1s0lDh2nhS/itQyFyoVY5tPKbmkew==
X-Google-Smtp-Source: APBJJlHVztoapKp9UMJzShU6AETqb1CHtJ24YW9uXJjh118Gs8dTOfXnT7tP5YuHwbNE5y2McAgoS6u60gG6TLBxa+E=
X-Received: by 2002:a19:f719:0:b0:4f8:5717:e421 with SMTP id
 z25-20020a19f719000000b004f85717e421mr2082691lfe.40.1690893980200; Tue, 01
 Aug 2023 05:46:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230801091922.799813980@linuxfoundation.org>
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 1 Aug 2023 21:46:09 +0900
Message-ID: <CAKL4bV45C_iieW5P7FRtRyURPjLZP=U3xioS+hxhxO_AiKQ8vg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/228] 6.1.43-rc1 review
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

On Tue, Aug 1, 2023 at 6:32=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.43 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Aug 2023 09:18:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.43-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.43-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
