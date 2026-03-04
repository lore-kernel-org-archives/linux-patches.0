Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88A137DE82
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 17:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646448; cv=none; b=rhfpgU/QG69TBReaN7lDj7SKVS2fRKX1R/7zDpa8cx43tTTwOlu/ihLU/hIkoKTNaYDWVnHotl0HZPF6NgtaE0F+/w1swVwoNEXrrkSrtRBkyK5lotXyzIlRLq6F4OCRoina2YzwR7oWPvcfhhThR3Nm12vCZmJ9cJcqgv3EvKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646448; c=relaxed/simple;
	bh=lyhuETUFgbcsXWmbTYd9lwW+f9JOzhXzkA98V+ls2OQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oGb98afyeisbG2bG/OldoRXiTwiiOyEx5xTu1GTcx9lnDTD2Hu/tjU07QL1u1iZfY6B5D8dH5zBdT0f9+FkoNIjZI9V/g4+kM4aLGRQwEh1AEzgIlSI0K15YLCqsTt6Pyrc3n41rLOSft9q3d/+OB5uZFpiYNbY1sbswseEt7vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BI9/S4EW; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BI9/S4EW"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-46391f4c1f9so4584213b6e.0
        for <patches@lists.linux.dev>; Wed, 04 Mar 2026 09:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1772646445; x=1773251245; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IfiUhb9CAEtVBxzFGoHFgkLPiN+xfkS3PmNKwc8D5vE=;
        b=BI9/S4EWncdKcCnmBIf7Zu1ml3qzMSZckv16J8p8Vbso8IqrzLVyO+osi7u4zRcTfG
         CsqzIrIihy7dop9jlFTBklmgWJpY1MTaPzNlX0Kxf+LAxe0SoWpF/NNvsh3qcARBWFrp
         C9AbPAGIxLp5POwj4YCMKNWt/PUrPm389nfLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772646445; x=1773251245;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IfiUhb9CAEtVBxzFGoHFgkLPiN+xfkS3PmNKwc8D5vE=;
        b=cquvaRZsacpcy46xzYd+mqtv749Qa9uSihptz7VpezFqHXyOoxOCKv9iQWIAuT4+Fb
         QtiQr5qK0xCR0n1mC5LqmmBZd3FMCGRrhhm7wg0pXMMGJWtDIBHaoAcz7tf1l9BXMftX
         AP7zhDllG/cNipYW3ZQEwfdDZW13/ntUTa8TqsO6t13/+gxAud4xOyd7EjV+rt+dJmNj
         bnOmze5bZf3xdIO9Xsydxfu9QYZf8GOAP0leTJ14HF7cw0OPGq6daIA/5xeEqHsU6ag3
         fn44sbMEtG3tH+TBRi7WxroHZG2fnFwvScj/ZebIMTmSBzVCDMK4KLtgPOx4xbDo6iY2
         6haA==
X-Forwarded-Encrypted: i=1; AJvYcCWDSU+ZYDGCDwFUSgTAJ1eF6/OVVZgaG9tYSCRYZEfz/5Jo9bCLiycUEoVi46jxh7IxVzZcudVa@lists.linux.dev
X-Gm-Message-State: AOJu0YwncZWiK30zfDfZ6oe3XnMm5kV8PTBvL1vDskrOSTlV1sb/6rCc
	eyktEWmXr+XVHM6tNFOpedBoOAMZ3vlM0txcxIAL+ASkgvULUjhm1XuaVWzzrz2F+AyHtW3/c8K
	eJ1KDbyM=
X-Gm-Gg: ATEYQzzbpg3MojiJ36HgKze1QkhXpHnuophIYQf/UT9CGPQNtK+dlPm7+4BfHmHr77q
	GolBKLUyw+WA9tYteVj0rJnDjxLyASDsH05t/O1pryFsfCRHpQ9xKYBX/okJRvjjWNN0uZVKBop
	aWXQyrbp9XXvGAJbClrTRwKiCcSAUPJNjD/lcUkBEwEq217Rr2XLtr+CqJO8tz1WRm5yiN//iw8
	NQkz3FW1aGo+NUg/IEJjvWpl0MhUXdNTHRM9XDpoKuILx82fZXMj+uXPDm1j4RWRD7/bMgVnIBy
	fsKz+saubJYbHL4PtoiX3adiGJIgKxFx+W7S2NcRRpXko6UbFbYvqkNmunXejRZDoKhdb6FWgsX
	w2TjYCakFQ5qwU4fS/IiV7HLNe4eY1SRirqwlWxlRItYkL5qDLvjqBrg051ER+NoCcl6m1d7CJ6
	PEjaWCTFHtaiRRlxsppf7peXV966obBFwB07Y=
X-Received: by 2002:a05:6808:150d:b0:459:9630:3742 with SMTP id 5614622812f47-4651ab9afa3mr1416852b6e.22.1772646444767;
        Wed, 04 Mar 2026 09:47:24 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb352720sm11903384b6e.2.2026.03.04.09.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 09:47:24 -0800 (PST)
Message-ID: <0583d74b-b677-4e49-96f7-c881dbec6743@linuxfoundation.org>
Date: Wed, 4 Mar 2026 10:47:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/850] 6.19.6-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260302160834.2518716-1-sashal@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260302160834.2518716-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/26 09:08, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 850 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:07:42 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.19.y&id2=v6.19.5
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

A bit late - but here it is:

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
