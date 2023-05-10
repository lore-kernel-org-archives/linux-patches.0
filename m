Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0695E364
	for <patches@lists.linux.dev>; Wed, 10 May 2023 08:46:03 +0000 (UTC)
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-3f4249b7badso33999285e9.3
        for <patches@lists.linux.dev>; Wed, 10 May 2023 01:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683708362; x=1686300362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rCPafpW7uQ83hGVCzhke2jlh3dmPbvqOP9zS3Cs8m0Y=;
        b=gAZr78E6iYV47qcwBsipvHYBbNpJzVDC20crMOT6gMJjOCSA6ITLt4cUdaT1Qhl1H6
         eZN6nwL1qWznrdUPaaq9car0Q/mzfu13SApBl+lbUysO9E6VoMLWNPMH8V/iM4AlhNZh
         W6/2XQrpxw18mDmNN65O6QIdlDV9g7W03qTnD0s8cvZqLESkmfLQzLxq7kQxolEB5/4s
         LXiJQxD7BjqGNAagAQ5c6QE5BkMAKeNsxilFE3iW1ptyZYHIJvbyAjWC+tm/Y3a9a/8U
         l9NDg92df3qXgWluZr+GHu2jQ7fSX6mThIYKYVY0+Wf/nslEd04yr7fyzaObAZpZdITW
         KXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683708362; x=1686300362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rCPafpW7uQ83hGVCzhke2jlh3dmPbvqOP9zS3Cs8m0Y=;
        b=VXIfrbykBNl8cAkvIDSp4jQVAPmhoSD7hH35m+jKUiiWrtdrFylmBMp1KWFs2TvtKh
         xKgcBqwsCD/XsbP6osu5Jy40KibmdXJfEuCeTW04nFjQg5boICuM2kT5iknG4vUiSkU2
         EQtFrffL4XERsGSOFQOQxq3IsLa5h5H1h5B4DaITa57kW4o3zF1guju45yj0t/GbnqiA
         DXL9j98A3G6En2pQKL4iMPNasxBrDGEgJb8x/ht0vFMFfoFhlrxX66zXxSm/WF/ewvxx
         Pn38qGXFxafOpKYENYzjV1LqSywTisXerJ/q1u+T46wafUDPWJZRKvCvZtiVCcH/E255
         dShg==
X-Gm-Message-State: AC+VfDzmrnRkkf/r2r/TYDjesUd2pyJuUUH2Fz1jii9X2IY5dlDenmpm
	tODfRq7PP775bnWHwTleQRs=
X-Google-Smtp-Source: ACHHUZ5OLxdFx18LuUykzc6Z+H0VtF0Lbx148HhoR4ru4qxPQKBLWmqtYQCQUBQbQcAwTqd5+ZbyJA==
X-Received: by 2002:a1c:f202:0:b0:3f1:75b0:dc47 with SMTP id s2-20020a1cf202000000b003f175b0dc47mr11589425wmc.15.1683708361869;
        Wed, 10 May 2023 01:46:01 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id l11-20020a05600c1d0b00b003f1978bbcd6sm6389336wms.3.2023.05.10.01.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 01:46:01 -0700 (PDT)
Date: Wed, 10 May 2023 09:45:59 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/662] 6.2.15-rc2 review
Message-ID: <ZFtZx1iSv7vdEY64@debian>
References: <20230509030701.507375024@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509030701.507375024@linuxfoundation.org>

Hi Greg,

On Tue, May 09, 2023 at 05:27:04AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.15 release.
> There are 662 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230501):
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

[1]. https://openqa.qa.codethink.co.uk/tests/3492
[2]. https://openqa.qa.codethink.co.uk/tests/3493

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip

