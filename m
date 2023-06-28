Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7198BD50B
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 17:38:57 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3a0457d6b77so5291095b6e.0
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 10:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687973936; x=1690565936;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cWldZ174xGCS2Gs9xZ7wHxkpqbJdzsS714AuaqaJcGc=;
        b=IncwhENVMCB+5fqBC/VlDxPnjb5MRamc7lX1hqFGcFsMVLGq9UVcRPJm1uaxIIhmpe
         PeUJou+xTHRkVJhK+5C1kvW+YkzWy1wc+EFz1ybEhKv1HKAVYFbjr827X6KC8WHy2UPD
         1ABWFfwpGtCnPIir00Qbev4cjF+6v3Oeejr28Ou8RC/7VstYwip0mQz3zijpbuDhML4G
         Vtutc/epw70sZ+aSkDRdHZ+6Y735/+Pfcl4/sPGatXCsqvLvV4JpHFvuS9eX7DGG4OIL
         PxQPmxMS2VDbFVhURt1wKrQjcqFUvCBUHtdmvS9BM5Nq7IwBwJ+pCEbNh2Pq5Cf9zoXd
         SgXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687973936; x=1690565936;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cWldZ174xGCS2Gs9xZ7wHxkpqbJdzsS714AuaqaJcGc=;
        b=ABcV3I6d7vk76kkEhWXAYjzlfVx7Q0RzQkkcXJ/cZ/bqIwahzLjsaEb0X89Kz+FKf8
         vfMniaP0LXazfEGf4B11EYSWMpG9r+onIX9ffoidkNqAzkCReizdR6qwH31s9kMo3fjE
         RU/FGkqBalYEc70kxcHkXfl9cajLBy4pvhKRMgfj4SkqMaC03j4Z67T+5+spAnkZRmP9
         LgdHUvY3/Y09J//EKUVpdLTbwVwa73lxG0cuGDOhFuPq/ua2kbuZ0kvpmP5F2x7hifLv
         GkhO+WqND6gYlYkXroEmLh7DGjfSRC5Wn1wvhzEI6uAnvyN03zJIuZKT2Q1VT+w8p84P
         LnbA==
X-Gm-Message-State: AC+VfDyR3Lvi0dJjqXnc6UV+4jDu20QDGhqlTJ7JqtlAeW+iImdWW2B5
	G0zAfz0+gjUzviRdjheAn0tllipvvWOfmjO5Dpg=
X-Google-Smtp-Source: ACHHUZ5zCwL8ebBj47RFOKQlNLdPZtnvNZoB0jdId69CdbJu3AgINjUedNvNDGCXntBxMZTaduocIChOfpEfwPFalQc=
X-Received: by 2002:a05:6808:2122:b0:3a2:ee9b:4232 with SMTP id
 r34-20020a056808212200b003a2ee9b4232mr5841254oiw.58.1687973936409; Wed, 28
 Jun 2023 10:38:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230626180746.943455203@linuxfoundation.org>
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 28 Jun 2023 10:38:45 -0700
Message-ID: <CAJq+SaDMbKq6wvAP-qA9odEB6E2avudft=OvRFg4eMX1HexCWg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/96] 5.15.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.119 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.119-rc1.gz
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
