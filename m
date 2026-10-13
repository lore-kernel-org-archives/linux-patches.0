Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162493A5430
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 23:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791933337; cv=none; b=lnMRvhn8MYbn5IZ+mhdrSbL0BKkxxuUYWQv6zFc0p780x6+Fc/+9XrkbZmttSwbsk1N9PJrd1PJzSkSfFWk0d2mU/YGxBNXOqP0B0ausa5XMXfTD3eg2oYf/7QLPuarK2iP1s/n0t1+eZCkz+suchhFaLfN4wDzhNIB9pA9gzOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791933337; c=relaxed/simple;
	bh=bJtFuAfjAsK2013vUx7Og4Fl2Xotxf6AIMZPLzNs+QI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uqpVOHezald2214N83pd74DOKo55n48bS2kJVgWaZPLrSTskQ4no3Ua5+AuzA5g5d/kvxRaDqQMC8hVEEmuNxFza8WxYTysDBD3j9y0fncwDDFFddtnzPU7INh4VZ47tjT+aH21NzJhHzfQZn0orIS6fzcE9zwZ00XnVaJX91pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxaRzvof; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxaRzvof"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-83bbcfba0ffso660271a34.0
        for <patches@lists.linux.dev>; Tue, 13 Oct 2026 16:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1791933334; x=1792538134; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dmwu/a/YbEyOYEh3D24w+BEmPqrGxVIF7pjSO5iEBzs=;
        b=CxaRzvofQ8bKPJTZVX4zTJz0iBrse18drCPExuMAeHcJvgTRbNISRqUHnIB6QB/txd
         SfgmbDqStwmJDYxOQYbeOhDZ9E2r8KWHXuK1bu2fjW8Y55r9VGXk6wjpvSK/0hGW20ih
         Ev3HhHZzStvQ634XYlKbsfATRVupzrLyUFqS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791933334; x=1792538134;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dmwu/a/YbEyOYEh3D24w+BEmPqrGxVIF7pjSO5iEBzs=;
        b=BgsVRTvD/69XGTcKKA9cOmAtvGvrRUqccq/j8/5QLx0EMBRn5echu5JJu20CdGrMlx
         3cqvKFDOhnKQRIOPkoiEiBxAw3LjXuqdnfKxJ1/b1LoOmIx5gn2128d3fKeCQTeG1jpY
         DN2EOpHyRGDwyjuzww1/2Bpr6X91MRnXE9nwJK3raqhYvxG5J9lbe95ntOmoTQiLhGOh
         82zRo4APlTPx1RkkoIFbqEFcw0+qDz3IXypvbR8nCNJHMy/UfrVnLNeGQzFX4zexSWBL
         Nu7D3jcy4eedesPuNWpR2q4diVKwW5Cw0ALSwsRJ7qKU1exv4xJ0ot02sNVP+BjeGbWi
         PLsg==
X-Gm-Message-State: AFq9FYLAkx+8N4rp/kJtmoMaivHv0B62lV+kL50pimQysxoTDxRy2hpE
	MA53JKKNQrxQZlUEto3NknSI5M6jJBs5ZcSiO5jIvPVo2ByW0m6j2Ft2NxKGzZAKKNI=
X-Gm-Gg: AYBFou3EhKLDdqkawts+0q/8k2yE9x9F0PNXCpFi+ToZ7Vn5D2bRa2uHK774HZgjVNm
	q1Jc4OyCrenLbN5QRyJLQoLST50oM1AqTixkEWXdBY0QUUKLEpmfsoPac2xtpp2jsaMPcQCgOQj
	0urqry8EovSPT3XcC4i2a+EBI8p4nTLRM47/IfJQIOcxo0WMPt+fhupVN8GUAvePcJaBnr3pUOm
	enKPd0hCplsvswx65GTSIax69tR8LrBx0HG9ux5Qe0Nu7ihHh08lAeHF8vOfD9FWfBfPISWwLR5
	eBF3scDNpjWeL8gwPiK94dyEg6IENqG0snPsnBRhiBpNNTzJ4dpyodftvCi4SP9Te9/MYOn+zoz
	7TSHE+mEZq01onQGj0bHdy19v8k24JKvGAobihuHgVzmQYHbDdq9COYKhn7GRT9/kvHFT62SqXd
	RYYz2Bt1tzvgVHxYkYBXga2QKUO/Yf+NUHTo1s+01fEeWpoIQL4dvW/Gu3gmiQ0r36NY+SXvGFE
	jvJoW+F
X-Received: by 2002:a05:6830:828a:b0:822:a76e:95a3 with SMTP id 46e09a7af769-8308b71a774mr14023795a34.0.1791933333694;
        Tue, 13 Oct 2026 16:15:33 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-83618a94fb0sm8058530a34.24.2026.10.13.16.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 16:15:32 -0700 (PDT)
Message-ID: <b63c8496-a3b6-454c-914c-1f94b122b4dd@linuxfoundation.org>
Date: Tue, 13 Oct 2026 17:15:28 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/497] 6.12.113-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/26 05:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.113 release.
> There are 497 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.113-rc1.gz
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
