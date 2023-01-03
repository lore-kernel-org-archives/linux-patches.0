Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9881E8F57
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 18:59:28 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id n12so20933603pjp.1
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 10:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jx76/1qwXkqVtZ8WWT7wUJXezQVggNO/8OW6AUwyjMA=;
        b=BxQMADJFAau6seEuwJ0tNqYrllJiRiRxCcYxkJHKE4QLFxmyvgp70j+Nwj8+7SIKQW
         RoeutIKxN539xK64Dsba4z9O/kv1OSYzJ/nQ4Rpk/k+J92ri8NBjcs4GxeW4Gbm9ftJy
         CHBT+SZYdVluwCJ1TKETaOtBE8FPVqvcTbn+HJ+Rl6LoIuyzeEE7AufGkOqj7EBHsEC5
         ylEPyiUuvYlGl+Tf20I/3DvGWivoHFrFLoTli7W1zSAtzjpJQLTW/SE/wjucnxuT8yRw
         L7zBC2Y+6+QklqO+MQ6JT0P5Q5vWVYK4OwCoDABydsu1lSZZ33er/6sCez33vxB59jlY
         NoJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jx76/1qwXkqVtZ8WWT7wUJXezQVggNO/8OW6AUwyjMA=;
        b=2OTzH3XHFxZCB7UeKCjFQfJjbzVu1Qs13+Hg93JEWd+Xhh3wZI7PZtl6MwcCC6jdcC
         gOrueonKjlcybC+pDBmzarObnAHuvJYmAr1OTKdZ2Fcxy9SrcCK/JBBWzAGLFL3IIAMG
         LYwi92FXleiWV4tqhFqYFbN4lN96jLH+kob5UDnmV5trVArk4N2zKXXW1XkQhOGkktXC
         rO/6tdIKFGq2U7trglh1hbhfiCRlzGda0i7vWUQdIthqUSDa4JMlJ/WWv4io8BwSYRYd
         9mFAaybW06FXJ8bS5enG+pAsxDEtFdv5JjjJpr9VS8bKTLOgqiKiRnghTlvbi41OlVHC
         o1+A==
X-Gm-Message-State: AFqh2kpXybnvd70v+K9LH6DWPAxvgqOWFk72YcFppgIogP4uy5ZOPKlR
	6HkvYRK7+xpc6aAu++ben0TkyiHr06HcFuxodOw=
X-Google-Smtp-Source: AMrXdXvu/j0jmA7+ISM9cNRq7iszIsefcF15r6xRSMLq70F8LTW/DsCyEPgQuOn4WtfbnIAGepMvNjKhlZngso3VREM=
X-Received: by 2002:a17:903:22cc:b0:189:e81a:1520 with SMTP id
 y12-20020a17090322cc00b00189e81a1520mr2865801plg.48.1672772367982; Tue, 03
 Jan 2023 10:59:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230103081308.548338576@linuxfoundation.org>
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 3 Jan 2023 10:59:17 -0800
Message-ID: <CAJq+SaAQWarJebJBmRv8Kwa6hkqg7rKBKyLZphcXo096PO8mKg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/63] 5.10.162-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.10.162 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 05 Jan 2023 08:12:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.162-rc1.gz
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
