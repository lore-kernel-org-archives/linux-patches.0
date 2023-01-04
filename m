Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BDCBA31
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 19:46:30 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id a30so7991171pfr.6
        for <patches@lists.linux.dev>; Wed, 04 Jan 2023 11:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Lfp41JQ/onUmjvZ07AVTcvQ52DwcrIfI2vmD2kQlaH4=;
        b=kO1or/RXoA05nURTG3xyN7muAUlj2ebxkGpDEctbc4x6Nqwc9T5PxVV04perKzOzW9
         SX6g6Y8JUF48swj3lmNF14tIlC/U5klThXu4dbx1aukENqSQUMfFWG/jJB6Q9xbl1ltK
         qNpSfcQ6np3P6rpVcRUp9mC8cnnqijDUGEiEa3zFJIlnzS17Pzo8ryM7Pf7d5Xtkz6De
         d6c/bZR2mtvKLev5k1qwzFkOo676v92PcZ4Pdu4mwwzepQ38u9h6q16OeI0OAU6XWltd
         XlFkx5ntnXOFPR1ByE2rVojIUXNjYviqtVUQH7Boc2uHlHZljhmmamshUGtZcT5Rh9XN
         QtbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lfp41JQ/onUmjvZ07AVTcvQ52DwcrIfI2vmD2kQlaH4=;
        b=imh9EGuA/329RqS8afPx+gyxDH0PNM5WlSfCxMp27cHZrHQGi8oK1atoDWFijC1FHK
         oGFQ+5rYP+kekdI7cTVD7Y2BptU7gOhq8D0XUon8U2kyTvzY3OgLz3YJp0td8EQPDUbl
         jNHeL2zGVIkMW0Hw2hAE9jkxbA1RwRPkNdm0leo9Hs9NuSHPg2X0flBGJ6fSTnF8EPox
         EpBkcsQY54NyNGsga/m4oXcgbcW6PN5tX3M8Genjhgi+wBpQIR0HmyMw9BbxgXn9noLL
         +8Z6FiUjy5fUTGypkPLQFO/KQMpQfr2ZJYg00DjxfRG+YJiQw87IaDd48Yd4+Fon19xz
         suQg==
X-Gm-Message-State: AFqh2krSbo1MfvSsFuUO6yywHZbath1iA5oA1l5qfqWRM86+xcGp/R4h
	QoWNURnzgEd9UuiNNq/BPPkMiZgMqOSa/ZlsLNU=
X-Google-Smtp-Source: AMrXdXuUI87EkFUiq+H9wnUuDjm36Sg0u4sCXF0UhtLLaXBCzOjCNdY2tjgwN9QtDTcSCPtYCShEKY9S0cZg3XH6MT4=
X-Received: by 2002:a05:6a00:27a0:b0:57e:7d2e:cbea with SMTP id
 bd32-20020a056a0027a000b0057e7d2ecbeamr3153172pfb.27.1672861589963; Wed, 04
 Jan 2023 11:46:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230104160511.905925875@linuxfoundation.org>
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 4 Jan 2023 11:46:18 -0800
Message-ID: <CAJq+SaAqX7ikxOEsNvqyAyrtDes5-r1aeOMSx2fapddk8s3U=A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
