Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F6036135
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 01:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706578284; cv=none; b=UaN+vpjF6Is2TkgYysyQfdFFaGwB82v+tF4glI9BL3mQEy/izpcq8X0UItffbSMdQd/YB3Y7vWB3Ltenls1qVv1GVHXr30aH188tbfG1G0mBF7UVFMY30h/eiMncgEAXuIQ9ARuYqFjKtZSeyERRNM6mfa9qF8dO6EIBhP/4GZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706578284; c=relaxed/simple;
	bh=l0t9jFgPIDb+BxojStFw/B4mQF8sX83DTK7Dq/RDMiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PyJKjnATJet0HsK6BGzrahs4QhFeLuVCL6ngDWMw9urGHkBRkAllShWhBucLhFgirCciz/8yAkHpGq8uCjCVBF8RpA3lMiMLBW9QkrQ7zcIXxToDuNxnKhV7IzKuPS1Ee1713MEJJXrloJVAOZ71mL90eVJ7Tuz2tIuUDlbK6XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OdHMqN+J; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OdHMqN+J"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-21460195d11so2277285fac.2
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 17:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706578281; x=1707183081; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yKPTGpRJe4iviA3naEAAGwI9bB27NhTfAciTApm6FaU=;
        b=OdHMqN+JphXPUUaNmtSVslYpo35VMP9UErs/62ZIRm5Hu3BiOl3YTN2CMsY2ZnvzUk
         3JMuQr44JuymttxdGwRvULyqNNYevmeLGz8l+bSKAbSgxGJsTlbevHgYPAm6VaWJXuF7
         gh94dfKSubnGm26s7F7jYjFbQkfC06VVq2hhkdfh4W/U6RsE2lPuaWxrCFdP1ZpNnK7V
         zr++qKplwly/SmLszdSp8fwPsvUVjGRrTz/952q2ZZNu0ZLnuV3ggoQKXmfh3dtliyiU
         gFjgzwrs0JI/hNBK0E/y/jAOWJm6PVkxciWze5ebNYqPlLaZ8o0THoAz3IBtDDBh6nsJ
         +Y1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706578281; x=1707183081;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yKPTGpRJe4iviA3naEAAGwI9bB27NhTfAciTApm6FaU=;
        b=csk9/T9pOZxqzHQVpblbiFxEAjWeDCnjZsSg1U4XEH0UuckmVY8/1BHbkrmkZFtXgv
         8NyOgtOFzmvNLXdGBJFSmqNn8a+m3qbBAFbJx+a/i6nGSt03GhkHE6Sw9PDfeItZEIG8
         y8kbvLFWfSQ0RYbvz2WvoDvSI8Qv0JMScqmGUG88IpqKb5L0WvPd/d5MBnOSPi95wKSN
         JC+PvgV2B86e0ZKsH8XqVdoonUkY1dHAUWXrwgrruPAATK+8eWORbkyswsfGSgUfm/0T
         Osh7PsdMxnVyn4n9O7VQq3/STs2MJAu9MOQE381CttlR1ZPXUf4FiYTjAPkVQ43YLlnm
         sO9g==
X-Gm-Message-State: AOJu0Yz6++E1YxsgMPnAV5RN3+1d08Gh6Wgu0HirmCV7kA8mKqhwf3Fn
	nsZW8Svw6kjJk80s5MuLBYLhpvCsIJlqETs8Ip+IVWaTmfc+9noHR+LudIh5Rmk=
X-Google-Smtp-Source: AGHT+IHiRF8RsmyJ9JXE/PR5570OucKCZWuOzmou1M+BxzDtaClKxilJ/q3KJ54CKVlIg/NScbdClw==
X-Received: by 2002:a05:6870:e0c9:b0:214:8499:1233 with SMTP id a9-20020a056870e0c900b0021484991233mr7224701oab.22.1706578280724;
        Mon, 29 Jan 2024 17:31:20 -0800 (PST)
Received: from [192.168.17.16] ([148.222.132.181])
        by smtp.gmail.com with ESMTPSA id lt7-20020a05687142c700b00214ca092655sm2295401oab.46.2024.01.29.17.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 17:31:20 -0800 (PST)
Message-ID: <4a2b55da-ee57-4fca-bb7b-240792b25460@linaro.org>
Date: Mon, 29 Jan 2024 19:31:17 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/185] 6.1.76-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240129165958.589924174@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 29/01/24 11:03 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.76 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Jan 2024 16:59:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.76-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We see build regressions on Arm64, as reported by Naresh earlier, and System/390:

-----8<-----
   /builds/linux/drivers/net/ethernet/mellanox/mlx5/core/en/params.c: In function 'mlx5e_build_sq_param':
   /builds/linux/drivers/net/ethernet/mellanox/mlx5/core/en/params.c:994:53: error: 'MLX5_IPSEC_CAP_CRYPTO' undeclared (first use in this function)
     994 |                     (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_CRYPTO);
         |                                                     ^~~~~~~~~~~~~~~~~~~~~
   /builds/linux/drivers/net/ethernet/mellanox/mlx5/core/en/params.c:994:53: note: each undeclared identifier is reported only once for each function it appears in
   make[7]: *** [/builds/linux/scripts/Makefile.build:250: drivers/net/ethernet/mellanox/mlx5/core/en/params.o] Error 1
----->8-----

Bisection points to:

   commit 1288b23c9c528796ab656d2796705f52c5ffad8a
   Author: Leon Romanovsky <leonro@nvidia.com>
   Date:   Tue Dec 12 13:52:55 2023 +0200

       net/mlx5e: Allow software parsing when IPsec crypto is enabled
       
       [ Upstream commit 20f5468a7988dedd94a57ba8acd65ebda6a59723 ]


Reverting that commit made the build pass again.

Reproducers:

   tuxmake --runtime podman --target-arch arm64 --toolchain gcc-13 --kconfig defconfig
   tuxmake --runtime podman --target-arch s390  --toolchain gcc-13 --kconfig defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

