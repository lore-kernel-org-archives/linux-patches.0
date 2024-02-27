Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6444F213
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 18:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709060166; cv=none; b=rswI3V8lf3ogJQGwhA3/PGLlIdo1VoqvaUCAxkB5C9NMtiVski6KNvf1uTE/1vkMRaEcXr68AB6EPX/jZr0V/1pIPxy9yIjOeIC6azjQl3VEJOS+4C8+DXsepmCYGF2UurHRSJWA+Q+s8jvJFP3918BGR64IrO9HQO7apG6o+Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709060166; c=relaxed/simple;
	bh=xQWxb5jXsREbqkstiB99b2thxnNCWYBgYcHPwz2pFEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mMKhSTwNA4cyISnY5R7GSg6np6Nw5re/0ppYwq7TULEDqmBCvYWNYkWis4roc9YRIjHBQ0s41rldCNzqptOZLcukTrWFOVzNgBFCA3q4VzHaauSrmEXuAriyaRTSIbtCSX8zeV1z0bM58Camg5LRumgdVp+BJi21Tjb+fL7K0IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mmpBJhxA; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mmpBJhxA"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5a0932aa9ecso1182758eaf.3
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 10:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709060164; x=1709664964; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IDR3qYUWJRNDIU0vAo9kG+/b8kR9evkQt+74AVhMif8=;
        b=mmpBJhxA3uEchGt+enQFtpoPkJ+BxHW0x8qhULc2l4MRilrZjYdAMeu/MRgUfJNwvl
         eXRYDuA7jnou6unggEK324xwfcHQtJJFjCv0ZKXTehWF51r2QLoTDVBV2ca7Tkd75NVr
         RAJfjFXWCxHSclqniF2eXNSoyv5O06ptqT7s1HFHmlbNbH86CA/TZ2pJhIRpw+SlfL7Z
         wUAKdZouRWEPq008MAlkj1kaOvFRiO4hfI/vTTWrwbI8PeKcl159bsVaii84Fm0qIB92
         KMkU1IYidDSPNlIO9JtxDw6dkjgROHY3zd6PqF6WMVuNF/jmvPVQ7GqQKaCfpqKrBVso
         Kpyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709060164; x=1709664964;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IDR3qYUWJRNDIU0vAo9kG+/b8kR9evkQt+74AVhMif8=;
        b=wf2In0SnoZZPeF9jvLOG/t+ubxr07F3iU7voppiq4pTDGOuizsZ2gj+5rbESTxoCJ5
         aU5F0x+mYfqXnQDNXdHiiM68fOyADlJcLUhFJEJolaSpGBK7e0So0cZP7LffAjjbUH41
         BG7HGu8Mbm9Em7fYU8LoW/uOzHyJZbN2TzwK/ChsQCIOFezvdl+zpzO/j+/WcyYxNuxm
         yMOIDR4kdQvfG/0dO9/dwBDijF/F8hIDCxMfNnRGEcQmQLsSoYljQgfPgd+036oR24js
         Jtpezx4teJzdhslow1KGK045jBojKhUSXcm5P44yqb2vadGgsuqz89LP0r/u2985jJ+X
         GjsA==
X-Gm-Message-State: AOJu0YxwURGx9yEW1XnTDXf6LWY5vQzCdBoDMmJJyBv7WYxvBFWWqUIw
	YXSF9+HVhC58ziWwejJh570twR6FUUa+n82VI2GF02V6Sg+uEj/OKwtPxrSnK0I=
X-Google-Smtp-Source: AGHT+IGt4SgnRiGwNSpwucUlCj3R/hQl8nk0pTJFwKC1NEk0SmrmixVrN9SOyNmf64JyRRoByt0oMQ==
X-Received: by 2002:a4a:3c07:0:b0:5a0:c53d:3e33 with SMTP id d7-20020a4a3c07000000b005a0c53d3e33mr92457ooa.7.1709060164338;
        Tue, 27 Feb 2024 10:56:04 -0800 (PST)
Received: from [192.168.17.16] ([149.19.169.47])
        by smtp.gmail.com with ESMTPSA id o12-20020a4a384c000000b005a0af4efa0dsm377271oof.21.2024.02.27.10.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 10:56:03 -0800 (PST)
Message-ID: <0b1b1523-3f26-4ce3-bdeb-4df3c2a8e685@linaro.org>
Date: Tue, 27 Feb 2024 12:56:00 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/122] 5.10.211-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, kuniyu@amazon.com
References: <20240227131558.694096204@linuxfoundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 27/02/24 7:26 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.211 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.211-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We're seeing new warnings on 32-bits architectures: Arm, i386, PowerPC, RISC-V and System/390:

-----8<-----
   builds/linux/net/ipv4/arp.c: In function 'arp_req_get':
   /builds/linux/include/linux/minmax.h:20:35: warning: comparison of distinct pointer types lacks a cast
      20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
         |                                   ^~
   /builds/linux/include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
      26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
         |                  ^~~~~~~~~~~
   /builds/linux/include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
      36 |         __builtin_choose_expr(__safe_cmp(x, y), \
         |                               ^~~~~~~~~~
   /builds/linux/include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
      45 | #define min(x, y)       __careful_cmp(x, y, <)
         |                         ^~~~~~~~~~~~~
   /builds/linux/net/ipv4/arp.c:1108:32: note: in expansion of macro 'min'
    1108 |                                min(dev->addr_len, sizeof(r->arp_ha.sa_data_min)));
         |                                ^~~
----->8-----

Bisection points to:

   commit 5a2d57992eca13530ac79ae287243b3ff6b01128
   Author: Kuniyuki Iwashima <kuniyu@amazon.com>
   Date:   Thu Feb 15 15:05:16 2024 -0800

       arp: Prevent overflow in arp_req_get().
       
       commit a7d6027790acea24446ddd6632d394096c0f4667 upstream.

Tuxmake reproducers:

   tuxmake --runtime podman --target-arch arm     --toolchain gcc-12 --kconfig davinci_all_defconfig
   tuxmake --runtime podman --target-arch i386    --toolchain gcc-12 --kconfig defconfig
   tuxmake --runtime podman --target-arch powerpc --toolchain gcc-12 --kconfig maple_defconfig
   tuxmake --runtime podman --target-arch riscv   --toolchain gcc-12 --kconfig defconfig

Reverting the change made the build pass again without warnings.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

