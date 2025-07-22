Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8611327EC78
	for <patches@lists.linux.dev>; Tue, 22 Jul 2025 19:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753211818; cv=none; b=P0d0AiMstutvbxux/mgYa6TiIDF8Aa/2bGYri1XQbRjWToF8Bl1TrdujWoKEuzNc/c3nnhglJXHuaWrAyynXUQqahNHDqm5RUTGcsEU3YUfL7zADi2Qbf6AzI7lVvxpykfOBS6UPhVvbnThpquoln42jkG6rFh5iMSO9z8N4Pvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753211818; c=relaxed/simple;
	bh=dd5RGWofHC4xPOJvaPYCb1csWyG+efVlR+JerfWTlp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KXPbV+f/jMeHvzoUNXP5oxuixDPRPkc4ngalBd/42fgJR0u5iPgF6OKkhxIkBbOLNa12v62Hz8iVvVs0nD3py9ZOeJyzXxAkq6x4312PK5hHxUpx9j0smO4zcPuP+q5wdnzQE/LnbI/G3FfnfGOD9UJnm8zwEbP1UIs3bCM8AyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RFiDfBI6; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RFiDfBI6"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7e1d89fcc31so586635585a.1
        for <patches@lists.linux.dev>; Tue, 22 Jul 2025 12:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753211815; x=1753816615; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HezAxjd9jV3el2JNP/W7rwAM9i6vSfM2srD0goJbh5E=;
        b=RFiDfBI6e1Wo8VzP23pjZvCSx/53XTtap1PGy/oTw+hyYLvfN5uqNrRqOUmhp6AS5Z
         AtuGv03qBDa0rF2/6Pod8gZKbFDjNIvburFtsKkwzV2z/iEsVvWjrwNah28hL/i0wWcM
         hsOuNf4I0bhEPzwFyDbVY9ODiLrsap9C3EK70M3cAKKDR0ZeV/LHhRVXRtd913Y+eG1l
         /Cma/JkwJiHDhUDrWjjsdkzp87GvioA8aIhF5CgEjPpPxMWZS/NlFRNGyj3Yke64oVtW
         teE4kAqszkrUx57vCo1WH7IYPrkrwdpSCGKm+nspEdJknF0ilkuWM5FYwoYyLHTA97Zi
         ofjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753211815; x=1753816615;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HezAxjd9jV3el2JNP/W7rwAM9i6vSfM2srD0goJbh5E=;
        b=sR2KCgZ0iI9VSwnv19KnTOaBDLi/Ta3aE1QDMgjymY0gD18PNpF/+bDceq4u8rCeWz
         x9K6wnLlwFic8gujZug8aPaPLP+bF2/amrVWDIf5PRbI0NrUEINdX3Q5QxVG4WOs20TW
         cg667qCY2S4csKCEeaxFRFwhEPuj760eKqTXLE7od1H/qswKYDYOizZwMM52aMcyJkAT
         ytz5VRNjesQGQ7m06Wc2S6gVkwpMD4mcNEJz7Mx8cv2xF1rStyF/ig+2AHseZxj4c6Up
         NznJmKRv6fmFEuNYFnboI4BTqRGlVcEVW7afosTuGx9NsJgOS8Xf0V2A7Npl6Pun6eRQ
         llhA==
X-Gm-Message-State: AOJu0YwR+Gw4LrXMVl7ayIyWVW9wOyucce6TJ9eh6elYUAj+n1zGX88j
	BYUHqd/VUBeQxP8vdbcWPJCZeomnyRfQMF727TX0iD9+1rJkkVn4Vs5H
X-Gm-Gg: ASbGncsnS7SeipyHr0IJc0GEhRu343Y5bN9aD7O4L0nA/XDP58UtGZjRqsOn2SJYl1T
	79Rxyb4QBcWp2jJxN/fnUA6dV0kx6wDPKT9Cvc79KaZGvx0NB+fI5HrSpSwg3j2VADLBwOEq21F
	F1egE7o5pztiUa0njKFXt7HE6oGIhFIQ5dAtkoioZ759fv2sfxpiYnZQPh7fX23AG0Y8/rTMi7o
	LgskEwk8Yfp/lGlx7k4+EylYWed8oDZouP1O+NIA31cW540CpWGDlpIUZcQRNn41hSb8EorxKih
	xETAa6u8JswuumLQ7BGxLWoWC6MU5O9azkj77PxU+QlXMuqO4H0nDw8N+PnjPtZ9r0EQJQgLOWT
	Ac9xMWJNYSEmb5PLA9G+CtaD6tIJlkX7lwucFsNYGzqqyW1/5HQ==
X-Google-Smtp-Source: AGHT+IHQ/cixMvkcUt9nivXutdja90YGJTdFNISD6ryZBEuFB6UrhR8v3P3q8XPTO9cbxX4eKkqjrQ==
X-Received: by 2002:a05:620a:13da:b0:7ca:efbd:f4f4 with SMTP id af79cd13be357-7e62a18d3c8mr53078485a.56.1753211815067;
        Tue, 22 Jul 2025 12:16:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e623ec39b7sm92654785a.79.2025.07.22.12.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 12:16:54 -0700 (PDT)
Message-ID: <ebc60d3f-ab92-4ec9-9955-d22046caf7f7@gmail.com>
Date: Tue, 22 Jul 2025 12:16:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250722134345.761035548@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/25 06:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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
