Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A21BBA53
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 21:48:38 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d15so37324010pls.6
        for <patches@lists.linux.dev>; Wed, 04 Jan 2023 13:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8adn/A+ajwGMUNs0+eHz0ODK0JoWcFgYpFS5En2WFqI=;
        b=WlGHn9tSSddPZCXT08KVBFVDHSDRlD1XtEo5BEpKQIGauMpYh0EWw2jh3DxU4yZAZ4
         iDx2Yx0AAoTjl8KXkFOyLPi2MUdx9cHorPJ5Dn/vlYF7v4XCkoSYtl0SYvbXH61GtWwi
         iWHPg+0iQ396j3Jxqmj9NfgSRu9+rTrpM9zJvvd5YPyi8xRnSy2YnF4Okb8EIufXAew5
         o7jWcWb0a+VkZyS8hhwBigYG8R80v2idgL4Q9a3u3YEtFZ+8/OjjyQtZ2uAgq2ExXIYC
         DP5SY59mJ9dRjn5D1wLjpYX7mtA753yvpB2P/fvU7lrzgAHAWjf6VRjfbhxJsoIN9nRF
         gRBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8adn/A+ajwGMUNs0+eHz0ODK0JoWcFgYpFS5En2WFqI=;
        b=btcGN82CMs/5HpsKKj7t6/9JsjGMUmKQWC8A+MWkJKPPsFXgEOZjZivxkKAMjD808T
         agKPF2x0WL+qdVpJTWtbDC5sIUr4LFCzgoE4fQOxNgTqiZbX8IId37F7fed2fIHJ4Lht
         LX3G9JFp5FPMg+UQe3+Tq+prjOEkl29SwBIC81RwPnji/5QZMlbFuNHY24SV2fZQbVO0
         HsPFY2CXpRxCruzKt5jQdueobCPiDTCFZbj8R9JkYxYOHca1ysWNlZ8ctsxHMOW+BKlf
         PIEGCl42IAwr5WraLtl/G/isaU7bhARa+4/azJ9N2PQaOKhcLJAoVOeZgvV2F1ARQhQv
         Zapg==
X-Gm-Message-State: AFqh2kq5zzaV1yCvOLANuoHAD/KLBXgKztey1fqOiDdVZr3wig84V40X
	9MkRIAdwtzDevMPaZ98JudkOAVjuAMUmM4DWcsY=
X-Google-Smtp-Source: AMrXdXsFdmIMy4C/H9FbcspY++BB3gUKc4jjVkr3RAo+sbvY/tSFk1ExfBfK4XwUf+4E+MFv9nT2wZmgHfLD8SIJiCo=
X-Received: by 2002:a17:902:ef95:b0:192:97d1:a4d8 with SMTP id
 iz21-20020a170902ef9500b0019297d1a4d8mr1914957plb.74.1672868917682; Wed, 04
 Jan 2023 13:48:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230104160507.635888536@linuxfoundation.org>
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 4 Jan 2023 13:48:26 -0800
Message-ID: <CAJq+SaAfWD3JskX1bASjUa+fpTaHrxm1Tzg=4vzgK2gzNCPTbA@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.0.18 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
