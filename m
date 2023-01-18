Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1002F25
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 12:18:52 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id k8so19244422wrc.9
        for <patches@lists.linux.dev>; Wed, 18 Jan 2023 04:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IzXuhTjwqwTTvvex3uE3V9EMJrJPQwqSYU5zyi+X+lY=;
        b=FXEPCsycYMMAkAKXfIAUXduQz87Ymlp+ZlN4h+kxS7ETHKGdAfbEI3dTSr58ux9cjh
         RuNujA2Vbi3wbeaabw6Ghyl2L5BWCu5agsYLl/+VTsnzr5sgzL/ZwJl//DdtDGQUmpd+
         hBMHydNtbgVkUDCvWmN6vJDW+FgBt/QeD5uq5+pS4K+OE5QIolpzPVbQy8TVpvEg2OzB
         f0vkYT+ana/viHts6dJsqGSb5kpQUrebotf4asW0se6LbPDhBMT853pz/vjaFhVRuu6R
         1A6HU/R3cCJJraauZ3faxlBtKlI/+ABFZ25vwI2/X0dkxn63eoBz8Sj5ahqIcyWGjd7a
         aBRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IzXuhTjwqwTTvvex3uE3V9EMJrJPQwqSYU5zyi+X+lY=;
        b=2dsD31cUenDu+CZYrsJ+nlmT5j6wwzM6L/u8Muu4qWz6QmkvvgpTmmRXhrAfMsxjfb
         fE032dKXKzst2zGcIkQGgRiZ10/c6SYHObtdWNBakNa8DHEL+a4NshIDdiNf9qJUgk+w
         1VQoWm+zk25xTozI8ybuOuKVRM4/mLckuwppV39D+y9SUr8WT7JYCrL2ZSeTCynl7mt3
         9OytUwRW+BMb1xvNnAzZkh/vqUQUbssuVJx9/A7q0G5c3m0GOft/fjKfjHRaK4CCkBDT
         SLixb1u+kL5jPIbH3+9Ck3w55jlJ/wYUtny7zXPqwNb88MkOss3zWid+ey41z7Mz4fp6
         5JqQ==
X-Gm-Message-State: AFqh2ko2Q708rxfPeOr4EzL4OlrDud98LONJiTSigxxCIvF/rQ0vsbwZ
	2rva5M1DLDj2PHeCGA0AkmM=
X-Google-Smtp-Source: AMrXdXu6KyXChBO2hAgogSw1N/qRKhCpFiz5gsLp4sYI8qHA3eLkjrD+DPciPH4/UlkIvhbxBSOR9w==
X-Received: by 2002:a5d:4e01:0:b0:2bd:e531:8e58 with SMTP id p1-20020a5d4e01000000b002bde5318e58mr6039404wrt.24.1674044330613;
        Wed, 18 Jan 2023 04:18:50 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id e20-20020a5d5954000000b002be099f78c0sm6935204wri.69.2023.01.18.04.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 04:18:50 -0800 (PST)
Date: Wed, 18 Jan 2023 12:18:48 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/477] 4.19.270-rc2 review
Message-ID: <Y8fjqFh/pRBpNOz7@debian>
References: <20230117124624.496082438@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124624.496082438@linuxfoundation.org>

Hi Greg,

On Tue, Jan 17, 2023 at 01:47:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.270 release.
> There are 477 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230113):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2673


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
