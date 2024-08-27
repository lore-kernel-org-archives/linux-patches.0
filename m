Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525901A072B
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 15:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724773188; cv=none; b=jGEiSPtAj92IPdbQ2b1AuOmqSdksT3WSAOLjI6eKhS0CRDiM6+mVoThksrnD9FZ6fa7D3nTxj2iqSjgKrA+qpRuESNOUFXnV84nSl9g990IPsaPSoniUDQE7m9sUVXHwNDc0eXVvCFQYuc/LhWANrGc9f4cGKLx9HCCD5R8Lrsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724773188; c=relaxed/simple;
	bh=J8i0Lb2oWbc6JBapK1BY0lUoCq02D7GVagTSdbkqv1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hV4VQaq/PRgGKDGTTdjD0MXfAqSQCisPwQzz+o5HTJnuQGqaHYyvrLN24ycIi7DuaiBbwYAoHgypXB3pRQ48AqAzhgJLvyq+GLxLVBEUcUntOlKsSuI3LxTttSNmvE/DQ4ju2vKA+5y7uhTIpgHYg0s1u2u706Im2F7nsyhSL3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BnFP957B; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BnFP957B"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3db1657c0fdso513454b6e.1
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 08:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724773185; x=1725377985; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ABrGPaQeXTHEpHj1nG5eL4qDwA/TNxf5sECkQr9qYBQ=;
        b=BnFP957BgvdstjsdBD2v7FsH9b+Jx2ZEgFeatfe1vggbtPw4VT30qFMt4fMpGuFFLK
         M9WaiHm/My0kNsT/2Ce9jRJjvsHd6kdB1j8rk5KGihc7L0Axy91JEC8BqQIrNEh7GS85
         EhWtxR1KipWvUL9BEeKiGXkcOaa/XKwTXbyKuhYu0eY6EgkaQ2aNP+FFiG+6Pfx7lFUL
         db7uDcKlgKGHSnZXOMsvj3L4B6NZKGiYQiPL/0QYhKYolYWCatqm051JFxwt3zgnvLiS
         Ad+vv+vRrb8kBFQAl0ED03G7tGSGtAKWsyMCbU7hOAKFnenc5wOMcU2LsOJDrMaw2hGu
         XwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724773185; x=1725377985;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ABrGPaQeXTHEpHj1nG5eL4qDwA/TNxf5sECkQr9qYBQ=;
        b=mz5dOJf/1Rw4A0HefA8DOdW/MI9cu4Mm6+nSa6kR+FPDk5fwxnnUCMq361nyc2UpXf
         sUVd3DTeMBoL6MEuHAtRk+XA4y9ybNs1Byu57hyuy/UNnHNZdF2e+sQZ0rDzITkHc14r
         3bzdbfoI/ajzCQqfIgEI7OtSXHOBVpmqgMMnym6reg0pPCqlNE2OBJSIxHyFyi+6SfhU
         //yQ7dovsHPgZr7K12HuYX/q+sa8Y9ff79294Gao+UHcwUDz96hNMyqE0x2/jTDhtEMy
         hplVPJ02KzvF5TjZ0Pzny4croU68nVgmShAvMTHGiFpd8GOIiZoRBJKiOduT8uCC2him
         d/Dw==
X-Forwarded-Encrypted: i=1; AJvYcCW4Em6TCZ/qtk9lrriQraDgDtcpdc/5iYTZ9f97aX3Na+QxRmG1yVyojzkjOqQqXiAmHCKT/G+g@lists.linux.dev
X-Gm-Message-State: AOJu0YxwqqbJByjh29EX0TGybrOkUnArZIxXiImIYslK+NI8S6kRiRk5
	Lq3auBhUKnrl4QNi6gGYkp+g46UFsulUSktIMLDXKs5uKM1xGLgYw1WXbSToaPnjA6rqo4waTaP
	wbJE89dwPlzC1Y4Sb3DScljU3MB0Y7tf5g1S9tA==
X-Google-Smtp-Source: AGHT+IE+kcBunpFXfOGpuNdas/X5FdTgaWsUmcSrsoP0VkiG4IG6IRfZg8+GgGc5TZDGinb+7wjme3MyFaQZ0qKWfPE=
X-Received: by 2002:a05:6358:430f:b0:1aa:c49e:587d with SMTP id
 e5c5f4694b2df-1b5c215d7efmr1740185555d.18.1724773185173; Tue, 27 Aug 2024
 08:39:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240827143843.399359062@linuxfoundation.org>
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 27 Aug 2024 21:09:33 +0530
Message-ID: <CA+G9fYuibSowhidTVByMzSRdqudz1Eg_aYBs9rVS3bYEBesiUA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
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

On Tue, 27 Aug 2024 at 20:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.48 release.
> There are 341 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.48-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The tinyconfig builds failed due to following build warnings / errors on the
stable-rc linux.6.6.y.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build error:
-------
kernel/rcu/update.c:49:
kernel/rcu/rcu.h: In function 'debug_rcu_head_callback':
/kernel/rcu/rcu.h:255:17: error: implicit declaration of function
'kmem_dump_obj'; did you mean 'mem_dump_obj'?
[-Werror=implicit-function-declaration]
  255 |                 kmem_dump_obj(rhp);
      |                 ^~~~~~~~~~~~~
      |                 mem_dump_obj
cc1: some warnings being treated as errors

Build log links,
------
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2lFMi7HOL2XF8hQWViw6CjE3NAF/

 metadata:
----
  git describe: v6.6.47-342-g0ec2cf1e20ad
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: 0ec2cf1e20adc2c8dcc5f58f3ebd40111c280944
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2lFMi7HOL2XF8hQWViw6CjE3NAF/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2lFMi7HOL2XF8hQWViw6CjE3NAF/
  toolchain: clang-18 and gcc-13
  config: tinyconfig


steps to reproduce:
------
# tuxmake --runtime podman --target-arch arm64 --toolchain gcc-13
--kconfig tinyconfig

--
Linaro LKFT
https://lkft.linaro.org
