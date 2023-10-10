Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FF78BFA
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 13:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="jRtqKjd7"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-9ada2e6e75fso1028457166b.2
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 06:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1696944117; x=1697548917; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aU3Xy//CzLR7h9ZqJQnq1g0juofjmbb1k71SCC4Re8g=;
        b=jRtqKjd7rTNoUcGJuTW7NUscFsUSSapajYI2bQxsQJu6GoSH01dZrEoa5wd2Oo3a1d
         9RoRRimxPnFw3Zhkgr0pNP80XfHBs5PWdjRcffdzP7mphZPnpDTlUtiIUb7CITv2BGVk
         cxjHfbwz/fus7AnE7zH/IkQEfbBONAd7NcFKW6gGMuTMFb7KxsstVQig6GWjsHiIzdyt
         mTO7kMCXmA77Pz/Zrn6AlncF2xd+/jjtAlImkO9EDSv3Liynt6naPQO3bDbdDGTAvf+e
         dOuIuUEKNF8jklDumahaJ6N0p87+C4EOtPJJn97+5QaO0vA3N33IBacaYNVwezqLhC+L
         9UxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696944117; x=1697548917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aU3Xy//CzLR7h9ZqJQnq1g0juofjmbb1k71SCC4Re8g=;
        b=l9fkDtZxZSamnAfGeTd+yzNxdhH+N6oXYLTd9vNDI4SEwT8E+qb4NSyOhe1XaiINZN
         PTKMI2HyWa/ZCA2qSkMXGjmit4moayahS10Okh0hgeOHdpbjLmF520VPzys6mlNCZTIy
         IsxprDVUqfVtJRNCf+iK0z2x62gBR1mkr+9f9vHL18iDsOcRPPt1jgQqbsgvdf75VApV
         4Se4dpmtmqYYiQISo1WNET75R/orjG+2vQA+hQfKf5S2ccwPr8N+LNIhc0rlWX0yKoMr
         GQkPUxzwQ/nbgBqJPFL513SKvXjzZNiJfgkzySy32kSO0d7iSEyUqNYTczyZP9R2gv1Y
         CFYQ==
X-Gm-Message-State: AOJu0YxuTUtOdYFquh8Up1k9b3WmQPcqf2icsQr54dyoOIJa3KZCDdxH
	qNXuuo0DNh/SavrRT5v+BH0aKU6M8Oi0G4ssdNvIWQ==
X-Google-Smtp-Source: AGHT+IEGxCodEgS+dG4Qmb/gPW4HE0qW8E/tpxQhRepvXhxikQlgiFrJMtbJ2Kx1NfOPrl6efMMFbwubxYJl8VIKgTE=
X-Received: by 2002:a17:906:844a:b0:9ae:73ca:bbae with SMTP id
 e10-20020a170906844a00b009ae73cabbaemr14081742ejy.62.1696944117138; Tue, 10
 Oct 2023 06:21:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009130122.946357448@linuxfoundation.org>
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 10 Oct 2023 22:21:46 +0900
Message-ID: <CAKL4bV5ZhhThGzTgo3keFKnnHBwfnhZ+7P6HMX2xAPjhZTFgug@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/162] 6.1.57-rc1 review
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

On Mon, Oct 9, 2023 at 10:16=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.57 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.57-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


6.1.57-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
