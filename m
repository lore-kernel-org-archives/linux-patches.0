Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A47C2DFF17
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 16:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178537; cv=none; b=kXkXjWVvqSqErlsde+jbmkRhLujaGLmtWnjaHP3Sk8QlqRWBG8drG413Qk1uglm4JFhDOGga3XVGXqGF/ck2RwOKU5ry8LaaYfM6FEhVMy3n5fEdrA2Se6P+mEDwx6eyCLfdZf7bfJGElS4wUSHfbvnNkB5diHYkW0+o/YnlmJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178537; c=relaxed/simple;
	bh=6LKUcqnfxeqdiEdGbuyyfPQbUmMmvb9HOTZrRiG4ZKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jvkfeE7P9OO7Co7H2YEnwww8v3vwJnxRZ3D2mRkAjGoWl8b7QnuMmXbzP0JzW16Myt3Y5TWmmJNK8d0/eBVYbqwFVWqNwzPkWKW2X9nw4qFtS75XOlag9H9a3mM9TMD+DNPcwX/6/8FvKyf0YHJNznM9K2HSLFSIopLcr9Xwt04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QsSdhpdJ; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QsSdhpdJ"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b2c40a7ca6eso6275396a12.1
        for <patches@lists.linux.dev>; Tue, 17 Jun 2025 09:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750178536; x=1750783336; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rzIr7BVtoGiV4ICDQDCaTXyipt4u1RSoJMsHT3Dzh+o=;
        b=QsSdhpdJ4sPVBUC+Gv+bJ02xhvdWSRJnW4Wmv13wUipS0JYwbuFwOa67B2pvJUuRd7
         6QHFBGJAVlu4vAer1s1NyN8dDkG88fxCslNDF0L2jd/yEqUxhqjwFT1II2PH1gJtd6MA
         n1vXLqWxKmpB2e3OINlpu5TIVkEcOTnxk9fwAJDb4+WHZZYQnJ8Yexh8viRFg+dgenNT
         HB9vpxsV0FYOo5NjrVtp8RRgv1WUQQHitL+Im932sm3qC97unZQPab147FK/9g6DJHjh
         axRal5qpHTcUgCZFsZJslLSc4epc23XAhVJGBvonlBy4vfSP8UOHDJXqOUPQvI9bIE7/
         oWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178536; x=1750783336;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzIr7BVtoGiV4ICDQDCaTXyipt4u1RSoJMsHT3Dzh+o=;
        b=osFL54n/Z7RcxFFJ2QLEhFAfgR3xwFMdeXTl41A2YbVmE2yIRDGDmJeF0UwZHIhzjX
         /cGp9Kz5SIgSgT7X2YS9buMTff/GPMuOwO8xLWZeOhAPfbiD/PVWO/1cb40iCcCRQFQh
         urSnt7R8JOTzX6RPsIR06paXIz7/2K7KZZZVCOXf86evJ8WIvxJwYrpHtNE8wJOlq3+4
         Jzbtcq9rYgNesweaE6CPcDMkW9djLRkyM5xr/grSKfjkC1KBkMXV4eR8ScGysUQ12HJj
         q78S3Fcj5T49dOzXZo2d7fPg6ASh28MAIVIR71f0NSgRiM1btBmY3xbBvIcCrreFkb2z
         g3MQ==
X-Gm-Message-State: AOJu0Yz4V6FN6/AOKe4Nr2WaatS1P71wou7PlLNfuHl0MnvpdsgnXObl
	uieWDG/QDENnodRznpl3SEzhZIT+YQieVa3+kUCNw+fDLChYC5kEuj+y
X-Gm-Gg: ASbGncsNSpLFzfRYYKAmry+PTwiFlW6MrGK2l3W+ZOwhYYPDgOqrZ0Ft1YNqXy+LR1i
	nTM8WwKCtpSYNSObvJDC6e+LnhDvBVZK0w6O46cAzijZs+q9wii2Gri9a/qhVDNR6qlyDUWIqm7
	bRfnQSb/YKY/EfW4ZGYLek+03fESA29ytkf7TE5lhxffIl7m7u/ik0lSU6h4j758Or87letx1GH
	reBjC3vynzWIyzI7q5r8gtLiie/PxugnU936aA/3mfGXKiJ9w9ywvgTqpLybvjUje4zOdXEa9Y9
	O0BJuOSbGemSvU80n/Syb9qhBPPtcvybYNDYIW5GaU7VUXXWQMl8nw/OIzb1EEk5qhWDaB2u6bA
	0NpLICYa9SeUOZOaP9JVRCXL/
X-Google-Smtp-Source: AGHT+IE2DmbJ7Im7JhcRZgi0/LOiucF2cGq00KyrSPkLTmUfZKiWMHrA4gNpzPXjuaEi13PvUV0pCw==
X-Received: by 2002:a05:6a21:9006:b0:21f:4ecc:11b7 with SMTP id adf61e73a8af0-21fbd57fbf7mr22136222637.36.1750178535804;
        Tue, 17 Jun 2025 09:42:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b31886377a6sm6970488a12.71.2025.06.17.09.42.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 09:42:14 -0700 (PDT)
Message-ID: <a8938507-3708-4dfc-8407-845cdd0480aa@gmail.com>
Date: Tue, 17 Jun 2025 09:42:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/512] 6.12.34-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250617152419.512865572@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/25 08:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.34 release.
> There are 512 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jun 2025 15:22:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.34-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMTB using 32-bit and 64-bit kernels, build on BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
