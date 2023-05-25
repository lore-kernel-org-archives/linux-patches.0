Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A83DFC05
	for <patches@lists.linux.dev>; Thu, 25 May 2023 19:15:40 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-25376483f66so88225a91.0
        for <patches@lists.linux.dev>; Thu, 25 May 2023 12:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685042140; x=1687634140;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vD9x7QANhEDW3ZYK/Nv1s5u/+9spAL4qRvjdLuUEXnw=;
        b=gY/WqbDO2dsbcTaVqdWRDV93u/7xbCUOLAbKWzPEtNF4BRi2usRUXxby0auby2u9Sk
         Q4i/Cx9aaGiw0rNKzulopZU9PsbWQn+rulu1qCAbk9wCaa1BOPPg5MOuK4oz6WZmsNFo
         oY/amMsNSRvwHxylqMrWeUUz0EdRWQI5W335aA+VCY+2D/roy0SbRPSSZSbbBgvj6I+L
         hMqeNX+n+8/CqP8c09vzkD3LQitgzt91/+NSQZFscEAJh2Td+reFAXHZA1wbjvLvKEXM
         rlMh7Ns+hjLIprwo+5AIFNeZd+wN1Olvl+UlYNLEfdIqSmThzEcO4URgaSXqSHXvLWaJ
         zMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685042140; x=1687634140;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vD9x7QANhEDW3ZYK/Nv1s5u/+9spAL4qRvjdLuUEXnw=;
        b=iLcIe9ePXEKi50yJGXYD8KD5ZCTUxFOhBI/U2miQovK2Fmvv/qq5o+RDHeReO5p9Sz
         XLbBdT2LI+rmgArRVSnPtCEn/9FDHDgQxC4PxolTuXuOn/xSWgTFugrS6RBvzdMZa3rZ
         byQUREL3zGZP+4dp+iQ2lEwqpSwwr12LOlEfaft2r2sS2LTSUp6nV3RqnIj8x3yOFnGd
         R9/C2e0b53Fzduk9psSf7KdxSsDsjHKWw37uVcSU7vn2uaWiJswx5cIrQJ63rtLaypVj
         qcAe8WLx0c/AufMb4XG5AH1re3sxd3XL9Of+leOiW6Mj5iuCD0E4MiWhFGJZySOUDKXV
         4hvg==
X-Gm-Message-State: AC+VfDwlXeqhzV1hyAtWRoJENVKqgm/pqOkJ/vEuOpngkg3K1gPewBnn
	sJJG5Hevmdl/d+n4VSPAaOznLeQimqdfVwLNeNs=
X-Google-Smtp-Source: ACHHUZ6tdB8wkjjb1SWqZ1GhpGQ/2w3tMK5HlcJyzjQcAQG1inzfeSu3o0keKePlJynIx8D8qm86vKV0GCjYkTQ6bMQ=
X-Received: by 2002:a17:90b:3810:b0:255:6c5b:3660 with SMTP id
 mq16-20020a17090b381000b002556c5b3660mr2866730pjb.20.1685042139768; Thu, 25
 May 2023 12:15:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230523164950.435226211@linuxfoundation.org>
In-Reply-To: <20230523164950.435226211@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Thu, 25 May 2023 12:15:28 -0700
Message-ID: <CAJq+SaBU0WbQ+SF3FvcF45Jq_U9KMjuPDNhdmXme5HRL249+9Q@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/363] 6.3.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.3.4 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 May 2023 16:48:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.4-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
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
