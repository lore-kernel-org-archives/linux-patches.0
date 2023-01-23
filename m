Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791D37C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 11:17:24 +0000 (UTC)
Received: by mail-wm1-f45.google.com with SMTP id q10-20020a1cf30a000000b003db0edfdb74so4147230wmq.1
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 03:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I8RXJKIpZAzsImUbnBlvk5rvp70BYcaKy5ZQ6jEsvD4=;
        b=eUK0LougOfbiaHnGbcLlkrz5wPfXRYEySvHvSFGeWQnCGq39xT3/khprk8GhhXGXrn
         kn7rtvfzf0NUhMTZmPyREGuJ7LtEoZLx0VJbk9Oyspf554j7TtKtNYe2ZCrACSvAiwxE
         nTDlNDOSfHSkH3kMtizM+H+27K0Q5lv4jJcwf/HHN2oO+32/3VkgZ7T9ThULvbkGfFXa
         1HL0HshWPIyIsdTfjLmPMJPKS+YkIYi8HY/L8LW/6iCWxLYs4dVzuTNa3HGaSdKKpe1X
         mXAo5GZfeTQsGGMOcif+fDZv0NbxOJ6ScYgnJBy+4OPFsHZGV9JUt801qTGK10aZuAjR
         PRKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I8RXJKIpZAzsImUbnBlvk5rvp70BYcaKy5ZQ6jEsvD4=;
        b=REPgIfQ+LRZrRhSLyzpE/NhYX69qc1kISC7OdMkdTL9MKQHB9WADpFOtQZcUb25AFy
         ZmYSIbEFWw1+HRIddl7bQlQMvjGd/pQSfpO+3l4UQ++JMFzbTxeiu4NL5Zg/XC6ZAtiI
         KueNLiuRqkWVK60Iydnn/lfsBjpwjRJB9gB9c6CYDLStLVmvh5AmprwokbeS2biteZLu
         Uwz+7XjYhZKMqc9nmFkTjWOqQiqswrldDzbh5iBKrvNT9ehZxpzGC0mBlB8iLA2I6WN2
         7MR34tQFXXRZCnP7p/Bv3vt4uhWRj0MwTFPig9EibVcPGf5CV9Ft9CBZkIK8WC/uHKDH
         TIkQ==
X-Gm-Message-State: AFqh2koLtLqZdcLrcFoa/r+gTbT1bXtl+NLX1jcospoCy4R/9bliRst0
	It+VgbHQmAEjSMy6HBkw+ME=
X-Google-Smtp-Source: AMrXdXsahbcKmGCEM+1XFhaWI84GK5PfbdpvjTupPmlH0P6XjBqopMsJSGNYRRJ8/6DPf4HpS9Oldw==
X-Received: by 2002:a05:600c:214f:b0:3cf:7197:e67c with SMTP id v15-20020a05600c214f00b003cf7197e67cmr23612873wml.25.1674472642640;
        Mon, 23 Jan 2023 03:17:22 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id p7-20020a05600c468700b003db0bb81b6asm10969686wmo.1.2023.01.23.03.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 03:17:22 -0800 (PST)
Date: Mon, 23 Jan 2023 11:17:20 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc1 review
Message-ID: <Y85swG8b0cYmALky@debian>
References: <20230122150232.736358800@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>

Hi Greg,

On Sun, Jan 22, 2023 at 04:03:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230113):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2697
[2]. https://openqa.qa.codethink.co.uk/tests/2702
[3]. https://openqa.qa.codethink.co.uk/tests/2707

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
