Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7217D81E22
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 19:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MrWZQQwI"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6d852e06b07so3169534a34.3
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 11:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702408734; x=1703013534; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lRI+Z3So7cR4czFluxvYwlfma5c41gzeBHqb5Y4Vja4=;
        b=MrWZQQwIRadVV8OPRCWBbtI3WKXtMQ9n/7qpE3Iikrrw5HbrdX6TXfP90ZGRDp1fWb
         Mnn3BfjEZZ9PTVbVVVSTxzmpzpwrGphH3rZWaE/kTZBs5DAihmGI41QpbKV7O7hthL9+
         ZNLv9axIcZo8vK/hX+kcwm+U10bg4ly4c2yG1CVgYHD2kE1C1mX718lnvBzMXYfZuwAk
         m9Hq7Odb7EBVEsN4UtN2dojhU4ibc4A5RdgOrrsjomzO82UHEggLBfqd3JG/41Edo2a1
         XCZXWcf9AdlMiywGMI50dIJLS49991E7YAyzEIxu3Bc7qKL2hEH3slGL7X3GwlXR16Mb
         uwdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702408734; x=1703013534;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lRI+Z3So7cR4czFluxvYwlfma5c41gzeBHqb5Y4Vja4=;
        b=V7iO7UUYByZOLb8zkc+DRpCN39a12sNzRNAVhiQQfrRWOEERTmIMwhQkPklNeS08mW
         UrfH6S9SjMkhuGQwv6cHRtS3Vy3rnSRhMsxYjxrdrK+WR1oCxMHthfbCpTJiqPEGYYIQ
         6TUXZ+XjZklfDus1nv+ofDRmNH8r45X8OXXjekxJfDyS32aSym422fIFj695y5edhi30
         mALC9kRaOQtP6EXpNvKWlAiotUZIWpgk9NJmsZv3RrB9hPdHBYmG/zGxDB9HaWO1NU65
         wYpezPlzl223Ny7pFfzLOyHDfV7hfp5r8ayutWime1A1YYT3VPT+CNPNRCkaE+AqK3YP
         2ENg==
X-Gm-Message-State: AOJu0Yxu2W9ODJj8RlWvTo6a+0uUL01mwzcmwPak7wTY+xmFIfffp+aq
	S5nwZ+qXyGpiNgSjzIuIH8X5OSLD64y9z6o3HgY=
X-Google-Smtp-Source: AGHT+IH7Gl41yzN1LlyzIXzr+mlZbXiwYsHqWWxOt4X/4Qmx+WYf32alvxIxL2Sd1mYkqJPxFCwDNJ75FR52QYnPlC0=
X-Received: by 2002:a05:6830:118c:b0:6da:3071:2f78 with SMTP id
 u12-20020a056830118c00b006da30712f78mr516440otq.23.1702408734423; Tue, 12 Dec
 2023 11:18:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231212120210.556388977@linuxfoundation.org>
In-Reply-To: <20231212120210.556388977@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 12 Dec 2023 11:18:42 -0800
Message-ID: <CAOMdWSKV3KfehCOpkANWxbbi7-kCwbBs93L12Pay6Bk_QRfPXA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/139] 5.15.143-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.143 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Dec 2023 12:01:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.143-rc2.gz
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
