Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1BB8F4B
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 19:07:25 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id f3so11939253pgc.2
        for <patches@lists.linux.dev>; Tue, 24 Jan 2023 11:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+/a3DRuX86fFzYSKcRnyqY4BjHdMD3vD0y6fP26UHyc=;
        b=BMcXRguM7BT1nuXNEPIe0VYSadw9apPpMkeXepdjn7PIThqA83olJrRlbmtb8FkZNN
         bqgIykvbBi09dkvLONVtvPErD1YsHZDxy6PXtholnSTwB9YPsu+1hwqhfLqCaIRXIWCU
         P5o1tUU39OUs4Q6jfg+zjFyrHoV64l8s4SBGdFlE9Fms15U1yz4w7uC+L+QP2BnxIgV9
         OX+lFvh91H16bD9Ws4/0Hxwpt7XzNnFHOaU6PK1g9zeRuS2CWLDC3ZhwPgRf5V/2y5Yt
         yqUYtH7LGJsdXeqhKs95HNyX7qOzT6w8O9Gp34npuHukAZs+n5q5CdD+1nuaHviHdXJM
         jUlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+/a3DRuX86fFzYSKcRnyqY4BjHdMD3vD0y6fP26UHyc=;
        b=59vYUll3PfMBZFFP1pUk/OwX+VlxQrRc6+kyKEwtlLa931nQYBWoxyp4aKExzDS9FJ
         qCneykYYAVTgFYEsbTjEDc6rPWw52m+TwR2YKMcfHhDyr2kpTmhzUpHbRq+8a9Kr9GbL
         EweBOLSPGKwAUO6ptWIVa7wTeCsg1H02nGMgOUUcalLXH+LQxhRWM9lMoYoX3RyBlx7y
         r7f47oij21WHwm8NTpSCX0E+NEo86VANec3Jnf3XYOEgOj5rtm+iWBAcadrnDBMPWNY/
         VWrLKzMXG1lvPkaWkDGZAe9cKd0KjzgDfai/vmKtl/0jlyv2GdRJ0n4Pgb5635bgSJd8
         aGGA==
X-Gm-Message-State: AFqh2kpvmmVgyjoGWwoXkjqEwr8p2WuvmtnE4GFIKl3EBMcyMfvaikb+
	FVq5CFi3Zft0qzeOE42VbyOUwsefVhO/2nzjTAQ=
X-Google-Smtp-Source: AMrXdXvgbRX66Y7F1/fxwnvThj+LWkQ/sM7WOaEK69le38ZLrKLu+I8+beokSOiwuqs72oLzPCauJwM49GM5lapGco0=
X-Received: by 2002:aa7:9f06:0:b0:577:16ac:8447 with SMTP id
 g6-20020aa79f06000000b0057716ac8447mr3070187pfr.56.1674587244698; Tue, 24 Jan
 2023 11:07:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230123094918.977276664@linuxfoundation.org>
In-Reply-To: <20230123094918.977276664@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 24 Jan 2023 11:07:13 -0800
Message-ID: <CAJq+SaB1rcEJafKybZNRn3Fp4EYuYVC4FOYV6vqzAmqPqJbnkw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.90-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
