Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647AC2DECDE
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 22:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777069638; cv=none; b=P4C3n+aIQrm6lHNlgKvRDBvir886dLhyDh50Do1aX8xZSHXaAGZYeopWmG4MsnEtYz5t8dEmkSKPMJO0aAzU8KFXGQIwug8OvokTOBjPgEmvsx3wvplZQjyswc6Jy9IYdoN6PLUkC9AQZ8p7yTeioHGQfgO/Xrsx7e9HG3v29Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777069638; c=relaxed/simple;
	bh=v2I4Hl5lAjs1x7TF5dc8qZL2larXyObUL1q17wd9CB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hJu8YdYbD1SEvKIv3edgq5EV7zcxGgdGl7FnV/Eo9UZxJfYc38ezxM4iKZLy6qBksprwoU4hJn8E8LoNynFbKsegbShLE4H25PLkb4FDzVww8xQrb5rBJUuvInItHHLN/oQ47JZIrUtY051olJQIUX5HAuW/IECKFzHiVSfjJeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCEgAsSJ; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCEgAsSJ"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7dcd89701acso3740570a34.1
        for <patches@lists.linux.dev>; Fri, 24 Apr 2026 15:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1777069636; x=1777674436; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3q6Y1vm4CQTFoejYPRv0KuV0PQZisrV0IPlAcrZkVoA=;
        b=TCEgAsSJ2gtHyfRyy7GP6FIeQqoPFzyBlC3xtzlozspqUKzQfjR9kb45PFx0KD+GGo
         42ibbGo/irXzlxoCPshaQ4v0EVi/Vz9jQkjEUszbl7q99l/H4izZHMaEaQvVJ9NLCOPF
         eowJSqCPpa4uRlPo4MJz065PcBwzJUg6D+AIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777069636; x=1777674436;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3q6Y1vm4CQTFoejYPRv0KuV0PQZisrV0IPlAcrZkVoA=;
        b=gJvVvZpL8jEJvwMbLxubMB3+iu0O/Oz7wh0T539HOr++i+s/UIYdMWQqOFpVibzTI8
         ggXgRMi2LkxIKzE6wdmkEeQMn8dbZCBZD+Y6AelKHU8yd1Rhe2Spwq1C0i7piei0+zmE
         fx0hiCs0w1LQ12mlQmvuWPeH1ejOg033f/+Fi9IFwXnsLXTZ0F6g+yU7OgpA5w0vFG7J
         Vqr7loQL0c9MPBt/AXP8H7L0ZzFBf93VVPcN1+Db1FtnOVqfVxK7KD/mgHuAQx6sxOpj
         r0Wtg1jUOaSZ30eCZreKC021AfZV5HU3kNs7hgCZ7C9eec3XcUxxAA4+ULb1Yv+HbQJx
         Vacg==
X-Gm-Message-State: AOJu0YzeWcdg+ptL0yxmKrfvJYoUoaRJQEGnYOwNJbh3oI2GEj7skX5F
	n72UiuCJ4a2K06OZLhHy/8UTI/1KpKNw5wvCyKC08qOq+scydEWdlgfh5wfyQtOZWmc=
X-Gm-Gg: AeBDiettjHq6spAIO/bYtY8QdgBDFGXhRJyxpr4IjM6l7Q5OFs0k7y8qBIxNRhQzGAZ
	Tl9UFMH0x5Pv33c3omQT7FzJnM9scpJZH7hwFRQPuOwWGp4+yuSiBj7M3IY22cCM4qgjLXxtayR
	HwRPvhRgGlxK7dfDoJnNQ+bgZvoWxNoqrF+6XRqYouRqTP0yK1TO4p6lR+G3nEbFB0dKiCxSlH/
	e3a/p5OIaY8ojW39FRvX6lyy+vEhiOiFYGFNF+pji6v+1SeDjvkiz1shjVwLxURAAIC7lYRCH9Y
	gqjscFvqTpzK8IbI7HsLAsNokV9WUBAIzmwtaV0WEFxbX+s4tPuWJVyaPQeBobitqrLCSj5CKEW
	GY0xHzHfZ/5cZ2dgvHXLhEpbu5rd25wwgf8JBlNpHXt+4mdzvnpsitsMIATKD/QQpfyZ5k9E2/V
	byzL5ybR5bGOcl0eRuK87S3KNlpeRO8sy38hKsgxS2sA==
X-Received: by 2002:a05:6820:1f0f:b0:689:dfc8:5e39 with SMTP id 006d021491bc7-69462ef632amr20171514eaf.43.1777069636061;
        Fri, 24 Apr 2026 15:27:16 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-696148cd37dsm4585727eaf.8.2026.04.24.15.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 15:27:15 -0700 (PDT)
Message-ID: <6e384fd4-17d6-42fa-88bf-d11649b3b612@linuxfoundation.org>
Date: Fri, 24 Apr 2026 16:27:14 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/35] 6.12.84-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/26 07:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.84 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.84-rc1.gz
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
