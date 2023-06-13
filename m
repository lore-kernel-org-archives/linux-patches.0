Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EED614260
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 17:01:26 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-25c2a404c73so246219a91.3
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 10:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686675686; x=1689267686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LSg+HtxF5THiYaLtR4tXUP2FGEx8HowDn4GCS86HyFo=;
        b=pTqe8PY+j8IKfVkzpy6szR3DwptR6CjyvjE7ttEuqLKttRukf1tHI8QSLEuw2i8T85
         6a12tp94iLWF6G2On3JX2vjHoCCK4rsUi8AArKlX9JZpMnGZV8EZucX6b7LY4FjDL1Ht
         R57/Z3KWEHzoxshEJDEG1yAPz8XD39M7ApI6W34uzUa3BTyFmkkRIOgznrUXnozJMbvf
         9aTlGSphDvubKSI+LwXGMp+Es4cCJLmu1Nbbdbq7s4StKdf631s8n/sIDBUuX5WHwbDY
         kySAVFJJRiA0mSiO556cn75/CRq6cE+RMj61QNE3+wUN2q/TP7m2KrmrfTk/aP/Z6HPi
         062w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686675686; x=1689267686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LSg+HtxF5THiYaLtR4tXUP2FGEx8HowDn4GCS86HyFo=;
        b=jTN3qM6acZ5zW1S77zBrYY5HpjKZs2qa/uUl3ure/MX0F8ENtwR29Nuzq+2EhpAfEp
         KKr4njIRGXBJ2mDiLNVq3YcMpuwSt6KitTaArIeSK9sygmMcU6NQ48ifiy+4Fd7cH7U+
         pjHc52N3Hqe5kD6uSyjNjxULSO6L5OPpDR6wKVNs+F75kS6+dJw0oFNBi1SC1KOuXIjV
         vndh5ToN5kEiwvnehHOBMyePTfOMPKq06pFH8DC4mO++ZSJNuuKvdXyYBXc5ZNybU0mJ
         /xVoUXLi8CrksT/n8tOlKjWglSdPGp17tnHFLiwjTGdQtRD1jxnAin2AHdvmigkdLQNt
         Yp3w==
X-Gm-Message-State: AC+VfDynLgLbKLo669PhwhAJ189yYxjpCZQP/0h1g+U2bs5FobW25UIn
	8rfKjmtUVCDVonw7HFpEAvnCwOTnE9fYOJwgzTE=
X-Google-Smtp-Source: ACHHUZ5OCZalL2yDi9uZjsX4uU3oHuRy0MIhAeXP7kaJBvLrfYUsH4IpjjG3LEkg/RIfa/oK4pUNi0ZXWgBfPQkBzaI=
X-Received: by 2002:a17:90a:4607:b0:25b:a9f1:9dee with SMTP id
 w7-20020a17090a460700b0025ba9f19deemr8562027pjg.0.1686675685569; Tue, 13 Jun
 2023 10:01:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230612101702.085813286@linuxfoundation.org>
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 13 Jun 2023 10:01:14 -0700
Message-ID: <CAJq+SaAdFH0n79w-U+sLQbKk1wwJhEx4WL=-Cj_mj1vMGyXxJQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/91] 5.15.117-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.117 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.117-rc1.gz
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
