Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E62014B09E
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 21:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723759175; cv=none; b=N/YsC8h9Hq35D+QaWQWUog4HXd3S12JZ9WhVU//K3LT9u5YvaJI6qTdjFBVHirMuBDwpS7/uo6hFcyrw118BC7eyBQztUE8q2JaUHaS7ZteuXh1BSLpzCEE7MuP5lFrmOOfcFmtDqx3qJLrQCqn5Xsx6pxy42ohkQ51SGuy1cFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723759175; c=relaxed/simple;
	bh=rK/esUI2zvQLYhcVj5TnR2iUyYOWNFYJgeHXx4x5oKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J+k4+E6TrHmzupBSmeeBIFf4LCO20oP81ioFi8vbNzdPsPiowCAeMtDqYsJzGFjHV1rzaeE0NGOYGLhGSV7BAr0oiysqneQaTOPMLUsApI7VGPU7E9IwpYXxQaPNGaXUstnOOG/xkkFdMFHu/HziFjWVfJJvFFIVB7f8EycXFCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JoF45xJD; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JoF45xJD"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-201cd78c6a3so11038525ad.1
        for <patches@lists.linux.dev>; Thu, 15 Aug 2024 14:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723759174; x=1724363974; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KyCVy6/conWBhY9JGn6L9AtFibyi83h6CoL5Kafq9P4=;
        b=JoF45xJDZQWAijM5uh+JJIHYozmMrIyFcpVlYXh6Or4l3JfY1joTuzd4W0AzurILAQ
         vbHZyYRvLO/dy6Ja42LhhU87RfDkhbgldxKGQsF2NLFs18yMyUy6yXePGdPubX+mjwt+
         oKkRK7EPXx2xvVGNjbV2/Xc+mhU2PVwyxWKJlMM2OQN0e5Vj5NgOd+0jc2GKyO5albtn
         WWsXjggriDJLhw1puX7bYbGeIoCDS761QNGOPP0pgnd5TSzLYV5YDy3gd7jaxHI/VVf2
         dVK3Zd6L5HGarmOoMpzawpMPITQsNSwieiD6++HuOZfSHP6jStYZPGDEpAYJSWaAZDgl
         rPtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723759174; x=1724363974;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KyCVy6/conWBhY9JGn6L9AtFibyi83h6CoL5Kafq9P4=;
        b=EHWQQjSnkeWl7I2qHkknDy9cfWNT8lW5dKJtemHuvm0HI25TLGxg1PlUGcJ2P/bOY+
         cv4j+FcX+awZcqiLQqbf5auzO7FcLhnBh9lQsKf2UcvwJWsgarcC+vzDRzlmBL1XxcxR
         IecTUqZjWui+93oGU52gUeqhNEFmaWAgEYQCu0ZHFmEkpWyAZp7OD9/hKH67ClHtYtpD
         hL9HEC5lDoqjxKT26jj6Mb8cPu/oltLr6905VLGwEfSLuqHumHPlic80nv6b2LcpHiRf
         mVe0Fk0hruLkCKY+J1+FyfwC4sPHhplTV8rFd3ByUXfzk0bZLabZOxKpwckyIrKCa/JX
         YKHg==
X-Gm-Message-State: AOJu0YxS9HJvthiFKiuHUpBLXbzKwli9FJyDFStd9y5QPCq2EhqABsHJ
	aAUzhGBRgtvQXL8aKVtmCpf8JlAbB1H1ve0wfmobbFPbV6xK0Ct3t63YCg==
X-Google-Smtp-Source: AGHT+IGKULXVi6fLxnWIIPP4BFu9bhcEGVkP+X0nnciCIiVVwfSOC9wUt3In96jhiXM6H6Png4gLyg==
X-Received: by 2002:a17:903:32c8:b0:1fb:9627:b348 with SMTP id d9443c01a7336-20203f53eb2mr13430475ad.58.1723759173559;
        Thu, 15 Aug 2024 14:59:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-201f031bd99sm14549465ad.79.2024.08.15.14.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 14:59:33 -0700 (PDT)
Message-ID: <840e5ad2-5baf-4c74-b3b1-f18affa4b39e@gmail.com>
Date: Thu, 15 Aug 2024 14:59:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/67] 6.6.47-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240815131838.311442229@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/24 06:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.47 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.47-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

