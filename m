Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59447345CDC
	for <patches@lists.linux.dev>; Mon,  4 May 2026 21:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929318; cv=none; b=pWgTnGBIcL7MZ/xxT4RdVgFm14p0zF01jhUZPq05sVqxQXJWQJSa1gGwtDrGMu1eypI7PdQjbqf9DmDABynNTG62EgZTV3U4u1Y4gF4DQ2qgMFVngJTzmM1QBs4t4JnR5sSvRS3EWt1V0jmp9f7f4Idf6spB3eTj57GEneSgpxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929318; c=relaxed/simple;
	bh=ZcwHhiQBeuto3+aHd1WgPtJBNLW6SzFA30xH3EUIueA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DJgy8Ug59op4ELiI4Z8ko++y+QEB1tX2W0hCaMp1GvSJgDf8oYRKx9vcfYOvhvwm2o/DkGx+hGVRhWmamve9MwsSlq/tnXRSEXwp7QwQh/tPcVhbG1j26cZkx30Sf3w3TWZ5Skr2lyY/31RIEpn2nBwzNshKBRlFh5q9W/1erEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RV+/b1NK; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RV+/b1NK"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2f30a4601bbso1231480eec.1
        for <patches@lists.linux.dev>; Mon, 04 May 2026 14:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777929316; x=1778534116; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T6M6O6vS5rinWV9bCog50NLyMYBW362x5+Rc5/13V6w=;
        b=RV+/b1NKjpQL369UUo/S94rAqDHbt60Q3zV/cKS/tYA15kKjPJIH8Y2O6h9z5YCZpZ
         UMxp89Dcw/9pKhbmboJhmnYaUw+V++XBzCmyp/VW5Yb+9CpsMSO8j8D+VJ04wrnjjtJI
         4M5pw978owY5lh7mC/RTnF+5iS+DOdXpO4o1jFxIIkiwyjsggdEmoNqRBhEpcS79SXDN
         xnx7ju2fiyBiPIE7/ymVQ1fPxGcewY3U/8O3R3vcQWUQW0UG3If8HtcOStHHDsu16WwO
         b1CnT8xN3oNJRVL4z3x9LSd52TD+uiZwfZ2kupkm8+WdMUnHTjpmk3eC3wfpBvEe1Kg0
         KbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929316; x=1778534116;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T6M6O6vS5rinWV9bCog50NLyMYBW362x5+Rc5/13V6w=;
        b=ZKcd/JPT/XldkHtkLMl3E928wjvUfvQOJNFv0IurtsdKV8fIY42+61N7SnIyVSoQfU
         3hAiq7cGgznZwFU7g0AMSvLJsIW07wt3GEIJ5GkP+Z29uVpVUZCk5faLkT/d0FG6FCVv
         5zTU7YHmpFaCiW2KmWPf/4MQ8T42gHz7BJI5X05uL13kAUnj1l3YfnNlH5BSMudEzmZU
         Cnk32biwnGauRksUigp3CV7dYbQDIeeyVB/iDuBP3YTwjK0FzqBDs5c7dm6bWa8DFJOZ
         U3rM8onbfWeh3i0lLu/EWiJhH7407cgPFh8+ZtzCWUX8UGDTDK74f0qu1Uw+GreKEQWr
         ViqQ==
X-Gm-Message-State: AOJu0Ywbmfxr1NnXLSVhWh6xGZbLHt+fYv/79olSmI4ayaVqDPHb7BJN
	p9mjSkLaHf8KiXAXSXwyw25sDo8CFnYL16mE0onETr4RC7oGh4+WRJsG
X-Gm-Gg: AeBDieuuV7V/X/HJmlQZQCKTfu5u0MZkgWSVuY3Z60xFXMkY4lNDVb4SnHHqTT68i0/
	CmDChoB1xBQypV8kZzs0rzJLPCK7DGnOAfSS+64T49AQxCszNPc7FUqs7dRdZmvhzEQioxnj+ZZ
	PkPWMzecPEsYwG2T3+Ijzyf0XHoeSkikZj7wm5cba0WDpbLxSzlQ0s5R5UO1Ks19DiDQ6V+gasF
	LL4POcEEiO+ApFbTWoamK7Rj2Qy8gojFW7sIiYQUp6AJ7k7FchNivCzceV/DrQ3YuDYYx+t5sbu
	THfAYre39FkNl88qvJkO6e3X7co0cTLGAaghAhh8kFegnOWqCpmQtVjC3SRa5KhIUDWo1TfyCRs
	edDNmNCtWKgzLPPi8/xOe8ZGZRkQGGOhBwSRDpf5N0GN362HR4lhkLbfKwbHaZ15YIBaeJ25I+n
	JzeWors2S+bLOGJYYlZMAE2EKvDxpPQzvlhMMo/M6xSj1aiiBuQGGMJJr7iME7krNW6q2GaI4=
X-Received: by 2002:a05:7300:7fa2:b0:2ed:e14:7f58 with SMTP id 5a478bee46e88-2efba7ab309mr5110790eec.34.1777929315837;
        Mon, 04 May 2026 14:15:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ee38e71bccsm16830760eec.11.2026.05.04.14.15.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 14:15:15 -0700 (PDT)
Message-ID: <a0173ef4-c77d-4d25-9f51-b232cf75bf54@gmail.com>
Date: Mon, 4 May 2026 14:15:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/275] 6.18.27-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260504135142.929052779@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/26 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.27 release.
> There are 275 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2026 13:50:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.27-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
