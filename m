Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBD5266D0
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 13:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="wyw+HUOK"
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-99c1c66876aso194367466b.2
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 06:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1696514260; x=1697119060; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3jhe3s5Ktjadi5rzr/ScNUu5PHR0qhenACs1FczGETQ=;
        b=wyw+HUOK80OUKG8ODSSOZm1cjzRfiSjfD87eFKO0xT02aI/vLyTw5yIOWuoH/5AZgl
         3R/FJvPZqDXFu6kNCLm7Z6mf7gK5wrlhXfkgaSwqynK+aESoBr5XDP8O0WPJ11r4wLkp
         DJkEY2PZQajpYV3zOUWXgmc9KvqkJ8r87NEiV4IYdTKF6bKaeVIoq7F06NAJXl3JpC0Y
         b9ZofXILl9P4NpaGFJXFUzA4Fww1da1AhOKLmtVYjUZmEo38D3uGwnREo4B7jf4nUimp
         vRF33KZDb8SFM0mfzzEB/w3DR0sRiPsF/T1U1rOoTmMGxd4bjTqNcEicVZUhveTlDChM
         EWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696514260; x=1697119060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3jhe3s5Ktjadi5rzr/ScNUu5PHR0qhenACs1FczGETQ=;
        b=iicLQwKunv7O3ptI5rit/ruqJLLUUOdB07eJ1zqmJP3V4/Omd3FeKuJunfqFmMWAmI
         mJWd9bp3zXeCmiIhReaOAIXca1kB0C/vDbhwxoRtXsoCryrEdvYZa/4nFmysJ3Q5HRlK
         7felCn3UaE+AKL6vUqKvR8R4F1I8ZDADHiAJutHcOf/d/g2Bwcav4MURYmV5f1jjzWVt
         K9FKDqxaFnWDeziGnM3htiegqbPivXR0Iqkftz9fNBT/lHL8BRcdN30iEteRuqquTilD
         mlMXdMNSrLIeuWaKETypAi4Im/BqPTuM5rypISXtUWnuPiMOnb+PtRRxjHDjEIDyxwHN
         8EOw==
X-Gm-Message-State: AOJu0YzE0bQtvuSMaScoN1oLQfWCrlC9oML907QRNDrKM0SNra0laQle
	Orjqb03faxsGIW/+tkKPHnuCiH06hEcNztJ8k1tTPw==
X-Google-Smtp-Source: AGHT+IE9EjlSzKkLLQqvCvGzIENu290Y/0rTmuLlaYvhP9xylHLtEWKPqU9Nsjm1c/1q+IItp+Hh54AChE7gTHxMG7Y=
X-Received: by 2002:a17:906:9c9:b0:9a1:bd33:4389 with SMTP id
 r9-20020a17090609c900b009a1bd334389mr4428143eje.74.1696514259837; Thu, 05 Oct
 2023 06:57:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231004175217.404851126@linuxfoundation.org>
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 5 Oct 2023 22:57:28 +0900
Message-ID: <CAKL4bV5n6_T5S6SrgqjKLbSZVg1FrB39a-vVRaa3m2uzXExJ6Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
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

On Thu, Oct 5, 2023 at 3:12=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.56 release.
> There are 259 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.56-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.56-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
