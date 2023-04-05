Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9811AEC5
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 11:23:32 +0000 (UTC)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-4fa3c1a7a41so313542a12.2
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 04:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112; t=1680693810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yfV2KWTK23dzQiE3afeURtamcrYwX7sqGIqTtLsTbro=;
        b=1RFvuNdT7bz4CAJPrNsQwQD0UrbzcRTLPCxW07F92YscwGUIslMfKrAFzh76cGAgGy
         YW94aAYWVK0XfBkh1fyb6W2ZghufSJh2EZHTamjBve09QpGRve0ILZxw2+725FLm7aEa
         WG6RYaTFgwRwmLZsngCyCIVvmpjSmTL24EgzU1/Bq3CdnX6pTJV6eijnFZAqKVOvzpl2
         jQAxOxv/u+YjkFWMGSVPJzY64R3A5ZLT+oq3zQAMLHHrMORHLgBpmDWF4cySeocvOyQx
         jr4VphkrQx9Cqh9kI4X/G7zEAf0z5FNuBzVDfcN98+NJFZnVQv/IPudFnGvSYzfB1bbY
         N+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680693810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yfV2KWTK23dzQiE3afeURtamcrYwX7sqGIqTtLsTbro=;
        b=jz1Z0EY+ogwnYMbux4rassviMIRFdORk46wVl+I5HD+ScLxdxeWMpuCAnhvIjHLGnI
         wSlM/MefgRq7am2BInUC4oIyIvaU7Pz5wDMuC32YA/ODqRb2Ao1KynnVPheQfqljWNf8
         NO31b/rpBN0Uq3jyG7sb0FPOYzigPPeP26HvsiBa82H80IWjqIZcDDIhBorl693jzBfa
         tNvZiX9zHg2uHjCVce+SydQ9lYA/phjo9u8wCnaaa6mZGF1YCfBI6pvPiW27Xbktyy04
         zh0uxbVNdLzVLqSRWag/Q29Mf+N/HxHnpTm0R+wiYNRyaQWZnVFu/wGvvMyuhz1kv5h/
         S1/A==
X-Gm-Message-State: AAQBX9dJV45dL8fyt8zBIGn4OXb6SyRQ8077S6JV02XeSkiKq03Vwq/0
	U98RcJCmyZovNnT8TwrZstvUez1BMT7u+oNsKYVIVA==
X-Google-Smtp-Source: AKy350Z/Ut9C1xKHKjY84iDBS6fxCvIvCKQt59xuW2g2VFOmWxh+amYNznrtGgfAJHqfLYjK5TxUes4SeiC/+uhiaPM=
X-Received: by 2002:a50:9fac:0:b0:4fc:e9ef:e033 with SMTP id
 c41-20020a509fac000000b004fce9efe033mr965995edf.7.1680693810606; Wed, 05 Apr
 2023 04:23:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230405100302.540890806@linuxfoundation.org>
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 5 Apr 2023 20:23:19 +0900
Message-ID: <CAKL4bV74voTKWLBhsa=gmQnked2_b8TF6UkvpOf0wi-q7tVX1Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
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

On Wed, Apr 5, 2023 at 7:03=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.23-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.23-rc3 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
