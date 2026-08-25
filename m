Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF9A3F20F4
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 23:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787701038; cv=none; b=Hmy89+A7D2vMV+VOgdxz22fgHVF3uVKxykFrGgCckV58BUbe0W+GLIAVdu0To0VnfDVWmSEfx6UXjGmmGMAOiZUR6kIjb/A/ry/q8OUs4O0pom6T0wSnJign0xyZL+JrnvHr54S06Z8MfIB2kcO/YmkJACyV83Q17fYQiRuu4bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787701038; c=relaxed/simple;
	bh=wskty0mVPYIMPkpNAqRuO1oxlxIJdMZjXtGTYJABBKE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fgVenptmODCGODXbOt0aQf+yYregvm4bAaJFl+hkisuZEqFPZdZI0bGIQpDzizXgU5u82DepVkeA2HH4S+wmgP13EFK6Seditjc92/AhaKjeO/VjHmvp2bap6E1WFRFcQPhlizrGhvtETM7fLgCmCUDsKZvTH7rJgKszgMt3e0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WArqmOCX; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WArqmOCX"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e512a9a6bso15401385a.2
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 16:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787701036; x=1788305836; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r+qRUR8BM/qOZCJYtmajcdF7kTP7NMvMBM/jMJHKHeQ=;
        b=WArqmOCXylWZvaXCau5tEXBdEobkl662GUBiU2ww/8szzUGGerrKWUiF7v6nvQfGTp
         LfOJBoXF1jzw45kIxLnDtirnu1dkzwRIUMjtTDIIApBvbfs28dJZKwPzcbDyneMjxVxA
         s5oeYGdc8upALvI3qVDwYIeIZh8GSvOGtIvt+k9wn1c/peCo3L54AP+3uPhNLx8oWI0A
         P7VEuCSgIHIT7Ml0DJflgng+b9hl7KKV+fJgNtalAJqUxmsgGpaBdraikY34Ge0sNZIH
         K+z0UGrfG8YzI+7bH6J2tBTvDqHS9pA+VTqlA/5n2wy76S6yWd5pmTJONQ7tJy47aYgK
         bDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787701036; x=1788305836;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r+qRUR8BM/qOZCJYtmajcdF7kTP7NMvMBM/jMJHKHeQ=;
        b=mO/+LgXScVWScZ110IpNkmr//2m/yw5K2+6WthVcmBf92wBG2Y+zSjgk6408DyIhT8
         wACUYYYsOch379raIbNR4ER5HImKh9/8R9JKk158VbrJH5vILngesU6I4dc+MYKooRzr
         qLNzDwnEL52SFJ4kfz8EITiGkmMxQF4wVi0/FK7bYua2dpJIQ5pqjO+vrXG9rCljEjyV
         K1lPH7rh63PFz/d3BWttbOfaXkJ+RSkIm99ZsB4hBGBl5+Z/JrRMtPSFmgPoL7ANDmbo
         2HLdSmJ5QumwXAVQsU7q+XnC/x++C3lKP9mFtCZOP6ol6gu5j01bTk5CiW0v4Bod4ZVy
         7tYQ==
X-Gm-Message-State: AFuF++kSzBmTRDlPzTtfkcDtxfoBudMhFJBBuVzNKLvdwklGcF+blBuA
	05EAZDHNuQIG1DZx0YzIr2OnrpsD5bySsVnzH9AHI6U6fDqEO5JorzfN
X-Gm-Gg: AR+sD11LXxImFlrp+GdpRJD39WGlOB/ZQ/05tX0EvtQvglD5eWCw5IHfyLfrMhz+DA+
	k3MroyX7M0iGMJ6tBmM4rYhGCYVrwmClLRpt0cERWvbeGWR1ASoO8t6XpgTBXY9DVdyEDBWqIkQ
	83HZxIHsfbXEjCA0jJ7aMDCTF7WNFbiVEmVvpj94wdD+2bQbExpCX+sgX81zTLQG06STWtJ7hMc
	GH8e40BSvncI2BSDltjPI5uqt02tOop1COsXpB2toYHHkM4JjIOEpzgsCb4L35kZWaHFvByPQb/
	fTPRSHxDuy6mdQxkHKsPFeXj9lIRld6ywMxSSbPehYzKx6Y+Tz7Z0kRTB+CD2W4EwjI8ZOqLrd6
	j3cZVwRyjelggaw875WXJwEIqkqmOJWaL8mb16EBrs/TlhTD0SniYYCyqkKegkPFLXNeb/ccdC4
	m9udMm1uqeUuPZlqbB57yOeht7NL+XvfJ+TEVbXNi6HQNXxgYwy5Qg5RdEH0XPZ5snY6xacc1iq
	WVnMmaBo6uiIqQAehATWa8fDw==
X-Received: by 2002:a05:620a:618f:b0:923:7821:dc0d with SMTP id af79cd13be357-93780446b68mr257224185a.33.1787701036142;
        Tue, 25 Aug 2026 16:37:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377e6156ccsm87926485a.27.2026.08.25.16.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 16:37:15 -0700 (PDT)
Message-ID: <98ddcd6f-b735-44d6-b68a-eed16e68d0ac@gmail.com>
Date: Tue, 25 Aug 2026 16:37:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/101] 7.1.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260825132541.986300899@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 06:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.11 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
