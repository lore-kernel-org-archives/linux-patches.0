Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A102253356
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 15:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761148469; cv=none; b=kCUg2wB93pUinQZ7BDijvoL2HZIaMqMjK+6ATGGMI+CQEuSXWs6bqfBt3Xpt2mjBpWE1vt4Zg53KJnXn+asXqRl5zsa8ZnvyHrooYzDbuMOLUAImwtm6IfI5SszUciZFABlzhXOeSC3dnUq1YPQdazorPmlLziuOfKZKDEwHe88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761148469; c=relaxed/simple;
	bh=VtcfjPwuQZm0EMKKvDInhFF5KNaU7Il0txe6BbrjIJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lpjbJ3fX/hiJSp0L0FwSaGF02QRgFhJ/rW/dPYFa29vngXfTpcg4L8Z0fP0bIsNEE1vT9V34qx8GtGUNS6zSPDVHj7446gyO4aBEOnd926wPTfo3Nq4GeKVmDzv4YwEC00TeNLPIahpdYfdDGtY9N5hN1ZPVIyxeIgcQiS0QRGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJ4D05rP; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJ4D05rP"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-430e182727dso13474045ab.1
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 08:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761148466; x=1761753266; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GIVUN3fWWhWOEdh7Hs/wcK5VnrTq8BMj3+c8cRQCw6Y=;
        b=eJ4D05rP9Xa/QiASleXRcU76eQLuBcvNkMGp6IYMj2K2ea+5bmqI/bqiiBz289zQg5
         XinyXnFVxFU7UMytjMyrRZ5QyF00DYkfXJ29nyRD5bMfQQaWLXTsv+svabTfwoxhrSoW
         nCvKzfljkw6jmOdoTQC56O0W2G3HpAVMhk1Xc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761148466; x=1761753266;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GIVUN3fWWhWOEdh7Hs/wcK5VnrTq8BMj3+c8cRQCw6Y=;
        b=MUifNDDxcfqj/eOhOYTDx9apju7AJtWoV7BJ+zS9a3EaefRicDvYM8PROHSVHi4O2P
         3BP43BobNIMfwcx0qptQjVzuPUF4CG56m565eGiY7Xd2OXLgEkAjq7MyjxMcd5KwffxZ
         Gu+TY8Sqg7W9x6eGijM+oc9pyH6ZsVPneAKt+LTqgSvzz6qu9dsNOrGcYcwOl36Hp/hb
         SPEv4M3w7E/8304cUZpbPd9z6sUQjfQHo3IIjiohTgUhs1rxnuHw3T4c1cILq1czcs/w
         Wh/MfMWBdTOE2Gygzlutpc4gBsnr1L2ENlVyKWdSAoQL0C/RdyvEI51vGAtKZ29Hn0pG
         NagA==
X-Gm-Message-State: AOJu0YzvPnOvfZEGJQ6JJlAqf3rq99QSCPUmokvJWCqjzBfCxL3GN7lU
	EeKYVyVbj8R8QIZD9B/IpvtjS8svvr61zRVFx9znDI/mZ29rEIV146OdGrHogZWK/+k=
X-Gm-Gg: ASbGncu8dUg4cbeeHf/bjgh4j8ar2MnGcNv+580i9IbB/H3eu6hIBB6PaDlUrma5dwL
	kG6MG0zUF5Fz2At7ftfPJwZ7Oc803gE1kzv97hyIix0EOlPW5M7zel3K0oUn3lyfcj1qkZwLlgk
	DsoKMPHXpyI4PX3ze+elMHX/ZQ4vHKVWW18vEEGlMZPg11kI3O5xi3arWaTH/80PUTCrJ9nveS8
	iAVQ+GQOvs0pC6+c4lqs1lzE2iGJ1+KgDckHbroTe1ExHwAgBIeLvX4f9PfGLQ8QpUe4oZsYBU8
	keFEwi5aWvEQSf21SGNbuP5CkThJOgs/uBkSyvjJSUE64LkdLgrqvy95ImeLBjsv+p5+DYxVgQ2
	xu9JjHLv5Phaw2JKf8k51RRzl+dpKozULZ5k8vNziG+jMmAN7C+BqHic34ZXXQWwI0WxFnc8Lv1
	C8r/kJn/EKNa+svW5ugBgAC1k=
X-Google-Smtp-Source: AGHT+IEcWRugNt4PgDrDpPZh4hjUcHFJMLAEuTjX9qEtdywPClLHqCfX+99xjdiYkwyoiP2giGCghw==
X-Received: by 2002:a05:6e02:2584:b0:430:a4ba:d098 with SMTP id e9e14a558f8ab-430c526604amr321051155ab.14.1761148465999;
        Wed, 22 Oct 2025 08:54:25 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-430d06f9ff0sm54597005ab.3.2025.10.22.08.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 08:54:25 -0700 (PDT)
Message-ID: <bd81295c-d448-491a-91ee-bf07604bcc69@linuxfoundation.org>
Date: Wed, 22 Oct 2025 09:54:24 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.4 000/797] 6.4.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230717185649.282143678@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230717185649.282143678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/23 12:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.4 release.
> There are 797 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Jul 2023 18:55:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

> Mario Limonciello <mario.limonciello@amd.com>
>     drm/amd: Don't try to enable secure display TA multiple times

Verified that the error messages are now gone with this patch.

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
