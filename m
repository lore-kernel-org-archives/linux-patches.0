Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1326714281
	for <patches@lists.linux.dev>; Fri, 13 Oct 2023 12:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="OZ1FvKor"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-99c1c66876aso327663466b.2
        for <patches@lists.linux.dev>; Fri, 13 Oct 2023 05:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1697199317; x=1697804117; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tlX2uOgdFdyVvDQRBX2OmgWHNmFmGPEPvcnJT7mREBk=;
        b=OZ1FvKorQxtQWcS5WgVki6hfcmLUmm+mfJvtk16EzWz7rrNiQkJiMukJbTPvPqS72y
         UQ7ADeAZTjCDZdKAxsWzBfdQgz7ug580TCC0EAcSvpAq3LPH4PesyrLohlL7IXLfmRWV
         U8h3iyzJJfirqrYTQTjlnszg+8YnjagkLDIpb41Jt7KUQ6SWzWPRfLK8LHnm6LDDIujJ
         nej4yBDoh2H2J5BG9b3NA55LzS5MGiqSbIYCBlG8nFJo7Twe6o8cP2mSJYIZQ5xhZCYi
         Z5rzQ/Z4MjxcOwn5VL6607KH376q2E0HxYdAv1JVyiLv4wBjIsuebBeVrcsZQLz6JtZ8
         75Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697199317; x=1697804117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tlX2uOgdFdyVvDQRBX2OmgWHNmFmGPEPvcnJT7mREBk=;
        b=lsJMbjr96lwhyjpl/r2LJ75FeoRqIycoGf1awx4M4TCVVLOkdcomdhf8pzyww6xqNS
         CGmwO1fppy/FCX62C0gnQfQmz+0VhjRqoQxiI8CC8biJAmcccCjYpqWNa50GXI6tXlnf
         o1gstiABPk1+tMthxLdZuDbHTCeC6wKCIU2ijX3Z1zlswEyjfF7/UqzilxRHSPOVKNSs
         tgp22rer/yjRT4F/gERe5B63lC8RBzaMA0tkKXmqpktU/tKKU2bPvm5BQTpibVXhraD9
         B72V8uUFFb884WcWc0o7ED74gUJR6Y3Ze4onNJTkrioEXnFGEakAwd+rxG5N83MVSy28
         dwUQ==
X-Gm-Message-State: AOJu0YzaJ4MWPyJZaKL5k6QfKKSZ1s7GVd3x26kkxUwolls3hmH5WoEl
	abiQkIBeOVcp/roMXnhP5+0WS/FM4OnjZc0RPshQVw==
X-Google-Smtp-Source: AGHT+IGRWZBsduUFUclt/en5C/1EQOPdjADBORz0lK1rGJIlwf8m1tOTRS4Wd7QLErHj1SkQNdMYhS2MZzzxL7gZr+I=
X-Received: by 2002:a17:906:ef8b:b0:9ba:3eed:879f with SMTP id
 ze11-20020a170906ef8b00b009ba3eed879fmr8067947ejb.41.1697199316954; Fri, 13
 Oct 2023 05:15:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231012180030.112560642@linuxfoundation.org>
In-Reply-To: <20231012180030.112560642@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 13 Oct 2023 21:15:05 +0900
Message-ID: <CAKL4bV6LcE2+=Y_jHZ+bLQqZQ0J3v0RMitjcop0z8R8gXbp_xw@mail.gmail.com>
Subject: Re: [PATCH 6.1 0/6] 6.1.58-rc1 review
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

On Fri, Oct 13, 2023 at 3:01=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.58 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Oct 2023 18:00:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.58-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.58-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
