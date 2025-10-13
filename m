Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1690264A8D
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 16:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760374033; cv=none; b=MtlgSqki5fQAH9yx182smCCHZaYGnmoUiWRVEzH1EnqD0nkX8G8KmjbK+1xd1IsfVdBMYhpDOsMlsS4fw2Zv+iNy67HFW9BzZyyqiGV9JdjTv098Has78CF5xv0PTT32UtzhIHARl25h30YRZ2Fh4fjEew0Z1UCfQ5YiWjIZtas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760374033; c=relaxed/simple;
	bh=nysorLopTDqkbUL0tqqaEE1x9Ol5vXn2RSHBgnImewg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NblTOjXjTS7G6gjRSxPLaiaAhbYilOIDMUgjLmnPZwd/68GdBjBOrAxxIx3isNHRNMy/pA7BZw5QXbs1rCEku1LiQVzlvMjbijXbutostxKGZmICSTd20xFlO7UwqX5YgrhrsldFIARRn9ht3XongblvKjBVnT5jPq6TNazZO7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ANjMJ7f6; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ANjMJ7f6"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-330b4739538so4196203a91.3
        for <patches@lists.linux.dev>; Mon, 13 Oct 2025 09:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760374031; x=1760978831; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=voyfMb5RRcwzl6imzXpESkU1fXWIq4jQYbcfjDP3qrI=;
        b=ANjMJ7f6T4eaokDw5YuIHtlGQeNSqNYARPeCwIc8AX7yRnNlO+1RQoj4fDaYN9q7BE
         w+NAeP6Zs9u84tv0BKCEV3w0iYhtP+HSzz1EUFGTEsSSMvogR1se6YZclQpmK7dHIu4Z
         eF7gNVpAiBhLCLYv5YQ7cy0AuYFBfmlVerU4tElbRqOqNw/YMn792svBEhb5xMchZ7K0
         BtfBDD5uAkTFrPVFtPAXwloE/G+zJ3+vzGAQuZNqh9NwES16Kj+Rl5xJKu49qkjRKdzm
         +xwYA9rxdOlbXiIgKJlQv1+CTNocN5NOLuttliKwFk+FGTsj24pCdCbZ6sASIDwIGmHX
         XU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760374031; x=1760978831;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=voyfMb5RRcwzl6imzXpESkU1fXWIq4jQYbcfjDP3qrI=;
        b=MiPObRb0DMZZ7pzUzjbrvsMXxppf8zg81i+ujTvzYnWDrzh0PfskZgrJLM3YpAKbOt
         Dp3GxQcmzKwAGOBo2g9P6uj1ZzGrXucOra5pUfFRpFm/Y1yJFVQOroOW7blV4aHlYbGr
         NR2JgHG0I1WqVwkDRNGNgmbysnQXNkclPfHJtWceYNDl/4rLuZkmOhWTBuC4m5IGqyZy
         9hk0DI0bFVonSLgHs+/5ydFFTUOuRp68whZuIoFhlq5+y4ZvYVqwFvnV1AnGUy/TBL6L
         YWpjFHlMay1R7fzDwY6Du7A70a+rAIOecJkxOV/gIdmeeP5XOZwn3AYzMqJszBr3X2X8
         6jCA==
X-Gm-Message-State: AOJu0YxHNNcGKJPD5g+4BJmX+NBjljjYNnJQImqds3FnjMTbwrUDKl04
	iI23kfW4Iy0s0XDWYrwUnAfBspqfOwIlbjaZenCptto6rAjTAaWw8cMhrg5pCz8k
X-Gm-Gg: ASbGnctucDUduA3Av4kLl+NqMqo7TGvMWDW9tIBBGEWixvqE0lVILGHt4AoDMQH7liO
	NW1KU3zQRR/6X+GnbUAT7vTWW4FK3U/wfAaPJ5zR1nrvb5kOpRsKGWkEP1M7XT63qwVgObyCSat
	V0BKygbSwRnu93GnwFx1YaQRJyeqCdstgLenX91gAVLl5p3bIV2qDutoCx7TwLuPkch/RnFb3N2
	oIg5SSc+6VQ+P2OeRjbQ/8wy52E9yBbdg/NrPgNIxyiMwt5w2mJ8S9G1JiSsRSEiQgQsdyrR9BB
	8wBUZ09DRg7X7UIiFAiiKX/ad8HKhefmkJ0qd89tZ20Iv02rMh0iAJ3wDTr2TnXHIt7u9XHSHxS
	wQi/ph+OKIn0IwPTDsWA7RaOoX59OqmJCtGb5NY0xKt5gNXDzTyPas9YUh2+eXB2clGFkPDeXgJ
	QELgQ=
X-Google-Smtp-Source: AGHT+IG1Ysy5KBOTuH75LYJyCJhrc7Jg42bTix5dwVq4VuJYEECGxkpdofnArrrEtSYwS+l9+qhUwg==
X-Received: by 2002:a17:90b:1b41:b0:330:82b1:ef76 with SMTP id 98e67ed59e1d1-33b513d08e3mr27148095a91.28.1760374031086;
        Mon, 13 Oct 2025 09:47:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b61a1d3dbsm13073884a91.4.2025.10.13.09.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 09:47:10 -0700 (PDT)
Message-ID: <5f1ac6fe-5b28-43f5-b143-dbece62505d2@gmail.com>
Date: Mon, 13 Oct 2025 09:47:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/196] 6.6.112-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251013144315.184275491@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 07:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.112 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.112-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
