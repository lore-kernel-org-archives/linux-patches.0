Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A4B12C528
	for <patches@lists.linux.dev>; Thu, 13 Jun 2024 14:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718290471; cv=none; b=bqBaFAYYIQX89fr1wo4KZoWqqLRELEQKtcXmijBtnnoy6c2a59Ok1zptZm5dLtaFNPKtSXA9apfgdEegvVu5MJgm8K3xw+1J2ftNttBPK3i9wa4lJYcFRSjMDh9/WEnzEs53NDSfNihv8YJK1qIpA+6O8QCHZ285Tix7wmoc+r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718290471; c=relaxed/simple;
	bh=+HZBDinZDCMT7Ez14OypUVVwLMkZvNTY8vfAf9qVU3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HzXHtA1MT9Xhxwj//pyPIVSpkfmKA4YTvpdTCSy13woalGw0x2sgNEM6ih2QYVvNBiSTKrCOncXcB90z4jD/l33CFH21i3JxOj9wxr/o8OLemWdLk73uwH6WS7WL9naISVeShrRTWhrcj8oU6Wm4v/jbOnlqPKbWlLuC+J/X+TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p7I8zU3x; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p7I8zU3x"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-4e1c721c040so384006e0c.3
        for <patches@lists.linux.dev>; Thu, 13 Jun 2024 07:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718290469; x=1718895269; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z7g5SALnsdPJQWBZt0kVgnA0bB4kjPLGUDBHBwv4noI=;
        b=p7I8zU3xtMXy64fn7q6AU1b+1BsA1zpAgliZLWAMve9S2Y3bojzjodEXrJQY/tGvt0
         C3Frc/LRadLZEmRIQiLnwuGsPVVwafZud2QSdHGuv7QJacX8iKCTZQQeUZ113rrgTE2P
         yqy9tgIzulxYVDkSm85ONfNAxUNEuk6k+hDb+GeJjtMe+PdCUS6Rm0X8BQREChhWVbPB
         gO1O0lZ8oxSmD4JhdkGMepvqvnbnsMZ3pHOXf4j5fMwbamXOtOcH+Q22uo++3BF32S4q
         W99cp6mvSDnQIkU+1Sgj6CDBrIeOsWFbA5nsGuI02/pxwG1uk3srU7I/XextPC2cWMvu
         YXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718290469; x=1718895269;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z7g5SALnsdPJQWBZt0kVgnA0bB4kjPLGUDBHBwv4noI=;
        b=WyN6oKvej0OFxykp5nPr4dwDlv0mIWkM1qPRMsoaupCtbiuCD/ZTmIpBTED5YVuE7s
         v9DSNdRBY0NLlJ26MqPAHHpTuEjIi+I9rXSg1WJF0HEKwqaaJHz2w5KvmIr9HO3rr9UN
         f9tLAfhYhbGQRL9mTa0hMJZDEb409WyVm0TxffqR//8AZtYgVIllufH2rtDgJbdHHyN1
         5EgqMbUvflJqQ0XLbOdtjAetYnKuQ1HZTwzI8loJxnhG4bzoNdxfurZQIxboPCKfUE60
         YQ8Nb3o+d1K0RHL/PJFi/FHQD90IaRQjeJGW+CuDbvSmhBCHWfaHUK73wD/3rRe27CrL
         fDsw==
X-Forwarded-Encrypted: i=1; AJvYcCUeW/DEs4W+78AXWSi6+TheI2AipwJukc/6XedRef6p425IDkLGlwaltfqkALkhUBn2KtKgURZ9tt/i+r7YrAfGHuLBiHWjFA==
X-Gm-Message-State: AOJu0YyjjZsVeik12CpYrk/Ac+5zx5w08Bfarr1V/4MdIwBlsI484RCs
	wRumCMea/0vlJBEgdq74cfl0N0pIqLYWPimv69sCJDkiiroZNG5/YQPIb3xpW6N9UFm3sSPwJ0f
	I2O5BT4KreQ1t/Qc9O+vYuJaUIlHeMXTVtYiisA==
X-Google-Smtp-Source: AGHT+IEFJBIeVpnD+lw3dEtVlaKMEXn/UPaJkQ+jBNt3IL0NdXWuc6/aVyLKENNOoHl9TZ+IQBZ2xK7qOnH1FQoGYNM=
X-Received: by 2002:a05:6122:20a1:b0:4ec:f27b:ee9c with SMTP id
 71dfb90a1353d-4ee3f1628c5mr73958e0c.5.1718290467801; Thu, 13 Jun 2024
 07:54:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240613113247.525431100@linuxfoundation.org>
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 13 Jun 2024 20:24:16 +0530
Message-ID: <CA+G9fYvS7u7seBUY36kGdJQJ4LS==ex=zzvBztYUE_X9AT5nYg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/317] 5.10.219-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Jun 2024 at 17:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.219 release.
> There are 317 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.219-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The powerpc builds failed on stable-rc 5.10 branch with gcc-12 and clang.

Powerpc:
 - maple_defconfig
 - ppc6xx_defconfig
 - tinyconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
---------
from /builds/linux/arch/powerpc/kernel/asm-offsets.c:14:
arch/powerpc/include/asm/uaccess.h: In function 'raw_copy_from_user':
arch/powerpc/include/asm/uaccess.h:472:25: error: implicit declaration
of function '__get_user_size'; did you mean '__get_user_bad'?
[-Werror=implicit-function-declaration]
  472 |                         __get_user_size(*(u8 *)to, from, 1, ret);
      |                         ^~~~~~~~~~~~~~~
      |                         __get_user_bad
cc1: some warnings being treated as errors

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.218-318-g853b71b570fb/testrun/24321785/suite/build/test/gcc-12-maple_defconfig/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.218-318-g853b71b570fb/testrun/24321785/suite/build/test/gcc-12-maple_defconfig/history/

--
Linaro LKFT
https://lkft.linaro.org
