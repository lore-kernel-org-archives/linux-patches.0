Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353A62022FE
	for <patches@lists.linux.dev>; Wed,  6 Nov 2024 14:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730904808; cv=none; b=Sf1zD5LH8MOX472CjI0TCRVsxYUbYJhTGZ7QZC5U6NBq6ueRE7yme4283PQbrIVhzl5afl9Pam8D9aDryFfgXAUrpBECnFpB45SbJuCXzjWVRjXYj2o89PPqc9mBfz6RumrJK+vsnCv9DbAKemnkiH4xnx1I6X65k5wl3gES38c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730904808; c=relaxed/simple;
	bh=Jsc2PoIQuQ4AsWmFF8Q6+FWTBnPxjtElzH9JCRFYzn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s7cG4EsHxC6CyAJ9dP5t3pZG5Tz4LlJFEYVJzudRtiUZuUPahyyZVndvbYHluRCJo41YlsuKx+Nq8L041ErTxXkw3gARK8WrtmoizQmzzA49fLJxGItm7F/pVEh5gyavRJqfCNfDDJfAbJ8gW2r4fDR/IaO9XPzB54RmbyLUGSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Rec1lwEd; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Rec1lwEd"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-513de426bf5so518697e0c.3
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 06:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730904806; x=1731509606; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MI7nbg4m00fCCSnSEy5rtRmHnkUgA3x+XzaBxsgKSKs=;
        b=Rec1lwEd/h8qje0N9JShglWoY0TnXvjcoemjS5K6AVEHPqJ8BlW7htjIoxJ7ZVe8+E
         +NP5xqzklo/n+hn/mwZ+j0/RqPkfuQUeODVkn1Z1oPNfbCGnFdARcdZNtVTvHfb3JcFR
         Ksx+dF25pCjd3ynV49PjH4BePlFbpa+oNYQ4xkaJVkQgo78RX6IAWEo0b+ac0BMaQuQ2
         XIBLLIzwZdTp7DRhnbeihyuGUMiZkmeEcMh/ERQVIV2XfA9qNqwsOuJPA643HzEmZiPy
         v5AhSL2fZtQdOWfCfnf389AOJ0U9ISBbUZQCzHDM1m2eEXeg5xC3lX3OKACoTOdDnKzs
         SUCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730904806; x=1731509606;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MI7nbg4m00fCCSnSEy5rtRmHnkUgA3x+XzaBxsgKSKs=;
        b=eX/snnKhJYmx7pfhjRW0EFQqut65RNSZK25KNdaFMnqiEv05xgiLdcErj0Nqz5oCX5
         sHHO8Ew7+cX00Jf3ZMRyieXIHfDY7jZT9pchh3CPjOxjz0wfcOabxzwBx3CZcsfNlRCj
         mP71RP0+ZZe+xLD4jArayndLFt5dY7l/pj5lbOV8x+rHsDXTrwNGwetGbgP4Fhs0inJU
         e4RjOK7uEvAuTdsWs5uUHm5wHNKCB5m85eHq0KsXJIHvvEaYEJAYiJT9hXKtv1sIJ0tw
         gaQ2ZfLqV+vHAiooFydWRJ57NGbfP1x2ME/ozVv2VtcZMxaBo9466KQgCisXebi4pdM4
         JjNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVO1emg4wL3urXkkwzDvjoHoZ7Vnmj8BoSF1+ecTl9a89O9FfcOFQ1bLz5nmbGAaHqX7CgeOjDB@lists.linux.dev
X-Gm-Message-State: AOJu0Yyy+5l7ViCAOkAjRFNtorOa9bqhT0+INInY7tJtuPv2ZZ8+Vpqx
	roGIiwSNqoGQRalVdvYLzUrOPaoX4g1jKd0yfgM0PvLMHksRVCuCyylla/mlAkW3x3wY2BzYfjC
	6Na3O8RuNYTh84FUU7NIqczluvwlnedsFPOqsdA==
X-Google-Smtp-Source: AGHT+IHs9hyVIriLMV9zWsnUhtPPevFZRCt/0mF2YKsK9ex6H5hpAbYzZ/R5/cPmYMGvyjEh4T44MeVLbN7lSIGnIXQ=
X-Received: by 2002:a05:6122:a18:b0:50d:3ec1:1531 with SMTP id
 71dfb90a1353d-510150e1e84mr38180373e0c.8.1730904806042; Wed, 06 Nov 2024
 06:53:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106120331.497003148@linuxfoundation.org>
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 6 Nov 2024 14:53:14 +0000
Message-ID: <CA+G9fYvqfxYX8r1rMcaiaq-K0xuVf4-pRrS77ovNMHNiA+FPkA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/462] 5.4.285-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, 
	broonie@kernel.org, Wang Jianzheng <wangjianzheng@vivo.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Yangtao Li <frank.li@vivo.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 6 Nov 2024 at 12:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.285 release.
> There are 462 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.285-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The arm builds failed with gcc-8, gcc-12 on the Linux stable-rc
linux-5.4.y and linux-4.19.y.

First seen on Linux stable-rc v5.4.284-463-g21641076146f
  Good: v5.4.283-122-g10d97a96b444
  Bad:  v5.4.284-463-g21641076146f

arm:
  build:
    * gcc-8-lkftconfig
    * gcc-12-lkftconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
---------
drivers/pinctrl/mvebu/pinctrl-dove.c: In function 'dove_pinctrl_probe':
drivers/pinctrl/mvebu/pinctrl-dove.c:787:16: error: implicit
declaration of function 'devm_platform_get_and_ioremap_resource'; did
you mean 'devm_platform_ioremap_resource'?
[-Werror=implicit-function-declaration]
  787 |         base = devm_platform_get_and_ioremap_resource(pdev, 0,
&mpp_res);
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                devm_platform_ioremap_resource
drivers/pinctrl/mvebu/pinctrl-dove.c:787:14: warning: assignment to
'void *' from 'int' makes pointer from integer without a cast
[-Wint-conversion]
  787 |         base = devm_platform_get_and_ioremap_resource(pdev, 0,
&mpp_res);
      |              ^
cc1: some warnings being treated as errors


Build image:
-----------
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTfYomC7gxQMBPlC8XecubDfEA/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTfYomC7gxQMBPlC8XecubDfEA/build-debug.log
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTfYomC7gxQMBPlC8XecubDfEA/config
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.284-463-g21641076146f/testrun/25690547/suite/build/test/gcc-12-lkftconfig/details/

Steps to reproduce:
------------
   - tuxmake --runtime podman --target-arch arm --toolchain gcc-12
--kconfig https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTfYomC7gxQMBPlC8XecubDfEA/config

metadata:
----
  git describe: v5.4.284-463-g21641076146f
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: 21641076146f6d3076b915009a45a9b8ac7b78fb
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTfYomC7gxQMBPlC8XecubDfEA/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTfYomC7gxQMBPlC8XecubDfEA/
  toolchain: gcc-12 and gcc-8
  config: lkftconfig
  arch: arm

--
Linaro LKFT
https://lkft.linaro.org
