Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D654156F2
	for <patches@lists.linux.dev>; Tue, 16 May 2023 09:18:03 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3090d3e9c92so3221082f8f.2
        for <patches@lists.linux.dev>; Tue, 16 May 2023 02:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684228682; x=1686820682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7C9HShPKwn8h1fUg0l7Pz8YXH+XNLX9Yv4wxCqkHcAc=;
        b=Png6P3fgMfxfssVCej+KqOaJ1EANCqSziEoKlHUZpz7WG3OiRvQSJrn2iOW2Pao/Vw
         vKypo5Ybk/aTbUN23TEfT7qSpVchi0McYwxu6cIirZSkxb7BE4h6cNriHaOy/nhc33Xr
         559/6kQMGduAkgnhOOncbg9WlK1evK675Qjt9IqWbtDh/Ew4VgFvnO+E5+1YU56gk8oq
         RuM4raoxPhm9+OtjTnR6SxZFpBjBFL415k5JJz6Mk9pfS25ylXk1M7ePH/eolVtYz3g7
         pMfMlWBl0poA60rbrHKaXkRlJR0nS4wadQ1n4zWA/xA63iapr0diNaLrjisEARvYaUjS
         0d8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684228682; x=1686820682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7C9HShPKwn8h1fUg0l7Pz8YXH+XNLX9Yv4wxCqkHcAc=;
        b=agEvdI6+G4Rx/8OXxZj7nafvBL+mvtussQaSgzPIc/6vmIJGcfJtokqiiJ5TTUZ/IL
         I9Id5VUPiCaqqVtDJEkoWHUVQaSwkGPlxGOUD9lGE1Lwr2UKFE8gDmNtRdwkXhMgXDfl
         4T+J/mu2LDgCIsRdZjx35DkeSPgifA5Xa+7STumT6JTaPMlU6+fWDDTm39d0m+7Yq3qP
         ruMI0ZtvB3pwRZe/hy8NzN5XsvWKcvJpL7UDGAAR1SuE5rZHaK3Rp+N5VgII5l939WTl
         9Cw/cUdiE5rRpKFHlylqmqYr9E95oNLwIsIrsYR6G87PkfZi8ObhtFtNnRUNaF5j/M3v
         Y5dg==
X-Gm-Message-State: AC+VfDwTGrIA/Dqb3bTdwa3Cz5WXoPlsxbxFe/f5uxRvZRWbM35lEebs
	Ax0MV8YfFVVlHQiF7btLj0JgaGarShY=
X-Google-Smtp-Source: ACHHUZ5XxE7qkMmTY2Ehr4lBCAHIRMo7+Pum83kyN9HK6pUBwpPFdqnjef/S9r0pjX2Zm5CLJgxu1g==
X-Received: by 2002:adf:e948:0:b0:306:2aac:4b84 with SMTP id m8-20020adfe948000000b003062aac4b84mr27823524wrn.30.1684228682000;
        Tue, 16 May 2023 02:18:02 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id q12-20020adfea0c000000b003078354f774sm1901829wrm.36.2023.05.16.02.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 02:18:01 -0700 (PDT)
Date: Tue, 16 May 2023 10:17:59 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/239] 6.1.29-rc1 review
Message-ID: <ZGNKRxgT8wj/CO1e@debian>
References: <20230515161721.545370111@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>

Hi Greg,

On Mon, May 15, 2023 at 06:24:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.29 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 12.2.1 20230511):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/3535
[2]. https://openqa.qa.codethink.co.uk/tests/3536

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
