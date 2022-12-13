Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084672F2F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 12:07:52 +0000 (UTC)
Received: by mail-wm1-f49.google.com with SMTP id o5-20020a05600c510500b003d21f02fbaaso888359wms.4
        for <patches@lists.linux.dev>; Tue, 13 Dec 2022 04:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hwy96dh9v1V8mXivId3Duf1vYojAc0muUBqdvexRVmE=;
        b=nLdaQuUaCDULhZg7QvL0uDTj+P1Gtbt/9ndz0wgrAAI6KuB6oDgw8SfMDM5RHQBBaY
         QFw6grq3dXP/RWaq229clNE21tb72lFAkdFD6mRov4trsAIGjsnb7Ni6BARcziybmEVQ
         j8YLToeHKzYzok+3hw82EPZzllUUBp47dzmQOUcS9lpsv7vSFbFZyNXvpHpbu9yOQda8
         IFMQdW6Hs9PP1YEtLCaYv9nkPDRq2zxPonTmE7KjWrxtX46N8Bk/5h9vmlVxhbZXCIjX
         jamHQUu23Tlz6iWsaOpQiyCZ5QpdHKrnNMAc8BjR9MXWG/AFYCNuvaKJDYIR6aoGRfoJ
         K2Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hwy96dh9v1V8mXivId3Duf1vYojAc0muUBqdvexRVmE=;
        b=tXKHNOxanuX1NbbGA0F+hHGwBHJYng6zLA2Z/4E8D0SULHcHmKjOlTmLgvXY+asB2a
         OM/FGcFXht6iCVo8Btf3fPTdt+Skupv1HB/VX9fXGxBCwzrHWQ+T/kGn/4kBsIiV9OA3
         00kFSQwC4WI+/YFkREOkfMMBBvTkhi4+oGfK3gPbjrMSgt9V6BW76LV0JLpdjiSxTahU
         1y5mNU/+6W7yEE5iudSEExQZJsSnLxBsEAauC7XRTGN15lEP7OChYI+dAQUMjni+HhWq
         XgQZCLMqV5H1f+BfBQ/qyFa79327sO5/bfxV+wTicbOiCeQP18b5YCcaHEIVNgg4hT3w
         MG7Q==
X-Gm-Message-State: ANoB5pkMP6uOPIv8O9evhmoTxjXmQ4giBdYa8Yvp9zMsi+3sLkXtwRxT
	s6XZ4Fc/sHOnMFomcy89iL4=
X-Google-Smtp-Source: AA0mqf51D/AdG/PNwZ0KBIYFURBFUGUmJMWvOQUlqozFf+heS21aHbui9wyxTQlYuM6h2YtcnJXmiA==
X-Received: by 2002:a05:600c:3d8f:b0:3cf:a18d:399c with SMTP id bi15-20020a05600c3d8f00b003cfa18d399cmr15428532wmb.1.1670933271321;
        Tue, 13 Dec 2022 04:07:51 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id g20-20020a05600c4ed400b003c71358a42dsm17382287wmq.18.2022.12.13.04.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 04:07:51 -0800 (PST)
Date: Tue, 13 Dec 2022 12:07:49 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/123] 5.15.83-rc1 review
Message-ID: <Y5hrFdv7r+WYhtUL@debian>
References: <20221212130926.811961601@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>

Hi Greg,

On Mon, Dec 12, 2022 at 02:16:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.83 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2340
[2]. https://openqa.qa.codethink.co.uk/tests/2342
[3]. https://openqa.qa.codethink.co.uk/tests/2344

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
