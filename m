Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FE23328FD
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 16:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775060456; cv=none; b=XPK0qGBYfvgI4AgA9N8921u+fIcnVyClwNeCcZOfK62bDY2opQP9pwExL+9aWhl3FV3sxI35tWIi67hd7q3PYN/ClPMdDMUxbTph99hgIv1p1Vugchm3LBB4mdR5XeP6vsgn/w7BlutnenrQwIIoauK5Mt1KrQ2xybYftLGmAkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775060456; c=relaxed/simple;
	bh=1DDtHzgrdfkKCkx0OZ6wRB0AX9NvikiGnVCz+Vob1a0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vEPw33y7voI+3G0FYbSU7IoABngwJXgGU8wVwsZuHE1kxqjvl6NtWci1D9jxjfpjbXFM9Cx1FPfj/1JkHYKjC+NjKHOMlfmhtgG2rWI1BrRH25MldFD9ahkHVSfBr74ea+rsFucv3X2w/0Ypp5yqE0e6YOb33q/NUUylSPRjioY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSehszt5; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSehszt5"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-46a9ae3f857so1779575b6e.0
        for <patches@lists.linux.dev>; Wed, 01 Apr 2026 09:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1775060453; x=1775665253; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3WujfaJSCGDeMyF313yVCjBGKmFvswNOtDRgJ41L3Qo=;
        b=RSehszt59CIG+IWYTvnm+8t/kMRPJwMwYrWHWxnOBmoSoTAeZsfDu9rmqi66mAcTxK
         5jqbbXZXhkZoBkXwsSeloJLNcvph/OxAp6BU828oM3KFFtY6xtj3sp3eYIdeSEDvIe7Q
         deEBiJScUmWsLDc5hfAT7+5afAg+Ys77rA1rQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775060453; x=1775665253;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3WujfaJSCGDeMyF313yVCjBGKmFvswNOtDRgJ41L3Qo=;
        b=VJP1VPuSvKbn8oeKbWO5Wr1hFGEYEOG/PZ75RNjHfM2GYkjuj7NYoyObQBdIILCl/g
         Z/wrAy9j0q1cwJde+whPFYVBRggbU7NIq2qtXsUxsF6r8Z8om9Hk6rSx9LAIvCkqS8qd
         GgBIWHTdeeG99tQhMGqyEq+DKGvhCk3p1Cr+RZFjvUXxKfz+1MD0+Yp3TnSaizaOz6Ys
         voafyXq7NjggCwAYPOGh2cRfkCIQmJwUe3nadPOCO1bojPmJbz05bqeTs41HWZYlPBF0
         opFFGxiEzxQIHxrwyMvocQWHecGQ7IL1Cr7iOqZe1sbjEU43G5oUvxc9febtU6wAbsEP
         XDBw==
X-Gm-Message-State: AOJu0YzM6TaKzKP4Djubw/lnQnDmpzNgyRDjApOtVlBoVOeFYkKRSgtS
	T0DyRVNnwxSHue9kJzDhV/xx1nT/UHRW+ySBlopT66u9sSva0InamOR+aI+Tj6n43iw=
X-Gm-Gg: ATEYQzyLZ7m3fOK6zKC/xfxU7GF0pjg873EvI3lYVTI5a3BeHyIspHQbJCJLAvr9Cw3
	KTG6Uyx3gI7CqV1xu96+gfD8bVFzEyyKNRvQg4SSITs9YRMQAOrEPHIo0c1+Rf1D3RJFOznpi9w
	e++q6vQwGXCyACNOpT1hT+7N3gT0woRUnYqoSd3k+TR9YcYZSJAHEouTNNxgeZWREfJOIFZ41vy
	JkuvsJY34JRovLQ6TPDkhBN6MxDoOtXAjd/xAgUYrKwO+09bsau0GpLY3UE0s/Gz8fUbU07p1E+
	4inugBPwK5Zn8yJw7erFNNsdNWHzcG/dclcQqMIHzxmdD8I8znlVqp2b0E/ofIyDr4T/aZRxHUT
	5dPVuBezA2zAqoQKwpTf5f8f0X745uSEetpQIGNjfyoJ43Izxo88PJFsMc66c155BrRskGEaBNc
	iU9zTpP6bknQ1YT/jfK403KeAkUxgUH6sQsEzaHmweTn5USQ==
X-Received: by 2002:a05:6808:4fdf:b0:467:1e5:6764 with SMTP id 5614622812f47-46d8afa09fdmr75672b6e.54.1775060453070;
        Wed, 01 Apr 2026 09:20:53 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46aa03e4acesm8942997b6e.17.2026.04.01.09.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 09:20:52 -0700 (PDT)
Message-ID: <5fd503e0-363a-463d-9de9-004e35012c38@linuxfoundation.org>
Date: Wed, 1 Apr 2026 10:20:50 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/244] 6.12.80-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/26 10:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.80 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.80-rc1.gz
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
