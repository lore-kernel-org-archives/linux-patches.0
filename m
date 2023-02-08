Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAE5182
	for <patches@lists.linux.dev>; Wed,  8 Feb 2023 00:44:18 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id h15so10147312plk.12
        for <patches@lists.linux.dev>; Tue, 07 Feb 2023 16:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UgtuVeH3SQrUqkXUTAMLpB03R+YUjFpbnh0x6QNQIww=;
        b=YecaEnu4PJEuRg3f48t57xWKTGgZJxOd7kXDGPQtQaAiP1KUBIPIgQTEYEgGxzLysh
         ZIUfSCbWOYSE1nimvNgQ5PtZBnWJsz5UOwH2V0+REOEPcKrns/r1ngDWdwbQExEzq2S4
         Gputbv6CohN8TWR/XM06Kis3RDGhq9X46kaXGwkZe0pPrxscEXEG5wVvnLgHEVRuRBUS
         6InZ/4lWTT8sYBJGA9Cj3WczS9BIfs9rGfHj4btE40NWCgtUQsgvrlLQBesFupC0izyb
         Opcabc+22PncmaiU5JjmZ2CgGJ+n4svsYei/x5QNqAwHn1Pfjq5F9xmUatKHZwOqzln5
         PEhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UgtuVeH3SQrUqkXUTAMLpB03R+YUjFpbnh0x6QNQIww=;
        b=G+W+KKLHp4XPBTDwyXfrKokDyR0VkTXYjh/9J5T+V4DwWMSnO5m8fMP76RjA6/hpmN
         J2Dn6eGH1J7Oyeb1l8T/3Fls0YUq2yx3KSKYFle/8TNwEqmd3dAvPIy55kR1yxZmhib8
         DiHXWMLsFQLezEB7L/xIGGfH9e9Rxx/cv8Ig6Mjs+eLU1sjCthOEJfYe9p/VNOKgaAP0
         N7j6k/ppeSgK3/7Y6z0UNO7HzeR6FAIejVSpEK4Dz4SHO7GAGJPZPD4ODoT8Pnqo3N0C
         Y6RY8X+7Kqx5heVeyTQms8m/XfvHQyfeNkxeFfLUlGnO33OE1mtVjdf8eerPv7hTh+lL
         6Lcw==
X-Gm-Message-State: AO0yUKX2NL+CnTL0kz/zFkuN4N7PDOn3JD5aKLhrXujGtFL5TQIlETvt
	VxW9JUMR1ZkbAD79aW8+AANXVwHynQDvT7zqmJI=
X-Google-Smtp-Source: AK7set/X9pmwhtLDus/6ojj+JFftt4o1+koEhwtLlgqj+PGzSIcLJnd6LyATGopfv80ukhar9wMOXKJYHEIEGH/CXXw=
X-Received: by 2002:a17:902:c40f:b0:199:ad4:6e63 with SMTP id
 k15-20020a170902c40f00b001990ad46e63mr1262887plk.0.1675817057927; Tue, 07 Feb
 2023 16:44:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230207125618.699726054@linuxfoundation.org>
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 7 Feb 2023 16:44:07 -0800
Message-ID: <CAJq+SaDLnbV0MCa8ioHBntSVexLik8DAVbEFYs0383DuscdqbQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/120] 5.15.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.93 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.93-rc1.gz
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
