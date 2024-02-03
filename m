Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150CF16415
	for <patches@lists.linux.dev>; Sat,  3 Feb 2024 06:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706941418; cv=none; b=q7oyJfNwU/a8sFPWXwkGNohDNPqLaakIDuXJ9+kQEKkO0KHI7hanaCbcCNVwQUHzUuVq/b170G+jiDZNaCGlJPXtochuezmT8qPo690MfmaKT1m4+Ln2Dc4bImY3dl9868Mufn0dym9Ipf38rw8KwGBvZW8rYeNdtOg8kJjjlZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706941418; c=relaxed/simple;
	bh=Jn3PoFXKEd5njDWhISFAGN3lFjLWLAEnXNMTpfnhA10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VQJy6+lMnwi1uEZDXE/d3TCzkTf5wMYtFnadiaGbDZzYNJcpcmVXRmlIGVYmDP98yeJnL6UVkv3E3OZ2V6bou9/q6/sqhJbPo7I0RUkXIATQLgFkTm1q1nd6W6nQuEwrCqCvYPn9hBnwuh6png/yF+itd/FWOU5Sms/GiFOR2+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e/n+n75Q; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e/n+n75Q"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6e14b858785so1661838a34.0
        for <patches@lists.linux.dev>; Fri, 02 Feb 2024 22:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706941416; x=1707546216; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wx/FHR/ZkCwr2WNzTYSorDZnzq3qTx8t/b03FExQ0Ys=;
        b=e/n+n75QtOPf043MgVY02HqNGU8rlpjh/rI+MWCykigr1yDrp7iUNbk+ujTx6AnEEb
         44BjD/YjEUFdO7Zw9U0lm2H2tJi+5Mw9oqez6ZxF4HYJZdJtFAms4ukPTEiA8Pgj6tqH
         EQ7srJ7BtFJAIOzyCwy9x+ePo3H+Q5zzDmT7cDvsWo6G6nu+JWLjrXchIm7GokAfIlY2
         9hKHuJBtl79KOR3AqTOBlnEkbQdLLRdoiizc9hXVFJOQrnK2/y0f5yU7ELhovj59LGZo
         R763vMVQoFnApN4JHVUvWwwpT7K6Qsl4/iMz6haKb5fzWmNe8IOqK9XZPSLVmk04xzEw
         ZSnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706941416; x=1707546216;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wx/FHR/ZkCwr2WNzTYSorDZnzq3qTx8t/b03FExQ0Ys=;
        b=MtWReuci4wIFtBsa3br4qYLAGA8vTh97FrrkAr3qnstLlpYwOl2z7+Xy/1BQRTX5RF
         GU71+u0OS4xU7zE7VcI6kLdQdpL8hEHp86AWiO9k2B91cytmChZMpRxWWY/4pZhoz/cZ
         2dqx527yoGsOdFrQlrF9dB+vhJULCTeg6OXeZUsxNp2Ckq/+cI7qbsTM20Q5f9v/b+he
         0nHb66n0KceoI1HrQg1UuHwCNOR6e6O+PdpP5nJAkmxZ/xvgLcT6CY43uro6BytFhtHn
         xGkx/HawuVQYT6o7uczZ3YmiXlnDqAlVihF54Y6iAV6KQY1FQOorSqh0IeaMgVchsLIE
         oNoA==
X-Gm-Message-State: AOJu0YwkexYRnJ/oPVBn4+fwUnPxa499/ZQA7Fftkh7mgOzV9CM/OMfM
	gj4dFTZe3wJfr2sRHQd32lcXOA3j2WMQMTWOorGKKw8o07Q+AX9i5KWp1mNEB5U=
