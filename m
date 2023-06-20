Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368D2FC01
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 12:20:11 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-3f8f3786f1dso50653315e9.2
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 05:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687263610; x=1689855610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YN4XeAAW9Msbpq4rVR/lXtHCKRrTEhKEAVXjSUlPPNY=;
        b=busncoqU/9hcpDtBZvdrY/THUyqTAoJ5hkQDAzgfzxZR0IMV4l3dNoPjUFYYHLZetW
         jf/5wunI/AU+rA3VTswiPQjns5p8diTzP77zE52hCdHQiAPpMcXHYEAmtIHkTbvqdK+J
         H7PZ+2zM47UXgZlwaf0IOx81ieDhrjh3HBaAawyVmDdw4wQseSZ+HGtw1TBIc5R5Vik1
         8lNpgWpUxYt3ZxLoWP5ssxtbTsnRruSzADbspW5ZAQoxMxwA7ZShMm58QapqMtI+kYus
         dvGl9BdBT1ztwqoaxIz2nbgdExHCYQeNBPLmUvqyZBXtW9UEnrx1d6cY0Cdjzy1Re/v8
         aN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687263610; x=1689855610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YN4XeAAW9Msbpq4rVR/lXtHCKRrTEhKEAVXjSUlPPNY=;
        b=WCsDbrxBETe2sXldgF2T8UUfIZSLRzrFCvZPHM0LX/wvKXvI9aYo49Sn16IV6zxwms
         NWej3bHelWZ/5Y2tRmwRnOuzWCMpW3E+0saUBU3vJNO6nQXDBdSOJ+WCARbq61wsJuzB
         ZmabVZJX7AT6IpWpSvNuR4v7sb1GXJi8bUPBf3/vRfiQjfZ1ZdIJr+8R2G212URrC1tS
         LAVNuJYjhZxODw5DXxTiMILa90IknfOVsliSy46aI5k3cLc9WcWvVZLGdWPhZWP8LTd9
         U32o43RA+ag4sntiSXRRQUDmvIRYG4DyF1zV2Rj8LHfOYnb3nHepQUChIjUrTkeOs2pZ
         g0FA==
X-Gm-Message-State: AC+VfDwrIomb3bnkLjHI/10JmQPcHOYtkbK8QLtsgm2KQIZ1txEaA3Dh
	UyBQ32km/+01aehYeQ3u3qI=
X-Google-Smtp-Source: ACHHUZ4O+NZZj+sKZX5xYKL3BHLJ2/pBF7IkPd8LnTYybGpvOtE4qgprz+QVS3Y/LdEwKd/Fp2xQWg==
X-Received: by 2002:a7b:c391:0:b0:3f9:b3f5:b8f with SMTP id s17-20020a7bc391000000b003f9b3f50b8fmr2994679wmj.34.1687263609980;
        Tue, 20 Jun 2023 05:20:09 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id q19-20020a1cf313000000b003f7361ca753sm13081501wmq.24.2023.06.20.05.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 05:20:09 -0700 (PDT)
Date: Tue, 20 Jun 2023 13:20:08 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/187] 6.3.9-rc1 review
Message-ID: <ZJGZeFafSMZGszdg@debian>
References: <20230619102157.579823843@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>

Hi Greg,

On Mon, Jun 19, 2023 at 12:26:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.9 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 12.2.1 20230511):
mips: 52 configs -> no failure
arm: 71 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/4085
[2]. https://openqa.qa.codethink.co.uk/tests/4081
[3]. https://openqa.qa.codethink.co.uk/tests/4079

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
