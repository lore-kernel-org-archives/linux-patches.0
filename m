Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8834A273C0
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 12:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="i1adOnxW"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-53db3811d8fso9228987a12.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 05:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1698150808; x=1698755608; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a+d68ElJXb15txlNQvNv4dpc2clYVoBlH5oUxqTkrhg=;
        b=i1adOnxW9iJ3AxG5Jow77IuHRus6KVDdoZkktndZPChmZochtuOwz7lem5dLoIkASH
         cmI08EP4Cc+NjMCrl2jEMS5rwg5NzCdDxcdp7EiCnewY4kJZg7/PKaXtHntQbZOdN4LL
         0gV+AXjKk7BqeWMkUe5BQxSw9+mE28cNj4c3HWorEJxOqE9JuumhwA3AQUt3WHBN/Ws6
         QoZ2NALLN/p2dzIgd5zL6VhgWdmzUhgAqtYoqzDjGkdhW+w+ysyMAjEMog4XjtUB+KJk
         5/d8DzgGotVfpeX0prqp+hOlk4AAH01l3buYt3hpM2A/KQq0xyWJZVRjnisF0QNV+26H
         bcvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698150808; x=1698755608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a+d68ElJXb15txlNQvNv4dpc2clYVoBlH5oUxqTkrhg=;
        b=jOUl8hPBF0ycn0OKonc3U8wbnsty8wbY6KZNMJns1C0+8GWofERuY634PBeh77R0j+
         QFKLDvDuRVsGLHB6gwIcTR9NSuM9ZM1DijGH73elhtHsER5hsZFx8yPAgt6u44otTz/1
         MIjb9WB7iKCai/ZkIED7luRptnYeQjuUQdATFRXdIeX21wtD7UnOLYDgntSIbcUz6u6q
         pQsd3yfgLCgaVtVY5sfliOyAAGDch1vuOsdb6fvZ/h0CQsOj6STtkTEGFg03ejL6hpPA
         s4aRu0mylaztVnlXllQkyFZfZMROZOZzMCyMgl7GPcoqVPQRAerd4Ie1ODXr6K7bILph
         HApg==
X-Gm-Message-State: AOJu0YwNFd2OvEIT4vTT9D29Wn/hi3CPTXJCci47BEsu/zWvx7d1zdI8
	l1nLYO/L56E3dKKzHzjovqpe/j8UFQX2UDvIy4JNuA==
X-Google-Smtp-Source: AGHT+IFIE9BIMcYN4kQR4ERtaL5CfnISK2mhAZ8gLDndSgRZW3ZOJJxhy0/w+R7raxMOicROhqY26qlwaC+yMCMevAo=
X-Received: by 2002:a05:6402:430b:b0:53e:264d:be1f with SMTP id
 m11-20020a056402430b00b0053e264dbe1fmr13478212edc.2.1698150807522; Tue, 24
 Oct 2023 05:33:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231023104828.488041585@linuxfoundation.org>
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 24 Oct 2023 21:33:16 +0900
Message-ID: <CAKL4bV4D4VD=kQuocwjvZxjLd3h6xUCx4mKugDGhY8muxH1gNw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/196] 6.1.60-rc1 review
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

On Mon, Oct 23, 2023 at 8:20=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.60 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.60-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.60-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
