Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE891C5D7A
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 19:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750706468; cv=none; b=B7SM/s+F8Cks+oyP51VoMDLRy/fOX868NIGkcY73vZgFPiJUvKDMUuOb6ge0PE02mUFL3oK/LnIjz7A9nnj32mKnLuk7ozIZ4uovxDqR+lWekLp/dw8YqHs+tk7kmtWEPlaS1eNQArK4xINVnTdbJpom0lHuxoBoMYdZJMyHyHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750706468; c=relaxed/simple;
	bh=B/LYiPF2jq1udnr8kW6Wz4JrvaLjqh/botvaVbZfGBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fSbpWwBTZk8u8f002rW/CSoo/IQ72HqXUe+fOasSh9cX3x+27j16aB/v+UJPCMQU7pC9KXW1XJAejxyN4s0fXSYrGH1F42m3sck2jTGhQguphVPUQk4LgX5jHAqo0MAU413BOgwtQ2a8W2fk5+hfeYInYBkPsim42ZkxRC2en/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XwDQtyg4; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XwDQtyg4"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22c33677183so41974515ad.2
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 12:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750706467; x=1751311267; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=S1vH0H7NtjGPUlDbrnQSLOBeFOgkd+rTZmu41DAhemA=;
        b=XwDQtyg456j47+z/m2DJIpEh5G4YiDwl7WUdHzADqHpJjOovZPTeY77Aberpe5w3GL
         YlL/s9navuBAb02nUqEZbDc2c99Ty0JExIEAWDsac7Bg6Z6YTpJhs1rvJO3YauwHRvqs
         lAtw23x/HkUCN+fMsQkRuohBYAihwp1Mmls8svcdbaBZQQq0H6UAv0BFfVwtgFYzGDHH
         uSc3OqBhYfyvUCkTUeG1dWUjcqEgB/asCYcgCWGW/rJkPi+FRQEX8+1SKYQ/nqIsRmqP
         oXGiWIB7j6bjR3L1UM9JMgBQ+NXvRcsCFlE9brMrc6yFtHlLmF/lkpvq5ZHG98bgk2j9
         o8Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750706467; x=1751311267;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S1vH0H7NtjGPUlDbrnQSLOBeFOgkd+rTZmu41DAhemA=;
        b=H3XdxTxtQzZMBsv6yn5wdGQ6sMC9UZcMWDPs1MD04FM7xnJviVVm3PrhhT1b5kUp3Z
         1L77T0m8sWCXnyiqq6cLJr4xOH1ye9Cla/BnIB9qQFJ+VgcPd0L2R4IC0e5rptoAWHQW
         a7MZ+qI18gq3eHHcZXNjv/UhslRtl+lIh8n8l1ge81JAwbPLj+ldSyoPlJTtoAO0irjl
         9xd31NVUzzXV0slRRCsp6OXPZi3CWtPD/UJ06byG3cxZs6g+0g7VZlVVhBoyEfV7Cn20
         otCpyhG7MkeZSougL5gPHuM1wWK6/yr0wmEnAcGeb8gz6p5HOim44nPsz2KcizMdE0Rx
         +xGA==
X-Gm-Message-State: AOJu0YxY+mb9e6GjqBVtJpPHHMXy+59Ze7jdhut8qpXA5/MPY0n3M1tM
	SO0L9lBE2uApYMFJKeaWjxc+hWtTvh48Wsld8wTVgT8iOKby66IKPOm3
X-Gm-Gg: ASbGncv0966R4bQdKS8mSWmJxFkZ7bWBoswXjtxo+261LhPn1GL2Pj6+z92A47f2+NN
	vRHiV4y8nSCthNBY+7w5+Zc/srpeb+PN4xzWyraghqbYYIvTCSA6kh4W6msZaqEVLhS04EvwIs9
	LvfPVriMXoGpROyRUISEC0t0NPNl9Q4IAAOmX0C8d+6s8yHk9FRuLIrJEnRL7ZDGYH8mR2V1+c5
	6G7iQuPtktWNkk3DYtdCD7sbyItvYkf76Sp6nUyKzgcCVLrQxh05XIZmruhbABuDaEB4iUT64tP
	OYhAin1NGBn+mjP6tPk+2Zl8Bpjva5OU2XiiL3QDdqFl0BmKHb4+zuhlja5E3rPdqM9nG0YQsiK
	nhabPX3N5iU802Q==
X-Google-Smtp-Source: AGHT+IFh7wAj7dunSH6c3tjj30+ExI8r2On7mXZtxe1Ghvs5w4+KzMp5ZJb6Hs0WK95cs9LDHWEbNg==
X-Received: by 2002:a17:902:ce85:b0:234:bc4e:4eb8 with SMTP id d9443c01a7336-237d9aaaacbmr202967005ad.46.1750706466668;
        Mon, 23 Jun 2025 12:21:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d8609209sm93011545ad.110.2025.06.23.12.21.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 12:21:06 -0700 (PDT)
Message-ID: <6ba5cf82-cd4b-40b0-8909-fa312759cbf7@gmail.com>
Date: Mon, 23 Jun 2025 12:21:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/222] 5.4.295-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250623130611.896514667@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/23/25 06:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.295 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jun 2025 13:05:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.295-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
