Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C335720E3
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 13:15:30 +0000 (UTC)
Received: by mail-wm1-f49.google.com with SMTP id o5-20020a05600c510500b003d21f02fbaaso4072232wms.4
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 05:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U6vape/K9pnaJlDnSHi71/S2eew2s8oAgi2GcuyJr7w=;
        b=NLZIxDRvaBg09uYmB05NVGlfFgsM464YV4dfl87tccVxpKakbCNzZcGBXjk7S1UMk8
         8F5wGjJr7qOdiWYYQJYHKWmCMmvmfh5zPRZqzpLI/RCMBreqE3htETqMlDkPEFukDQ1y
         IpulM2fqI+JcatW9Rq7JdZRvSQt9ywZ1X/LKbE8rccnYQql2RqmIUqbBVKBs6dF6sapj
         q9AXObH5zMCJ4cWIX0ix3Wssm8wh1Bfzv3TaB5w64RJ2ivVyUPTiARvXX8XXkycwOjKB
         mBVcyJtKG8lDo8xKdWag3XW3ZlV+MmqPeZ0PQqehbpdV55ee6J/CSD0GCl8CKLyHNSe3
         yGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6vape/K9pnaJlDnSHi71/S2eew2s8oAgi2GcuyJr7w=;
        b=T2f0f72SkYPY1NAL3dYpS1srMpY1XeS3A2CTF+kzjM9dO+TXUO6ty+NqCqefFkTUs7
         KNm/0EN5adfRVqnzRCg8EMkbczrVrEEm/UxZf9vpObcII67zCsoJWEviE49A3IQqN+uh
         wZeHc5E4vUtLay57suNV/LNloClp0GgoRGZmjtPWJiJXiVVYgYfs4hOItfwxoZyTWS/C
         WgKuzHJnNKl/FFs6DeXOkj33APZQQKqLLXAWhWnm67e83DCgxOk3xPdXhn4HAVsfOk8O
         wRYuaZce3+DIqUxZulEZrVDGavmgN1xtFNDTMU6dKbn8cUZolb/bJetPG3UC0Bp5+gm0
         XjDg==
X-Gm-Message-State: ANoB5pktM7eP0RAVAFGrh5ZjC8HhQK3dpowAQ3Pqee39wuHLf0UjKylJ
	xkb0m5XcUJZFcJuCvfQd+nWor4FJ96o=
X-Google-Smtp-Source: AA0mqf6Mu47uRmTadCwmCNfwLaGp88C+FUnqUC1x8ZdL/mptD2Q2Fe0vtaYqIKOLcAWmOzKxnykJ1w==
X-Received: by 2002:a05:600c:4e01:b0:3d2:3b8d:21e5 with SMTP id b1-20020a05600c4e0100b003d23b8d21e5mr8230872wmq.14.1671196528998;
        Fri, 16 Dec 2022 05:15:28 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id y21-20020a1c4b15000000b003d1b4d957aasm2556229wma.36.2022.12.16.05.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 05:15:28 -0800 (PST)
Date: Fri, 16 Dec 2022 13:15:27 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
Message-ID: <Y5xvb4JB4ceOZdCQ@debian>
References: <20221215172908.162858817@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>

Hi Greg,

On Thu, Dec 15, 2022 at 07:10:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.14 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
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
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2364
[2]. https://openqa.qa.codethink.co.uk/tests/2368
[3]. https://openqa.qa.codethink.co.uk/tests/2367

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
