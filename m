Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0FC23D4
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 10:45:47 +0000 (UTC)
Received: by mail-wm1-f50.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso3620229wme.5
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 02:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OkVcv1cn9b60nNBS5JVT31BD/8eY5SE8Gy7OuhYf8XE=;
        b=pLEDMS+R4/Jb+gXuhyQpAGnX5fgd33+usIh1Jp073c9tg/xNqCw3SSkFQy/gbQ6yCn
         S4+dp4NycYIB6U+eduC+9lj8lFRl3UzWiPBl6m9BPkpM6viE+LG1uKxUWbbliO0loJUo
         jiuC7KIGBPcOO7JcEJoD/yLhOR8S5i9Mr/IzemM4EzpFF2Y+fKng7A0sU1EK1L+eq1Hq
         TDVkmQHbUVHbc4dWIhh5HxOzQx1DlAoxA9RbhWInRtoI2Zh5Ao6K4Yd078w/eeJsFp6W
         YSmrrExvyKpWo1wr7u5L58JBuwRdd+9Bml5DqUzF6S705VYPneL6It/gFRz3KTX39DGt
         l6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OkVcv1cn9b60nNBS5JVT31BD/8eY5SE8Gy7OuhYf8XE=;
        b=QIs6yBHBEgoCFMlbwZ5+FCax/vlG23sPtALRKGK7+EFQbnNDVIl+NOUSzv8FDFgT7m
         fFSLEVkIMhKV/UxTbvvc+yr+lg81njsTBBPpyJ+bOPa6A8Q19CjMfQG2ROZJAXP9B6u0
         W1kJMBcUi08fgf1JOmlZEyMBgtJ3R2+zTRO29e/dE8UQXm/9FTPpYOYtow/H2s5DEJBA
         0jSnkBfDBK8oiQdrp10XZDX2ZhQy7zXnY1C/cxHDOKHXlBW2dHuijiyq7avYVd5zIgeN
         VuEr9IiJlR5tbP2PMADkTFr8P3KyqkJkQK/FXVUDteN0voSyZwagJnU89AFY31gVfPdS
         OG0Q==
X-Gm-Message-State: ANoB5pl+TOJvevjbaToWzi6pVEPHW8BdsyPcdwn3U87SgF2VueIu9Abl
	m6Fc3uRiDXcdyReqCuCCBQw=
X-Google-Smtp-Source: AA0mqf5GHAFhr/74O6Iyd8KoLwdozaQ9xytpWWtGIt85IZgMQVqWqm9tmJ4RK/3ZUkEQZlb9LhbNQg==
X-Received: by 2002:a05:600c:3d10:b0:3cf:8a44:e1eb with SMTP id bh16-20020a05600c3d1000b003cf8a44e1ebmr14028709wmb.189.1669286745736;
        Thu, 24 Nov 2022 02:45:45 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id y14-20020adff14e000000b00226dba960b4sm1079481wro.3.2022.11.24.02.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 02:45:45 -0800 (PST)
Date: Thu, 24 Nov 2022 10:45:43 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/156] 5.4.225-rc1 review
Message-ID: <Y39LV9/xShW88nQf@debian>
References: <20221123084557.816085212@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>

Hi Greg,

On Wed, Nov 23, 2022 at 09:49:17AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.225 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2207


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
