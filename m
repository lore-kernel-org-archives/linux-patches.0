Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CD3338931
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 23:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768002978; cv=none; b=Niq921B78URNKnzEfwrx/j6/MXbnfjU1mpeGoGD45thMmilTyhR3KMeO/1eQSOYRMKx8FOszZo9MuP6z/aucds1YDnGgBQp4KTq9gv8DYaWoc2jL8L9B1Wy1B3NbEG3G+OwTwMaiBlGFw7OpK1MdToCoeujeob+ijG5agBdD8n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768002978; c=relaxed/simple;
	bh=WH0dp1Wx+KEOW2dk+QuvFMsYYMNoKuK3BCTZY1ds7kY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cc3kUgIfxgVuxBcemCa9SN3wauuTze+8Oep11AVm4hkI7MeM3xdMwTjQwSwRZhUZCiTDwQhLsWP+0GGiVUDG/ygzgGYZbJX3XITmu6tbOkYD2KY8S1o1Uc6Cx7yfniK/WqGD4ENWpHAYA3mk0zOU0REiNk5EZX5UrRuiGJDz41E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKxgllU+; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKxgllU+"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4557e6303a5so1549866b6e.3
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 15:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1768002975; x=1768607775; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0vtEiMwF95PgxbG4PPVBhcGfmlHI+Wo1hj9Bl9Dc5vM=;
        b=UKxgllU+1i4csK4Wb/8ABKR+WM1p6DeYkTv6dC2Ms7/bk4qfhOzwXnA0Iyyz2X6Cfo
         UmHHZ2rSS2ENkIv30dqNzp1VqRCg/IuVOE97YqE8J3fWvlxehe2m2QLtW3Y7I1ZJF/sj
         2kjC1ToZDi7l2nxBMbnCd1SyC7j/gmrhb/bo0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768002975; x=1768607775;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0vtEiMwF95PgxbG4PPVBhcGfmlHI+Wo1hj9Bl9Dc5vM=;
        b=IYIlzeKbuT1D9wQ7OnWGrJ1LHr7DYzRp+iR6sxQKlups0YLZpuBKkyOPeX+yv9kEe9
         FWirUAnumW/JLArxUTHJDwnyUkXCvZXPx0Fv3W+ImnjTtEZJEN8HXKgdUZCSKEeK4xT0
         6I4yXEtTK7xF68XfTafvTvcJezyexcQZ2vbJeLzvqyMiHhIsIljzCjEn78XfLeEESQDL
         wbbA/NhmrJtS47TVJUvJNJmiH3XJJg75h1pBwd30p/RpmS36id/bKc3PASSybPom8T8n
         FH0v0zIkBNra7PGsTc/zW1oALLKkwX3UZsebTJ2UUiaNEuZfc7L6E2ly8dqH2I/J1QLB
         aM7w==
X-Gm-Message-State: AOJu0YxPySrlw9iNq6gz5oOA/skdAhwUd14IN1inZsstQ4Bw00uq+wUe
	/+tU2jFS1q5RTEeeTxbIa0h3sTNUPuIOE5HFFARMiDtGirf4xWD8fywkss9EacXGbKc=
X-Gm-Gg: AY/fxX7/r88SLvz/3esznPLIvnEPX1N7WUC0Yg71gC5PkiIiQ2QsRP1XznBmKmZdNoB
	TxAHg7Hl5cXtkCd9fC3UkXCDfHp0MihinF6Rww830wEYGfNJsrLuP6Yz5GeH9UfVeChzXYMT4oh
	sz0D285CLYYUKL6APuUKh5xO/nE8Co8MEl8sw0AMCukb6PYFAePCe6e35PRUJP+9BDCvR3IJPQ8
	Yq5YFetn8UQXjvUZlSo9eaGptt/aBFOXxFfQ20E8NuQYzIq9wd3D/xarx+10UYMbfjqsU5NsXu0
	DxjIzIaJkPa0TeaXJCyGFPgLlZsae1tCYyo+Q0koHyYrWkcQnsafKdM6eHsWah4s1aJFEcsQzIh
	wUHW+xW8h6q1GyNDjjkisPt86ZrK57pAF68eGjH1x8xRaAnscsUadaCNPljxjJGNNu5gHlW0jhJ
	SjMFipNN8pLG8pHZU12ffOrHE=
X-Google-Smtp-Source: AGHT+IGb/ANQW4oYo23GB+o6gOePNPs2Ss/ccbhGWa2b92/2fOZzyHf2JqsPa3t+fNKo8+RvX8+XVw==
X-Received: by 2002:a05:6808:300f:b0:455:ee1f:e1c3 with SMTP id 5614622812f47-45a6bccb5a1mr5652095b6e.13.1768002975643;
        Fri, 09 Jan 2026 15:56:15 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4de539bsm7728174fac.4.2026.01.09.15.56.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 15:56:15 -0800 (PST)
Message-ID: <965f2405-cfb8-4d03-92ee-4c5bfd35346b@linuxfoundation.org>
Date: Fri, 9 Jan 2026 16:56:14 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260109111950.344681501@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/26 04:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.5 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.5-rc1.gz
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
