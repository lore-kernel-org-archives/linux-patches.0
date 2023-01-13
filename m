Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FF6AD4A
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 18:00:28 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso25130289pjo.3
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 10:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ke+ienpbuFMxWDqjTnzXxB3ry8pENDQ07EXrRNlGZRU=;
        b=G4mb5qnn4HfOwTQSLovmIewgur6Z96/xjlZ65HdfRB6f2xMA/vWIG2wfw1hr/nChzS
         32mtz828+E3K1bvLflqWdRmy0wfFDWozd/JVNxGYwmb67dRwQcvMoXeHIkApxPC1ciV4
         xnOFtj3ivERLFS6jWb8onr2C88Y/xWlloQ0YyY/W9rOqQ2RLjG7PhlWgW8BGFQrjB/ys
         dCdAk48N7hYKuys2+fHRPDcoJVETA1aV7P2h+8xuIhTmZyKz8LQL8WSTzhEBtfhSulFT
         JGYr2k/kqidqhdCcz2tjlO2S+602+Lw17Xn5BkX8okNNCMqzGwL+8GXZ8dTPp6mlUxIT
         7fqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ke+ienpbuFMxWDqjTnzXxB3ry8pENDQ07EXrRNlGZRU=;
        b=ksvJ7dZGycj2EwxaDdMHMGRnISbQffLpHS12PCjTOrbbojSBQWe9ywoo6q2Bo9DnVM
         FcqV6zWc0Szp78CVYs5xK9XYLmcruvnkUMHMoljjNn/hM5Gy6k7lEKwZ9NBaaBrRJx9z
         dvjzxewkPMYJUpaJu78xQSnkzvtJu+nOmw+u2ap17K260+lwzNet5wS4t0iJ4PO2qswW
         cKM/W0A2zajs9C/pqffVXeqoWNkGVOx1vE0aPkx+teI53QabEHX4g4WRmlh3bnX9j69t
         PWgx9WWUnNZGBJ6/kDZbtEcllTG3aqeaYb5oX+aXKrQAgIlt0g6rUnyB6p9a371pd2yg
         tmcQ==
X-Gm-Message-State: AFqh2kp9cONC2VehQyoVzsRJzs004CR21EJPkmwAo7TwjYTlcsxfq9Fu
	qtlnu8kPaeASVdrtgktdQtX3Py8i3DT94/2zKBc=
X-Google-Smtp-Source: AMrXdXtuNPALzE7NjD8Ef7TcmxoiFQT7MKvPY5Hl4JnizFCF7SPgtbZ9kns/CvMJX0BoxyRA3C9dvaWBsCeg4s6vep8=
X-Received: by 2002:a17:902:e786:b0:189:8f97:5f14 with SMTP id
 cp6-20020a170902e78600b001898f975f14mr34180plb.49.1673632828199; Fri, 13 Jan
 2023 10:00:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230112135326.689857506@linuxfoundation.org>
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 13 Jan 2023 10:00:17 -0800
Message-ID: <CAJq+SaDOEUqfp-dK_TibbXwT9zfuFf8bgeR3BeWsCpTEOJz9aA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.88-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
