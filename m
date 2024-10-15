Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9781D516D
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 14:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729003244; cv=none; b=U+NdVtWKcE6eT9Z0u66Z6UeDj99EqE3Gmj30l7J4+etiAXsE+EIVunOs9L+P26oHx8Z5R47Lecj3VL4IV286tWn0DjLyD0Gydp+wwKsS5sSCOqqb0g7bC0Du0dP3NvPqBb9yD7Ks7grPB7h7J3ODRg01hDHSBkIUQjMjPBTYQqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729003244; c=relaxed/simple;
	bh=9j/iM9ZFOnXJ8Pq4EAuSjpyDlhqwQ5ndLD3SAv/tylQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=suhPYt8Y6Omkmta95BsylPr4SNWZwL8unZRnYSttKPdHgLCKgEL9MS+O9B4v0SHD5f22GySxopjyDZypIFjkXOETkudCGJMO+4/33fy1/UpPHkD0TkL3FjB+7N7tldWfPCdvdXHseRwbO57EDg++4wGz1jSdjB1UwQoICa0ilJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kc1V59WA; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kc1V59WA"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a3a7b80447so20243265ab.1
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 07:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1729003242; x=1729608042; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dt0BlX7ghZTRqrFsNZjMr0j0wMiPy8jkYnWp/1A16kg=;
        b=Kc1V59WACqorH3Ty5vlQiAb8xYueLanl872X2EI5tjMn9Chl7jbiDn1YkIrzFZ0ZxU
         +zzOnRgF4cYJ4iSHVLUY++5xbrQJ0UdPLrZxtu1IpQGCXScssZhmQmYAe/nCZpKJ/MBl
         7MaKUN8zkYdFXDD4XSd+o0hMxyOhmt8qK3vUw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729003242; x=1729608042;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dt0BlX7ghZTRqrFsNZjMr0j0wMiPy8jkYnWp/1A16kg=;
        b=cAuSpArscgZh2ZFLAjwx3sI9wqqEhyUiK6JTB7N0+adbyGfUNk4KZgRmHCOqFUQt+t
         LYA4MWkcDgYkrxx7D5g6G3T8wYcvaAZeqBV+nFBK0wTc1toZIirQ1ujflnlYINJDs3NV
         dcIsVJdk0YejQ8NczfxHLiA2gzJoAsXKNolG2S/vVV78SudSGszLj8rxrOEjQHJ1wRDI
         ZlpaiCMnY09WCzb/vcob5FJJY9I0/3JuPpyxH5+Bf4z8c9vD6IkNLvaKIvfgtqGyNafV
         VDfJaYk1PX5cBjtxZfdlGrgyJkx3JpoAi9KI/hmwSfIEnCERfRR7qxn3lJIgEzHKG78I
         t8GQ==
X-Gm-Message-State: AOJu0YyoE0+47ojM9e7lxTSH90BPj0FyB+cGML69f/3h8Apngqb3n7O8
	bchkz8fJxOdrWGmAIg7lJkx7mIq2aM3rMSC+dH1Jbx4TugVwcc6624ZmdRgfoWA=
X-Google-Smtp-Source: AGHT+IE8j3afbFFAJaUzf/DFsIbH2c/+ncqZt9lRW/uO0WSLuyNF5qt3dAKoftbomXfEkEynRLRBBg==
X-Received: by 2002:a92:cda4:0:b0:3a0:98cd:3754 with SMTP id e9e14a558f8ab-3a3b5f237d3mr136176475ab.4.1729003242255;
        Tue, 15 Oct 2024 07:40:42 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3d70cd07csm3412505ab.37.2024.10.15.07.40.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 07:40:41 -0700 (PDT)
Message-ID: <1a173476-ccdc-4007-adbf-812229520b3d@linuxfoundation.org>
Date: Tue, 15 Oct 2024 08:40:40 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/798] 6.1.113-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/24 08:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.113 release.
> There are 798 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.113-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
