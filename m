Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085137FB
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 17:10:16 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id a184so10696818pfa.9
        for <patches@lists.linux.dev>; Tue, 31 Jan 2023 09:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2YsoUtxMdDPQ8yDUi29M+HZJqOyAdBFa0EqB6bM6pNk=;
        b=VjV6kl1sLRaQzDBF+fH0BO/N1BNv7OXBoZjC5MEakqVRd+TIIlQY5Yt8azEy38PMuy
         /0IGbMqVNmfoGxwpzMavJnkdizKYi0lA4Gn543bRbJErtN+Lao4N3RB89hCWbrqMQ9hD
         PMQ9q69Bmjk/3lumPpmE8gmWryKeD/Pk21xyta1bN4RCrYKFbrHBFsnav10O1yfc/TIO
         D54JaLV8+fFT+6NVXnGpNibih0xld/LAYnySQXvz5cUrWo4vsouCovAlmv/VFaWU6xIR
         z6CJQJf0+s96c4XGGdLA8lVFpdJaM2sENbfLDgXVik9s7oPD0ZvRjFWkSZ5GatpHkS6t
         uzcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YsoUtxMdDPQ8yDUi29M+HZJqOyAdBFa0EqB6bM6pNk=;
        b=jqSXMAizwSYc7d2Dc1nBUK432IIV3PdIdopXrZ06BHl8fz8L/0EI6sRt+SyEkn5I8a
         ndedSLvZhXcYBncJd/5/UAITRMTu+xBKLQZ3aR/wQcYITYh+3+j9iEfpYRuQdJoiMGrJ
         X19Act/lsEwOAC2+87ilBsxSKa6qxOfp8YiQhF1P9FqZXthQY/sJvH5bq58szBDuOGLq
         PPWrx+9+Exq9BRwL4W6qImz3pH63ckvytkKeO0UUEmmzZISnD3ki9gyuRXKPTYiFTxRu
         5HmrsR5kzVzucsSOjgQHOgVl3u9pzftzFsAW4wfW1FgDny7gujCO7jwtN7b7mLJN0p0/
         lFxA==
X-Gm-Message-State: AFqh2koJBpCHquF3SoZOd+X+eIHRufVFkPNkLeHShst1eqGq9sEpn7BG
	wz2IFpoKdojie8XOkrOtRimwF/y7qRmLu7kqz+M=
X-Google-Smtp-Source: AMrXdXsp01qQCgakWsr2TSZoaxv7mAj1Q+q0neqvSSh54o2EVsGbaMY7XQ3CXBFnh+N5OEINVqThhtQh+7jGWdnD9ts=
X-Received: by 2002:aa7:91ce:0:b0:581:c732:2b60 with SMTP id
 z14-20020aa791ce000000b00581c7322b60mr6857105pfa.25.1675185016458; Tue, 31
 Jan 2023 09:10:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230131072621.746783417@linuxfoundation.org>
In-Reply-To: <20230131072621.746783417@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 31 Jan 2023 09:10:05 -0800
Message-ID: <CAJq+SaCGpH0dGyahEdmv2-2HxPwGU52LbSjtroqZJ2w9uMWmOw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/306] 6.1.9-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.9 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Feb 2023 07:25:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
