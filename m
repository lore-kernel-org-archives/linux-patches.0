Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7ED1171D
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 16:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722012121; cv=none; b=Fn+FLMyyUVf4sgNXsa6nQRgbPvy6sCw89pj0NUft06vN9UqPLxFhDHICdNydvo1TVasDb7bSAmxRoLLnYhEKfKx1WWuN7guzyUo3rXonekYQxEAm3uEEc3JyTW/HWGBAhtG3wrykGfOOEXhOQcJjMourYbNyIdFZhCmIYJM31BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722012121; c=relaxed/simple;
	bh=dSJkqABeuzbK/5xhttwGDS9K+8whwGr7ZPANeTmVWec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f9hqHeZyqMs6sOEWHpBkUn6Hw8BFJyoEuFePU5dNBomokac2B0ruYoKmhjC1YXXjaSd65u64Ymp0qpgxW1gyAbAyk+VT/mYgMsXp8oEXrKBlOZQS5x3w98CouBxP0d7c7LdGh0y4kE0UM8DZBcC3lPfedJXzzwIQqagVl1/4/iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PlB5TkPD; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PlB5TkPD"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-81f7faff04dso10318139f.1
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 09:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1722012117; x=1722616917; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fwYlsIb0TBL8ApmZ4UOjkmkHKXDKkw/fhwLj7jK215M=;
        b=PlB5TkPDItUk7wDrhJ6ItqzyOoF09MhtlEvKoIK4JoG/pLFXXdgxBtX2fHTWEq7m9d
         82/zuSSFUHc5V1E4pL6GWZpMkJoLjuFcQW11wr4ww4x6NR2tXBTsrdycbEhPBHERJzSr
         DmxB7hxFFlANcHXhmAzD4vQCZDaCytHRI4lPw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722012117; x=1722616917;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fwYlsIb0TBL8ApmZ4UOjkmkHKXDKkw/fhwLj7jK215M=;
        b=dKuTM5Fvp3x2XvR3+BaE2g+ftdEgmtnz1cxXKrvteUiSLdhMDiIBh/7gWmJwRm40XP
         w217CbbwGtk/Z4gyrYRu7um7rJ0+sm6awEQYwTDiS/mBsrLDLvqa/BhRsQpAZj6BUSsJ
         ZIcoHbq6NtlwPLxEo3lbSE+iYWHWESh7Yhcb+/1zldk0EAglN1ofonHUCYPoa6H4Sq8H
         vADBAGMrUFhyKUaR050J84xfBCwR/CajJdtX8wIlAmrp6aFo28Qs/UNd7YAnGt+P1m/Y
         IcuSeVXz058DbjdUS7K+XU3IlmxXFnRTn7MvhL0Hobc52Z8wjc35dAFQm8QfiGwp1Z5Q
         QtJA==
X-Gm-Message-State: AOJu0YyPJMNOufMWQU0e976FxO9lHegY3SwymivQ7ev7SXarKSKRb+3E
	4gXN2CAGZ7LTH5n67YfUXkWifZzflr0Vf4EBYGm+Bfa8Qy8SeRk8fmtvDOWHXK8=
X-Google-Smtp-Source: AGHT+IH2RQ7+hRvoU0ab3eLlqs915W7aXZ6Z3kSZzsOoboQc2T5VslhirJMEX8/vy6pHmiY/Qs2rtw==
X-Received: by 2002:a05:6e02:1feb:b0:38e:cdf9:8878 with SMTP id e9e14a558f8ab-39a22d0f3e4mr43022985ab.5.1722012117634;
        Fri, 26 Jul 2024 09:41:57 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39a23107376sm15321465ab.87.2024.07.26.09.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 09:41:57 -0700 (PDT)
Message-ID: <e30b5166-a6f9-4670-9875-286cb2229c60@linuxfoundation.org>
Date: Fri, 26 Jul 2024 10:41:56 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/33] 4.19.319-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/24 08:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.319 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.319-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
