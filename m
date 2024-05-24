Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EBF86643
	for <patches@lists.linux.dev>; Fri, 24 May 2024 14:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716561327; cv=none; b=QQylYcGma9LDiWPo7bOgdn5gAo8k6RvBX8Ij4gHtAmLcakMYAjILmj+mCoCI8qnvTBtXR6eWi4pUc481jDoW5xnX9obPdnUwvVAFi2IuNdcRFdC0gRYzk0Xkpy4qq3UAkkkW3mV3CulYpFXIZiTqXA0KF3UPcyZLrtFx9T6x0k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716561327; c=relaxed/simple;
	bh=O08vWwtBUIpEhU5WTNR5BKBLCurGnvqSyTGFDfuzxvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z8jcPyYC6yNDs7BqZGmxctA7YExBp8Zx91J9YoT+8MbghFXXdFrW4+VbehDJLwCLLfrAy99iR3lFA79+k8GXQpFxxYvogChggCepx95rNYnGzAEhWzPqrrCsAYbXYmMkrt4/+5tnCRzV18PHzTjX43G5LD9ND7vFHjZoM7+R/qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwdyR8Yb; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwdyR8Yb"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7e89ade63cdso3593439f.1
        for <patches@lists.linux.dev>; Fri, 24 May 2024 07:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1716561325; x=1717166125; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jle+hnicjpSclGaYZzjyKVLl1Ha7enj6gT7jZRGY2v0=;
        b=fwdyR8YbDqCNQfzfHGsUjIEORaXl2E6qKfWLjpDgQfFYFqRCUoc4yRfNvYF9QsoDBN
         s142hLrXprpEzm1tE966da2uF51kqI3iCRJpg5CgrkN+RTd4stNYxFtdmQI1MqqB8akd
         fKyArrJl0lhCozE/M2MH67Jkhsst7NQYjCGGc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716561325; x=1717166125;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jle+hnicjpSclGaYZzjyKVLl1Ha7enj6gT7jZRGY2v0=;
        b=tMrKPNLpmZSo81b40NFcNt4zqpw4+tjjCgJoS8hqo5KB2GwmVPdXopbOlhu7u7DUPv
         dQI/paDNnThRJ4CR8CABEs4ssN2zGt2LUXTxmzBD/+EbdAn69svzEXh+i25SWJNkFkih
         09+OETvrYBHmTU1kcTgcxdPoW2r/KZK+MrvDFfMcMPiA/gh27gXnLiM83wQU39jVxXgE
         IXn5va5GroF8d+gzRnbJXaJZLgAo2sRI4YBf6uny3kEe1TSkGO1oVp54LZpU/2hQyIvr
         X0fp+bJ1T900CQMIG/QV6yhl+fjvQNxogilgNYDeYoG8kGwguX925gqOuyPKUsyzvIw4
         +GxQ==
X-Gm-Message-State: AOJu0YyU9KPaVCMhqUFdnRHDJeysOuxLCCE/1PzgBE+OwJfHhXkMUIJ6
	hu71ci90KtCW2PmHz7PF2gi6n+u2aNXQ7AXq/gEXBCi9+dAOJIHPS64mcVkIMg4=
X-Google-Smtp-Source: AGHT+IECqnorAkwMxUXRDn2Mq4YCQEosZzpHiwGGIY89LRbKtPXIL14ZxrWcSfKIH4ZIXrhutLmYBA==
X-Received: by 2002:a5d:9354:0:b0:7d9:eeb8:ddeb with SMTP id ca18e2360f4ac-7e8c664ff36mr272174839f.2.1716561324217;
        Fri, 24 May 2024 07:35:24 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b03ebbf7a6sm385939173.91.2024.05.24.07.35.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:35:23 -0700 (PDT)
Message-ID: <58b5d404-82fe-416e-9110-6fb113e3b8c4@linuxfoundation.org>
Date: Fri, 24 May 2024 08:35:22 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/102] 6.6.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 07:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.32 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

