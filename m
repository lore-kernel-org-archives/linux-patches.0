Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455032B545
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 17:27:18 +0000 (UTC)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-1c4c7a83bcdso2937409fac.0
        for <patches@lists.linux.dev>; Tue, 22 Aug 2023 10:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692725237; x=1693330037;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fiue8adnEplxNCTAe8x76ojpHeALtOKAEKBFz0Pp5XA=;
        b=XLSVcSF7OK0Dx/KBUVSJfmuTPF788JH7nop1wrwgECZ2000enPzPxDIyDKEiiFcbic
         dFyPL//RMX6Jfp74r89NUAK4TETGpf2tPUONKOm0gzQcaI9RoJ0PRfkZLkT3LCTueD0i
         1cXPBqCOKJnFDoEax6sZDUYmguc/LMpxpQ8Ro77K3pGNGA/w4cRwL341OS6zcYx9OdO/
         hvBLmea1RmGYK2ze+Q8lW2YSVJhfqVUakUKv/ow8MxVn9u/634dzrPZkP3RaQZ4ggQpO
         ICdJSBrYtQdUvxpodJrkBMhSp6FEmvb8PVmENMH6Ye9D8LtIUIKG7DYSrcQTc5NVS/xC
         q/HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692725237; x=1693330037;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fiue8adnEplxNCTAe8x76ojpHeALtOKAEKBFz0Pp5XA=;
        b=EclDMM0UWKn5YJ1m8WUTfzihIask0X6f+21BJGT3wM8x/4GLb/AsML1JqUEUbAvo5S
         cwK5LX3dJFp2A4KJ7tDEMOnbqkh1kIjyDwXmXducwQrSORRXe+UuMm/TZqdBy8aGcWuH
         zsaMeSDQtMJTk8p5hlGAQwN1W3T8XjgG4LqouidttLBWWs6fazcsCQHg+QTThP+3B3Dq
         HGMS7H8nP3//YFtoK580meWHBBYGEOIbFwGWa1J53FW0PrCcrqy2OzezPdcPodkkuw34
         JgKTyQtDAlp7xUAAAjgSVJ0l2//9945LUCis1ci8bvB3riPSZfW36RCd5KLxMviO81Fl
         Po7Q==
X-Gm-Message-State: AOJu0YxjOSqcWUuiLyo55RnA1mlqpS5omCSR/tiuWYwCWVJEgUjySmhV
	jG4oqaGAVlGNNsciks3u++cMSZeQBp3buZt5U+E=
X-Google-Smtp-Source: AGHT+IEcDfI+EwFqDNdY62vV9JavQLjkFt28CXAKlmLiVxH10C30Wd+S+GYDGckUiNyX1divnx95wkPO5XNmVhqNIt8=
X-Received: by 2002:a05:6870:9110:b0:1bb:99fe:6ad1 with SMTP id
 o16-20020a056870911000b001bb99fe6ad1mr12592794oae.6.1692725237163; Tue, 22
 Aug 2023 10:27:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230821194128.754601642@linuxfoundation.org>
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 22 Aug 2023 10:27:06 -0700
Message-ID: <CAJq+SaD6Ls87X4tMwZSjrkOJtwn5oOo=DvszZsYiaAEX57HXoQ@mail.gmail.com>
Subject: Re: [PATCH 6.4 000/234] 6.4.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.4.12 release.
> There are 234 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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
