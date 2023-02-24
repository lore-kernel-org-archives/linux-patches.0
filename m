Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9E4AD58
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 19:04:42 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id c1so489735plg.4
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 11:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/QMQOnCmMUtMo8h5zie42yxlNpj/X2TsJVs5Y9H49Y8=;
        b=NAQWYLUZrCqL6SDknIVS56N9wu3Ca9ML+Fz5DncJ8Cjeer6C1AI9lSgpWJyVDudYdD
         +o4WRlH0iO6elISadNe1q1VdHOmVHPw5zhB362PaVSfryaLN5fRlmz9pRSVFSTLzy+lS
         dLEBNKMFnBBBxeENmbTPY+jnExglJsQ/v5/lWTLLQTAPIqlQm6MWB0fEfZIbZvNikQRk
         w+VRqN0lSGo3J46fi1PBXPB548obZtvgatULX9F57XtKnxc3dumEWDcA1gnvjl50Gsvg
         M5GL2KY4rX3k8zA6a4MddJdzqYicjfk0jAx1Zsc5DWaPFD4sfu4Pb1Fvbm4mlRtvJTkV
         AeyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/QMQOnCmMUtMo8h5zie42yxlNpj/X2TsJVs5Y9H49Y8=;
        b=CHrTxeEBQv4+Twlh1unJh+YY9KkgfUvY9qm5dbGChZbbYeQoJ5FIhbpwLwkZF6iTfn
         vGnmU4cpHpfAbA6mrENkkX2Jfh3UeE+poUNyB+gIFGZr5pCXi4PdJZg8gelV5tmu5xCD
         s0o5Unfl5gGLrxKMGVTe2IG/lTYiuwSpz+Xhe8F9zZTrgwaw0EzyIL5yJ4rCOW5TVMoe
         +yERXevGvqmtKIKMQhOQwOpnJLQlRtUm+fvI1tkzcn3F3Vc/Til3EFQBPq2GUffRHyyH
         +LBsLzE5ksmR0Jv3+y53Qv9NqRqq3pvPJUMXUVRbN4WwnjnSrkr9O9JFFXY4aMPBSu5n
         yFXg==
X-Gm-Message-State: AO0yUKWX3lXV1g180L+a2H1jQvbC/WTU+DoKH/Gkpy+r/8F7Z0j+aDuA
	W9kDroJjuNso/JyQ4+keo67uJoRvNwHNr0d4F/s=
X-Google-Smtp-Source: AK7set9jAvUbiEqDsthOhEMH3ysvnzTdpIDq0VzNx6GUYNiR6tWA2k464mhSqXvD1AJymY/p2iookEYxY7j7mMpN9YU=
X-Received: by 2002:a17:90b:a49:b0:234:258f:e2a8 with SMTP id
 gw9-20020a17090b0a4900b00234258fe2a8mr2114725pjb.6.1677265482407; Fri, 24 Feb
 2023 11:04:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230224102235.663354088@linuxfoundation.org>
In-Reply-To: <20230224102235.663354088@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 24 Feb 2023 11:04:31 -0800
Message-ID: <CAJq+SaCiFAwgN57chu0o9ut65MdgCSLN6PJ-VKTq7S-oefcY4w@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Feb 2023 10:22:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc3.gz
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
