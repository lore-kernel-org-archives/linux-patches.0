Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFC1256A
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 13:19:47 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id 36so21912256pgp.10
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 05:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U+mHMoqOxjmqlEKrrvnWJRDjZ0/NgeDWv0+LnS3FTis=;
        b=HDNHDgJaLjQvC4ODh63qdBSKzGq8Ri77vm3rywY8ZkY39iyX+tsnS/bQloA5fydjJA
         Gr8D/UE39tbGqpj4brtX91M2fYNY3NjPiYuwFEMwxSC6trAJmW5H8yfAQo6fWbUbwL+I
         G4mWWoF3R0XRiSypyGAjJNkNeYwXgYWJ3X23P0l+LRkqKyy0cW68g8kd+t5wDfbnZ9ip
         +5CPG9NL+dq6Rbgrzhf3dVNZccLmsdmfyfRKmGszQIcb2O3jiWCQWwD/JTjLEefApiBh
         xKTIOiBKegbSIXkaYeXmc/gZDbdX+UNPNgqkNj/BWf9MfpSvcQVqI7v4CCtgA/pIBNgc
         Ts3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U+mHMoqOxjmqlEKrrvnWJRDjZ0/NgeDWv0+LnS3FTis=;
        b=DnUZbHMv9ETWu3Uk7u4kDvMRoGOJlJComKAnXWiVpb3cCv1dpGR0kYAy8I9YgN0xNY
         XG8+t/03bWxE53yFGqL8ttEltMbjbwyc1FiBBq4LPsr0MPIpAAT4KBXp/NSSuBqeIQez
         8fl1ps6H/kvNBxGbb0EFXTI0j4BUxk+hdobiMUYEfW6dxBUYNHGxrsV3nFZBruCaU6sw
         dE7o2PfXUIuPF0rBy5oVOw4GxOrXpY67ffVFgilAaPdiF10WJO3BwtgZmifV8A7azqpJ
         AWgtN74kfUk+RGGLxKW88qHInMb/Mvj3aGoAK2OQw0YWZcAh/+ZKmT5nmBhVWlkQF9Ux
         phEQ==
X-Gm-Message-State: AFqh2kqonveNMCeAi2jvfXOEvJ3BCJNDZ2DNtCDWYxf6cQUXi3JC1Hvb
	NhXe9BJkCqgdd3qAXMO94AMp/o/VaTwXwDD0DFg=
X-Google-Smtp-Source: AMrXdXtJ+wI0o3LZ3iVb7QJNPU+v5VCjfsfJIvOOAXonGRm2rTJbG86U9Yk5+BouX0OFe4amGOJTBmIsmbTHH3RBW5o=
X-Received: by 2002:a62:e40a:0:b0:580:8b92:ecff with SMTP id
 r10-20020a62e40a000000b005808b92ecffmr302635pfh.4.1673961586875; Tue, 17 Jan
 2023 05:19:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230116154747.036911298@linuxfoundation.org>
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 17 Jan 2023 05:19:35 -0800
Message-ID: <CAJq+SaC9Vrp5R0Mt78tBCDiT30tW1o6KyFvYooosq_Wt18-fqQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.89 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.89-rc1.gz
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
