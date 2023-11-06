Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836A8DDBB
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 19:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XvdRSWtq"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5b9390d6bd3so4608024a12.0
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 11:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699297278; x=1699902078; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OnqhWQVVoM13n/6TUxEaGzq6E1f+94dxT1yUPj1Hc6A=;
        b=XvdRSWtqv/zYA+0JNWkfN0YTi3aT0enjvCybfFKhfQUYPEBkMW3UKnvbYtSz1GfjRD
         o1bUoh8n+lYD2KeNUplb9srT0L76FPCyfOr79Pqn0UPKhe9TKiIx+mcR56ltyeYotYPS
         Fzkh6EgUl++whxAg1A9KYCR/+H9DqAW/1ytCa1eHxXmoRXrrf8lPrxK9+TYAks1fbPUr
         osg9AzITDJWqUsOLfzagQ86VMAw4sGlL3sJidAet9tw32GByItGlqXUpkf/hs3SRPEKY
         eNBWyw7f82YR3l9yLmLJkXT+wwe4PvXJt/wRJSiCIIoTmVX+0TSwAISKOd8uJ7fMvG8N
         rukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699297278; x=1699902078;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OnqhWQVVoM13n/6TUxEaGzq6E1f+94dxT1yUPj1Hc6A=;
        b=ggRGTmgSMfCsPqf83ASFmxIZd3sGt3j3zF6n82TIB5yoRacSAqpsmm62S4W9i+ySQS
         bNj+zslFmkKykLMFogfAIFN0AtO++Tq/hsP5JdIitkCGD2RnLHlp075VNYOYz7MQ66cQ
         Jbm7bsd3iCMBVs+WY8B07mAHty78f9PKnxijt1dXKbn8mWwoauu50RwFbfFtTOpw0NQX
         zSLmIugNZ/H6fkwLVvqUd0veApGen1HGF2RzjUeur8fIZMDs5V6G+MxCRXeSkCfZ1zjV
         66kojROSTP9MuERH84p+LlmWl87vZOwq49LnUq6zzw87ziELA9KuONrFqXOYGZBNskn9
         TdUQ==
X-Gm-Message-State: AOJu0Yw6Cj03w9dj6k/FxB9gaoQCp2/5LWbLgCIdaj5e8xLL1FNpQPtL
	RgX084JaOB4mpzUAja/SQG+mYHI+6lMzspIEI+g=
X-Google-Smtp-Source: AGHT+IHOMzZhwZUzQo3gVEguGmnOtkoq11bSZEx+5KCfLgJQeTbR+2oEYbr1d2ZSVvImy9vDPVQ1PLhH9xiUGNVdTaw=
X-Received: by 2002:a17:90a:d913:b0:280:735:bece with SMTP id
 c19-20020a17090ad91300b002800735becemr521126pjv.16.1699297277791; Mon, 06 Nov
 2023 11:01:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231106130257.903265688@linuxfoundation.org>
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Mon, 6 Nov 2023 11:01:06 -0800
Message-ID: <CAJq+SaB81+eq01-NGH_LqMCKAew7m-WE_05=qQ11RZT7fSD67Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/30] 6.6.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.1 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks,
Allen
