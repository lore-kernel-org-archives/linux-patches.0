Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826D13F23D7
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 15:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302180; cv=none; b=T6ULnfZLg3VM8SLK6ZgSu187Rw4yZoxLJ1WZrP8J1nsL7WtaPAvPWnkBJej4vS5mB4IiVBehtuGysqohLK6xS/57ZivYYrT9+A7I0+RKNusgShb5dKYAldI9r+VnC8kiYKCh9p+HbYMdYFNtoMbmJz2qBBpTT4jiil2hruUgOQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302180; c=relaxed/simple;
	bh=GigjgsAQay2xWPGyyBlPHgSfJeJf9hQ58iKnrfuKuug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gTr2HpbF+YojMPly1qPe1gGyDMwVBbPKkDe2DB1AyNRweCe9wakqIot6fvt/cD7+yVkQDVA57zRvCKJ/na/el8m04Jd9OPglOa0DjkjED+6kku42aZhJlHPXTwgr3VVPgWOo59vACssN9a1sqg0I4fPYs4wHbhfdgEl6ouWH8LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxxF6ePI; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxxF6ePI"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-44856d185bcso4091564fac.3
        for <patches@lists.linux.dev>; Fri, 17 Jul 2026 08:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1784302176; x=1784906976; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uKfqwUoLQDCcY1DVOzAXCStYSm8mMQDKjMof8yWpr7c=;
        b=KxxF6ePISLvgfVw46+BAFlfNatOl2RzYzOlBF7sv+lbXlew6WPdRy2GYUt6zo4MYkD
         W5/aYp+y0cPbGy6VD+jD2h4uZkKuZJQPTsZxiq/YkiUxws7pDGna3aHRSbfVVEOB8xYu
         lAgQtC5ORkoQ0SSrcDLzjaxVtiI6cOQijPKaY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784302176; x=1784906976;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uKfqwUoLQDCcY1DVOzAXCStYSm8mMQDKjMof8yWpr7c=;
        b=SGstb0KCkeMMC3cPOPEnWTY5fA5lDVum5VNLZsSO/+ArjaUzaH3BV819Bhn/JBLsgF
         4TA6ukN8D/XTPVLr5AdRKetrTDFGlZQQZeHwncQgp9LzwoiNzD3ZXQOZUb4MU3EF5zgx
         INBzlj3BRH7QdJiVv5N8FDKyQaC65I6YWu2Cb41d6OUhuHRzpJNn3rDEQwLx2S8HAM76
         f39mrq+yeJGaHDswB123r1feQNfGDl1MkI6I9Ucd65g8cnyc+cjs43eg6yeVITke7/Fc
         3RZRNYHwUc7ILAO7sHs/QJ/rN7rlK+0cmWC1SJbCxNe8djKnRxyk4Hh8vW79ppmKKhPS
         +QDg==
X-Gm-Message-State: AOJu0Yw2m/KstIKEC3CrUdMxmgASLKAZlE/bwEi3Ua94DHxFR3FHWmOn
	BZ+2sIl6Up1Ybj7dlcAFLgpLTWTBsKQwLn7QRQuULMQ2V8lMXcYVyGLs4Mnepa09ams=
X-Gm-Gg: AfdE7ckVzVEUyZ5gpKEJgGI8HgurcFzJdYfcotU0V06gLb7H4u995g1pUGY22D+TVl5
	ZFFciAre5d0APMS38LirNIvmC3UOiSJJpOGzPxPs6ScIfp9ncm82f3VxKt3WETCo2th6T73Moh7
	2XiZqQ9vDCCm0f24cQIppYKw8/waazWF6GTsv9xet54cKAzRF0eR11Hroh8MSgB4DzHM7TcoE+P
	I+R19WUN4QPUG3HBoL16FcaABnUg46tckUMdbFNJNU1qc/yVOwBGazIwz0DBxQspEk3LfhSGukJ
	UZlIz2ojvFH90gHQS3U+xcg8NFJNBJcgOe4g8qpM7DN8NLX+WI/XS0PgRzWeOzWBVU26lJAsrKb
	BatE9EAtI06ENnnXDDEfjTUZDb+Vza7+eEUOJnX6AMDQqx22JWIOjLfQfO6xMYpUKi+w+TPV+jy
	O88FuirTay1y8=
X-Received: by 2002:a05:6808:1a04:b0:49b:9a35:f71d with SMTP id 5614622812f47-4a4d0389a1fmr1375408b6e.30.1784302175977;
        Fri, 17 Jul 2026 08:29:35 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4a4d3a57b0fsm1003127b6e.1.2026.07.17.08.29.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 08:29:35 -0700 (PDT)
Message-ID: <fb873910-2073-4121-995d-93cbed621c4e@linuxfoundation.org>
Date: Fri, 17 Jul 2026 09:29:31 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/480] 6.18.39-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/26 07:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.39 release.
> There are 480 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.39-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
>
Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

