Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE6D2C726
	for <patches@lists.linux.dev>; Tue, 16 May 2023 09:16:38 +0000 (UTC)
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3062db220a3so9006217f8f.0
        for <patches@lists.linux.dev>; Tue, 16 May 2023 02:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684228596; x=1686820596;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O1IhhzxB4ld++kwVUQBLJ+A21ev47I69qBykT3coDis=;
        b=ZTi+SscxdHIR9WWsfrSoFeB1FUYfl3ewKRBEkna2ORTjo1QQ48jl1VEKRKxpJMZBLj
         SWr5C1TGBSO9wAQrbY0cFBvfKv2Jfq4G0IusY2mqBpjF7QV0gdVyENretJJkkhaADARk
         uSfUd5L3P4zgpljQloc4E8zHlsqzMNe/Uz8Je6uynYBKOt1XkZhoQ+vGoeIMBLPwqKp4
         lng2/3fMxTaUHB/p0kDvYecyS/q6u1ArYIN+SuyBkSdHxSwBHeEd1pXl8Pj8mmOYt4pO
         EY95ykDu//fSZJCPaxw2MBsqQledsBBcwIKvjz7YE6tK73VhZ1bvKORkFpp0fIz4a19n
         X+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684228596; x=1686820596;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O1IhhzxB4ld++kwVUQBLJ+A21ev47I69qBykT3coDis=;
        b=KYqkWM0kV+sgL2S26dsUnmq/I7VtEr8rkxz+KBV+abh+j9VT27KCBRpCQ/FUSWx3Kf
         RoaoSPzY7FN6RV1qM5vBTR7GWk/io2bO6pYBRHd5o7qXYOr1iURq1tC2eEZrtPitrVia
         gO5GFYu4AhN46n9eB5TlvCLwByxyx1hxB02ZPyVBes5vSypo4Du4Tq5nC0heUToh0ZDZ
         DrkrlNtbi7ZzaKhY7PJE3DyBq4pnGPr1bMHxj6kRb4MNrvpUYBJxhZDsqcVwz6Og0TRu
         AYmt7mQaNsVcr3G8btujyFSQqGYsQA6PwTlWoFZEyGFCyGDJLZzMkAqjYS4Lt8RDF6Of
         AkIQ==
X-Gm-Message-State: AC+VfDyLkkQoTpA08+CExUITH1LaJycdlxtTw6y1FsVvqKPJTnpO7BS9
	uEaI/AJxAEZ/JSS20epqyD0=
X-Google-Smtp-Source: ACHHUZ6Yb5LY8toZrq9QUlM2s0RaPoyjZyKienkGcjLEyg3wqsRjagP5t/yUcLY1KeMxHTqeJcuR0g==
X-Received: by 2002:adf:fd0e:0:b0:307:663d:fb1e with SMTP id e14-20020adffd0e000000b00307663dfb1emr24719501wrr.36.1684228596510;
        Tue, 16 May 2023 02:16:36 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id d9-20020adfe889000000b00307972e46fasm1856086wrm.107.2023.05.16.02.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 02:16:36 -0700 (PDT)
Date: Tue, 16 May 2023 10:16:34 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/134] 5.15.112-rc1 review
Message-ID: <ZGNJ8kTietfewsgu@debian>
References: <20230515161702.887638251@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>

Hi Greg,

On Mon, May 15, 2023 at 06:27:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.112 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 12.2.1 20230511):
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

[1]. https://openqa.qa.codethink.co.uk/tests/3532
[2]. https://openqa.qa.codethink.co.uk/tests/3533

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
