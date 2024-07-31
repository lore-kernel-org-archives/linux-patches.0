Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945016EB5C
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 21:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722459839; cv=none; b=jBd/pS6TlJn0RN6dEoGcW6pJFFgV9cQrzLr2SIbs3Bv8b1CIHO7OdnvWwCeL5CKBDOIywWS3FyArjGts6ymdpJlL9BwCuvwQhN5cWLeJU+HjQ3f1mlwZeLiNrcbubfoihnZnEK69OJ6xxRKM/v3DxcOUB0wv0L3NVfA29goZWyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722459839; c=relaxed/simple;
	bh=AUkJ686A8RH4qcFlXPTcSnFatT/ytf00l23UxvbQAAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UXJmLP08J2tCs3tzhVod3t+b1bLnEuEJyFbYdT0B9+aQcYrZr5Gg+dn5JmVnj+UesLSt2EBF6oHh5NdZQoG1ujnoOiHgeFAqbefEI69brHq5W5hXblmr1TCnE0N34J/4RlugVPll8RE/QyGFS/+o7NzXMK/7cl2nEmlbJaWP27A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jMP9HPai; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jMP9HPai"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2cb4b6ecb3dso4155261a91.3
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 14:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722459838; x=1723064638; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9HPGA+i9bLxv8+ywKzP8zynz5mLJCS77FFmzEIhkQ6g=;
        b=jMP9HPaiWeMe7qQ3b2Yq/G81mSw0GU9JMxmg+dpHzdBGWCGpzhApnPVx32HPys+g8x
         YM6txFYLdDtFPISeqHcrzRjUs2+Sor9eblAfEaxGAr0tBrh5B/T/NXEvmgcuqAnB3vbe
         42DGmV0JMswttsVkh4NjK7nDQwuiYnOS5KlecxByYAkgo0fdqpqjTndrrZ1p/qeJhdAm
         CPMl+lEwM+m+M3DgCsR5hyd3hPyR9hY6bG3JOVMQIYPXJV2VzlP2MluKba1rfZXvKxSP
         hQr1VWkpWm2+uzTi+YcfKkkPq+Bxuq+TmjpxUR9nOrcwBJm0Dm9na3vP8MKKN1Ge7lc0
         HuUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722459838; x=1723064638;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9HPGA+i9bLxv8+ywKzP8zynz5mLJCS77FFmzEIhkQ6g=;
        b=MTS9cGxPTi6ogMTnKBdNyLEM6JOH9tic4Km//ACW0FoHNQE7ut+Ds9rr7de66c/f/j
         N6HjQtUZXBXDXsQuvD0EMKWSdnggdsBt0k+lk4bc9ZF+S/7ZQC/EZ5Dl/d4y/8GEMuts
         X39aPJVZlIl4dDBHq0cStPMbY9bhl8uVrit7HUOB0cjsy+H4EbOi2atD8EIczfBq5w1h
         eXcMOUcHptPlrATn6BdBgthh6h4vexzSkqQy/pCR6yS5kI1TUGzZbueMD38ArXrP/9ZM
         KR1UjUcIO6IQxtjSXhzpWQKqTswVy6K8m53ri4+mV+pMClyUgTZ4r6f/ve0BTjNUGgNc
         smwg==
X-Gm-Message-State: AOJu0YxdEMu1nydN1b81rQmn63X636J5XV+hHPnMnOHL/OZOdCBbIUlc
	tjaBHceEA5Fs2pqP0C5rFizAdn2R8tgPxrZ6niCeS3B3JbsYjaYt
X-Google-Smtp-Source: AGHT+IFk10AYWxbSh1MmvpWEmpv9q0UkSPOj4nAsBLWAvUgWZuIy6nbW6vx6nkjdyo27E1GFlvccQg==
X-Received: by 2002:a17:90a:a110:b0:2c9:a56b:8db6 with SMTP id 98e67ed59e1d1-2cfe7b73301mr634074a91.37.1722459837737;
        Wed, 31 Jul 2024 14:03:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2cfcb85b7a5sm2146765a91.1.2024.07.31.14.03.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 14:03:57 -0700 (PDT)
Message-ID: <66c69c35-6486-4b84-9315-3a88232694be@gmail.com>
Date: Wed, 31 Jul 2024 14:03:52 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240731095022.970699670@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240731095022.970699670@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/24 03:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Aug 2024 09:47:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.3-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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

