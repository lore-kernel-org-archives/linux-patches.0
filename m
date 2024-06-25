Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E96149C47
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 21:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719350684; cv=none; b=Fr7u2/95GF+eTq0NExCgeFyx51yIb7n/3bdj54hOxz+u5XBsaW8Iqlf8KsF8pnK9RTYL/SUkYg3mIX1evfnwK6adPxVUV/X95r05guui/m54XFxAnUVXKdbJ3xSlUPtNdG9pBCN7n07aog3X3u5DgGTlKlgYKtOc+Q9W0wiihQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719350684; c=relaxed/simple;
	bh=nW0DR9XCcCb7XpSfcLzEN9SyQQOB3xwFqsqnicd5H2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KS34YAW1qjSOPoaq0pBJO28nQy9GjBtHhE3u3fRK1Sx1FNkjc49t8Eg5NPaaE01mHnGVwKYKAFTZOlqKXpeU5BaCU53CHZp/py01bID98mEaMTJq15tXLETGVkLZyL9McVuE4mER2RseY+B+lG5BbtaJcMOa3SxWbs1Lg0KF0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2sjO/Hg; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2sjO/Hg"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-375f6841f01so2706335ab.2
        for <patches@lists.linux.dev>; Tue, 25 Jun 2024 14:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1719350682; x=1719955482; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gq8Vr0aVYkgo0bSzjSaPaFgESu4jvyQ96EXjHbRRL9g=;
        b=a2sjO/Hg1uWCxJwm9ltp2983cbHXQBX2hA/Vjc27PaOZDx/NXbaeoYPPe29EmnlaBg
         20+2/+am2LMQOV5pjgtztnvbHMytVDN7wOTTJVHNM4wyPkA9cwoT3JsyVaHczwFWywGL
         BT2kGCVr7yGsKlVIObGf2k46CQNvDKIcXixfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719350682; x=1719955482;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gq8Vr0aVYkgo0bSzjSaPaFgESu4jvyQ96EXjHbRRL9g=;
        b=rnkEXQSvvWczmDVUF6LPYU9IWIoo/+gkEccSqqFDXXuY4PqdH8vl992leUZxAJ0Z7/
         NGpH8LPpBjn5eGm9y0faAI9RGGwbM7jmRBLB5DehJXP4LrJn6iHzSkHI2cMogNp6ndC8
         +RO1p8i7dJ9Qy+L2UdmT2mN7LvFN5ZRgyXOoEncPyazauaTWK4jS7H4+9qQabyebNy2F
         LSApJG6LPFPiddsgJVLprWWBYGS0U3/45nVGdv8xyxtMmMWuDlbneStqlcAERW65t6vn
         5pzkfk/u5/UK1ntNdVCm5PkSeBxalCr4/NBQOaPCo4CHTq2XZQpXH6M3eTSGyg19YEqa
         Nh8w==
X-Gm-Message-State: AOJu0YwRxo7QeLN5gJ5Fuzc9H+AeLG63oL31QA4U1Nlm3clMDctwCTMo
	txtuOmBcq6iOSLykpwXulqL7FweOp0XB4XK/bFh4Ux48t5kQTAotvGZ2afmtqbA=
X-Google-Smtp-Source: AGHT+IEXftu3PDBt6unrIK42kaT9PZZmR9EuAq5kHQmhySuQkvNlwOHsh10mIITw3dzkWfWG2eiacQ==
X-Received: by 2002:a05:6602:3305:b0:7f3:a20e:c38f with SMTP id ca18e2360f4ac-7f3a20eca45mr930160039f.0.1719350681125;
        Tue, 25 Jun 2024 14:24:41 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7f391ff51ecsm234726439f.31.2024.06.25.14.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jun 2024 14:24:40 -0700 (PDT)
Message-ID: <251c5d41-a8b5-48ed-adf3-864477059070@linuxfoundation.org>
Date: Tue, 25 Jun 2024 15:24:39 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 000/250] 6.9.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/24 03:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.7 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
