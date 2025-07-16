Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCFE3596B
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 15:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752678082; cv=none; b=HAiuf8OwjcQy6gD21R/gy0PHGTfovlh/ykLvSSmQXX6HH+MXU5SxEv14HMjc2zmhVg83QUd1RxvdTLJBVL1GdAh8Jy9rMfqPKt8oEhApZqwuAUSOmmiOQuiKOInEKMDDXJHtOhbi5tAlg0iMsc/aJx+5UBigeVUofh8lENNzcAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752678082; c=relaxed/simple;
	bh=E8bua9ms2CAifgDQWPYLUARYXuLyT8TOKHOiWf9yyqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=go/MhgJJ4GbD1qHyNrIP2ZWlFG1Rt8Ik//Udrf2S6KqWPXqa4+Dvh/QpbjqaC4SteXVBunkXjGjrf178a6rZCE7R4lQShpinZ2AHC3m3dQgIkk/OnLW132zS2bdH0miaR/RnLuSWEUVIsKMcNSe/4wtNwoyV6fOoyFfI1dWFC+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boKCPz63; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boKCPz63"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3df2d111fefso56818185ab.1
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 08:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1752678080; x=1753282880; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/L6AVpaMRxQoagP/2U0TZvwKc8bT9msQKrHGder61Y0=;
        b=boKCPz63eqXLzghClwnr07K92dSEfbaNcsNZs9/kFu/YLXEcxWnovEzhgo28iUwzAO
         tDH9BTdAdUTloQYbDDyz2IU7ESyznsBuIM3zoZUKc6U9bsSpkXuu4k8fW6DBzGT7sfIu
         xUa33ypObXt4C5cNvUIfLv7aesPoHM5bE/aOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752678080; x=1753282880;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/L6AVpaMRxQoagP/2U0TZvwKc8bT9msQKrHGder61Y0=;
        b=EG/32XCGjFeEyVj5kgigpcZ6PhvoOF/Ucu7jfmaLlSbCKGyjXj0p+NpwhhQZ2lS/or
         q3eJSXi7qU3yX3U/YdyCIEkR2m+DsLsTUqTvPl+wigdIlpQcZ4tEYasb594th0cdcg2Z
         bhymLnKfaImVDCjOfkFv4Ttzu96OzWC6qMG73Yude3K7K+nDxo45JqsbBBrvB4pBbgPK
         EPxjl1Z3CbLks9FP6bwo32wvHl0CQVNllP1KzK65ls9KTB6dNrtHdSY1E5FeCDkQ+Vol
         2ItA9ocbV7PR5LmXXpRlcxS/7Z4jZGgNppKax1LAIniN/yytgAa/kHeEZ0rZhoCA900S
         BVAQ==
X-Gm-Message-State: AOJu0YxWbkLJrba6UwVssjojO2kSdjR64sH8DgH+2el4ukMibzPK2gXz
	hJilu94UStxWED+0Q4fI6J4ncG3cSk3g4Y8GpmbNQzJ5JoYfpaYZuGG80snN17UA5M4=
X-Gm-Gg: ASbGncseF7HGWGzRz82tp5nhTfuW32NK6b82jzcvTfqI5k5FHv4k8QkE4l6wesdBLaC
	HN+VnmaWuVMfOgpXhIAjTT7pQpn6Rdzlj+Js+IXMJHWsQVPLUi3Z7/voacsfl3lgEWIAg8gSEae
	o/ZHKhDzPk59cPmbLNfamxK9J7spJYHERqEs3wOmV+8p9BmdqOWGJQ2udfj7Wpdx0sd34hvyGQu
	OknG/kWI6VCk3AzGx4hB1sexhKOaU5lL7+aaU71GgkLFaO+q/RQ69JP/jqOM02TGIWZJVC4VUF1
	63cSVQDc586bvs5EJrOp3uQFrx3KJ9S5vnD8v0pZwBCi0dBDG7x0Ix7xacdRLk1MbHhbx+322O9
	njpFqBgzesgGqwUR4jnjPi7ON6wcRsHPGZA==
X-Google-Smtp-Source: AGHT+IHfZQtErGT+6TyVnEo5uXoQ7tA42hG0UFbluZUKT9wY/1GsEkt0bSHRzJHzmhjhK6e2Gk4vMg==
X-Received: by 2002:a05:6e02:2288:b0:3df:47f1:bdb9 with SMTP id e9e14a558f8ab-3e282e8d3b9mr31378135ab.18.1752678080006;
        Wed, 16 Jul 2025 08:01:20 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e24611e84asm44726865ab.15.2025.07.16.08.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 08:01:19 -0700 (PDT)
Message-ID: <a7205943-b3f2-46c9-a00b-0706eae9743e@linuxfoundation.org>
Date: Wed, 16 Jul 2025 09:01:18 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/148] 5.4.296-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 07:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.296 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.296-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
