Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1DA33CC2
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 19:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CalCFT+o"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-59b5484fbe6so21895717b3.1
        for <patches@lists.linux.dev>; Fri, 24 Nov 2023 11:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700853508; x=1701458308; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6Y5EvPm+dIyyxToEIiLBN/BUv/oh/7CgG9QocWi6TRY=;
        b=CalCFT+oRb2YeiSvW2oD9YatKYAHbdFoSEd89k9RWNNISl1Ah4UnhcME4iShgdZaQw
         N5a5RIUqzT3/1icL+C7S2O0c5Ro7f5EUMguO9FZQPlv1BFuenWwfYQTmTzOx3K9HqEkh
         JDoSVDENW8Q325ACmiU1Bez3MNrCOv8EVART2djFt2XxJ6j8y/QUmOyhf2RgIdiP1tjj
         evk3gxlV1Ivyl/HVNbn4S6Pi2bbmaWUvXQoQ5J+UTcUl9OrdXIqAqwyr14aXxuvS8m+K
         TJ1/BhQsbaZLhCbLfKInZ01rwMhjnT0Ubdh4cCLkjxF9QHQpFeJP1sOlxBjdiIbZpyIB
         VbDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700853508; x=1701458308;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Y5EvPm+dIyyxToEIiLBN/BUv/oh/7CgG9QocWi6TRY=;
        b=pgcHsK8RipI4Efq0d3ku05r+UR/lasPQP0ROHTyKZ8egyaq52Vj67CUtuz+xC5HUzJ
         rSMppVTjCCdawxTpB/iUi4FfQ9nqH1q+vY34gD8ISK3eadIF1q9iztLYLvBeAvW1+z4B
         xdBPNnT0nh5cOD9pReEwdA0Zdhc48U5UAx3Oz+YaJpH0aZSxz6lIxD6QoaDUd3iq2jtJ
         /Z5x63Aqh6uCFXLvTDsiPsXgBh5hB789WmKlfx85lJKUW2UBQYHHd0Ev57intosbZifF
         1RhAfsTc7yyF8tOogu1JQTubQJlyjAmFFTE8hnviMyqOp9ksWIFxmQSMQfnPSR7IGXsB
         hNEw==
X-Gm-Message-State: AOJu0YzscD7Fsx0DQZfAIQXunGJVN/tAsTerJFN55jnd2YHJ/Lf3VR1J
	QjDejJGVEFmx/FVkfntNtXBlNk/2ftpTz53nWzFs3A==
X-Google-Smtp-Source: AGHT+IG0J+CigbyzoWqpfwOWZHGZshBQ3BB6VtNdolTpxujJlcObsE89jrok8amrqDkQvtpvSn2O/PyFKR2BHzwUbio=
X-Received: by 2002:a81:5e43:0:b0:5be:7046:b2f7 with SMTP id
 s64-20020a815e43000000b005be7046b2f7mr4634734ywb.40.1700853508071; Fri, 24
 Nov 2023 11:18:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231124172010.413667921@linuxfoundation.org>
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 25 Nov 2023 00:48:17 +0530
Message-ID: <CA+G9fYs1QwVjKK0wBcm2EtDbSbvG7fu7Ca=SBAZfGDAsEJLPZw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/372] 6.1.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zhen Lei <thunder.leizhen@huawei.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	Frederic Weisbecker <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 25 Nov 2023 at 00:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.64 release.
> There are 372 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.64-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build warnings / errors noticed while building the
arm64 tinyconfig on stable-rc linux-6.1.y, linux-6.5.y and linux-6.6.y.

> Zhen Lei <thunder.leizhen@huawei.com>
>     rcu: Dump memory object info if callback function is invalid

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
kernel/rcu/update.c:49:
kernel/rcu/rcu.h: In function 'debug_rcu_head_callback':
kernel/rcu/rcu.h:218:17: error: implicit declaration of function
'kmem_dump_obj'; did you mean 'mem_dump_obj'?
[-Werror=implicit-function-declaration]
  218 |                 kmem_dump_obj(rhp);
      |                 ^~~~~~~~~~~~~
      |                 mem_dump_obj
cc1: some warnings being treated as errors

--
Linaro LKFT
https://lkft.linaro.org
