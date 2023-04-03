Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1F8A954
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 23:21:51 +0000 (UTC)
Received: by mail-ed1-f47.google.com with SMTP id h8so123648233ede.8
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 16:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112; t=1680564110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q+x6zT/m+dAsDwlmZTQ6fHnL7mfdbfX7S5L6qymWph8=;
        b=fGV2tUpkSYHP+auN5Tt9A0V8ABbv8FjjqQfuwUDI+bsm8v3WfKVEFJ4rM3kXuUugSr
         fDKSVo1cTp3qhHnQCkIjnIxMjXt8rFoJd2Kg17R0fvVKd8/u7Wb//I0gE51POVtMWPw1
         aiZkDQxhrXyzWZO/zw+UjXhSj9s9VdhqHhdp8cLOzu9ztMZO8bbxYOKxaqv4Ds8w5Q/b
         8C2zbNqzMl6LjEKk7Q4Vfz2NJFAoxLWtq/CJ7zFBugYpQGOzKAkEXAXyg4MI41LtPNQX
         7dJoRQ/kxzYad9pN+864gYPaWMN+gRgQWU32+Qvt5EZAhYT3yLOxLb1c3Wt13PNo60DO
         G3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680564110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q+x6zT/m+dAsDwlmZTQ6fHnL7mfdbfX7S5L6qymWph8=;
        b=B9B9XjLmLmhXOogSpNVvACJCf8Ut0pVKm/6847LKi16bY1NRVsVdmwznIAVxbBkVdS
         9gTgiFSh8ieaFxyM2geLTRLhIUxAQUc9ZJiYYt54yPGDu7D70Rx3LJdnE+TiQQP9zEar
         0UYgaWGjgmX2CDJHrrSNZB6bFKq+J0yv1Xzr/KbaMaCaldvHjAxAwLp6FGw2QxK+g4v/
         I0k6MmkufQZvl4I0lE8eaZUiOLAICzXFwmu1W/wBbQcxFlRAzRf0o8ZN6nG/glfUBd3a
         /SpHNJBJv+oQdWgQTw2qsHMpaWd/rOQet2faF5QrV0tkxnepkOLq7oMzKcv1AHNX5war
         ZLFQ==
X-Gm-Message-State: AAQBX9d47TkmDmkKyprU9S8QSnKgX5TP7rSt4Nu5IygygIBXcy0+faLd
	tMADPn8qz4ARXKG3frb/3ckelDcDVAwqY1MaT2nU4Q==
X-Google-Smtp-Source: AKy350aXpJlmqvhrvqJFhN16BucqBU50gYr7+1E8+MZeJWTJQ5PXLP10MGd5hXpu+yN69jzS8zRSYDN3UQqsLoIFv2I=
X-Received: by 2002:a17:906:3590:b0:933:1967:a984 with SMTP id
 o16-20020a170906359000b009331967a984mr162732ejb.15.1680564109995; Mon, 03 Apr
 2023 16:21:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230403140415.090615502@linuxfoundation.org>
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 4 Apr 2023 08:21:39 +0900
Message-ID: <CAKL4bV61zb55_+uJb=XXUdJXMoR=DahQs8TLdzeeiMzHDFRL4A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Apr 3, 2023 at 11:35=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.23-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.23-rc1 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
