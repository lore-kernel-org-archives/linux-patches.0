Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F197E304975
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 16:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760461111; cv=none; b=dj3/93VR8NGsKqjUDygnhh/VrzPsd/W08652aBvxTa8RGLUltrU5GfcjBkaUNfFEFIERURlmD56sE+IHf0YXgOK4t/FYenMv3a+grlGAy3fxOaTNQ7US3VXoyjBmHVfAxMiQULYMWda2IKcSKTB3SlTC4Z/AsZb7xh+DAFMQShU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760461111; c=relaxed/simple;
	bh=YsyUZHgi1wpE/vvikQRglq+UzixFkapYZ/q1X/Cvgvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hrDoKMuj674RJL5GWsV9lWVFVZRqNMzeWLbce8Uh8Wm7kxCy4YB+0rHntCdFjPrTULov21nK2aUFAizU9Z9XvCtxTxuxD3HipASi2jScn5Ht+ArdzI9pB3n7MHO5cbhsVustRE36VtYudwIyPCX4IsIgxbly4PwjlGupftWKdsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjJLiHTY; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjJLiHTY"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-90a0b3ddebeso228357139f.0
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 09:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760461109; x=1761065909; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uv1jmh2eVmOSopdUqtY+w8Wv8v5i6enZZ9ZLD535XmM=;
        b=XjJLiHTY0a1tLW+MFqzX69lfaTEPVdmCWthkfG8z0pzpxryDUEsPO5r4gUJMN0rOtS
         YmDwEt9NsppGmDPH7i2nKzCxsPtEmF41por1/4RA2j+eVKWJEWcTlCsZQV1LfuR9W7QG
         jWokTwCc7+t1/5XJEfkX3nOsxeMJWZ0qoC3GY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760461109; x=1761065909;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uv1jmh2eVmOSopdUqtY+w8Wv8v5i6enZZ9ZLD535XmM=;
        b=u02KHcTpW8gXhGTqtGXtmanxlbV9Rff7VKjRu41vAAk3ZCdQnB4uJpiIVmmwC3iDkk
         kwwZLvoYcHhKpDSu7je6QkDxjjEkLxs/BBS7rudTLESA1RZ1YvGhpSlnztHR3vbiHbHy
         nw53n5OeNcH3J2RphJcj9UJq3fGaYjOl0pK9ci/9Xs+s3qe5I2c4RBU4x0TA2X3sSuGE
         HD7UWVioNUdFfRO8MJDrC3dcuIMkSiUq5pzA4HP5giOfZtGUIAuOYPSFinY3GK8gbVp3
         IbMNLVfeujS/YVNAqN2Oe0Up6IWjuMrjR6rwH9r1kLaqiEDbRf3e5NI6cuG2usd8Uo3y
         P+Ow==
X-Gm-Message-State: AOJu0YxgSMjw1TAZG2v9d535atjATV1QMjW6YiUTJLul6GRdSgfr+Rlz
	zTNDyXAJ/b2vQV8uZEEso13OSxb25uXLroFnH7+9Jvuj9206LUz/82LVVm3gC+bY5Eg=
X-Gm-Gg: ASbGncsoafngVbc+uK1XDEZQSD3VkFo0w+8EmTleO3uOW1h8A5K6oUwmElhkjJSIvwS
	9PJhnCpPPvu5ZmHHGiI54QlEvd+wHK15uSuZDdl3UhTFS499i3aMPJV2PggLuVjH+Rfp5OuNwAD
	+kouNXN6gWGUxuqt8orzshNadhbuX9nFzw+GbAWU9JlLpnt8r7ddY7/k9Y4je3xCS9OjCj2+kEh
	ox9s+6m6fNONcO8aTfpNVuyNGPNgfVNayywGjKcYQnhrlvjqwm4lCJcayrl2GkN+xcels3mjsuW
	9G14f7/nJus+A6KuBqyV4xmsQhBKEPGXc+ZtqeO78VTmhssH4ZqXy+vUgNkrCAboSAmP/zYx8/d
	OVj3LLgazchw9WxGHXyZlQaq/7UDz6+q6/6A9PrdoSGmZgX22zxj7rbpzS5P08tGkeO6DD47LFl
	M=
X-Google-Smtp-Source: AGHT+IEpt/iipPZMrqhw1wAspnajPgF214RYw1OdoUghqLh/7sXAtLGEGZrEJbe94Pt4al96RJkdQg==
X-Received: by 2002:a05:6602:29d2:b0:8a6:e722:a9e8 with SMTP id ca18e2360f4ac-93bd189ad24mr3241436639f.6.1760461108974;
        Tue, 14 Oct 2025 09:58:28 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e25a63c81sm487119339f.18.2025.10.14.09.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 09:58:28 -0700 (PDT)
Message-ID: <1263d6cd-f9a8-4558-9c59-57f9b5503473@linuxfoundation.org>
Date: Tue, 14 Oct 2025 10:58:26 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 08:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.3 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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
