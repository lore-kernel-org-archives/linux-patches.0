Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2803FFABF
	for <patches@lists.linux.dev>; Wed, 13 May 2026 16:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778688985; cv=none; b=mtuugk83s3qII1Mq+fNDBUVq5WrjYtlSsOWyLdNaYTWFauUVV7+qtjLj4u8WJp5dI2IsOeOf6itjAGXwy1Bi2/OwrHN1aEEfXG8uwwiiGvOLdf2EK2J1R7j0pATxt+JHwIcfclCl5TeHfKzZ2S+/QBwpJgWdjXp3onKfMmup3H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778688985; c=relaxed/simple;
	bh=XQTwzYPVURBlHWEdONVSVsJJzSDY9nkNJ3WY7xVrkA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YTk2afS3jJxgLQ3YY+BfC1uqoEANccFtECHkz3NmrHrL4w9gy5KcdHw51mVuj6zyvrjpglW6y2vmHWVUDL6RbiDkGsfY9XUjmKlg9+1r6rJW0RWapJhUHILjzFlXRRI7w0eNEJ7BBz+cHd10mP9TqEru67VuIo9t8APynuEKkvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEdWnPKU; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEdWnPKU"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6967fd0416bso3704258eaf.3
        for <patches@lists.linux.dev>; Wed, 13 May 2026 09:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1778688983; x=1779293783; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m6Eejlp7oSyunKKcN3YLsdzZb+7PxrsXrqFJYgS4Kdg=;
        b=UEdWnPKU6vtJas7HPgfjw4v2/wMrQz/gT6PLTBXsLC64T9SLadMj7WAGvcsWPZ6rul
         5W+y7rWHperrhKS0FLdW9QdSpv+eKBSQL0RX51BGcq+xuJh97hHwVvgF9mnhHiw60Bwe
         agdSjuB3wztyVj4RGNjbqnmyjIkclafHi4nnM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778688983; x=1779293783;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m6Eejlp7oSyunKKcN3YLsdzZb+7PxrsXrqFJYgS4Kdg=;
        b=UyohtIBKKnupg6QR18G0LlM4WSpqtrJyrJLI8H0+1VBeeLH3BppnPd+rTddC58v3EY
         gjGGLlxgP83Y/YMK2uGczTfbBa4ISvxdLNlSNL35CuUc1/y3zwsE6ASm04JsvapJaxGV
         /3qP3ntUNdmO34YNSc/eBaLh0qsz292qWQ5EpAy8Rf7J2wxJe63MUFM4nRVXr1ui4sOO
         N1JvH0gcTvNpoL80zuPlVnUyXThnJkx6iH6Nw4UxWLJbCfUWNOezZIqU4FKOEerorBEP
         FvHMZoPT26P6sdGCeRJY9+LhGzmPMZREnASIUcLngHgZi8U/fpncEZGif3quhLNzUVzI
         q9+w==
X-Gm-Message-State: AOJu0YyyCt3oCQyziQlk7JtVCcOv30+w9xZtFDCXiru6Z6PQs2arb3No
	e7buMAOqyRAxt32M/6fiDZk8bU/R4Eqs36aS8AspjTVvoqo6uQxPS691wwPAj4IvtDM=
X-Gm-Gg: Acq92OEY/0ZgLC2zeU0F6NwjQSE8Aw5zVqNEloqmTYRIYtFvFIUp1BEbCwwloTzPMSD
	8iOKOejvXHfgXIzIVSqlAnItOdJcnCz/mdAM4OD/9kxNR7HUyMg3x1Byq3vUhsdXCElInp0zoY4
	PqkHzzVWNx9H77U8kMe2jUECIQxlMlmqzGQvKG0yQNiz1pJ3D5WhRiZ4KHfkgI5RoZRpir+i5DD
	hOL4v5x3kAC5kVu7ycwoaX87ivSSnBU1GPXQC6JU1FbCNmvj8cmrN27nMnQd0W+PGtYKpgOgQuD
	VmoPXrMbNgYjZdJXgrZVIuWRMgxt5MMwEYjvLiqFMhWLEQk7XRMGobQ4MxvArANTxOjNpNm9Os0
	ynSHHB9OkMs6H8VXemLqqOg3RYS9tYHRCFP/5H6FVQo2keNokM4xYq+Qu+HrUBVJSRe9TIoPMWO
	Ii0Sw/xWkOumN5RJIuzQ0K+CQ+q+wc9UQ=
X-Received: by 2002:a05:6820:994:b0:696:6c93:e81f with SMTP id 006d021491bc7-69b7ab3361cmr1853130eaf.33.1778688982936;
        Wed, 13 May 2026 09:16:22 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69b25e0e79asm9499281eaf.14.2026.05.13.09.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 09:16:21 -0700 (PDT)
Message-ID: <b8ed00fa-26ce-48c2-9deb-a08efb1ef8ea@linuxfoundation.org>
Date: Wed, 13 May 2026 10:16:19 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/206] 6.12.88-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/26 11:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.88 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 May 2026 17:38:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.88-rc1.gz
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
