Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981C22E7395
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 10:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780916232; cv=none; b=ogrTus73Xxa0NL1IUqwHsAx8gQ6bt35/olZFdzYnyODRSrOeaWZRjAA9T+1C2ludDNY/uOVNAodxJgoxd7J+zbofryRrcbxEHe/4JMrRbck4u56OBYLGS2cD6v6DScIpYNhC/VPJHbGfnfs3y7ugQTir5e/6d6vqmKKHxPE0ujY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780916232; c=relaxed/simple;
	bh=0vn0MVBVt7lRwVyhjwIAw/ZTQAU2EumbcQrS4nQ/D6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B4QltsOAW8Rdq9AMPDJWzKZgw/OpnjR3QLSv8pohWI93LnfIF8gD9wZPqGD+6DaPV0cnwAM5UKH8DSBahnPtDWUPPdDb1CrXAwKgDstToJdZVzvNs7dKV6DgDhgblFPTQV2k4jYsxD8Vwqiy9/cixE+8FxNjW7ZQNknItALCc+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jIKt7PSK; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jIKt7PSK"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4602e2a0372so2901776f8f.3
        for <patches@lists.linux.dev>; Mon, 08 Jun 2026 03:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780916229; x=1781521029; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QyQpbrcj9lw9mGc0nK+HUbc4jAd533Efk6gZmiy2FdE=;
        b=jIKt7PSKf+E9MQiG4WtfjLM0SXnx/ocSKUrvuymr2FKHQ38PAf8K+D2LolWxUvwsBD
         /tvLmXp9eMQ2IWvzhN/IUPsxCTleObRJwdKdPQRD3XiSXAmgAGImVlNwWOQraeGaHLQi
         XOUeTqyUusvtKybOFbzrDhts4ntL5FnyaNOo5w4JotNnfI5IgkvHv8K6mBv1vGlNqgjF
         JWk+AyWGWYa9rRcDy4noKmy4MjbrxSdU6JqrfM8UVW0wQlx9y3InNVP0UjEXEKQEeFes
         Jcrm64FSfkXMtzrUclDxR/AU70+XSs2Li61Wyb3tGsCNjVyFAKVWY4+d+ru5gCdiI0Ki
         P5uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780916229; x=1781521029;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QyQpbrcj9lw9mGc0nK+HUbc4jAd533Efk6gZmiy2FdE=;
        b=BtwU6hHyVmFrmAJ22xi4SjJZKE+1tFSGkmggw2KLDeJDT1JHGLE0MIgHGbpYecdl/S
         nLXx0CUaxnDTkRWe2dxifENz4THw5ZEn+7pefeJtNf9D3yTMj1sqOXHViGjmsetvwF/M
         /yyDpLYqU2MQ05SOc263uN/h/7qhBfkwlPXEhZmtFb4APHoKaYyZgQx0GU0F33xDK/ON
         ltB1XBZDNcpbYlY3+nzqr5ez3dhfW6y9LJ32HSbRY7N34/AtZJJDYil213qgU6VAPkl8
         NHNBojLjaorXcjVhV4jjTNbbRecE9KzCTgTytqpx4xDXDAtjWRIhsRprtSodQ+F9elf7
         rXQw==
X-Gm-Message-State: AOJu0YyAv+Q6H7RA18x/gnD9Ab65yzpAOkdTGtiDtY0A/fLn6Jfqfm71
	LdqRRUukql/54j7N2f6pHfLLtpcb+V8ZpJOvhTWCxvZD6CAYBJaZps3V
X-Gm-Gg: Acq92OEzt4CoJlMvnoKAorfWRWT6OGJB9hjEraU4HUKCOuI3KP4Cnk8bWgzaPDHBkh4
	mqrhVBezSNn/fabWxTeISn7g9c1my9xI+MLYI2cXRXXO+oXvVyaqpB0XvgI/Wx1NJkYphky1ltO
	knsl7kfFerkvDAXcM1t0kIRj2Fa7hClokdMDgc2j105GuwPleJxBWYIE2QUI5n2p+zV9bY3owPJ
	HSVV4nyxPx9z8uOJzPR98XPdLAY7jNxUCLkbI8A3XShYdtzo0UiZQpds5iAt/RISJUIL0PqDMmV
	fAvTJDjlHfUw6tG0YX/bGbMvc4sg4otoD4ksDF8wYm8yOd7RAnP/s1BpdZ6UU2lQStq0fh34YDF
	NQ6XHHcAvd1wTZjrBb1ZSjxbGfy3pwUAqoB+959JE08N89bTBQVs72GtV0m90QhbF/L4S6ba5xD
	ZF+ac/QDY8DXAEwqnD9odji3HExz04dtYEjQ2jEQPqXjOkXWu6AZBuskQPI0mXG73DxBfBBOsQ3
	1O/9BnkuSXabegAOmAkiA==
X-Received: by 2002:a05:6000:46dc:b0:460:1d74:a1b2 with SMTP id ffacd0b85a97d-460305146c4mr17352616f8f.16.1780916228827;
        Mon, 08 Jun 2026 03:57:08 -0700 (PDT)
Received: from [192.168.0.105] (88-187-52-200.subs.proxad.net. [88.187.52.200])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f351d69sm93075906f8f.29.2026.06.08.03.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 03:57:07 -0700 (PDT)
Message-ID: <52d2ce00-d1fe-4c1b-810d-b99165cb9d3b@gmail.com>
Date: Mon, 8 Jun 2026 03:57:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/315] 6.18.35-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260607095727.528828913@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/7/2026 2:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.35 release.
> There are 315 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Jun 2026 09:56:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.35-rc1.gz
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

