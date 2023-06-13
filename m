Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B47B33E3
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 17:46:08 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1a6860fa9ffso2271167fac.2
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 10:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686678367; x=1689270367;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r+5mwwaA6A0ULLPC2ogIpHLP4usp/UGrYH5kzIP5CcU=;
        b=Xi5Rwukde4hySx+dADQprbbqtXFg27ORxv40DoaCuyfYEqZsATebk5ZxwPqxdpYr20
         4ZDqtaICcRXMkQDMA+pMwpadAEv/5HhzX6AJ9yOJ0C4sSo/GumoX5zJXG5lclW6e9wKq
         b8pYGA/lyCOscOOo+cJqVD7R9W/rQPu2X+EpPRtjWLriqZikEq+EdWVzGEKSOb02j4Og
         qB8P/3B+vpaGKWlgnFcJG7nr3GnJtI47SGR1gsF8o4b7B82xKvpe3LSxu55Do1MeO7YR
         G1lDQAu32+6HKzptIooiCDtOvtLwVikauPmZW9e5Aya/sO0fVGJP2s4pmQsue5KNueYJ
         Zh+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686678367; x=1689270367;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r+5mwwaA6A0ULLPC2ogIpHLP4usp/UGrYH5kzIP5CcU=;
        b=Y4iCmLvor47GPzec63EhpUXKx5APl9XZfUx5BFisV6cJTKC7gaDDvOmMoPVMLOJhUo
         ji8pDL4yNXpHYGlIXAo2U/exj9Gl4FXnoPdmgp5LW4kKRphit+ZYMUvzPo+iV2F1ah/k
         TF+6C1B76qWJH+tjtRyOC+FCpoHAu/H4Nsl4UMbW30mXoizQBRNu/XHafPBYJ9id5ee3
         T+itksXpSI9M9UFtxJ0+gJRqL6soH3OoRdUfbaUJu6eaOEJYcRuxM18MtIVMR/1Vig90
         B8FkTNeT3ueqLF8FVB7/wx/+RzNK9hQweqspASR2lbxRGla1twiM+Zd7cDM+jZUvb/Cl
         5t5Q==
X-Gm-Message-State: AC+VfDzF64zD1FMBoMJBwljzTLUfjgJPrEwLl5iFVjRY0CCPOmKbdZK4
	Hmy8lvNd1L63TkVOJUX/tQp+aDGdDs3QpSeRamU=
X-Google-Smtp-Source: ACHHUZ7rAuJaneU4XmHOr/sNK6EYX6i3ZzOzTFK+UCnoMHQU8H2iPTj6JJkrv3m9uGffddzwLg7nW26CkbWKKAMC7Mc=
X-Received: by 2002:a54:450c:0:b0:395:eada:79d2 with SMTP id
 l12-20020a54450c000000b00395eada79d2mr7802606oil.52.1686678367345; Tue, 13
 Jun 2023 10:46:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230612101658.437327280@linuxfoundation.org>
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 13 Jun 2023 10:45:56 -0700
Message-ID: <CAJq+SaCrwy0JkryrFFC5Nq2WVH4cX2um6HJdqYksoV8rxTx_cw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/68] 5.10.184-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.10.184 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.184-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
