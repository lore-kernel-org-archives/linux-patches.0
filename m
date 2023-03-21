Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0A5C952
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 16:04:12 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id 187so13797442vsq.10
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 09:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679414651;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mLnw4/hq8OG1me/CkEtTgL26WuqaZPsS6YVVaJ0eX1E=;
        b=iGtUdAhnLewhz9waBIa0RMr81+7nRX/lBs0MV/taQ3yXkDMOax43/6dEpZKuIsQKAF
         J1LdZRvQHfvf3Biw29W+WOArDLm3zTzlBT2FfKbctr9izh6XJEyqwVb2WbhmfRmmkpV9
         MCy8NDWLne22qk1a7vLszVVhVQz8nxVG4Z2wWdIETl2eeooOeN6i31y5RazUYVCqYGYo
         94Q7VeFObuUsAQYKJGOsP+S+Ih95g0EJTC4iYlJGRLY6lSfo13RMh7/EZZqAFVPGK8Ql
         7cT3Rj7cxi0Pi8x4Gru4CHj0upIOvuiCg7+LB5wOOzIC0GC8wKJ+nfyAPkHfFbiuTxFu
         yPMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679414651;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mLnw4/hq8OG1me/CkEtTgL26WuqaZPsS6YVVaJ0eX1E=;
        b=ne2yhEUCkk4LQ+/hL/hvS9zIMtqEiZBUaPt9XWqEbEu2LuGxDHhtHe+XH6T7g5NLl1
         Z916DS7hsXUpPQvlvaD82xTWt7o1n/FBtDYetptrPy9kgTyjcWEnfMfk41GYOIOTJu0g
         lHHECGagYj7Js2JV0Y90vTXSsAHjHoeWzgIZ0IrwjHCTBpMAYwBrZfbwf+0jJ7gFTaPR
         +pUCMmhpqDKr/OcmlyhrAlQf1RbR6EncORtc5rC+YwEiqt8m47sTwXGPhrtcrLlGKaIo
         A1U4tmAP8u6K6gYDirWbSWNALiWeKzYFojjh4FD2OXgg3Q2u0GiV6QfvQzSyW6QJ0N3o
         MoEQ==
X-Gm-Message-State: AO0yUKXJ8iFAYuvlSGwP8qz8cQrU4fLfaItW64haqOIUFyUSf/wCPJP9
	4GJ5hRqrJ2mKtUXM5rN5h/7LNVrkQgQiFJYbXeriUQ==
X-Google-Smtp-Source: AK7set/OhKD8oH7awyUpeq4BSIdxOPetYViGRrteazzF6GzXctryWjuGC9F+OfDIMmAdtLNMbw6J9ARkttXxiCEzsy4=
X-Received: by 2002:a67:e0d4:0:b0:425:b211:3671 with SMTP id
 m20-20020a67e0d4000000b00425b2113671mr1915864vsl.1.1679414650735; Tue, 21 Mar
 2023 09:04:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230321080705.245176209@linuxfoundation.org>
In-Reply-To: <20230321080705.245176209@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 21 Mar 2023 21:33:59 +0530
Message-ID: <CA+G9fYsD6PVkfrpS+k6TBye5r1JzWVOzRwAsndSYzVwgB+dTxg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nathan Chancellor <nathan@kernel.org>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, llvm@lists.linux.dev, 
	=?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"

On Tue, 21 Mar 2023 at 14:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 08:06:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.21-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Same powerpc clang build problem on 6.1.21-rc2 as reported on 6.2.8-rc2.

Following patch needed,

Upstream commit: 77e82fa1f9781a958a6ea4aed7aec41239a5a22f
     powerpc/64: Replace -mcpu=e500mc64 by -mcpu=e5500


--
Linaro LKFT
https://lkft.linaro.org