X-Google-Smtp-Source: AGHT+IGLJilOGe9v4pmuX80A+qKaROuFu7kzLvZdDC1GQJRyjaU5vat3w3/xfQ28LrId5/hQeqQ88A==
X-Received: by 2002:a05:6830:1d62:b0:6e1:ff3:d369 with SMTP id l2-20020a0568301d6200b006e10ff3d369mr7957113oti.25.1706941416142;
        Fri, 02 Feb 2024 22:23:36 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUk9PvWOAPudwGGHN9T1ZSTyXKq50ExkdujlKU2whjYCSJ9N7/BRayi1o+WenYiMMmzyPb6NN+JGLdT2yu1SimMNfg0cgM1k3VYlqxYO2nmW7xUz7jfwgQnLDpEgzsdIZxc40ieXGYkOzRQh5RgXJx7Wl3qsk8tv6ck9oADWpSTvRtbfN8TAtSX+bolhHUa822u1CuPIRKOUaEJ9ssjaHGDnrX8Sa3n7KPmq9CK5XBT2AQDX5SIwhB7RFsl0h8T1aUEdwfifjaS+LZkUaJATgwrMiTfL0wAEKOvcqbYV1QPltwxrakfWjwjxr7DR1Dgq6mvLUQYNFOm6dTegICAhIn0I6c5EUwxnZIuvPdCOnWNln0ar/DYNY0nJ287Teebai/uZ6Mk4cXmJwU1MfpBf4EENSB/QEWWjVbWkaodhph/bpS0q6j6cLi0UCnPgW2k3bc8nsIJPadvoqhfSe24H9Jq3tumEN/rShtwnVCZnrr+GMVx6xAsKR/Qf0kKPMWw3aCoPiVvXt0uWpqjht/Z1HaAbJgG9+FcFsiBPdydPvwGhlBiB+z7AJIAkw7eqw4aaOnfXwjEL812SqZSHhk=
Received: from [192.168.17.16] ([138.84.62.70])
        by smtp.gmail.com with ESMTPSA id bn11-20020a0568300c8b00b006e1363a01adsm691471otb.57.2024.02.02.22.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Feb 2024 22:23:35 -0800 (PST)
Message-ID: <13ddf68c-df25-4f5a-8044-33543a726889@linaro.org>
Date: Sat, 3 Feb 2024 00:23:33 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/219] 6.1.77-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 mathias.nyman@linux.intel.com
References: <20240203035317.354186483@linuxfoundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 02/02/24 10:02 p. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.77 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 05 Feb 2024 03:51:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.77-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We're seeing lots of build problems and warnings with Clang 17 and Clang nightly:

-----8<-----
   /builds/linux/drivers/usb/host/xhci.c:1684:37: error: variable 'slot_id' is uninitialized when used here [-Werror,-Wuninitialized]
    1684 |                         ret = xhci_check_maxpacket(xhci, slot_id,
         |                                                          ^~~~~~~
   /builds/linux/drivers/usb/host/xhci.c:1652:22: note: initialize the variable 'slot_id' to silence this warning
    1652 |         unsigned int slot_id, ep_index;
         |                             ^
         |                              = 0
   1 error generated.
   make[5]: *** [/builds/linux/scripts/Makefile.build:250: drivers/usb/host/xhci.o] Error 1
----->8-----

Bisection points to:

   commit 37ef029fe9a5639f12250f75f5d1594c6a11e181
   Author: Mathias Nyman <mathias.nyman@linux.intel.com>
   Date:   Fri Dec 1 17:06:47 2023 +0200

       xhci: fix possible null pointer deref during xhci urb enqueue
       
       [ Upstream commit e2e2aacf042f52854c92775b7800ba668e0bdfe4 ]

Reverting the patch makes the build pass.

The problem manifests as build error in i386 and x86_64, and as new warnings on Arm, Arm64, and RISC-V.

Some reproducers:

   tuxmake --runtime podman --target-arch arm --toolchain clang-17 --kconfig omap2plus_defconfig LLVM=1 LLVM_IAS=1
   tuxmake --runtime podman --target-arch x86_64 --toolchain clang-17 --kconfig x86_64_defconfig LLVM=1 LLVM_IAS=1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

