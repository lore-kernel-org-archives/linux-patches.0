Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCFF33E7
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 11:49:06 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id o36so4103362wms.1
        for <patches@lists.linux.dev>; Tue, 31 Jan 2023 03:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xOuKpEZ1jj97XUC/j3mPDWi/nJBBNGvsjF3Zpzi3Ud0=;
        b=qEEyrBhq59r02hG+3psz010bdHV8K8LBFdcPjLxfk4UzbwCDBPoZkqa1N9/qNnaO4l
         YduhEmRExorbeoa1ygcZNv6c/KuBubPdXTWPOcD+TXacbDPvRKsv9IZ98eCkZ+xaHKmq
         wdEsSLFyNzKbhHaoomapYTFnncVVGHNfKNhaa6s2JEthouhh5PswNJ31HC93bwnq/PFh
         l1eT3xiXnDpmgz0SNSs1Y8MvLv5SFJ2LtMdMYOsYb8enCJZwQ193NYVgLzMTvfv++oBB
         Wudkf7ZymGjBEDxVLvRPNJs5h6TNaB0EOJJwLLBpmg0z9eLI8EdfncNUKeF3JS7kgU8U
         dWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xOuKpEZ1jj97XUC/j3mPDWi/nJBBNGvsjF3Zpzi3Ud0=;
        b=2UBTdI2kO97/H/Qyl0McOZLBEIqqcKx5W0ZFFz6r9vHzGQ/eR7qCYtTGAvhojRq4aE
         pzdxtynEDDdVRQuuSaO00+Bo4ikh7/gazssmMAiUkMfS8F65gGYCzRFgn0zNyABJiVSB
         vxUsvHMsG28x4SG0wFjh1yZt/tgOqJHBP+9+Xjy94YUyjFAF3bSjXmPgvdqdfexb9x2o
         ljUXgtomDGsdjmlybg1JWbC/u+qt0KOEw1nUMikyNwDrMbRKn65M2JcBSxEEsyemew/+
         jJ9SaUas7VMbSt+Ju5d+D+by6rmdq+CXrbU0nVmhIEOCRF+taIekwqrWW8qwoTWrMYVD
         yKmQ==
X-Gm-Message-State: AO0yUKXZepbEDmMsl9NR+TErqpW/giAINE/KGgfrH+tlOvdrBbyvxYiV
	GumiNBFtHvH57GMAtxYfy8o=
X-Google-Smtp-Source: AK7set/S51RBOo0S52AlhMr6xyFSsTawRhwIeQkzjCf3zToS2aDbDQi6oMgQqUd7+4IigxhDOgoIvg==
X-Received: by 2002:a05:600c:434b:b0:3dd:1982:4d14 with SMTP id r11-20020a05600c434b00b003dd19824d14mr4792279wme.1.1675165744862;
        Tue, 31 Jan 2023 03:49:04 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id j14-20020a05600c130e00b003dc541c4b13sm7333208wmf.21.2023.01.31.03.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 03:49:04 -0800 (PST)
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
X-Google-Original-From: Sudip Mukherjee <sudip@debian>
Date: Tue, 31 Jan 2023 11:49:02 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc2 review
Message-ID: <Y9kALqNnCA5cwfnC@debian>
References: <20230130181611.883327545@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130181611.883327545@linuxfoundation.org>

Hi Greg,

On Mon, Jan 30, 2023 at 07:24:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 18:15:14 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230113):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2772
[2]. https://openqa.qa.codethink.co.uk/tests/2773
[3]. https://openqa.qa.codethink.co.uk/tests/2774

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
