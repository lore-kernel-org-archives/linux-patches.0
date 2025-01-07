Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9C6156968
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 23:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736291823; cv=none; b=FLKAyglRHieEtpNE+41DADC61USAxSP0At4bLQzh9FBurn/HpsBIi7jhYsAy++i1wHvM5TGPMqZ2cepRQgQjThU+8DKQi/ty02leQDmdnU/Zig6nJWO01BY7rfIbDGXLGghOf7l15yW5txmNxMaPpPVRCR1Ti9DeTlsOhgWdcrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736291823; c=relaxed/simple;
	bh=d1Wf7HmzmZETrl4P5LdvbflK1KjFt7WH0v0l8Sg5MLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hc/LtJ0eLLlEyf9l04naCGXVzpl0iLtzClZKKARUGVT0JE+hsfJYbkhFhzaGm6Ayaxy4FQSa0QBkKWhI/GpfLV96ZxwSAmu/7w/MFP4JhLf4Ygv7AY2WNc05nE7/gmqb13ojbiHNb9fa6jkEk2XmFIAmpF7MkYHODO9i2g8hy24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1nkwGtC; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1nkwGtC"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-844e7bc6d84so10958839f.0
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 15:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1736291821; x=1736896621; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mKvnqOoKREb9v40G02PEhw0Z/x0mrRRo+ZyEtkk9LsY=;
        b=Z1nkwGtC4Aq4SXb/6668iHbk9QJN9JAE8ZdqydQ2ws3yLGQJVGGAuttKc4sGO5Ss4F
         r6Wva6nKRoUCPrBqic0MGe0XWjiOYBxarIQAQpUvAFDocHzWYEjw4m1tq8HANlBx23ZG
         DgcCfKxMZ6+ZR2ZaDtIlMLn4YnEoWFTUc3fos=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736291821; x=1736896621;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mKvnqOoKREb9v40G02PEhw0Z/x0mrRRo+ZyEtkk9LsY=;
        b=b3d0IWmJW8Vvip8f01ubgxUzM/ET+nMlnVKxLr468xoE+FC5lvq/JJhbsIPNu4ZTYJ
         pTbpRiuplinqL48QDZBQ4eL5bxxeT6g75U8mSlJjj10PS0wtDeGVbjPrNursMAY6w2MX
         48cs/L6WZfDm/Qg6P4WArcyT8acAYAN3ZO7HlI+EeCUe8MjKK3KeO0+gdz1GgDmeiTuL
         umaZYpcga2FiRsFkzhZjU1chLbOd+FH5gzMxYphR4Y6DwPVAHPkCLyEKfPqKbBHSk1i4
         4vSn2I1GgD7JasfLfop2AkHym2cjxja7fCkCmtkeQAnkk0kjnimOp13x6YeKkI6E2QNm
         afzg==
X-Gm-Message-State: AOJu0Yylydlw8C8xzQSg5+cQtCvK7xIZBF1lzqX4lwtWpnKzREXJabbK
	pFVlRO6UpZIBoHmNzfWSoTxvkjYYagZOg2A0Er1vcdt/g7952rTC+LN0XLgHFzE=
X-Gm-Gg: ASbGncv9x5dCOgigBGVGcvhdVMz8hocAWGxGMss0O2abd6nmAVljny/5dk5wwJBSUy4
	OGx8OqY2R7syHfPhGRlfAKqk+8U82xT/IEb3q5kUqlaHFmb+xVg6pDQHP+EI/qxoOccmPpf02vb
	hPVjYzu0pRRNDzUhstEwUfcRDVC2HHGSy9VwnZZpTLKlFYRIaZdXUzB/CSXVSCuWotANB1qKObT
	wXBMhZ6fpnI5sfsAX6lL11FDQXyKWfux85d5I/9HAHCRWUXvtRFiZbvnfzvP8zrXgZF
X-Google-Smtp-Source: AGHT+IFjmbOFdzhWqE3/ofO2w/Dp/RPz2F3LP5aRucRpn/nz5bX6qFNn5WWbBrCkNDGpQEboNnwUbw==
X-Received: by 2002:a05:6602:4145:b0:841:8345:5eed with SMTP id ca18e2360f4ac-84cdf5ef66dmr83645939f.0.1736291821241;
        Tue, 07 Jan 2025 15:17:01 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8498d8aae0esm940816139f.33.2025.01.07.15.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 15:17:00 -0800 (PST)
Message-ID: <8bcd6f6d-5627-4f3d-a749-5cb84381ae62@linuxfoundation.org>
Date: Tue, 7 Jan 2025 16:16:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/93] 5.4.289-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 08:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.289 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.289-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
