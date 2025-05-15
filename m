Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02746283FC3
	for <patches@lists.linux.dev>; Thu, 15 May 2025 07:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747295739; cv=none; b=KsHRu20olNEBUgIiykF/rdrpGv6cJvLGvS477UmB8Q6Iq3eh5YFXQWdrOlL4m36TfDNlTMOV8Kvlh51wqnd76Hezpyu7gmv/yyEp3vizbF19G9Sov5BrzV8pB9MWZzQT0MocVgnEiVnsWKfj6dk8HUTftGdk+PYABlddf/AnF1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747295739; c=relaxed/simple;
	bh=9NpqHQAAUq2k+ftmLn5puhGuaRy6O84crNT/k9jw4nY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WZr1mFJtTWnmOBqS+GF+ti5CS8RVzn8plkYB3uK2hR0amJ0Ncle60wzvcjnvsWQeh5+UpNWo2MEHUJdh1xPKOYY7uWGGbqVOeJT0XwgBiX1KIhodBjv7uiv/uP2709nXa6GjGXKKK1QmWzQOlmA/imJoawwyKxgR/WKb3I783ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PRjkdAZO; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PRjkdAZO"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-742596d8b95so863553b3a.1
        for <patches@lists.linux.dev>; Thu, 15 May 2025 00:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747295737; x=1747900537; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=K3Jn3/DM88WWkJVvmk7sL8Y7DUkSufUkCtIgvuhMPVw=;
        b=PRjkdAZOZ6Kxw4YhTurTyGhoBpOUl1xDIdlghah/10gWWVJn5ZlTdUM/Jxb8dxUbE3
         3x473RA2g5LeUh+SrRf9RyL6thq7SK0Kib/rcED7TqcHuSgNtuL99kEnAn/4N4EOW4Gw
         YxuUDnC9o0lx9h+SVL0AhFlFw2OyC2SG0YceCP3IjfRdRc23SxAMODX3fqb405T+QZge
         6KrcVe5t87dhj9SBK5p/c2BL18z7ruqS7QQG9k2wHXADwdL2a2Ejbzk1UVi8PkZP4A5q
         gaXjbNvSTP7ZZ2KeSdJToXZWGPJVJ2FgFo9fY51ATUGF2V7DX3D1xCi1ifZGR+lXgS7u
         vQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747295737; x=1747900537;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K3Jn3/DM88WWkJVvmk7sL8Y7DUkSufUkCtIgvuhMPVw=;
        b=ojIaNZY3gflgHgWuE6CSWffNiFLXl3LNl3EcGOrqY/2pDC7QAoc2NnAa3cpI66C1Rc
         awlHCHLhyPbxzW8z1rC/nGz1X5yPH6gntF8kKrbhY1drH4gAqZd5CE8KJmodTBiD291p
         IAzdqXkJGpq0DDY0abntDDsobD9Gx3Bxt6DBYwk6VBVbj1+bR3S5EAjGWnKeemW4Vlir
         ndTgyu1TvHEelP4OozW6z16NsOflXogVRVl83Ms4/Ggiu6c0NS7x0Qj82GSEa2NWujOV
         pmsifoyTxAEDTamshPxOaCNzvzSEE8IPYIjLAy8AzuHQNzL42zcojMIqFAM9qi/2Q6Uh
         QGaA==
X-Gm-Message-State: AOJu0YymbixNxPDwXL7H/7TTG4NAU8Yk7bZh0i5KvWO+ritpVYM00vTD
	PbQ0INhd0N6NZRFoKEuuWqnMY+cHo/rWfnjX74jlYEs5BykIsevX
X-Gm-Gg: ASbGncsh8EMDNlX565tKDkzB0N7pF5O67UO3dNij7yQc7aCnNBSTFCox8VW+iLLFWKU
	vLv6Gule29WNT/5cq5N+yqipAJ87rkw+M7CvrN5W6Iov+DykbPndvbhAbQlRTBebPwO4lXMv5Q1
	Ii+eNqWiuD4F88DMuWDnUGAKnvYh7M3IuP+O+2fYvBSgJeFj5HOYlSxChlmpScJRCIYQsZD5vlj
	iVAWJnAbpLrUJKb/YowwffIJN8ziKJPy1CUwcpVAv01fR+lVx4LqlN7GlGFx1D+NCGGHo/ORixh
	3DBXb4KeYG9KsxgkeDFfM0BvwGlJ3Cv8o8E8SMcYVryFa9DeC6dzfG9cksIx60YMpqJen8WjtzW
	+wudcYkJbthDUFDfX9w7PiFQhyyW0vzI+bBHk0Q==
X-Google-Smtp-Source: AGHT+IHnHlfydB4fPE1z0O4AxRK7cFjPqerf6TRjI4Dqj9F5qWJIPALf93Kj3F/VKpUIMgDfhZKLvg==
X-Received: by 2002:a05:6a20:3ca8:b0:1f5:8c86:5e2f with SMTP id adf61e73a8af0-215ff1bd72emr9734011637.37.1747295737124;
        Thu, 15 May 2025 00:55:37 -0700 (PDT)
Received: from [192.168.48.133] (mobile-166-176-123-50.mycingular.net. [166.176.123.50])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26e0fcbda3sm240899a12.16.2025.05.15.00.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 May 2025 00:55:36 -0700 (PDT)
Message-ID: <ecf34b62-142b-4ace-af3f-c531d5d56e8e@gmail.com>
Date: Thu, 15 May 2025 09:55:31 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/96] 6.1.139-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250514125614.705014741@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250514125614.705014741@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/14/2025 3:03 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.139 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.139-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernel, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

