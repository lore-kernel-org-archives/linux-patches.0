Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C9024F29
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 18:07:21 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id io19so13880155plb.8
        for <patches@lists.linux.dev>; Tue, 15 Nov 2022 10:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bBywltwPfbjC+ce3gndOtHFxBFbCBPvkG2/C6S0a1WI=;
        b=GaQUaznYnm3NUF/MC7IYlMFHFoWHVbc4RHuWnJN50nyCIwN7sx9p+FB5jasfcprWCE
         BWcSCAtHtnaUUkFsshq4oqZHstukeJoobJDLGVRlmSakBcZ9IMppe0BWufDYAQafwZyI
         kZ8F2okBfC8J7JMVNR1CpsgffFHGv6c6Ej2U8z+mvJCUtuIcvM3h0gLrND7I7kE8ozFB
         xtkLqoKGPyt3+FodUj+mnabAvKaCTFaAr3t0NcKg8GxYFJ3EhfJ32oNvn1ywTdLIkjir
         r2/uTSLdV1JI0GAI4wSxc8VMrpsBDFF2CirgLfJfxoyolnrIzRbqCdltuT4378tqwleD
         537w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bBywltwPfbjC+ce3gndOtHFxBFbCBPvkG2/C6S0a1WI=;
        b=QzCTpbl7xeNkHlCV6YsISAvtpKd3lNQUUhOKcf6b/VLjKoiHhViisxXN2BQyFHdAgd
         sq8MCd9rgz5CFQRWRgpqqSMnBCNyIWkkQs+BpHZ9B4W/Svusp4zDIPCiPpYKXjWZKiZb
         A9mcUNBskFvCrMapICZ0nlWVA1ZEti3Ka+ihgM9QOOipOmqBFiPHCQ/Py6ITvuDrEmmm
         n066b1Lh78UOojVH8eDBIZHtvUAX0hsHCKTFcGFjDXR96ZtivjR+20tXDFpOPMFG5cHe
         waj+l1NGfD2DN3mUSOZC0dtcPrhodtAuTAAd2mHaQJfUcYx+tzM6fTv2hazU4IWnPufi
         ED9w==
X-Gm-Message-State: ANoB5pmOiUnGG7KuRQSK+ekLN0S8l1xEfghOUzv7++JbNxS+GGFd11qx
	ECYUo1biMoeUbEVsFCaKxgh8x0bItTR7hmgRIvU=
X-Google-Smtp-Source: AA0mqf4DjA77nkIh39DWoUK2zu8eLVruCRANeUn1hy+5egUcLsy5ITYNaFkdHxmQ3lPoYOKqg4XiObTZKUdlHIWnx2w=
X-Received: by 2002:a17:90a:fa43:b0:20a:f469:7307 with SMTP id
 dt3-20020a17090afa4300b0020af4697307mr1652818pjb.213.1668535641357; Tue, 15
 Nov 2022 10:07:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221115140300.534663914@linuxfoundation.org>
In-Reply-To: <20221115140300.534663914@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 15 Nov 2022 10:07:10 -0800
Message-ID: <CAJq+SaAF-NfnPOiVu6s1Hn5jSs0595CjeezR9n-DAuZFzDZyhA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/130] 5.15.79-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.79 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Nov 2022 14:02:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
