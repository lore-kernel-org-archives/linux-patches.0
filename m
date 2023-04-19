Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D0915A8
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 01:26:00 +0000 (UTC)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-94f0dd117dcso231502166b.3
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 18:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1681867559; x=1684459559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uxXITgakLQZjUNEWigiUIhamcKFCLzsMS5+jd7cbviE=;
        b=dN7EGNUqn24hjZ1K1ZiPbjvrPoZ7/E0JgBK1YZVnNP/D4euPBMQj6Wj1oTbBqElPhQ
         RDjPhyXDBm1cHvfDTjZ5kU+032R0OGuRJA7ImqR3lGc4gmNXrTFmOs7T9sVZoDFieeWQ
         3jGRKTgk0yiNRli0UH1rJb6WMxk1ZFGlcQW801v5nGv8ep+YtWq45RGzq35boFTBwjMh
         5yXO2Hb4nioc/Gyg968bN0ZWwdEC7AaliTSvDT6BipGowpBjNyeJHi+C8o1P5hTeRtkq
         HM7DZN2VvLJFNEVx5BhdPVEZLtV9o8dDYB3mw4zA7+5KNmxd2HG74nrSmzLvTdsqUD85
         bsLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681867559; x=1684459559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uxXITgakLQZjUNEWigiUIhamcKFCLzsMS5+jd7cbviE=;
        b=QqPJvAnkw4E7ilA+RRD44CsVSobYmBmroU1eb72rPW8pLpY0PeDhWKiVTYrq7xLQPY
         9dNWCg2Za4EM3cskS12SOJIVSePFGKvltvVmNnhS6kzM5JzGeBFdzqDQOO9fxty3h9q2
         fwTcXeaJPVCRs+UhlV9mi59rP+CVlQiJDoXUkAt1XtUcV7kRmF/KHGQrOHS4Qeo3OtDL
         xZ6jfNZxreT/E0mzCwjUyakLFmJ4PcOuSNYPq97NRotC7Dgg75pNcyv++PoNiQY/dPMJ
         JTQsQfjNSrlL3hgyfpfLJZvydh7MH+X96VvwcFNTczuiXniT3PMnmZhWttXIHm9Z670I
         /zxQ==
X-Gm-Message-State: AAQBX9cDvjowiH89MISVq5awdKYCxmmX95gInxD0CuRI1gSe46luVHnd
	1WpFI2EnDaLJTwd4aWkzTcgeuJcHsKJvqZW8CtV4Fw==
X-Google-Smtp-Source: AKy350Z1r3MHtabcSD0aZjLFEKplpiH17REkLAHbs2RkjUZefY0gvuZrC2SMt/PEQWRJRyDn3SmxLfaORy73MLYbgsk=
X-Received: by 2002:a05:6402:c1:b0:504:ae78:89c5 with SMTP id
 i1-20020a05640200c100b00504ae7889c5mr3522250edu.28.1681867558993; Tue, 18 Apr
 2023 18:25:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418120313.001025904@linuxfoundation.org>
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 19 Apr 2023 10:25:48 +0900
Message-ID: <CAKL4bV7sw7AWc14eXOh2azGH+=eHWni=wcisHJfPAra4xYUmuA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/134] 6.1.25-rc1 review
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

On Tue, Apr 18, 2023 at 9:42=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.25-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.25-rc1 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
