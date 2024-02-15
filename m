Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F47D38D
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 00:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707956533; cv=none; b=t1ke9dMuFufuFsD6e3wS+GHyq38HZ8xKhwj9gkDlchziNM8ws8+lGA3JTPtib6NGlf8Vox7Mk096I+NHm6g1teEP0i+aE6ToEVLSu3JIrqHcQ3TLkb8dxhpkNGjlNcaB6MMg2ueaLb4qKLBelnEW7LCNHq6L36fn3qHH6yc3Iko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707956533; c=relaxed/simple;
	bh=/IVDv8ZDRpkxRX1EmzLDaIDR5L1QLIzQ+L3RtGoXYck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZR5n4iYfPnOPnjU5Y7RRn7WHF+MssxE3qg/Rj3Fsc85vs3QDkjcXncHFeiiaduVooLHC0jR6/aza99Jd/5vVywgr4Z0+Nk0Lq5vS1ilwOgfNh8WnTrepmp6pKiHclSdP/yQYRBXw2kh6Yp+RF2eQQLfnyiRyVwS4qVIsCMB6nX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M3DmiQH/; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M3DmiQH/"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-68ca3ab3358so1715556d6.2
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 16:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707956531; x=1708561331; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QGv9ICseLvTa6Gc2Hnpxim8An7iZ8HvjgY4ZwW+CUnQ=;
        b=M3DmiQH/iQO+Rt0IJCmi30xhVkxPhiiTfJOaPiWQ9R1aC5EW+d3QeVGFXSdpTrJKlj
         CiJJiShglwQh7YUOt5p8rhOvf6uCHSMpSNbnRoncW7Lqjb+tV1Zer1kg652YvR75lxRb
         L4cgHRK/ZVN4U5mAnoWSZ+AMH1IvslVUcyatS9Zj8QTN3fulxFXTldC48zdyakmuZ1Uk
         0x1nHJHGY7JUKlxb6oj8a3vs1tV70u9EGiM3uGZeFzCge47CvRa5WQfUeKNkNtxgEjjU
         zcCM1KMGwOvnv93OCnCMXdf1FtvTO5IbgB6TAKoz9kvOtPPzqARGYEUvlNDwY4IRyse8
         jn3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707956531; x=1708561331;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QGv9ICseLvTa6Gc2Hnpxim8An7iZ8HvjgY4ZwW+CUnQ=;
        b=Jooh+puYTe8qg5HD8Wb/gBzhgpv3Fmqb9ibg6+pO9RaqDoBjDetWs+1iM2HeHjq333
         a0l4Dm/Yvbw2VfWX1s0KpG5YeUK8BYWUUW5lFGgXpbsH55+O4wAtCSKVhzGfDbgSxS++
         5jDQIRgWM6I9bK8PaWb9sH3O72d+NOWQvfWz2Vjh4SW6rL+c5y4W6F8zGsOHU+VHsC1L
         O3CfgHdy6HQP+JcP5+wIztbqdOUFj6kG6LEhOOjemCXQWqzNKJRDxV/nJcFWR2GDxs6f
         nCe6BaewLXo1CDY82hqB52O55GEYNb0duJvUG5qSYMxWVebIc/fTsOgOeWuobao3Jtqy
         4RCA==
X-Gm-Message-State: AOJu0Yx1fro0lmoWZ97fPPH+wk0U1ZJwCqrPeLX6IAomeYiTS/8qoDPU
	xIb5etMH6rEngNxeSVNplVRdB/9grqj4Imh1zvTZXHkJ9UAI/c+k
X-Google-Smtp-Source: AGHT+IG6+oriiJxs9z+4QKuoEdbN+sEQ52JvCo5Zun0AX3fk9znaasW13XCxBp5KrK7UAOGxrxSt6A==
X-Received: by 2002:a05:6214:c4b:b0:68c:7395:1bf with SMTP id r11-20020a0562140c4b00b0068c739501bfmr346565qvj.8.1707956531258;
        Wed, 14 Feb 2024 16:22:11 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pa6-20020a056214480600b0068ca30a2a23sm94016qvb.133.2024.02.14.16.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 16:22:10 -0800 (PST)
Message-ID: <38b5f0cf-8d4c-4c2d-adb9-781b8d39e59f@gmail.com>
Date: Wed, 14 Feb 2024 16:22:07 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/127] 6.7.5-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240214142244.209814342@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240214142244.209814342@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/24 06:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.5 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 Feb 2024 14:22:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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

