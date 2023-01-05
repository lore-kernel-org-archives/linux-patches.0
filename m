Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AED320D
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 11:15:01 +0000 (UTC)
Received: by mail-wr1-f49.google.com with SMTP id z16so19280942wrw.1
        for <patches@lists.linux.dev>; Thu, 05 Jan 2023 03:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=86+q+Qg4Mtt40/M5jVCX/R4x8CTXT7lPu4cQ2thqb54=;
        b=NfADKSaeWac47xmY5tV2DJYIvVmBqPQUCTLMTzIIpGNF0g4v3IwpQ2aN5hw2t0BTG4
         xIINOPf+cPbYWgkZ+71/IJWzWhMGRdXd7RlD67P5+48oYXtFttjM5xCp+PbUshXw58is
         Hr/mgxae7ChT+7yRfYKSZeGBnTD6joaizJCXOCQS9ftIetljdUsYkPlT+NrhqDWb1BbO
         Le1hnlur7Ywyteqi6X1yVVkMAPNdzr3rxNGthnHj5QVMggbeQ6QQQxaQA/2CzDHNKBKv
         AbPxZsI4t1aLcmG0YbimV603ruadsbQdgk3PBYUqDzDgAYh87v+Y4Ni2N4a1tmqOv43Q
         A2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=86+q+Qg4Mtt40/M5jVCX/R4x8CTXT7lPu4cQ2thqb54=;
        b=SeCt4IfAbGVH613zxqcHVciw9169IjlESysdr2ImljTQeFbD/iYAtY8ERd1YRDYk4t
         AaUwV6NUCrcvjDTx9mKK+UbeeraVg/McUhOGbhpmdSPP7FsPj6jKQGH6ZvuXqN7xUt8f
         n/PQZ5h/VUQT1F5C2sq+wLfGwqLM+vTOe+CDU4F82LtmbP9qa4Q1fo2ZlUSj53SAH6cO
         G/sVN55BbxuwWhIPzWaa3htxp/HkL3QlT12uA//PGiMJi4p3mOnQqLl2WcIjxRVQdzO0
         zXQgbzjbsqmUWezEwKlUC8z4nmRqbJ+N+vyyonbZ8CM6dS7QRnly1A2AM0IhN6haZ0Kg
         xRHg==
X-Gm-Message-State: AFqh2krRGDU3LEXuOuEIdLaA+jWU9jEHrkLO4uaYoHPE0a3agR4G8GdQ
	6Y2mVybVi9J/Da7dep54d+Y=
X-Google-Smtp-Source: AMrXdXvT+YBSRy7nCyvEbQI6Ep3rnuWCLY9a8Hc1SArTdh63c2Svif4IsSGWLaW0MG+/k6AUEwyktQ==
X-Received: by 2002:adf:e78d:0:b0:242:5469:55dd with SMTP id n13-20020adfe78d000000b00242546955ddmr31114084wrm.36.1672917299600;
        Thu, 05 Jan 2023 03:14:59 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id f8-20020a5d58e8000000b0022e57e66824sm41581877wrd.99.2023.01.05.03.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:14:59 -0800 (PST)
Date: Thu, 5 Jan 2023 11:14:57 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
Message-ID: <Y7axMUGRQCJXt8pp@debian>
References: <20230104160507.635888536@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>

Hi Greg,

On Wed, Jan 04, 2023 at 05:04:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.18 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2559
[2]. https://openqa.qa.codethink.co.uk/tests/2571

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
