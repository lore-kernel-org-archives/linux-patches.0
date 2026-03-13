Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268F82D97B8
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 03:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773372307; cv=none; b=JfQJOzjuy+Vzse48dWLwm3IYORQgzbVfm1KWJqOW+vghKDo+AKtq8y6wULDr01cKroWBR0I9PX6zKE5cGa2vq/D6ImaT1JV5yTnzwGOfnQCurWajqVKKqujC7mVeFdDuwy088ACIYi3NcZ30duZHJOlKzuYUnHlPq+mTCxzf+qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773372307; c=relaxed/simple;
	bh=UnpoWyQV7I2G9oKCVZTTUlyjEKgTNZRO7I8Y2CTany8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J8gkjIlMwjcx9gr5y6ycoy9O0Hdb3EzpbOsaFpiLcqtaTW06Kqz7j1obV331nG7znDM5/g0ir0FQpOzX08Bt5PVu6BHfXvE1daRqR52JrbuKSil2630NEZ05dooHeLyMc8uF8rU+Sm9cupn3PuLZNYJ47wHLSjUUIazjWyqC9Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZ3nnSjz; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZ3nnSjz"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cd751a4e93so92049885a.0
        for <patches@lists.linux.dev>; Thu, 12 Mar 2026 20:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1773372304; x=1773977104; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QNtbuNDe4pXFksjcrSvvrnUEDc9BgD3q2Pyzectx8xg=;
        b=NZ3nnSjzuv5kmgvAult2HOQjw2n19weiJI9bfsaHNA/L2M22kvH4cN8OLRha5VOKh1
         3Czce5RQjvUk41gb0XteYVKATzsQuqGAkRjt9x8+2jGbYFckzGXve0fzMi27moSFhnY8
         P5/NowEYMNQbK9sT/9ZUnDwig8lL/PQDa3kWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773372304; x=1773977104;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QNtbuNDe4pXFksjcrSvvrnUEDc9BgD3q2Pyzectx8xg=;
        b=NBBc5tN/w3AzcKK4z7lRD35QChoe8ftFc0JcRrbDtecsJW0TdvxL+0WxAZPc7q+RcF
         J3nDkn5RxXMM4OrB/c7OjNLwWy7uJlOS0U2/En7s4xW/350QP1O82+3tuUBbVjrT3JCW
         13LnG+r5fAnyCYEm1iDLb3gwV3xXbA0v1Fhp6z4w4oZ/ltyKawUX2wcLyVtTKuNTuo4N
         +WXZQRKmL5SGJ2+7CincMiouNAxtw8hZbWT+xZUJu/7UymhV7BSC70+LetZQVX1kAD4I
         nhs/W3iAbmwqGIPzKxsxGmErW3vf4jkiwaEUiNLim4s1+v9ekGvYqTCklcjIatgl8qKt
         S9cw==
X-Gm-Message-State: AOJu0Yxgq3h70H9j/cZO9FOqItE+3d3FYwf2RpnC/PobfE9h6MTkxrmi
	OzfLZu9bTHBHKsj0cju1YhQZoB3jd6/48PjphIuTOTyc6xNomF0z1zzMH67a1s6euUc=
X-Gm-Gg: ATEYQzxaOK8eQvLOw4X7Tn35s0llMd8FuY7h77Kga0yqtNC6nqooyUlH8zwmGox+rI3
	th6BeMDDJcOsGtAnG+yE22gWZYPOtsmj7F3fT6WOctdz3ByqWcpvW7t6BHPtVLgMYTOIXE4jFFA
	3FN38Iyi+Bp65quiYNxnCzAR3j4P47pwxf85G71RyMxUuMioulFlViG5DEG51K77flOY8u5rmca
	0CeKCtOJ3cZjc5tusjkXPypT1x5CfTuz1UuS+T2zuIvqNTCRdhfGd0Oxw/awDd9oM+aN0DHR57V
	LK/ebL8DTgPcLJEIYIY9z8UuDrXNWz3yIw6+3XpdLMzf4Z/57rYLihw9Iju5HTwTyNrrBuWRGXS
	k9Q9zk1sdyqdQFbNPTfp8YCFDtZZa1sbwpDQH2Ya9wQwrGpDATmnqs/97beK1tXpCeMM5ihwowt
	pKZnkmk68/sFaocnvt7fKFcFozJSp1Sy/tHbhGYru+cxUuiw==
X-Received: by 2002:a05:620a:46a5:b0:8cd:8f94:2598 with SMTP id af79cd13be357-8cdb5b54176mr275792285a.61.1773372304103;
        Thu, 12 Mar 2026 20:25:04 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda1ff7642sm529673685a.21.2026.03.12.20.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 20:25:03 -0700 (PDT)
Message-ID: <46ec4dae-8422-486d-b2cc-fb4c0d385780@linuxfoundation.org>
Date: Thu, 12 Mar 2026 21:25:01 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/265] 6.12.77-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/26 14:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.77 release.
> There are 265 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Mar 2026 20:09:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.77-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
