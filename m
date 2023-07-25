Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6AE1426D
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 12:33:13 +0000 (UTC)
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-4fdd515cebcso8429620e87.0
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 05:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1690288391; x=1690893191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKpkzF96g9NgPXhoWUx4qyrJxQAYJZi3pZkdXCYeBMY=;
        b=4svnrkRxCvqD6vorNSJ9EaNW3eXE3a6UZ2gc6wDPppaH8KH26QSUVB5VR0+xPfNfkB
         3uwaDda0GVEq5B74jOGO3Sgj30u3I/rpJan0+jcgEj1o0QElQte7N2suv86J3/SLewNX
         9JDYA9sxvSUT0QGxctNzMwl1/+KGZ14n5jAm3Vywncfc+FZ9al9JCOFhnB+LJgbvEJ4p
         76g/SCsq+F4PvA/D7gx78PCLrNyjDniUtWMBr5BAvKwHI8+AUoUgzNHyWru9hdl/q3ff
         EQIng1U+whNHxVRd3bNHL9CtvRtJAAR1w/Gw4y/3SapsDAgOMcINyW+xnht4HjrTw8+y
         VFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690288391; x=1690893191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WKpkzF96g9NgPXhoWUx4qyrJxQAYJZi3pZkdXCYeBMY=;
        b=hTtTOueWrToj8O/Yut4Up07X5LQAzVg1ZPr6fAB4jSNDcT5424rZOlE1OrKw+NIaci
         0CEZl9vgMoL7lPfssHn66GWuwLnUIs8Fm+J4JW06dpQyj4xjhXr/gRisqXaiiNo7Sgd8
         IT5forc97ocogf+wZLvJZnWv7yNVLPXBtIGFcFqgSmyLry+00/Fm35R063331E9uBbBZ
         6RM1SANUDBD9HTIiBn4i0Xk5tj9o84YhLeBsTJwvcHFad9hs7zzJWuRjniZVCe6rkXX8
         P14nUAStv+O1xNzpoynVyyt79YtAYzsnPJVWV1tR0zfq/NbfMvLDGyxfqRVOxALUPJM+
         ISQA==
X-Gm-Message-State: ABy/qLbWspN2SE+qwvF0DcNRF+kK8fdfgn6R30M3GRHpVzha3mfiIkcB
	cWTe8/cQMtsuzxiOOwfhJ5WDueEFXGIpSijYBQCEWA==
X-Google-Smtp-Source: APBJJlHmfFkFQER3q6Dst2bu92mvAGDw0hUkJ4O0za2LwpY5NSiE/siaSsfkrIU/FsRkfek7BbGEr5EpbXqs7WSnVUg=
X-Received: by 2002:ac2:4f05:0:b0:4f8:5696:6bbc with SMTP id
 k5-20020ac24f05000000b004f856966bbcmr8779702lfr.29.1690288391202; Tue, 25 Jul
 2023 05:33:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230725104507.756981058@linuxfoundation.org>
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 25 Jul 2023 21:33:00 +0900
Message-ID: <CAKL4bV70qiD5jFcx9ALXJdCS+OBeQnZpAwJZZsJhs6=vCmewsg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/183] 6.1.42-rc1 review
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

On Tue, Jul 25, 2023 at 8:03=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.42 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.42-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.42-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
