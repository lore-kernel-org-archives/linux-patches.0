Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9707B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 12:30:30 +0000 (UTC)
Received: by mail-wr1-f51.google.com with SMTP id g3so7408078wri.6
        for <patches@lists.linux.dev>; Sat, 11 Mar 2023 04:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678537829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nq3jzIw8qkZj50nUFqJA+HWT5jSIOVCQw4lTHi9m3Bc=;
        b=h6q9u9/zO3jte1IqviUmbqs9N9F9u1cp5f+od9Y8m7bHli8iGco99KGT/45t4dswX1
         5IoIQI9/ldHnF1mgZ1ZJtHqQ4I89kw1O230cFg7Xl6OFGPSX5Tgx2YHGb1QRF7PEzRDR
         0lqg+jVaXFon+UmuR3sDGUtxM/CBYKEAYmYkECAWYgzEF9AyJUa4yU0XMS0xnSU4VcFh
         lc+L5CKiDD+ganVjwKWeAvXRzoZ724vZDdYJKv03JZYhXvo6KS5BmwxGttf2LM4jWaIy
         daj43/siLCjNxAdyaJhJMnMGuxvsBM9GzVsnfTnn8goap47/sABVOilWxNTOGl0WaqpR
         IpgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678537829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nq3jzIw8qkZj50nUFqJA+HWT5jSIOVCQw4lTHi9m3Bc=;
        b=K8WXnCAy92YG7V+vqNJ+Yi+oRIxcT82ESKTQW8Vq72iT/4Mhfza3Y1a/lmf7aCrcjn
         gKeVFdHVTG669JB8xe0G0AIk3jNLAi+1KkhW/Yt/FTF/QT7juM1s07eW4Diz9LVSKTfL
         ghRFmVR9036OM9bgwvuoCF/Xy3EIBp3mvdxF+pkv4zVeW5dZOGyiH4hvaB6ar8MSwrLs
         qFGa6OPMiXNEs32YkAHcnD9CiY58SyQA7+CIf5HMc5CUdxg3fXnWRpGOGTJfKFY+hPSm
         UTUTuUXHnOHdrhZebtFumidg2S7Q2PYAUwF9qVSQZCy5aHQAK+qbnEiyyYfvG6n2yIF3
         4yAA==
X-Gm-Message-State: AO0yUKVvZkBjQEHizZz7GDaXfXWhVJwc3sqkW40p7Cm6NJfV1SVZrWL0
	x+MAbMUbuLhmc6l++DpNbsk=
X-Google-Smtp-Source: AK7set/Wm2JO+lDCe3EQc+1lsmGqsZMIdnfELXQOBWxZyCbHg9It0mLOCPu3VxdQaGu1qyBAL6M0Mw==
X-Received: by 2002:adf:dfc3:0:b0:2c5:5886:850d with SMTP id q3-20020adfdfc3000000b002c55886850dmr17335171wrn.5.1678537828789;
        Sat, 11 Mar 2023 04:30:28 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id j28-20020a5d6e5c000000b002c551f7d452sm2239782wrz.98.2023.03.11.04.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 04:30:28 -0800 (PST)
Date: Sat, 11 Mar 2023 12:30:26 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/211] 6.2.4-rc1 review
Message-ID: <ZAx0YrXQ8KpmDxRU@debian>
References: <20230310133718.689332661@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>

Hi Greg,

On Fri, Mar 10, 2023 at 02:36:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.4 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/3082
[2]. https://openqa.qa.codethink.co.uk/tests/3085

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
