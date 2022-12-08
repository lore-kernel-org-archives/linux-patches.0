Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37C57F3
	for <patches@lists.linux.dev>; Thu,  8 Dec 2022 09:41:16 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id f13-20020a1cc90d000000b003d08c4cf679so583659wmb.5
        for <patches@lists.linux.dev>; Thu, 08 Dec 2022 01:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t/oPdE8gI0My+jyuLY5X8msXAYGJqJBO3dcAoMyxSeI=;
        b=V9YCC1LOdSgHtVHqLHwIGdi/z9Ap2kwdQgcpzzRJx3WDkpvyTH31dTEZRd5OEGcFhJ
         BgOsR/ooYablm73a7xOHX6hBaRLqjpcFeFnmse4P2Sf9Rp73KMcfdbZBQWfhVrJR4/sr
         lnF0uuKKO6ljzpC1zNwdSNGu+phtX6xR3E+n4cTaoyCxWKCdBZ2NtiwIf52Quwwv5QAl
         9UF0DG4BRpJeQ+lXPrnvhsDh8qdOFqE+7tHWQLHWVV4V/2F2pW5k5ytZGMRNwPe0EKdx
         NznCu8lQBjKI2Td4Fr/Q7XZdnRym5eByDc1wgj63GfyBRKTNaX9lhn5wVvsJH7XLwMvj
         zDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/oPdE8gI0My+jyuLY5X8msXAYGJqJBO3dcAoMyxSeI=;
        b=rrQNML0Endbm5axevvUqbbqz2a96uIXGq2a7Rvb+KWTnk3QfBFtlpYSilzyxAGMue1
         Z17BPDnbntgzAy1w9FsnRPKynxAwlHEQRfOI0eFhrBqNYMpkaMTenvrHrNZkNSo3pt4i
         7pvAIwNY7jfv1OPTC1y082UZa/yFDLtsCCvto8KTn0w5yz5vQCBTFadQvneir6oNAizd
         sv3pX1WJZEP1BhEfotWGPIID2/N96bWCsQhOMEbVNHkcNnFl3K5p+foLff7Z5PcTmKu+
         Oz5rkS2sVjt0w2ND40T/07uorvJgM6wKH9huMrrXPNPxKCeEdOd1y957Y65aygEoonZA
         yi+A==
X-Gm-Message-State: ANoB5pmAiNF8wEsRT7PnhtW4kVXKj8umHbmO7V1TzoLHfe6zD1nmCfxT
	nExIKn/2R1Ypi225sJU8kVunx/zz3TU=
X-Google-Smtp-Source: AA0mqf50LTcRbr+w2TD++ye3fbkl3KEWmpYtOfrY0O9yaYSbB5UoVo5D0b6TEozCGUCht+jCnsFS3g==
X-Received: by 2002:a05:600c:539a:b0:3cf:8957:806e with SMTP id hg26-20020a05600c539a00b003cf8957806emr1708520wmb.5.1670492475272;
        Thu, 08 Dec 2022 01:41:15 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id q21-20020a7bce95000000b003d1de805de5sm4303221wmj.16.2022.12.08.01.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 01:41:15 -0800 (PST)
Date: Thu, 8 Dec 2022 09:41:13 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/96] 5.10.158-rc2 review
Message-ID: <Y5GxObmE5m/QyVgQ@debian>
References: <20221206124048.850573317@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124048.850573317@linuxfoundation.org>

Hi Greg,

On Tue, Dec 06, 2022 at 01:42:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.158 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2313
[2]. https://openqa.qa.codethink.co.uk/tests/2310


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
