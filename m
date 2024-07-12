Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755D7176AC4
	for <patches@lists.linux.dev>; Fri, 12 Jul 2024 17:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720805937; cv=none; b=usfoIEz5nmiQP1ZWG0IbtaOXJF78lLgYg5TwM32xBLBVlJjl7CXq8A+b80OybislgoVfn8uPlyDscnv1Z3xHesSxRBy+FXDW6mufkeoAk2bMySDbWmpUYMupqbkLEYN91m8rbCB2oyfBfpn4vDcaCN1fVvc3dJz+l/zVtNZNeEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720805937; c=relaxed/simple;
	bh=1V/ENdQTei7MNCNaneHTy5T1yttqICLHC3xv6bU0BGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h9rWo1q+rnRuesywa+AvxuSZh23d6VL6fA73MlZUCWoKTKynwmAdlkxKSnXKH57Vhv5//I0Wco5uJdAynFiiuCQBPm2i+U7/Cp7WS6OTotTQxy7QXABK9mQ3yUZRytJWtfozrkhgboG3z87q1nOJUP5U6tE2dnHJLs+GihMhHzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bA1ndtcA; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bA1ndtcA"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-70af0684c2bso1809734b3a.0
        for <patches@lists.linux.dev>; Fri, 12 Jul 2024 10:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720805934; x=1721410734; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L9FqVr/rhZyzwfnucHeAewr1d8dwEYOh9P/Sief1hgk=;
        b=bA1ndtcAGx+6ydSSddg0vhtRMbI6ONDdN6U19+L+Qu7llE4G3bMfwrCxqUXG5t8Nlm
         g3hsU4VHWkzi6MQ+G6SVbVMr0BeAgP014JwOFxhfi9yVkRM7LlTb6/iIWOkh2dgYZyky
         OpWJjsQvKwd8NToqsI30yxlL/QKbub83P+wQjvBEAzvK1EjnNWMi6/bKtTq7Bc9ixsz5
         j/nCzVkGAAs+IGxPlMkqnJPqIMldxEPCKmYkgKeDVT+p7ygIoo2C2+kfI0+9BN3juFgD
         s8eEhBeNM1lYzoLgBE3dZ2h5vkQxbI3uZydDLYLCcRkJLbTqvGjnd2SjibHmStU9+76c
         0NUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720805934; x=1721410734;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L9FqVr/rhZyzwfnucHeAewr1d8dwEYOh9P/Sief1hgk=;
        b=PenkfFKcM7kNHYE3LJ0zQnGQH4diCfrD+BdtYjLweL5kmA/P1Z5nLo+z2ST15VZ1x2
         DTlO7iVEM0yiD9li+El1nLq80zQrqmT91kZvmSBPOpLWniYoqqoel5HYHyUwaHV0N3Lt
         OIjKECHIG9LK/Yyt5MrppFROHqkpMj2/81CTiMAoEeOWYrIvHBjICqRlDTLwAUVmDBCC
         thLdfjzeFvielN3a9xXwIPyp+uSx01VFtn68OdmnKIR+r3xe78i+JrEUCn+HYF0DZTPJ
         3ceCfLLhZ8dqOjZxru++Jma/kQJyDJtP02h+58TIvmLV27Eb9qU8eEFceo+L2JGlaIp+
         JPzQ==
X-Gm-Message-State: AOJu0Yx7wPH/7Aapsx/fvZkgR3T27NOkusnAkBDdR3+f3p2n8xsCBAvq
	/hyQBsY/bzpxhd1YrjJ6a73W1TPOvh5d1wq5r7k3a5kWMzC2KLpH
X-Google-Smtp-Source: AGHT+IHdX+ao63nA1fTMZfLSJG7Xybt0fUskH7EuIH0b1VguS4qarFsUTpYI3p+dG3HrORxzZF31lg==
X-Received: by 2002:a05:6a21:3394:b0:1be:dd1c:a6e3 with SMTP id adf61e73a8af0-1c2984e11d9mr13338042637.54.1720805933399;
        Fri, 12 Jul 2024 10:38:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-1fbb6a3ca56sm69551665ad.118.2024.07.12.10.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:38:51 -0700 (PDT)
Message-ID: <191d8761-0784-44f6-9b8e-5d3c1c15c5ad@gmail.com>
Date: Fri, 12 Jul 2024 10:38:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 000/197] 6.9.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240709110708.903245467@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/24 04:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.9 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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

