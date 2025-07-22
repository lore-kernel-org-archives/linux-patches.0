Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC24285CB6
	for <patches@lists.linux.dev>; Tue, 22 Jul 2025 21:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753219616; cv=none; b=iwB3lGbb6gnyFM8s2aT1dyaTPVrzpQ1IQcTb9XB64qGWA7vn+D9iMRFMsSdMZ97dzInJ/mf89Uzh6QGgAwu26kCSFs+AapIUz73RgEUwzLZDTK/VwN/AplzKt6U0ngYsprJ35WlJk+LZkRqxqHmFO/5BUHUYoP2admQGBR4dBPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753219616; c=relaxed/simple;
	bh=R90sy8ga0ZZZAu0ItAJ459x0QIDCaY14qd4tQ/HifJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=goH0Je+qTghawL/FJeDDuylyxJf8FUmmqCLFklTZ6MaMbzaxpeYBAQT0EPd8NI6kG+rvqwpnLAVZeeRwgvj7i7CLp1NKRw5xMM7X/NKw23ApvOrD/eHddZhp0ynUWhkevZT4rmDqYDExWQWzL369qSlaBfuZw2GpILq4ZTm+ub8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlXAb4y1; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlXAb4y1"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-879c214fe6dso162474939f.1
        for <patches@lists.linux.dev>; Tue, 22 Jul 2025 14:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1753219614; x=1753824414; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4UuRsKYfywplWAbr3imuDGMU54u1KPSnKxc8G3B9oxs=;
        b=SlXAb4y1b3W3HXzpSX+ay7PkKd1h04hXYRtdlpogjgrN9yl3W21ZDmSgNOop8xtWRA
         fadN6M/Tk/xUqjV1pk8Fhupg1PrZ/TkUgNEwEF9j5z26ogeluwngg1rorkT9mH86Id0m
         1++RqZWXVYtVLL503mbNwhJ1+fBfkw9/f0DuM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753219614; x=1753824414;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4UuRsKYfywplWAbr3imuDGMU54u1KPSnKxc8G3B9oxs=;
        b=bYvuO/ch8heeekjm+GCt9u68FpIsFqW4rfPKsjqxWczZKiEHRkNGWloDynzGfXlQg1
         GVENHP+qwF2vU8ZxePbtGwjzJ8ByHZXqgTrEhg9xCFJyK24gyFYpuJ9Ni8d+6sFh4xMY
         fB6TAe7EWSifx8Nlnlu0b2lD4DsuIDnRyIliqvomiKIWDQLDniqhLFHW9nBSfgSpmQxG
         DBBudliQ4QaaZzjvCgKwTYXDiaxzezWq3dlCyO6UIokpdem4A7xnFgsdtFVQIMcnwRHU
         A9E+iWgjF0wTbhixUhzyb9WYmGCS+EeojeH+oHLIUNuEwIvuWlpEudIZ5Hzb/gh2CcOE
         KliA==
X-Gm-Message-State: AOJu0Yx8MkfspWBvnnvEl5CWzpoJ+xB2VPLgyV9GactNg0IYNzL4/ywD
	HXhLvCoLxQyjILWudQh0CMqtQjwKpfS9TLeifEgpPCdPy7xYM9ZUT6A1ypdOx4FLBWzpMwadCap
	huW1/
X-Gm-Gg: ASbGncuIzOE3rNGnoYakASftfO3h5aGIOFlr6qc2WjEt/gs7yjJu6XkkvH9GGnyaEbn
	3nQ6aYOOxT6P+l7qT90f8puqPVzver+hoYAvhJXZpxDsK+v2H2DjEQ7h+MNZaQfP12rf8KYyZzr
	gUJ9hhyis5nahccTu32L/0/v3onjKWL6IuSao+mpux0ID/2cjALHMkIdbq/8Fk6gTS4k/Au7xjU
	gDcKqL04oK1DumaWiguIm8fJIBA6mBNYT9LdGVRw3xTeXJMl3iByQ5NgY30XTqKuur400Ex77Qy
	LaMDnpYwKvRuCcOK2vGHV4r4N0tHa3FbWNykI4ix3RkuteloyHLYZIvuX7CsncKyVAHmEbctZUg
	V6bjYpOyNxtgkJkb2e7JHkVydbbAKnq1TdA==
X-Google-Smtp-Source: AGHT+IEenob1JoKLFexDbIKx2AIbRh0HfTi7tgzzyJ46nb+DTSQdX6wLisZdHxDOfQgdRENh8XvLqw==
X-Received: by 2002:a05:6602:7403:b0:867:6c90:4867 with SMTP id ca18e2360f4ac-87c6504a724mr115953939f.14.1753219613813;
        Tue, 22 Jul 2025 14:26:53 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87c0e40f9efsm331649039f.1.2025.07.22.14.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 14:26:53 -0700 (PDT)
Message-ID: <27d83e9f-c2f7-4d8f-b5c2-0b23ece4ed0b@linuxfoundation.org>
Date: Tue, 22 Jul 2025 15:26:51 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/79] 6.1.147-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/25 07:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.147 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.147-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
