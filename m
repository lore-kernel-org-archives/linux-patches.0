Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E142F25
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 12:03:28 +0000 (UTC)
Received: by mail-wr1-f51.google.com with SMTP id d2so13568954wrp.8
        for <patches@lists.linux.dev>; Wed, 18 Jan 2023 04:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8nhezqflOATFFNnPhTotRfG2qXe/R2C82GK9147Uq6k=;
        b=ZPXzjtrQKfSffr6NP3Ie4Q9762h40A4UqbVI+8raOIk6IgOVQ6vukTzwDDe4zsMWRD
         6IdD2apgtz7nW7I6KFbt6OHNfU/l2lEkkF4Gx58xuTedkizhD7D+F3czue3cpbUKnUX5
         p+DRU9uhTjjJ8UtJVzmwMpjFJ4izt21ieLZS7PWR+uA2x5E7jF8XDKggj08T0I3Ju2Js
         VK+9xJlqPw4pihZw5xoitjYRERpT8PeZreewTVHPv4WTj+O8esxrteopYIB5uQ2rusro
         x4EzWG1ZhSVXu0xrWsDYZGtxpykyERBBKgOsTpSw/qrWW2JbGJBmtVSKqwlBvoAKITyk
         1v7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8nhezqflOATFFNnPhTotRfG2qXe/R2C82GK9147Uq6k=;
        b=Zo5gkwZDJCpfwKsC08ADVm6FqylvyG9sT1D8Gs+wZeqZLBIMZ80w64gmY8HkpuNv2f
         UxC58XW9nJWScg00bKWEIVvrAKpgsrN0OukwNNM1F4JJlBruxZMgeLjJQwcfi2T8lmtx
         eaIi9mvVpprNPtIBqLPHsEUhCqT6dMSZF2f5kGArmYSHqRyJRlnyWO8Om5oTrfczy+OE
         e275gja9Sb0NXVEbLsjXrm85PBM2VmdWmZZoSFRnWeM858xcq6mebOz3IiNx8+Ctwf9f
         y7ctwwMZY1pRQTf3FWyzyCBH+P/eRziV1Mynvkbku7qpajTxAoFtZSOylnBJdKbaiV6y
         y3eA==
X-Gm-Message-State: AFqh2koZTuP1Oh53IOsG7ZKZW+NGeXZLC9tgQEKqW3/sIgZxpeOKmYBk
	+XdPyb2uS9MeMgiHOZS4G5w=
X-Google-Smtp-Source: AMrXdXvNmRU+xYMjcdBGpUG52jhIDjjbp9w8DVYtmASVRK7Yt61KX8EkAymfdItkn4V2AoAXEr1Bug==
X-Received: by 2002:adf:f0c1:0:b0:2bd:e7a0:6b5e with SMTP id x1-20020adff0c1000000b002bde7a06b5emr6223464wro.40.1674043406275;
        Wed, 18 Jan 2023 04:03:26 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id y18-20020a5d6152000000b002425be3c9e2sm30535321wrt.60.2023.01.18.04.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 04:03:25 -0800 (PST)
Date: Wed, 18 Jan 2023 12:03:24 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
Message-ID: <Y8fgDBLOMgZGerSZ@debian>
References: <20230117124546.116438951@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>

Hi Greg,

On Tue, Jan 17, 2023 at 01:48:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2679
[2]. https://openqa.qa.codethink.co.uk/tests/2680
[3]. https://openqa.qa.codethink.co.uk/tests/2681

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip

