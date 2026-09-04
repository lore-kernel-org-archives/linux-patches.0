Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D2152ED39
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 21:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788556247; cv=none; b=pldDakLAVoMtqEQ7eSQxA7IkgJaC1KmfYxrmLUVRz+F9rZiflnhUnBhTh/ryxIk9N5FXoCh/oJ8KUpLzTnkIY4KpXW/wO2VA9Ml5PORLhFf6NIYW26kl4oam4k6BJXe/MUXsq0JBX74fLflMSr3jpf6L/+zJ+bHhFyKhmPghVDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788556247; c=relaxed/simple;
	bh=AIzN88yObhLJ7zH0xiBeiavZN8KhADkVakFvDUmpWMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iwQs5klUqeOq4LVfTsfFyEYM+nzawFkKWWH5tAJWDQUYwyDS0TgLgvX7RtHr1vS4o9B5M4YaZD89YN30QDcvFx+e/snkt4GZQ91DM2SzHno+3HS7+fANPexHU5S//HxNcw5Z6RjmDT7t3FxPOpRTOFE7DTyBGTiXbBgRAFR+k7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYEYPqCS; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYEYPqCS"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6b1598d3f73so895317eaf.2
        for <patches@lists.linux.dev>; Fri, 04 Sep 2026 14:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1788556241; x=1789161041; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zZQ3f33CzKvQ9e9UVdtviBIiGT2nRTtAw71SUlTm2xw=;
        b=YYEYPqCSkNCJnNIpSGeBptXIstUtDzcg0+0t0FSIMFL5TtIHokshrob9PIfkTk3+gV
         b7yJbQ36cKqDphD0Thu/4eBYOxd+Hz6Pylv9brqfgGgJF0RFgLUqqUiYCI7+bRxWiIUn
         E1wvfYIPhnpG5NpB6eELJrvyiDW9Pb0BOjv/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788556241; x=1789161041;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zZQ3f33CzKvQ9e9UVdtviBIiGT2nRTtAw71SUlTm2xw=;
        b=oKLULcNCejT5lMVGlTqAc9paDwanVeNXAxIAdI2pEOzC36AFALdcSHQeZdYEApyieJ
         MLV/KkYADJaJIIuaC/nWhFDDZYMlbaJ2J37aVL1VqxakQSoep+TDc2Ma8tr20xkTXfmE
         W4x0TtDMhKPqNZPlPou6xaaxvEhTfdAMsEYULOyaj35flwVn4mdOSr5VVLplsZcaCUyF
         OwDKke8JymQUp0sZam6fpzsBv9QIT4WveDEUZoKxJD3Oiv/Qml+DdTWScx5qJvp4ZOYy
         KtEitTxXNh7nEhb7W7pD56LLOGGx9a1APkCi5aHCghpouwGGFIlRpccaXGjTcnbniuwp
         66bA==
X-Gm-Message-State: AFuF++kZmkoLU963m7XwFssFZg9f7WxtubF9lEVQU5ytnGaJhQIblAlo
	pXC7FKrm1LVZPANolZisi8iNZInsrp7VBBBuV5ZaFLg4mkY+TaCe21OJTJxgAFFeflk=
X-Gm-Gg: AYBFou1UQmJKQW9dNLc8FWy5PpuOrhv5mq1Cov9iAd5xyH9AStyrpx3kLf/Lag9pQNs
	5kjQ/J7XZtbEZ+klicBo6M6AloKKRSToRCsds+GWGXqRdGVSHUeZ5yuEbFCkylYKe4C97iBIrmU
	szRZHXbzFvE6xi4q9W5uCFXtsvdXmDFtHg7+LQMagMpYLC/1M29nhrGH7OumxtAtNv5e2JCGkxh
	5uxMJXv6PYc660hKoAzezhSrVbI2W/vicUIk/bmowvtJS7TLeVgEJnZE+YcNWxT7Jz89uGgmVJj
	LCG4dQ86UwX1mCqEfCWoeU32eOUrg+PdAJkC/XdhHRYIH0PyUz6iiI567gJb+mYUGA0uO1pgjVk
	mUoJxwPcnC9E5rHCU326JCUcUQ0RGp+sG/6/485eDDSIcYx4xP3JNLaoMeMvzG9AJX/mrF5hK25
	dTrYJx3xGSBm+WP7yUaDvspoTobaU3XtJvHWBIPHl8iIWADqMWJ7XAxBZbB2/17rGFBOSw
X-Received: by 2002:a05:6820:168f:b0:6b0:4199:3cc4 with SMTP id 006d021491bc7-6b6fea84e5dmr6631267eaf.27.1788556241315;
        Fri, 04 Sep 2026 14:10:41 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b6dcb85a61sm4575639eaf.8.2026.09.04.14.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 14:10:40 -0700 (PDT)
Message-ID: <6372cf4c-3bb7-48c9-81c5-cb828a1b2bf0@linuxfoundation.org>
Date: Fri, 4 Sep 2026 15:10:36 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/552] 6.18.50-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/26 22:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.50 release.
> There are 552 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Sep 2026 04:56:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.50-rc1.gz
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

