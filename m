Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE50737BE8F
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 22:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774303579; cv=none; b=TICYXVnbPXotkH8gsMzuCTqWleHUkU+6oiRhnDqVdY1S8eZWx3OzybHXhJVVIxOl9e3tf0D+iuzjGo1WR7WGGNQ5Q8v/5ODwAfxtHi0uyRFec5T2QgOUuYABnCO5sC/eFO3EPoIb1VIXACG7LwdVMYbmzQQJ0yjzlS5qgV4PjGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774303579; c=relaxed/simple;
	bh=5TNBIu+1zNMlQ2EzrYj8YDKPSFd9UJLXVnMoMpiv34Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R4TjIEgxosD+3GJ7ArFafhggV7FrGbOxx0hB8KrNb7UmJumA34xG0g7RkPcqzGz+bNW/2c3A32ZTofQWuSWxfFroW1ioxq1wfNvP3pmelUWAq9QfcPxEMwlub49fmaFofQOJv7KiS9sAgMhC40zRwDPm12AsxR+M9lgFymDnFVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObOjh6LF; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObOjh6LF"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-4645dde00a7so4389001b6e.1
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 15:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1774303577; x=1774908377; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L+uT5kvrXZcde1sxcqGB4st5JQXrajTNaDzGATU3tww=;
        b=ObOjh6LFwY8aZITVcobEkEt6ZjRLHkDGS/bDSV6U+MZcOzOI2hfgxbReeQSRLH/jWA
         v2cmT2uGzQpc1PbVDvAv3Ds5u9AnahbTwCvN4yu4E9sFX4oNX0W4vAEgTd3Hgw+hBQ7x
         TY+7Fj95cq0jS7a0QeRNs5FBQ883p0bbs8MHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774303577; x=1774908377;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L+uT5kvrXZcde1sxcqGB4st5JQXrajTNaDzGATU3tww=;
        b=Aqu+zNIeT2NGNu3ib0S8I/YNeaBc+ZToaWkGaVB3ciphpox0QTZaewNanKS1w5OGK3
         7Gom+BkJJeHs/lFO2FcyyafeOCx153TqVzOQSk3rpwA30CtuC6onryZQZ1w1zFK+/vPh
         5MF/YwTYTm0tOAnwZEbqA7TTkY43QNoIPm7FMCKdAF+TOAr5m6cOlmjPU8EOKDuPC6yE
         lgD9B3Nwm8BqkAgJSPMvHmUmLJ1aIVimJvfgHLR9dJdbAsS7E6rt+MyJyBbZ0dOTclB7
         Q3EPlNK3QH27jye+YW9QgQs+4UxqfCsBe2tIc7YhhAeNwxW9ijplaLywkWDOjxcNyAWn
         KznA==
X-Gm-Message-State: AOJu0YxKewNbRzNETsj/VYdXpQI32BNZq8P0gRUXsx1KIVS7jxoIeUzX
	Q5N37tXKmVxOoXJaJly8fWy/3N46OtcTD7EDehBSvcKnu2m1KB4Ysfv6yte4Edie1l42WAwktN1
	TaIuQ5pA=
X-Gm-Gg: ATEYQzwVtg7yUHZkWmlJ0h2V9LCyihRHokqaTK+Ww3JlczQLGxhFkXVyqfTesldvuyq
	fFhQKoWc7IT2kPfd7EHzWe5qweDvqfyfqzpD+cG8uzu848fB2lypX9y5G986NM+ZJHQn7dhld6h
	o2d1GwGHLdep5uy/qlbbZYSjX5a+tigC7WeL1xP/NcNmLr7Hch9DnZx/ltUehMwqlIo2t4i5pu8
	VQMN3O8LGAYW4Xzhh4F4xGDp4BOVOpujKJlEnfuHQzpZ5NyAMOfaM1mYcFcYq9oAiT5jafTeUnO
	Dv8IYNxvuRfjrvamEZGXLdlZnfH/0weQGuYqTFuhLxlFxIhbOrJgc7ZaKHc4pFG5+dI3rOj2Wde
	L1c1SdH0vaqc0gnzUu2OaUFRZZ1UIJSQsxfXJnDdTh6bF7UdpKW7od7SSTdpblEne5X414f2x37
	Oct2k7PCFo9ZN1hE8Fmsh7zFOcxG2RdQ9HU+w=
X-Received: by 2002:a05:6808:238e:b0:468:4b3:d12d with SMTP id 5614622812f47-46a0cdb2d19mr705075b6e.11.1774303576681;
        Mon, 23 Mar 2026 15:06:16 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c4833257esm5980819fac.4.2026.03.23.15.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 15:06:16 -0700 (PDT)
Message-ID: <e5af7c22-e40d-4344-a6b2-be6d62f38df6@linuxfoundation.org>
Date: Mon, 23 Mar 2026 16:06:14 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/212] 6.18.20-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 07:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.20 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
