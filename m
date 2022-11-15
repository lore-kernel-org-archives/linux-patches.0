Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45014185F
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 10:51:02 +0000 (UTC)
Received: by mail-wr1-f52.google.com with SMTP id w14so23540425wru.8
        for <patches@lists.linux.dev>; Tue, 15 Nov 2022 02:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kHCgeLA0fpuWkN3uj8aUPAizFmCCsJ1Dqq3I0wnRPWU=;
        b=GG4hmXhCqxKmzlYOL7VTm1BeMRDNqi2IpszPTa8xfmjeMQtQPJqlN7zGzaHFVnftl0
         KdtyUPlz/k8OV4yns0BSqXy1RkDHPJRm4UyBUam9wFX06Su+sha5n0j6rfYgSne4FVWH
         KrrS2f6ko2zg6Lnk0dZwyhAMJgJCm2VENbOh7+uxiuzRH4hWsWZzOn+vt8L1+N4VZwnQ
         4qZDnPZrndHhVplG+4zWuVixqmcQ8+AkO5rvdJAm3PBZaikFMz1wf8uB0kqQv76KT2mP
         ah4H6cj0Sns6e8hVEsFtFrwuiqoc6oBhSImq8mdOhmpKCFe6Y4lXBx3AQ3ghz4MBXFvX
         7qaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHCgeLA0fpuWkN3uj8aUPAizFmCCsJ1Dqq3I0wnRPWU=;
        b=4ANYrcVaN3zDNpBxQmsW9LVjYCzPfi4SUNqDvEYlJqb+q7O/gnXfOgh5PdENPcEeRo
         duHUnF85FjJXIo/7Ff8O/sgJ/M5dXN31Q6hOqvy0GmerjdHVokk9bRrPREnYci7PGXd9
         Fwed4worucFCAMoqllpDzJd8qCwOF6VfjSMq+ESudbCtOnbW+OZD7xz7FUe/f7oJZci2
         3T3+uICVfAyJkEO9L0UD2VG8lSw0pbo0hM3yvpkXE6S+oMBmpCjuLryUbxjAdb0mxe4g
         6H2QtFF20o/7Q0fOB9xyHEMObnntf33JSa5Ws3YOgzwDv0xBKNMiecbB6/8dsmL0audr
         JiwA==
X-Gm-Message-State: ANoB5pl8Y3/X51lRrNnlJQzDh3IKZ5+fgihmMKLpizvLbZNg7NMKJHRu
	jj2Oe7U8YUKJW9Y3DEKdsf8=
X-Google-Smtp-Source: AA0mqf4GEI373UOdrjvDzZ5pT8z3m5lebiGDE1qPpELbuVBcmrexL72FD1b57d+zN8FqQnPe9icPAw==
X-Received: by 2002:a5d:590a:0:b0:22c:c41d:3442 with SMTP id v10-20020a5d590a000000b0022cc41d3442mr10526736wrd.494.1668509460593;
        Tue, 15 Nov 2022 02:51:00 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id a22-20020a5d4576000000b002365254ea42sm12189900wrc.1.2022.11.15.02.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 02:51:00 -0800 (PST)
Date: Tue, 15 Nov 2022 10:50:58 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/95] 5.10.155-rc1 review
Message-ID: <Y3NvEpXzNBxu29lZ@debian>
References: <20221114124442.530286937@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>

Hi Greg,

On Mon, Nov 14, 2022 at 01:44:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.155 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2161
[2]. https://openqa.qa.codethink.co.uk/tests/2162


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
