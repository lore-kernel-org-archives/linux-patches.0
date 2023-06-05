Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6292C323E
	for <patches@lists.linux.dev>; Mon,  5 Jun 2023 21:16:11 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-543d90cc675so477414a12.3
        for <patches@lists.linux.dev>; Mon, 05 Jun 2023 14:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685999770; x=1688591770;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pgABzOJPJ5VIj4UQYjPtZhIHLv/LvJQylDwcub2S5pU=;
        b=NDEefdGqTeKN0VC0nVdBRObxZBclc8lfeYbbNMC5GVI5QfRrLVsk2VstFZXB6x9Qax
         1tfj5Tc7k067Ym30bUuSAL9cTG9J6DGO/XG28pO0o6sU+zE3gfmgfAOFZFAR0HtfTPxe
         WkMARgoT1VI7LgZDdRlHTb9Fw9rL39+GWvpsK/qH6rsNcF7v/QEA48HsPQ8oLeq54aD+
         PTEYEuOWBYxz1dDHA2XQwfwgETw2P/OzhLpHiNgyUZvWE/2bhseAupxSLPZLSHMD2jfb
         Uo/se/6iBxktgiORd8b/+wienQArE0DMPsRF5xP3PoXkU71PL95E0/y684Jg6Df6SBOv
         zqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685999770; x=1688591770;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pgABzOJPJ5VIj4UQYjPtZhIHLv/LvJQylDwcub2S5pU=;
        b=ADr7uIMOtpCRFImoFCEkgXN6FPVfJH18oLPXvLgIRNu5RKIuQFoRrpd+L3qtGthXYt
         ij1lGnTIQOIo20rTVoMVUNPcb9NXkGn0U1gnl7DoFQVEZu/0jMxvCZxEE8jzCX/PYPin
         cUhoCMlGqp+pKGuBRPh4M2Njx7SD/OeYutaVRy9AyFW4xjGABq9xdfcDV2sKZt/4rm7e
         K/97LRDcKyhIM2wlvrqr+ee0ozFZTpZCb2XC/+xR7xYGCpVVFePuOKct1f2m6bYYhsne
         +Zv+dRuIXX+5AvitOGTWGpEZc4NiLqN1xG/0N57aRGPYpf+QPs5iUVlyX5H9tN6WJvfi
         zL6A==
X-Gm-Message-State: AC+VfDyvmlzF2jCqKUbdfqKjpZHR0GS/N2bLD5R8FwiLtdUoEVp51P+I
	KEfA1ErRyyShFTDTkVmskI+nNr0xUCUC8z7D0PorWpQNh6o=
X-Google-Smtp-Source: ACHHUZ4gRcnOB7eeFTHK9+AFV1iotvVJC3lxKfkE/D67ktnXzZGsaN6ap1I2IvSB3gRUYgCA8JtK9+wDW9pXTlLj57k=
X-Received: by 2002:a17:90a:f98f:b0:24b:2fc1:8a9c with SMTP id
 cq15-20020a17090af98f00b0024b2fc18a9cmr3824386pjb.11.1685999770620; Mon, 05
 Jun 2023 14:16:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230603143543.855276091@linuxfoundation.org>
In-Reply-To: <20230603143543.855276091@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Mon, 5 Jun 2023 14:15:59 -0700
Message-ID: <CAJq+SaC3jGqmM1k2FbpSoe=3uZC5BaO=SPgHW2JuAhxqeLk7ug@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/35] 5.15.115-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.115 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 05 Jun 2023 14:35:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.115-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
