Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE63482DB
	for <patches@lists.linux.dev>; Sat,  3 Feb 2024 07:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706943766; cv=none; b=CQqi1gdCZUtFzV+QkaXdNV9+PkD0cuR/jegvNHeS2NKGh4e57j59BXHhSePjVu9d/ypjH3lxFFz3CMEirihAkUO+doA+eYLD+e5U2l6BHS0oFNKJ+UE0vIX8pYAr8fgcGze9HWL7s+/R77APfMOm3j9mDF7bCiJEH8nM5hZe9ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706943766; c=relaxed/simple;
	bh=h2fM7rc/F7wbTwf42YgOD0rHOq6xAjpwpoQykbHjlkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sffhAuvZTwc0kHpmm7Pzfajki5+bxcFWUKt/eie1nARDhW8XNr6oZ9vatS2MmCr3W6yvO6/d5cIqDwwT1FmSxBGFm1p3UTyHVGOyjIUD0zgb8stjVx3oOEM/gadNOMMcyhEeAMdH0h31yxz4h+V5QuAcy9JkkBLreDngjX4lloo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VAOrCoHb; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VAOrCoHb"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6e1149c16d4so1136778a34.3
        for <patches@lists.linux.dev>; Fri, 02 Feb 2024 23:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706943764; x=1707548564; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vlWjANUaYQwVUMpCKRrrDgA9uFKERft9XbPhIdDG8Y8=;
        b=VAOrCoHb4h/8g4w8Z1oFcOwMI4Uc3OjXMtEK6ACI4hBMtms6KATQlVooGQLvkhR5G5
         G8HP+Hnr68TMCnQiC15Sz0r9OY2gXh8rfwjgLMxtKmnpcmM159lRT3tiUfYB2GxJQ7Cu
         9iGJjOt9yKnm62m0mie9FdIDfyLZ0tCzdqPn177ng+5LjrXmKlIGiW8wBkTzP3FqmK8+
         WryTD5wwQpfAl5EBLi48NXUezeuFpHs3SQ/bRaM3RdqdksAnUsa90RuxbOjTUqT6CVPK
         xX1/XsUAY/EmF9fpGosDOVgqKhrVMGhekqjMnnlCsTB9tOLiuyYkT1cI5Sky9KKOwbGi
         kSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706943764; x=1707548564;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vlWjANUaYQwVUMpCKRrrDgA9uFKERft9XbPhIdDG8Y8=;
        b=Lpjd7jZHJAm3PoM/W0RaQ0CIuClX+b7IWqLw9OyqarUhRTP+9O1feAah6NPHQX5QeG
         6LvKpG1Od72dZjnNia0ppTTvJFb7qcmQHpk6dKoaF6UOle9DgtcNFRYqgzWU48B6T+5e
         lzcNgxuWoc60xZcx87pzEGSjh7gPnmWInu7Dik9AlE+fH8TAzyHk86pmhrjDMOi16bmy
         w5d6Pryq2f6BqxTFapi0UWgg2LYEHRCj+xl9pF7T37KbpKtudm/q8hsEvwgF7hJx7gtN
         L2LKS0hi1fL+an7J3H+OiR6beLhlMyClAdoVe6w1PM5Ry5U4Er1yagz5QLJ0Ob6FQCc7
         A43A==
X-Gm-Message-State: AOJu0YxBxd3qCM93Kis/0Y+zFX4UAgZWIil/FgVvm1CsAN7s+liKS5Bn
	k0brvmD3f8WMq5n0jSaOv/O8PBMklZOmoIToPnajvYVAFqsvphYlGc96bxfe/5E=
X-Google-Smtp-Source: AGHT+IGyJKL564bbjeTHUNQlaF9o1FxnbrAUyU1yF9si0FjSbmxSOjKjVSe4z6FwYlpbhISyiRV+RA==
X-Received: by 2002:a05:6870:b6a3:b0:214:e186:4d3f with SMTP id cy35-20020a056870b6a300b00214e1864d3fmr1708185oab.26.1706943763992;
        Fri, 02 Feb 2024 23:02:43 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXF+v060q+BIe0PITMEbjGeKyNuAVzwVaq+Vests1GAO6QJOf3B92ackeIGvwlkzarqahed14QjRqY4lOET0flnpCOuT3phwGsJ1DSE/wZUVyV/JgRI9ro7H8aUj8Rhel8JPC0bGyB5BxwP3v9ROY6Et8Y1xh5TP59yodrEy+GD5fzArfJyqTsCjuYrly/IA2I80miuhbvTOsgMVrUK4gnm1QItdYZO672XopcGc+AGwYnm8PjMubDci6u7oe0A+zaz+6gDF4Xus8nqd32rLZShsUkYg4v+PDwC18fSV2uX0aHiIAGRbIsqgyF5bqbf2MBDkUV8JSyDDhxjywvJZBWAlykeCVQleQ1a/lUOKM+zvuFY1e6nno7oThaDI6SNHSkmi53JRKp82LKYAPUm4J1vwsmwB1mcStjy98TEjKEo9NH6tNEhVm1B2EcTNgPoEUKZkKEQucjzMsR9bNePBSplb7un4f54L20XDE5Dn8lE/HxYtTPTQHsjlG7po98RxCgq9LWHSDu4DuK9uFRa2HO/Nlr7ZxGIp2mPTvfFdEHSK7QUwSXohmmhfZTNGxRTKtWN7oMA80Q8opOH
Received: from [192.168.17.16] ([138.84.62.70])
        by smtp.gmail.com with ESMTPSA id ba33-20020a056830462100b006e11c53b99esm700670otb.64.2024.02.02.23.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Feb 2024 23:02:43 -0800 (PST)
Message-ID: <5c1f616b-6244-4df9-967f-8063968dff3c@linaro.org>
Date: Sat, 3 Feb 2024 01:02:41 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/353] 6.7.4-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 dmitry.baryshkov@linaro.org
References: <20240203035403.657508530@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 02/02/24 10:01 p. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.4 release.
> There are 353 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 05 Feb 2024 03:51:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same problems as reported with 6.1, but something else happening on Arm (32-bits):

-----8<-----
   Error: /builds/linux/arch/arm/boot/dts/qcom/qcom-msm8960-cdp.dts:91.1-10 Label or path pmicintc not found
   FATAL ERROR: Syntax error parsing input tree
   make[4]: *** [/builds/linux/scripts/Makefile.lib:419: arch/arm/boot/dts/qcom/qcom-msm8960-cdp.dtb] Error 1
   make[4]: Target 'arch/arm/boot/dts/qcom/' not remade because of errors.
----->8-----

This is seen with Clang (17 and nightly) and GCC-8.

Bisection here points to:

   commit 4fed142bbe3ca920810eba12fe96800cfd094d0c
   Author: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
   Date:   Thu Sep 28 14:02:44 2023 +0300

       ARM: dts: qcom: msm8960: fix PMIC node labels
       
       [ Upstream commit a10a09f34eb80b83ca7275e23bf982dae2aa7632 ]

Reverting that commit makes that problem go away.

Reproducer:

   tuxmake --runtime podman --target-arch arm --toolchain gcc-8 --kconfig defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

