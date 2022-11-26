Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9722517CB
	for <patches@lists.linux.dev>; Sat, 26 Nov 2022 11:19:01 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id o5so1084780wrm.1
        for <patches@lists.linux.dev>; Sat, 26 Nov 2022 03:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D+0puK+taLmh7q2XEEEVa6EShVz+GcTC6xdX07f/2xM=;
        b=FFe6lGtTQ9b3SgofHOyHLZWWyjkQEAD92acdEpUJ6UTIdyXTc0s3D2fKX0QOF+cFh/
         yE1KeKSMd68VvB/qANzoywqd5a+KepPfMP7YguUCa+TFVYm2we0JGqx+lW6Cb287WOCZ
         4aUYtR80D2DVGnFchZ38hP8H8LA3cFdyS3JcTXwUemM0H6bSGRYnJrebK0tB41zrqFRB
         hZA5O5tE3YkXhnJMg9h6I4spE0/UMbOHjfdruBvg0k7Z5nJF8hIxPhuxwYwsyClZN+nt
         HZZSY5U8LJxwdrcDo04l0l9DKGoY/YIjsl4oCDKANHhoe2ebMw1B+yUuXEvijtK0oeXh
         H7EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+0puK+taLmh7q2XEEEVa6EShVz+GcTC6xdX07f/2xM=;
        b=FUDmHGL8tjCWImeK+DlefWzrgtLaGxbUDZZCgSO2PS2wT8L+X+4i8siCEqyFiFC9ym
         10gQNlk+1qCEi+wDTLg7j45ZcVJqSB5A4hlGQppPwNQvyXlN+WY/ZvpK873y5RJcMIhL
         QhAeV7ZoxizWLiMn0uVIY9cXEWddbInHTDnCk4FSrq8Rm1foQ9aTqpF1Tr1CwqRaE8fl
         H9FFTHBnq69id8Ekqi4VfjyRwm2mjJMuamPK3KZsuD/0jWXRHiTjn3zrj5dsS59YO5Mn
         rauF/NSW7+aqnBr6Ost1MinGgqOda0tcVQ88ud4LaSgOqigiAmMOtroj9Des0VdPApyw
         deeg==
X-Gm-Message-State: ANoB5pm3ziS480P0Ddq5R7ZdDj02XfN8OXxR/cFVYYdjDJ6WZi7N/01r
	wP+Xoo1/aqa9w8TY6lSEQ8E=
X-Google-Smtp-Source: AA0mqf5y9gWYmf+pcFz1umxzIPTKdlkS519VScjMl9s1exM8Iy1fPy4+9fRp1crTBhWfIGCdLQnFrA==
X-Received: by 2002:a05:6000:1d92:b0:241:6e0a:bfe6 with SMTP id bk18-20020a0560001d9200b002416e0abfe6mr17967047wrb.34.1669461539782;
        Sat, 26 Nov 2022 03:18:59 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id p1-20020a1c5441000000b003b4cba4ef71sm12001305wmi.41.2022.11.26.03.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 03:18:59 -0800 (PST)
Date: Sat, 26 Nov 2022 11:18:57 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/180] 5.15.80-rc2 review
Message-ID: <Y4H2Iea9GqSXTkYx@debian>
References: <20221125075750.019489581@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125075750.019489581@linuxfoundation.org>

Hi Greg,

On Fri, Nov 25, 2022 at 08:58:52AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 180 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Nov 2022 07:57:16 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2225
[2]. https://openqa.qa.codethink.co.uk/tests/2227
[3]. https://openqa.qa.codethink.co.uk/tests/2230

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
