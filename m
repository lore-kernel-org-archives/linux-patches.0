Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98679D30D
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 17:37:40 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-26307d808a4so2169445a91.1
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 10:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687973860; x=1690565860;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1yBs5D4wuN/Qn3dTB04DQldh1q8a2hbv1sJCNrinerQ=;
        b=HWp/WrUb9iVyx1eK+ZvTzvrWC+7UTUHapR4hQT7zeei3AcUJVeobpacj+UcELGoHIV
         iwqWGobm09SdUbNSxdLhA+BwcZgioTuxUvKzRK8jbhBks1fVebyHZTlAezIhJtSE3Yjl
         vi161Svqtqi+l0WhJ29TqvqGdM9xpFcEsRYnEgc1g1XO+B7NHJws9Q7DAuHeVw+hBrT7
         3xFAhzgLpXIxmJrD3pbfGXUS28FWSdXfomwDE3cCU1MS6fLdK5zN0/LT9wKGbUDHQ9cI
         mfoYni20HXEAD1wvfcN3xd7QdIWctN3md/tiUNnIvohpOZ2bW9ATI4LSr7bCgfOW3gE7
         aoRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687973860; x=1690565860;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1yBs5D4wuN/Qn3dTB04DQldh1q8a2hbv1sJCNrinerQ=;
        b=aMLjifUH7a6uaudvG2kqCprm44JisJxQ1BT6Yoqe8uwSoU9c9tHSsniuubaRS4zO7z
         yDNR/WmB67IhKLDhU+7zcL6YrpfPjum2AQB5WZxseoRYCUM9NA56OffaBdYv5049d2PK
         EIeF571Jo6vspFOpE056yQ2thPO97jdiBsRY//pktyEMpVQJooJVU2gT9JFwfj6aLUZd
         AL8nPjJnlL0/LprbLbvpMTAKSMU/QyFisq8uWu8prMggqXLN6Ggmyi699yt8TPkV0jrV
         s8sXXuEaUPbh5vAzmfEGJle30GMGskIM5EomxizEs7Ahf7k+ZjiuKKg8B+qHTImP+52B
         W11A==
X-Gm-Message-State: AC+VfDxnf69vNdaVA1hPslvamYthG5c7ZvKYRyp6tHDh6sYWznFj1KRT
	T/I/FoGrf1D5GexyjucfB4rmXYLvod1QjkqkcaE=
X-Google-Smtp-Source: ACHHUZ4PYVYUjZfEER0mnrZe93juN7xF+PBfEMEb/F1Ax7S/khFtg1eYQxso9QE6WkFA9CfWoXK8t6ANuA3XfJyXa48=
X-Received: by 2002:a17:90b:4d83:b0:263:4164:dfba with SMTP id
 oj3-20020a17090b4d8300b002634164dfbamr2118362pjb.6.1687973859868; Wed, 28 Jun
 2023 10:37:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230626180744.453069285@linuxfoundation.org>
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 28 Jun 2023 10:37:28 -0700
Message-ID: <CAJq+SaDykUQdMHsCvevXoHA18xGgqU=xhj6BBR64T8_H5M+0pg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/81] 5.10.186-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.10.186 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.186-rc1.gz
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
