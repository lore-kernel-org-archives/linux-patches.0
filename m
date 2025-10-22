Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A81256C9E
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 15:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761148607; cv=none; b=GQ3r3qAyxBC53Woxa3HR6C2ntmIBJqsXWa9EbuL56VjgPaeQte7F/g5jxEZX45t8WII8ETmbLWOAYaqphKCzBnO+GIABpYIN825XFHV6Ip3XNeA+VjvhgRzbMmmemgP2LbnThiMxCqLGnqIA05skrwziPXvNK/o5663ys4GG9go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761148607; c=relaxed/simple;
	bh=yZxdIcNjsvsepd/jR431aaY3GWoUemNnmmdOtuw8xT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y3uKNssWjIfq8lcUUI1s6Uhob//OT9YuKWRVAmsRE8sU3Pfwp3srDAwy+oI/rpiDSD6QBR4ju0U+W/fVKWf8pv6dWhN55udx1Zp6Bxrcj6tWNLQcuu9XA6NSIxYQSnxCb3bx1ThQnQDuavqOE8xv2RVejH/3S6FsQse/78Nv4/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wj3b7JeT; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wj3b7JeT"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-93e9b5bafa5so171756339f.3
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 08:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761148602; x=1761753402; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jpVnSWJTgD2kkjsIK6B5EZxkI+BQNyamIAMlFJBOIaA=;
        b=Wj3b7JeT00VK4gukkgt+GXc6lM2gKy2I2AJQHVyx1bDCWJx8UMwVJBxlQOIYzjQ8I3
         8JDhKEWqOn27O/yqEXko1x1tYrkdbLoulIuNewNDfClnLGExqqE3/y5h5uqNPdUmIGZf
         yAk7JybN68m1cC9eTvssJO4tHelUVyBqH/gLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761148602; x=1761753402;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jpVnSWJTgD2kkjsIK6B5EZxkI+BQNyamIAMlFJBOIaA=;
        b=sbIeT8R2OEXfOdvw8cgbEKtWkcCFCyiuSOtyvA9NKDxxo0X6QbxdplImTMu2XQfuzX
         lWnMItNy3QrPLh960YfhXp1eFkHnt4YyfykRcF+YQlYjnoW7bgnzJx/ob0BSkbeu4z35
         U43a0Zm/EA1FpVyIQOusKv63D9c2gcj0agPr3Wdc5ZpsL8CJlCzDEjj49TxAzqJDI1xd
         wOFhClK70N1Mc6g/EljBxq9fJlJdXqGy2H8hcJWf3Kuz9m1qqUzGdo0DIYfjvidGMwcc
         GSROMS7uSbeGDENvKGQRJ5XO/Z0fYh3Om9awK7r7YooGU/DZ7Bjr2szMzoaSqItIrGac
         tpQw==
X-Gm-Message-State: AOJu0YxC3lSz8ROoB4H+7o4RedqynxJob7ZvUr0DrBPei/4vYs9P4C4W
	0YZKWJy6DFpMVbCGjFDwj6bVauuSnO84qv9lwOD1K1TRdn7h/XFPP8VqgE8m3lKqhqg=
X-Gm-Gg: ASbGncvw4R2aBvuKUrtGieGBdFswPWMJg3eVeJEYymNTtmN2XhXfN87IIX24QizkmRZ
	mVAWqwytwXFDmWYfOeLFkEHeybkNsROeGRAAnO8kWOaDQM6L6Ux/V7TJtnyI4QRBomDJ9SLQ+Rq
	q37TvPh/drTW7RUYNTx9tv7u3LRZh+3WMxJGBoSQLSi1e/ZMz9iHVYKH6O7yaQCccwU4HCMWnWL
	Fx82jnwx6wxD2+7nkoKGinY6N1LaZMLmlizpW38CtJxjM8lZnTBh7H/sFAU+71opjOYiFu35WgT
	IftSHPZuM9Xz3DrTKZlUGP9+uPtgLUNTYa5Ynkro4JFk6tWe9gzXCSUST/uq1pOdX2vCuW9eF4y
	ZnOXqQ4J+2pLXipjLJ8jS/VwRNf7F6aYr36XIT3jiesIExy1Iv1ABl00sjKTyQp2nRfAxzL8iZe
	RVUBlzIsLjh1gu
X-Google-Smtp-Source: AGHT+IH+q0EsPvLLPOT6AkCFc3G/awB3o5SJxRzTQyoyquh1E8IUgNyuxjCWbZDUGJ1+3fGtEEZu6Q==
X-Received: by 2002:a05:6e02:4711:b0:431:d63a:9203 with SMTP id e9e14a558f8ab-431d63a93fbmr23185375ab.19.1761148601709;
        Wed, 22 Oct 2025 08:56:41 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a9451918sm5225944173.0.2025.10.22.08.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 08:56:41 -0700 (PDT)
Message-ID: <ef7fd14c-fdcf-482f-8af4-115f090caab8@linuxfoundation.org>
Date: Wed, 22 Oct 2025 09:56:40 -0600
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
 <bd81295c-d448-491a-91ee-bf07604bcc69@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <bd81295c-d448-491a-91ee-bf07604bcc69@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/22/25 09:54, Shuah Khan wrote:
> On 7/17/23 12:58, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.4.4 release.
>> There are 797 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 19 Jul 2023 18:55:19 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.4-rc2.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
> 
>> Mario Limonciello <mario.limonciello@amd.com>
>>     drm/amd: Don't try to enable secure display TA multiple times
> 
> Verified that the error messages are now gone with this patch.
> 
> Compiled and booted on my test system. No dmesg regressions.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> thanks,
> -- Shuah

Please ignore - wrong release

thanks,
-- Shuah

