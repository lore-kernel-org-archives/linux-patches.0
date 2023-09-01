Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172D0881F
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 09:28:13 +0000 (UTC)
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4018af103bcso10783065e9.1
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 02:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693560492; x=1694165292; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=921PCazgPbPvMm6h5EIxZTtPV/S3F9LCWQZ9BR5vflQ=;
        b=M+7CA97LU+bDgGpJ+2Qmcadz/j+E2VcGxSiBJbTlZ177o0bb56IH53jIfR00K53vbL
         B4Nd6RLCpHaxwA47JD/4u9w55sfoKwbSxwqRpBKkNnrpiFmYRzVPM8TgOvs8rXU4aomA
         xvoNrUA3QOnjJHwmXHF+ySGp75CdPtrw5RKRv+ddyRWCfhh/rYLuzYaraeOZy3bxjlhh
         JPQQAeL3grLfTEHWNgbNcllz6AxSJN2PwjJKLpGLaLLrNhtl255SIGAFJGd/G5512CiM
         aIndhgUKfoYGbP/lhLnZFLvoO4XW42UqvaDaqFMQCI40xCq6iHQ55iZD2PiNheDA2DNd
         AxFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693560492; x=1694165292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=921PCazgPbPvMm6h5EIxZTtPV/S3F9LCWQZ9BR5vflQ=;
        b=iabQ1coeuVHVatrEicSWrfiqcA+2KhnZupOYhxl9ZTFWzWzBvkARyt+x9QeSRVrK87
         jAR19DIlBQ2ImUcBr9cEASDrEzOM/YzOC+aeoLyTHssoiSQ+ecSDH9pDmjp/beYEC400
         hyw6cvXhynfvlZT4s4mCOWaVnLNqCUPDpdRSwwDAlALJxQVAvHrQ0HA+GOk6qfH1F+1h
         kNcgBD/dcFXg/z5XsPK7lTBzsDSqbjvO4UOmhyQx71W9e0YYtDNLFnc5twte7UV9y5Yg
         Nm2Awc8ha8BzxTl8XoVf6ZIxpqOs9W4DqUkkuTQcUDgHYOUn3Ni+7l68P+17p2T+zT1G
         UsoA==
X-Gm-Message-State: AOJu0YzFPSQhNxhuxZ/aYdsVm4IKBBNra55rOKIYjuKjpx3eWtjbxRam
	R4Re9k8OR55TIxeJlOX/rGk=
X-Google-Smtp-Source: AGHT+IEc6rJeSSYPDFUfT5rGECkv/1fyu+f2+VIOpvD+PXwRc7Z6zMw8NZ50pxUPaCFo3NWbJdWPhg==
X-Received: by 2002:a05:600c:5109:b0:3fe:d589:ed78 with SMTP id o9-20020a05600c510900b003fed589ed78mr3278661wms.20.1693560491666;
        Fri, 01 Sep 2023 02:28:11 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id k15-20020a05600c0b4f00b003fee6f027c7sm7369556wmr.19.2023.09.01.02.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 02:28:11 -0700 (PDT)
Date: Fri, 1 Sep 2023 10:28:09 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 00/11] 5.10.194-rc1 review
Message-ID: <ZPGuqeR3zQqoQbyI@debian>
References: <20230831110830.455765526@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110830.455765526@linuxfoundation.org>

Hi Greg,

On Thu, Aug 31, 2023 at 01:09:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.194 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.4.1 20230829):
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

[1]. https://openqa.qa.codethink.co.uk/tests/4881
[2]. https://openqa.qa.codethink.co.uk/tests/4902


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
