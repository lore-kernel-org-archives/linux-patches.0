Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DFF1D0DC6
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 18:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724782077; cv=none; b=EMDfQLS5jEdipf2xc05rLXi/14409Z6inrlJ243IA+hBLe3ZX5jt+HIJva/yExdD5y437kh7mHn82TM7wSYJGpFd5KfJKeid2a0tb3UwM8QvX+6EXtsQ0vvikkOc+FI8O193bRKO9VCygQFSaxUtRIbh+za7P/v9RMMQJO2PEUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724782077; c=relaxed/simple;
	bh=lAhAeqgjNAY5g+GAszam7Q3K2oVB0wyj04I9ekuclp8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P90sU4mSQ+nwrn2yam+EADYnovKmqJMKfZhJIXVBYNKoRrGe/shZKmiC3p4A2Ib3OjD+kMBEGpam1sLeIffg67K+vDa03gsMUBy1VNhAXBxBPaH4xHGdrBPfnT1PCX9UO5Qie3bG6yX7cdfVUvQl6oekWIPm0D7J1FILnV0CvYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aeyXW+oG; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aeyXW+oG"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5dcd8403656so2922456eaf.1
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 11:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724782074; x=1725386874; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/b4dRpNjGudpEwl7Acu5bLfC+npGjFhptD2B2uvvIhs=;
        b=aeyXW+oG8d/esETC+d/cuXImT8vpaMDYsYkby4ndVW/04qRRZ0969Sm3gYjkXoRXae
         Hae+QB/amqa5EhcfAmCbL18Hh80kfJungR84QG8rnpfzgRz1Dp2pW/vD4sNUoljmpjy5
         fYzTeRFMVI+2HpahzwSnetFYu0XmvcK0EwMzeN2r1waxT4y7BMR/WfQE1+nqm6BqrNaL
         6/lSR2CJHDW2woPj3652G7P26pPMzeZE6LB0mFP8G3cWZ9GTIvPvIjTL0Nepo42YqcDJ
         +flRzb3pEKd553eLpVtKofdF2mU4WucZpkPJT8SfDPHc1TOCKuaBxRU9BBpLqdUG5Tpu
         VxPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724782074; x=1725386874;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/b4dRpNjGudpEwl7Acu5bLfC+npGjFhptD2B2uvvIhs=;
        b=wMAYVzVr0dv0Ao2CgVnpsxcbh7l8ESsksTX54fHKMfi+DzB5ztP7dyezr7a8Q4UOSt
         6fwgBvWDz3femapy0g4YdAMfNkq7hBVVvc6eRHSQzC7+YItAqV2jfJYldxHcGoItvR/G
         e3MMb6VOhpsR7zSQRkRtIE9PA6ecB83UOV5PtxTNqYu7ree+NwXgkR6XwkTYmE3HGaKU
         K+hHHxsVIl5zDJwz9liI2aBTkBQLa2KRBB5rB4TyFfUAIFHCi9OHWwD1f+vL/TOaVgm2
         bSl4Oi0M7U+DrcpG1Mj4Y5IydeDaUpCgs648Hx4digbjr+lx6t/cE0u+O5+bNPHGcN9u
         MFsQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7LDaaBk3nlrEk5VYnGioZidZ4IXxf4gIO1irv9/GpgAJ+/ff43CCq79rbRs3niL/VfUmDxCGb@lists.linux.dev
X-Gm-Message-State: AOJu0YwoIP3JHEHXK+sHS01ypECtH2jOqD7Sz1lxfG+qKvkPPjQyFejV
	SjKMLwtXAfIAtaK2i0ceWyTvDbaOXfCBDo1x4F47wij8EUtgDuQDyuOP8cFAHN0O5f22rgW8sH5
	Mt8qY/ft84lbAkXu78QewsPVYv+528KypJNNgzg==
X-Google-Smtp-Source: AGHT+IFR8RYrS+3AYHKWfyfd4ucpXHOPlxyO3EUNWmKH5WtItwGtOhPVzmXRV9SuRNdjiJdFwEX8Vni9ZUK+S+bHf/o=
X-Received: by 2002:a05:6358:724f:b0:1b5:a043:8f43 with SMTP id
 e5c5f4694b2df-1b5c1ea9182mr1595275155d.0.1724782074350; Tue, 27 Aug 2024
 11:07:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240827143838.192435816@linuxfoundation.org>
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 27 Aug 2024 23:37:42 +0530
Message-ID: <CA+G9fYuS47-zRgv9GY3XO54GN_4EHPFe7jGR50ZoChEYeN0ihg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, rcu <rcu@vger.kernel.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Zhen Lei <thunder.leizhen@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Aug 2024 at 20:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.107 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.107-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The tinyconfig builds failed due to following build warnings / errors on the
stable-rc linux-6.1.y and linux-6.6.y

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build error:
-------
In file included from /kernel/rcu/update.c:49:
/kernel/rcu/rcu.h: In function 'debug_rcu_head_callback':
/kernel/rcu/rcu.h:218:17: error: implicit declaration of function
'kmem_dump_obj'; did you mean 'mem_dump_obj'?
[-Werror=implicit-function-declaration]
  218 |                 kmem_dump_obj(rhp);
      |                 ^~~~~~~~~~~~~
      |                 mem_dump_obj
cc1: some warnings being treated as errors

Build log links,
------
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2lFQ5BrEWOun7OOelPa1RMAsXo2/

 metadata:
----
  git describe: v6.1.106-322-gb9218327d235
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: b9218327d235d21e2e82c8dc6a8ef4a389c9c6a6
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2lFQ5BrEWOun7OOelPa1RMAsXo2/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2lFQ5BrEWOun7OOelPa1RMAsXo2/
  toolchain: clang-18 and gcc-13
  config: tinyconfig


steps to reproduce:
------
# tuxmake --runtime podman --target-arch arm --toolchain gcc-13
--kconfig tinyconfig

--
Linaro LKFT
https://lkft.linaro.org
