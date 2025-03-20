Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF1F223706
	for <patches@lists.linux.dev>; Thu, 20 Mar 2025 18:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742495338; cv=none; b=jRqVTPjZqNBa+r2GB4LIY5nRyv7OROmU7IQldum322gd03+rtxcb7tEmsELyPFwf1ZbNa5fpD85IdfIgfvyc2eA/SD2L6Dy5zrKanUYJFbFLDhrCizuIwssfEkGyLQH3t28lZ/iOwzJeHID7S9J5lBbWylfqq0Rh59ZJuawvXPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742495338; c=relaxed/simple;
	bh=Plfowq0KFer0siwzLcZW8/vSCVw400KQjHSjlQ4jkoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pvkLxEQt7n/SK9qDZfPnSQZMJAdv3ZUUgWPLJaoOxY7zCt775jIhtKIYQdahRQOOo82JIw1YHB8hUMQmgZmZdFP54AjJpIQPxUvA7yDBkc7550EP7YkiHQXOt9A+yOXc+5+4BP+xBQyj9jhOkoB7xOzFXDE9+rJDO4HWXlk34qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YMWjbWAG; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMWjbWAG"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5fc447b03f2so267434eaf.0
        for <patches@lists.linux.dev>; Thu, 20 Mar 2025 11:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742495336; x=1743100136; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HW/LIsGIPLKhuQXiS4oCB9/8flni1RJfR88TIPdmowA=;
        b=YMWjbWAG6Wwp5pG2PYEqPDVkoiDF4c0VhA0x/jF6wmZrMTP+P7l0Srzf86EVZNdzAz
         ibNF7Bknrwk3Vh3rLQo+DVZGw6VIyIY5BwlAfMJTS7pGJO/b8LSXb4Mm7IFUKTBA7FNj
         0qzc3xWQ+l9+0Ar7UnBPnVYWVaGpwtLIQhD+OyeJHGLdutGDV0qin/AaJkRQvZEAm5R+
         fCcMxM0jlETWu6gXdCOVU8Bj6q7PU6i9SUYf867ng4zdaF+02Mt7QrChdp+7iO3jRdpP
         yt+g9d2UWPr095WcxVT3QcreDKi/V+YM7sbyGnSDGUwzi59h4ULCxz7mf3etNaT/7XtK
         HnRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742495336; x=1743100136;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HW/LIsGIPLKhuQXiS4oCB9/8flni1RJfR88TIPdmowA=;
        b=ICRpbXknESu6w15KaF8oxde6LgZ7RaC19NH+IL0n19aeCkPkFJsVSB0TYB0bhjXZU0
         AxlOas+VPVNDDx7GYE1eBGOAqw3HMnLwdDefWBvDXW96s91fiXoejeWWKY5XD09Qe6vv
         5KDodO9V6zJyB5cSbEDh3wlUaxq1INmHHbH1K0JBTJXyy0Sej2PWJvBN+o1UUVRPK9fY
         6X/9JoP4tJo4uF4DdBNwefWoD4DlhheMrOgU8xrZVYQ4UTbhPLDQzZdL8t/ioNSA4CTG
         5YkNO27NSoECJI7kUEcBBEO+Cqio5WthaRCAOHbxPgJp05L+BB3XVGjWzga7xRbpqahV
         ZrIw==
X-Gm-Message-State: AOJu0Yw/8PVdunoBaE4LqP8hIIBjzFkq/5604v7/eBWawRbJcmQUoJH6
	1v6cXF3RRrN+kq7q1lKmOAn8SvozyHEW+YndBg8bMqFSta5j/nFG
X-Gm-Gg: ASbGncsqrjYo8oyq5SdxHYZZeptUo28tQGOQuW8ajHFKMGsbnCmDrKqcJtG3UBRbf3o
	TuTWWmqXOwvsjhNIwJupic0Fnp+HiFnrw2o57KMjwfGY62TNoiAaAr1AWWzr9sp+fY3LwBaT1el
	PrSxN64L3LSUrK8WvsggaY21B9FgtmZtuAWr2lWJvTn+eic2AOW1C4S/f/a5TU3ArwKtd71QWJR
	7ISbszaQ7Re2JDTIsRaZuQOuB+UlXq44yGni5J0Wq1DhB91rDXgG+p5QOBniMAfBEyRBeubaLOW
	cCMgh9yPixNHfXCKSXujTjkfKAbcsa9QRTnhBUXvI1AGJAEt7+OI5oA29MMjMLwWJpZvTos59Z0
	0FSVxPvQ=
X-Google-Smtp-Source: AGHT+IG5RgbMaiZlm951zawlAC8+hWKyontiV7Pl7ZVPI1+0v05juqySzCNKvVqE/AGF/77jGSra0g==
X-Received: by 2002:a05:6870:a784:b0:29e:6bdb:e362 with SMTP id 586e51a60fabf-2c78030f84amr359639fac.17.1742495335770;
        Thu, 20 Mar 2025 11:28:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72c0abcc037sm48469a34.33.2025.03.20.11.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 11:28:55 -0700 (PDT)
Message-ID: <8ee4139a-19d3-4727-8823-8130353d8da7@gmail.com>
Date: Thu, 20 Mar 2025 11:28:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/241] 6.13.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250319143027.685727358@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/19/2025 7:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.8 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

