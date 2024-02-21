Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7848F12BE92
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 23:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559917; cv=none; b=fk9/RIY5DP4YR1wflPXG5NjQOh2uNn+46DC5EJyOhz1g2906ORw8DG17VF3gg5135hbdlpunUjT0hZ4UIJK2ZIXebs8uNim3yIK87Ynqk0nUiHLJ1+QHqj/CsoBvSamsW53wYVbsZlLEv8sqw1+8O5EqGyV/3dJ8AJQdenKLVps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559917; c=relaxed/simple;
	bh=NjHEsS63nxugBfuzRK3toKI+rQRHzacrMXIMYoWFJ2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U2zPM1yy92sX//bNiQtIMFRAkXTc+WKOO2PgR8eo3VfZJAEQeq+U0dbBNkYq1aSkfuzW2HKZnh8EcT6k2xIly9kDJfBcXv/ldKz89Hil4i9ZoBNBg8yH+CRTN/LjDMMd3yBpmLErr+zuStIEpRplMh7xSXp9gYYV07dn3YlJgxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jV6T07cf; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jV6T07cf"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-4c01076b9faso640466e0c.2
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 15:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708559915; x=1709164715; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EP0KhQ7me5uYGkPq+SVmWVeUELHXBfsEoRR+81Wyip8=;
        b=jV6T07cfxzSSROeHnwwP884lANAHSAjjO+EduI/SNtzZVAQ+fWrJsMv3y5OVtm3Wt7
         gUGugq+fA117efyWGzXXXnbnAp+afUUKBjM1670NkwfulH8tx1Ojs2Mfi4WOCsYWrU0s
         vO3nLUKmeTxb2aB8FPQJt8Ndu/zGJciE+UIdNyPwcEHmcZ0rJyM+MJz2s8rfySF8vmIL
         iF4uQc4CkRxrkwkbvvFUfPuteuLVKbWbC8fk6U0hL95g/ubX5fsxMNjqzhy+huqZYG24
         PFu6oRvzaSVpBe6TU2+i66BjhfRej1aHB1FK2K5krEeL8bvUZLYhHEddiECme2sYkgKo
         yrMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708559915; x=1709164715;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EP0KhQ7me5uYGkPq+SVmWVeUELHXBfsEoRR+81Wyip8=;
        b=HmTKxXhdtHVWsLJYnL5tdyAf8n1VLuu6AfnHWCAqR4yNR/EcTov7CelMrxlYzjjCv4
         wJRBCScbe5tX66GLa99XDYBTwpV86ND0YnmIicM8ETRyMcazgDkL3PoDDbHm+REV2jwc
         /IDCc7WpVT/ZfKhNLJO0Gt0qEfcIcbddB/drqBrNh4ba1mC4NHix3pAnlAIBtIXlYKYC
         Z1h0yQ9t9bZMEaD9ulBz0vIa2lBAkeikEu58eL/yzSJhkGZvPrrUlXVPaLXoDOrff7nI
         6tEp3Seh5rDYW9Q7kUvADn2w+ifRKESRFNJVXx/NVnnHjXIdREpjTHarI3uM1xajl8hr
         itAQ==
X-Gm-Message-State: AOJu0Yz1Pp+5shO3DL+flZDZSAAoTphYE5ipEW1o3oWfu3ouMHR1Ew1Y
	Kg2LvNZpXVSs4aIVqClnfvc6mjlVs5iFRk2Ub0NUoUQgH6eJzEoy
X-Google-Smtp-Source: AGHT+IENn9yK4/uMQmv06gzZbnBeeYU5yEghu5HVKlU8WptLqR1Yg0RIQ0MmB+EAwwuafjTgDx6jHQ==
X-Received: by 2002:a1f:e602:0:b0:4ca:80c5:7544 with SMTP id d2-20020a1fe602000000b004ca80c57544mr9019451vkh.4.1708559915320;
        Wed, 21 Feb 2024 15:58:35 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id md15-20020a056214588f00b0068f760929c0sm2496421qvb.71.2024.02.21.15.58.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 15:58:34 -0800 (PST)
Message-ID: <9a906f5e-4644-44f2-a67f-2960f056eedf@gmail.com>
Date: Wed, 21 Feb 2024 15:58:31 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/476] 5.15.149-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240221130007.738356493@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 05:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.149 release.
> There are 476 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.149-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

