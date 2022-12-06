Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB26027728
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 18:08:34 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id h33so14059404pgm.9
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 10:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ebNy6ciyWP/1wiyDXiZM5ebyIeGQ1+JDe4V/MHiBZ+Q=;
        b=OtUqvnwUVOzkQtcy9vnKjntBdvIkNoE1QdM6g7d4AFJQnKruGjuo/jIu+0Why58dxo
         Cwk/orPSQPpBPc6O12Mfd2+BGM3xeAxVJASCTKRpnWguwv/Jwr8aQLUNDhZrx4Hlq6lP
         5GqdrF8v8myEeXDypCZgW9mmN74IRaLMZ6w0Ipsn7iOQDY5JPThw2UeqJfCd45HSa1ht
         6JjQx4q4gqfVcAbQ6zvL3yYfbyP6NiebJe3QgJJwUJNBQvfP3TjYqEC0t0cJB3sRDsTA
         JZIlormHlVuav8KMtAFgkcywAfCmW5qYtN2VvEcxIsAsIzM+1g6dxPV3/iw7fT4nm77o
         TTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ebNy6ciyWP/1wiyDXiZM5ebyIeGQ1+JDe4V/MHiBZ+Q=;
        b=btE3H6qoDyeHrEyoGU3BEISGIpXonHh3qHfROkg7lDbCNvi3NnECDvEV9B3QK94wdd
         Cg6mbiJAs/ZXgIav00giafyqdeKCwgYKpYvrf3YF73c2bYqaLHgfn1MqCZuuxI4VcCr+
         FL8WcRqVFcQ5+C3GkcM2U5rrJhSeowJnw4IW6IBg2OohA/ndjKUc0yi3FKyxTEsJ17Cf
         6s77iZ+HxuE6gqr6XgqSzmkk0CEVnLr1YG+TM4cU5fHe9S3N1xpvpEhWDjbSXSNmzLI4
         krzjY2iASXgomYqEYGRMbcLJb+YVtpBDRpXwao8h6BHMlVauKNEovFq9hdqzJTUNQpbT
         POog==
X-Gm-Message-State: ANoB5pkS0y2ZvoxzGrGq3wsT4bQY2lYmrM1A3kK/dvNKpKpDR/rNYvj5
	CL+Kl5iX1UuV+3/y3TI2yqZw7rGuqbFK2pF8Nhk=
X-Google-Smtp-Source: AA0mqf7MgxRO98B9Da0Eyo7NARQx3m8FWTBB2bKRqrCBhIW4Wo17Y44H1pXz3YVK4KbEL1WLqDEbyHVAeVaDQ1b7pLk=
X-Received: by 2002:a05:6a00:1d22:b0:577:16ac:8447 with SMTP id
 a34-20020a056a001d2200b0057716ac8447mr7955316pfx.56.1670350114320; Tue, 06
 Dec 2022 10:08:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221205190808.422385173@linuxfoundation.org>
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 6 Dec 2022 10:08:23 -0800
Message-ID: <CAJq+SaCrQG4WBvPPV05E-206-G=kVjyEBNyVs498nOEGzzx9Sw@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/124] 6.0.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
