Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDC156465
	for <patches@lists.linux.dev>; Mon, 11 Dec 2023 23:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="luo0QA3s"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7b6f2dd5633so306866139f.2
        for <patches@lists.linux.dev>; Mon, 11 Dec 2023 15:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1702336350; x=1702941150; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CzlKTDy/RIEAdRnxop/v7aizphXAOoNjFGr5djxk17I=;
        b=luo0QA3sriB0LA9YSDDMea5t7xRnpvh9Vf4ffJ3rilWH2Q+CRevP94q3YazyDeXjVM
         nl3mjk2up5kxJERHGYRR1mAfvsv954GML5FTDuHNy2bEoIRJOasqp8OuRbjAxukjI3U8
         Ehw3fbeDllzXjMlitAFUfkJSzEtRSZKEG+BFkkQIqwmghp3vXpJLXzFXqzTBogvPyh1+
         Pymtli+lN5jCLkfjPuzerkPsm8xq4Kp3+Bij/H2bqvRikeJqqup+B6DEkPYs0DNMYwbo
         3cNIKqFY3G0sGNXQ7eZ1QmXm8F2ipyTbN3wuWl1PUs8erXbgffpItU7HwfzouYdui+aM
         fqNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702336350; x=1702941150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CzlKTDy/RIEAdRnxop/v7aizphXAOoNjFGr5djxk17I=;
        b=JsNfYauCJOafA8KfIfkWkyTKVXNsUddMMYBTJxiZ1llyUPAKNvCOkFnTHF3N2LBpJ9
         /LsglMkqp2dUFkEgFi45tCWcrsy7HmF77Sh52wWLSH+MucCfrVY8SbWBpiPGPf1rBfEs
         dwLVs5Rw/AOwwcyKZ/g4SrqkSRVOrHG1KNCDPfQUOCtl1uGCfIGCRHso2DpsoihRR1fK
         D2/VfD0LerrTIQTkZz44WPHd6DZRamFikjgnmiTdwBBSy2t5XFWgH75j7+pyNluBDHHt
         gQgpccKtm/yhf596HKHREOcl3zRw9qAqygAK6u8nYGYyc30a7j0doLxoakf+Kbhl1GYQ
         JPdQ==
X-Gm-Message-State: AOJu0YyuNnWM2dTJvEd6wTR3DO9QkDxQXuYG0Tr8DKcUC69MULZ/lZ4z
	w0Mu+musu9usd/QPtYfv78bU94Fsoj5iwXQ5EoUEjA==
X-Google-Smtp-Source: AGHT+IHY1fYWDJPUV8SQB9YLhJzscvke6ZJL/pin8flSX56KTuPcOW+twpGkORoR+m65xh7PMYfnOBMu3UHmIQaQ0hc=
X-Received: by 2002:a05:6e02:1c09:b0:35d:59a2:2cb with SMTP id
 l9-20020a056e021c0900b0035d59a202cbmr8110442ilh.107.1702336349600; Mon, 11
 Dec 2023 15:12:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231211182045.784881756@linuxfoundation.org>
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 12 Dec 2023 08:12:18 +0900
Message-ID: <CAKL4bV7DjZiNLNcWrMx9A+pYSaObc5F04=4ia9YkYaso3_3b+Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/244] 6.6.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Dec 12, 2023 at 3:26=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.7 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.7-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)
[    0.000000] Linux version 6.6.7-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.41.0) #1 SMP PREEMPT_DYNAMIC Tue Dec 12 07:24:53 JST 2023

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
