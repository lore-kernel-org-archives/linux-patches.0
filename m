Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793287584;
	b=GvEVDY68J7mDShzutIfec1gQEqTqwGvKxO/AyQJa17DxpyCWStuM8ufUuPtsLN/Zt4aI
	 U5YgG+2gQDpa8Iser5/aEdwOthNqxvyZWsHJrqL1UfctKHXpHGaF/g8FS+Q9XW2KFrgdS
	 hoGCdrkFF87oi0oQ+fBOxJuvehOYKWByZ16+d8TEl5xVFSDVqtFXvwr4hFGsNNCnQGc/x
	 QTuyjcPnJZKMuBNcGykUyH685DzkeLYcIGZjDGsdWmIprUMUE0chDGHd34E4V21X2Tuqz
	 7PEtcI9xxeai2/NQ/kOtS4Jl2EyKQ5LTf2Q7oN8l2Qw92dnXAS6PCC5V9ylqhBDN8Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793287584;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ABoTDXyOtvkcn7EUfVmTDlnC7sq68l91R9Ze2UwYLLQ=;
	b=WFf6bKwwGOHJOoDb9YzLENEtOPrf0w6edMXfYol4B9oZ8sx92R+cyhnJXcHpJ0fum52A
	 JMCHgo5ygCeSj1h0G/mTDvv9c2q3aEdk6rnRjLi4Lupvutqi7r+eRg6+xkZNnlnNzQqY0
	 1aK26xrWI53xe0xGo6ZyV9NvWAwNeuYGrSL5x6kIsvyTnROO+ADuUS2+aagqgXs8NZdMz
	 W5wKoyfZnK4PdniL80W8dsTUAgmRIikCzpsgckVVygzq7laMSlC+BLPoi3RbYG7nSj1sM
	 uBdAX578v8zsO0NbmQAMLYYZqLaPDS11qfZG8jJWAEupP/gwIXQM9ni8IguZR02MZxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=GJpO1Fcx;
	arc=none smtp.remote-ip=209.85.161.43
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C14606A31A
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 15:26:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0C14606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=GJpO1Fcx
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6de1fd5f572so1105143eaf.3
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 08:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793287581; x=1793892381; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ABoTDXyOtvkcn7EUfVmTDlnC7sq68l91R9Ze2UwYLLQ=;
        b=GJpO1FcxwKrzKsD/Xoqhv1I9DiZRJhHurqmE4EeQMXF0NnFa4LibWAjB9UOjsNiAzr
         2rEpaB/OFdSLVq1kRR2PLtP7Bx86vubdD0PnqcqTgoXx/SilX2kBO186rvlOIBa/mMuo
         PSXzL9JHUO/LSWCA2En91uhjjYQM0mPh91Tno=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793287581; x=1793892381;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ABoTDXyOtvkcn7EUfVmTDlnC7sq68l91R9Ze2UwYLLQ=;
        b=Z3TjiEuLBlvD1QMTXrqHsLEamu1SaxFpKLUxXWPG24NZXI72MzChqTGLVmuwhjC8NM
         Co4SKZg8yBSmZ622+TeBiWAtM1RQjKpj7RVPrB6IkRIfvowt0rQ+LrMe5WZ/u6mtkRQ0
         qZvT8qoNzJuDBLHTMYpM0M9D5zTj+xBuyJJ6bKZV4E+aShtmyF21BxdcHV6l3W6LMUdS
         yrFHp0yhQSdqxWN5gdVfLDI2cAkXSuqGEAn2yTYuyOqoMbl2P7yXtG5JBvUNdG8P7Ryp
         0x9ht8vZ5O6xlcD6oGSyaJ+a+PjaPS6yNEZV1wdiscmaIO0yDLijWd+hOHS6DBG5jJhZ
         cxDw==
X-Gm-Message-State: AFq9FYLtE6irMme+bRg4V4amBfUwPzynbzsT3rbwQRAI+kTrxXglK67Y
	S4rwMn3dI00Tc9/xlDbig5d9UkiJS8zm25+KZvdik+dc0ZnWOv7TohP5qyjbFHeIOgo=
X-Gm-Gg: AYBFou2JYwxuYiiPmta+AKG3174XEi8PVH0m/Vc3xdSDMvyfmvTJFqj+Y0moapwvI2r
	W0kUh1PPFBXwK9HtvoSCLLiayO8sVpNEL78oOJIhIKKT6vS3EP5Q3q738XXLDvAGk9mHjABLy+K
	eWFk4kmUOmyOWUgrQE1qB1GOljGvhLVz7r1/rQUNHUqmTamTh0Y6zf4dg90aRrRYYRNvcA1rcIe
	76gjV+OuXCveSJPUknJlJCLJEYb1rqvzheKxc0UlR+/PZvv1ealDbqMrs7Ypc3mTqic8gkeyDNq
	m4To+YSi8FaMGqWro5emZIVhNf19tii2w9jGXvjveIrNOU6EU4qtQyOYmDbZSmWd+bXmwYiFD1i
	lX0FdEBK69T+Yh3HesLszwkK0ps9kCUUtp+xhbfxDoFOymw4jReS0ToJsTTcJ0CtNwGyzCNptJY
	yhyd5sjuWbhVZJmXZb3iUhWehUA36bZhz8y54SM35JsmUwPBT4m/hFQQ4r2yhKuwbPkE4jOBD18
	t8nlO92onluUYXvBZW9gxG9HuyW6YQlK6/J2sr+kFkjfsFKEdxeHgOwCplUzVzJersUZ8MCvqZS
	bj+pxDLuuw9ueofh/hhSyIVheu6AnbXqNwSnU0/0Jn/9J+VEcUXo4jVNCaU=
X-Received: by 2002:a05:6808:178d:b0:4e9:eb70:b98 with SMTP id 5614622812f47-56382680c8amr4552456b6e.32.1793287581613;
        Thu, 29 Oct 2026 08:26:21 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-563c5a4d8b7sm3701051b6e.8.2026.10.29.08.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 08:26:20 -0700 (PDT)
Message-ID: <554ef84c-a307-4385-b244-007adeeb8fc1@linuxfoundation.org>
Date: Thu, 29 Oct 2026 09:26:17 -0600
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/247] 6.12.115-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 10:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.115 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.115-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
