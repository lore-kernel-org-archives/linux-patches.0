Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4BA262FC5
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 14:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752677777; cv=none; b=Ycs7sPkL2fFPggv/0xisvtoUmWo4h/VxiSEjHux30ECAyyEHUPTw4eOJuiBxJTTzOYMCGwGdRhcv4qo/TrC08Cj/bxeY2GewxXl6ALgR81fSi+5T0Bp8Ou/A4uoDJP147apfJfHFU0yK/kBryow9sSRocANzGGEQSj/uN33xwlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752677777; c=relaxed/simple;
	bh=nMYQIUNNbhxTwKtjAj7dPAqrvTYfVjiLl0qUeBv56e4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RhnfxNIoysyqEjQ00FJ0n3aqk0rtLr1V4NOMIZHW2ruqHSU1ea9yqpBI284h5eoZoZjI+RSqfzIweyOVNNHLB3e3RaW/kHqjgilp/w7EV9+fJgS4hk71abl9m9stsDb0QoBkld+Ysvsl+RNvrvbMrh/IIkasP026tX5eysxtyIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1n1tJNc; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1n1tJNc"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3de2b02c69eso40714365ab.1
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 07:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1752677775; x=1753282575; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EUVr6thTEstHKrPJDWmNddZkR2T0nuJlZaUbFO1uHtU=;
        b=N1n1tJNcXkd3h5qjwYS8PT5oLOrS3GHNrc49dzTeO0ATYl06dY9cCzytVHYnnSxayA
         q5T8Bw8l9J3lL5Vs2tIIkgx8/O2JnOZk8QRpMF/XC4jMlKAcrlaWHobxcGycKZH0q71n
         YbxqdnlzHrMpW2a0aElh+vT7PKDgmWLDZ/RtI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752677775; x=1753282575;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EUVr6thTEstHKrPJDWmNddZkR2T0nuJlZaUbFO1uHtU=;
        b=T09iday1pm+8UCtNgeKmA89pJGVlZjWyJY7TeeguxWol5D7Y3HFZiFKi4Hg0vHzG7A
         tLG1b1uJwL2zh6c3q5IK2JXTHkQl7T7e5VZaP25NjO/hTnnDf30kHCqmFKJF3pnmbjfX
         BMsIF6uv33ZygmmvilDQ2zxOS/myd8UHuyyxUgRO1L0K/EKH4x06JOaOu52xKC9EO0f1
         RKlPuTDSL2IId8dP9GLI2oHAe1dmj3TJHjMKDL0gga+Tz8U3PSxM+4iHyjvWb/J2dxZZ
         gs37rhbV7BHGMfwNxe4sfyM1jrOVPKkQksiznWh1U4eiDwj5HJCKkqpGwL+JQWIeH1Yv
         zrjg==
X-Gm-Message-State: AOJu0Ywtf/tA+t3YMmzGb9LCjuoZTY56mj8la0eFEl9ctlGV8lhR/NIP
	dMtu+2WU2mZ4m++pWL3yFgj1G/COynidhzaMcO19WmHBn5PRPknYHg8+K0LxtemY5WY=
X-Gm-Gg: ASbGncvtui4X+DPlIeY7tsb1s1ufnL/oBmahfj8ACjlbwMp0VbV6Az7HURBlpDj/cCr
	S1pDmUdxRwhnyCONgwjNNpaqamL8DlQjnCw1eGNh97GXkgV+BBHFXVMfyL0rqModV3gvkcH4bQk
	WrLwPRmNximU+QNaiWyRtXnZ7meItDqF3IO8E9Rahw/kHvH0KOMtk5HV7/UTCaB9PAxSDfE7Nx/
	YLhT08/KfKE1d14fZbRtHNT18F3uj18T8GjOuPF/1FkHHn5cxbgDeRJtmauqJ7Fh33nGaUwDbEN
	UXIaumPKalafcbxeH9IqMU/2s3j33tsy0+L3uy72Mre/2jq6HW6xnzMaST0Gt7Yw5Dd8oYq4xz3
	wfxj2VgKE5MbWAk2gwP5txWEKku68DMU4NA==
X-Google-Smtp-Source: AGHT+IEUsiRokRBvipgW01VTedaC+V39tgfxnOQkDTq4jt3Hr6rMqeQ3rVY4UYjScrCHYSad8Y0i/w==
X-Received: by 2002:a05:6e02:e:b0:3e0:4f30:c951 with SMTP id e9e14a558f8ab-3e282eb1858mr28608415ab.14.1752677775170;
        Wed, 16 Jul 2025 07:56:15 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556536065sm3075868173.26.2025.07.16.07.56.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 07:56:14 -0700 (PDT)
Message-ID: <3f0cc5fa-149d-430d-844b-dba70a485ffd@linuxfoundation.org>
Date: Wed, 16 Jul 2025 08:56:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/88] 6.1.146-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 07:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.146 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.146-rc1.gz
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
