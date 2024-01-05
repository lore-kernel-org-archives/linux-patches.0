Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A713720E4
	for <patches@lists.linux.dev>; Fri,  5 Jan 2024 02:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZF5Gc/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485B4C433C9
	for <patches@lists.linux.dev>; Fri,  5 Jan 2024 02:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704422624;
	bh=rWN8Oxj4NlIFuGfV02gz0YSvDVcUX0Lebz4/0QC3IGI=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=YZF5Gc/gPqBQz+pf0J9R15qa7+pavkauDvvl5V2/Oo/FlF45T/UcPByAJYDhK9rYZ
	 r4uYIjklXG6XW97f1/PM3zWKKT3hjBiwjXgGzZeViRXIIDdlpCVQxGjtQe6++QSXJH
	 qebtyYPv8kS2MYQhgi71UJE0NZCxNKVj2uOjXO/VrpN5CzGboukhoYhJHJSpXvNgR4
	 78puAVtEl5zdD2Wxu/riMbV//o/zqw3jZVfyERguACJCIqGwAER/kgsMmvyfbH+Zdr
	 5v1cn9bf9mI93dNVSqs/qeewP0bPxhSbX1ZCjF413JzgCNVT+GompC3NTtCu0DNZRl
	 c7SZTX47300tg==
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2044ecf7035so644287fac.0
        for <patches@lists.linux.dev>; Thu, 04 Jan 2024 18:43:44 -0800 (PST)
X-Gm-Message-State: AOJu0Yx8+3ZjtV3ma3pUQD3azdnDbMXbWLvAvAwx4MCvg+dhqTmm3VV7
	4QPzw41FtuouEeicl/xJgpsuq38cfAxveK1ZfAk=
X-Google-Smtp-Source: AGHT+IFrU783/2GXXJ3JkkUuny22+ef5hXh174D7y54izTQ9amqMNItOH+VT7bsmTu2/ASJYRpQ6DR70aw79qLXepGw=
X-Received: by 2002:a05:6870:709a:b0:1fa:edc2:892e with SMTP id
 v26-20020a056870709a00b001faedc2892emr1629833oae.11.1704422623582; Thu, 04
 Jan 2024 18:43:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: by 2002:a8a:c13:0:b0:511:f2c1:11ee with HTTP; Thu, 4 Jan 2024
 18:43:42 -0800 (PST)
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 5 Jan 2024 11:43:42 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_g_Y=wp9qbJpLg7su7ZsQU_NgoGE-sybpJU56aU9d0gg@mail.gmail.com>
Message-ID: <CAKYAXd_g_Y=wp9qbJpLg7su7ZsQU_NgoGE-sybpJU56aU9d0gg@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/49] 6.6.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

2024-01-04 1:55 GMT+09:00, Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> This is the start of the stable review cycle for the 6.6.10 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
I have tested smbtorture and tests through windows client against ksmbd.

Tested-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
