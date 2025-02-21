Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B012A1F0E36
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 18:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740162289; cv=none; b=XfDEFWHPs9VYKmBnT0IewT7IlU3KrkooP77Aa31998e3cwwJq15BFEXVdRIZDyb5hD+MmS9S5y2lgu7RrNmErvckOnGjo+9LpRP19wJm7hAVcL0C26eO8/IZKczLGU2ppqz4m1+WI3YqTvdmConk2eja5jnNoNOplf6DaZ2OiNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740162289; c=relaxed/simple;
	bh=KE/2RO/lFpVr7sVpJR/cW8Netw0FEdWCl/HcdQ7hZSg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WjogMMxgbf51jWZkej/qhN/WZWdgvBeYK1QRAjJBc2WndFnncj8HwpqhSFIa1xtqolSzCGzdw2pRqTaP3AJjyAsgByNM09z6Gp9FzoVdkrXmoy+reAJn5Ql9IfkLYpMWKpqI+wmlSeKpD/v4tQXk1hCdNGgZUUZbjJBn/BAcmKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IrFS7cfI; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IrFS7cfI"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2bd2218ba4fso556586fac.1
        for <patches@lists.linux.dev>; Fri, 21 Feb 2025 10:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740162287; x=1740767087; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6Su3+14tpxkqTvwfVPEZByUtjouZaShymhRyBoXcd7s=;
        b=IrFS7cfIsa8dVDOyLeVyhrwoRs7gI9LQ7riO1AZ9ZYlaD6fHQ8HF0J36H5EqHFzMht
         fLEK18Y621ufYHh3tn1xu++c6W0loNnt8xDjgw8LPLlYgflS5yPTmiEmScn5QFus4wZ+
         3xGFr0VJ4xODHc9hdJzZO0P5gUVrsQXRff61ehvNyCd3l05dYc8wXG+xa/rww3SN8LcA
         CMhKQaiitfB++XbG6Iw7ERTEMxGYWJgIDi94IAdel4PoaQ8b0vXnwepzgbJAJcAnmZch
         zmEqeoEAx6nWqJx37hFlVGs2hWPY/i/ZHcG1Okqo3c2rbwhXktoUhtBdVSnNDnCDuZfm
         7m8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740162287; x=1740767087;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Su3+14tpxkqTvwfVPEZByUtjouZaShymhRyBoXcd7s=;
        b=Fi2c/KUph+GVE/7fw9s9rV1f0qALNB97+9lF9MkITNjzaP3N7RgbUr7DMY/4G60fh4
         phPecjcG7wBaO81ABQLV4ew0B+KlJV/7dTjNLygKJ3uEgEgdWwLQNRjYckCY6mF+GBaT
         Ip1j1zvL0lhXC4CirD6t49voYC4Kiq8Y5tGcwWm1M0vSYwydn7C7ofQaKrsRTbH8LHBp
         VVP5eTlSy/bcoROZQq0JqYIOe+rP1vVI0i1pmmPGXIWJeN8AyLOf6YRoifDfwGywC3Hm
         LAwlzt3LM1R9vK2fLnmxbGfEl8wMgyelc/CWY52WqtjJggv3hDmrr8hUkVu6kU6st7wZ
         eIDA==
X-Gm-Message-State: AOJu0YxDZk8LPYo5Gl7k6LLcov6ieEVdJaUXREDxwGHCpeuSkciUO2hc
	Nub6ihZh6O7P74PuyHrsqwce4ltdVzq42eoYZs396Nz88N7cndWE
X-Gm-Gg: ASbGncu28oYEruKrKz+T2DmipK8oCDFdi4pDV+pqh6f0lBKc5q/JW1lB4oHzwDrfUxx
	krULuwDIiS559RgIhKq/FBOthECyXOX+1FP4s+MnvFHthyuM5/SgX3A/4ukA8BtMTpcJXxlLYiN
	vvpWgMYIrnponrflZeekwnELVSUqvDWjiqEHzgaKjmnF4AivB9CQo2GxE1emEw98SXz625cXdxL
	iPdcC1j/aHlA97XhEkjDYORNb7mNn+tKX1C9u5wlFfmUNnglbodGhSWlVeHiRQb2GDFJo4KBPRP
	cbnEo/+iDXc4ayhhRm33Flo2tcw7CMwRmnBxVOitsEdsJgjuS65I3w==
X-Google-Smtp-Source: AGHT+IELQYu5EK+8uQbcZYp/tabGOaWFJynVjv7IEdRKtNkhYtBb5oVqlIM2APCjl5rzlT4RblTrWw==
X-Received: by 2002:a05:6870:9f12:b0:29e:2bbd:51cb with SMTP id 586e51a60fabf-2bd5180cf5cmr2853498fac.24.1740162286691;
        Fri, 21 Feb 2025 10:24:46 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2bd3438a93bsm960157fac.25.2025.02.21.10.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 10:24:44 -0800 (PST)
Message-ID: <dd1606d2-f03b-4a95-bc80-2daf55747e26@gmail.com>
Date: Fri, 21 Feb 2025 10:24:41 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.12 000/225] 6.12.16-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250220104454.293283301@linuxfoundation.org>
Content-Language: en-US
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250220104454.293283301@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/20/2025 2:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.16 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.16-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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


