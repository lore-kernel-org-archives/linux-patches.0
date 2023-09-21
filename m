Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B69EAD2A
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 12:08:56 +0000 (UTC)
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-7a7857e5290so365870241.1
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 05:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695298135; x=1695902935; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f0A4cf8xaLph2RFxNW2e2zC/ozNHYMpBHiQTWSZDrd4=;
        b=zx2f3VIghu/nczWuJp4ZctAAcr9kQao63xUqTBD6P29ocavH8Tzm9PRR6fDJQbkzdU
         iOqGW69dPVplzmZEIx2IomR9AxeoOhc1hf9CZlqgIPi+HL5sMGzjxdHW804gJvFoiCMN
         SfNJbeJgeqUBD2k+jOXcznDjnl4YWKftEg3BSUdSmhxWarNN3Mz4R1x4Y9VMRevIaXJM
         /iHk9vhh9Z5SbkmSgxjCdPP8X10a7nzvxs3yDpE1nIqx2n7CiFRfhsAGD4nosV1jAWDN
         2LTuqeeNIje3dazMOLFjBuPWrElqYMIiH1e6PUExXT4ibvbT6aVj/2XlZP0CawtdOujP
         hUfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695298135; x=1695902935;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f0A4cf8xaLph2RFxNW2e2zC/ozNHYMpBHiQTWSZDrd4=;
        b=ELxb7H0+YlycjJSn/cJbmzFicUz1WB7Rj+X9hMpzgPjRRIKON6dsfbquSxOSEP28pV
         uQ+uD9xEQQ4jZhtTvCkI2ryJNDWDs1sbgmBMAl9WYPRc4i7ZeSsU+hsebAJH95HwoSjB
         r32+CYZnYxpfEY7agqT3XUpYj7K02ts74keX9HXiiMuErBnuIDdX3t5mKnib3wj85RDC
         j1H3RwMRu1Z8yiC6bkDE/q33d+eG1vDv5CjwCJR7uL6plgU8/pHXt31EF3kkvR59HUr3
         sekqeJzsQfxwv0bz6m0kVbwHaIixZJV6ePZcZIJnYbYmW9xKhu50ZZbn34m7SYi8J4qu
         pX5Q==
X-Gm-Message-State: AOJu0YxuIHx2HmK9WOvAwc+ah9xGC0S3FHzYvs0VVCyVYfVLjFXHjwYO
	kcOXAWma/o4YFr61reIdwBcUcviwMSaoBxmejIt0lA==
X-Google-Smtp-Source: AGHT+IF6qOrjEY9if7ZapsXGGL1X2pv/FF05y7VvQhm8TwsXueJgwhY8SQCZZx9F8vyaLZqpsJvBOnpMrRr0N4EDD4o=
X-Received: by 2002:a1f:c6c1:0:b0:495:ec90:997e with SMTP id
 w184-20020a1fc6c1000000b00495ec90997emr5200602vkf.7.1695298135191; Thu, 21
 Sep 2023 05:08:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230920112858.471730572@linuxfoundation.org>
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 21 Sep 2023 14:08:44 +0200
Message-ID: <CA+G9fYsM0Lr8TNQJxsZFDZwcH-rEzkVV+y+x5FX18oH5wm5dRg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/367] 5.4.257-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	Sui Jingfeng <suijingfeng@loongson.cn>, Chun-Kuang Hu <chunkuang.hu@kernel.org>, 
	dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 20 Sept 2023 at 14:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.257 release.
> There are 367 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.257-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build warnings noticed while building arm64 with allmodconfig
on stable-rc 5.4 with gcc-8 and gcc-12 toolchains.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

drivers/gpu/drm/mediatek/mtk_drm_gem.c: In function 'mtk_drm_gem_prime_vmap':
drivers/gpu/drm/mediatek/mtk_drm_gem.c:273:10: warning: returning
'int' from a function with return type 'void *' makes pointer from
integer without a cast [-Wint-conversion]
   return -ENOMEM;
          ^

Links:
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2VfG47LmPH9MUEuIcMVftu6NsFy/


Following commit is causing this build warning.

drm/mediatek: Fix potential memory leak if vmap() fail
[ Upstream commit 379091e0f6d179d1a084c65de90fa44583b14a70 ]

--
Linaro LKFT
https://lkft.linaro.org
