Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BBF262FF0
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 14:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752677494; cv=none; b=oT3v20EbF5IYPkIgvTKJCef+FrGfbxVUEWXvp63/doQKlZ0n8o/MqPkyUQiqsWh5NIBoCHV0RGkApAJ3FqLh9qAmy5abfsnl7rTzpjHwG52dK/3HViTvks1xtaV+jOCtoqVS3XSqYC6oJZggax6yJHD+YSuIWWJIcMjXOJr5SOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752677494; c=relaxed/simple;
	bh=ykpYMgCTCP5IA6crj9QAcn4gLod+08HVDpTkohc2frU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m7x+eBF5IOXhbWXlsxVYCvI7XGPzZlSV3Grb3rfRDpP0f0fXBpSAJlZiS/Yhwvqf2zxA9nq6IGfKp3gbVCoDGGQhNjldRd4M8lCOqQ6SffTFPFqy6Ez0dZuBilCdjczRddwAhpcS8nISDme9sBjhmBYBEFtZ6tlP4MyQU0956Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdllWdqB; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdllWdqB"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3dda399db09so54707005ab.3
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 07:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1752677492; x=1753282292; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oZ4fgAdCXaMF+X8p3B+OtFN3EJU615/xlwO/KEG8q1E=;
        b=JdllWdqB12mC8dsONZh2IkE7tal4g44Juy6yn932MCVevTtJdxqc1/tibK+fb1xIyB
         YxDwn86x5+Qk1rbItRKA7ykQy744nS9Jz6f71vQ91WxjU8h8Zzne6clQvwPFyTArcnYb
         QJYtzYFxxgieaqHS1mGFhkO4Q30r787qOmDig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752677492; x=1753282292;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZ4fgAdCXaMF+X8p3B+OtFN3EJU615/xlwO/KEG8q1E=;
        b=CLflhFqsKUdN0jEnrweOQHlFr78XlUe9VkPlYecTCJpwcGa73Mvd1aQmsGzXg97RdS
         LPJJUS/wDUfVW3KB1LC/BXi40x/6l9pH8KggAtXCynyiJfPYljqkDx0ZioInI/XY3tg4
         9AUpdNkfISgprJmXgdSjbZk3YaIikHTxfC8iwRccDVabGDHRY7DdLBAZztM5MeNmFGl0
         NUuOh4RCwJQA5I7Ds13DtxB7rIDQZv/E4jJr76Wk66oBlG997Bts8BN4up+60yqAw2fA
         iXSUNbq4YJYh9PtFVwY4546rUTYkxfMt1Q0LCK0RjvFJq7gBi0LMIl/YK+gu/uPe5ldT
         Wdug==
X-Gm-Message-State: AOJu0Yyk5A+OVkU+E03eC7290aWewXaXduPbWzXlSdn+mxE5EbJkdcRT
	9ourDL1evYAM1dzkTAj4G4sPK/auiMzNgNuRNp/A+vBhUxKOJJvjHQu8RL82aKcaxxY=
X-Gm-Gg: ASbGncuTM8wMUuYAApJG0wEIrFyuYF8kNwA0JPwiVlIV6WzZXjh7AIrW6qTXBo2n3iM
	3X+8+JhY9GKvZxrokOZYoI+H5TORqGZlPSCmb/WRI74yJqdcjQVu9OlkQzHMVS7nVLhb6ixaTa/
	RwxnUo1ymUvp+m67bCzQe+zGEdUB/6KGI2iCaZm4oAlsQ062oRL+y0vhrQhdCQ4f/AdZjhe3rgN
	O17LjmDYgMVjH+NGFjzPeNFlOFZ5v8B7oMPR0MWznXHcxMB+uXpWavtO0lZDIxPSCxV5gGieiBM
	sTMG+wF5SrS7X6P54AQleeXFlWcbByAULB8suP/QEBKXf9sVlI+Edk0/LVS7p5AmT1/7E6/Q4B1
	GY/fX+Ee87J+sp4u4nh8hiiV5Hp0V4e6p6g==
X-Google-Smtp-Source: AGHT+IH2P5ahWBwNlpCIsyRgQhzxMyn4xcRyAWIOS7heh/HEDYEdDgo3ckJ9w7dS/5M/k73/Vil5rQ==
X-Received: by 2002:a92:cd03:0:b0:3dd:ce9b:aa17 with SMTP id e9e14a558f8ab-3e28251fdb3mr29219435ab.20.1752677491760;
        Wed, 16 Jul 2025 07:51:31 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e24620aad0sm44817485ab.34.2025.07.16.07.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 07:51:31 -0700 (PDT)
Message-ID: <a5582e62-274b-4c61-a9fe-9b7ad0b87970@linuxfoundation.org>
Date: Wed, 16 Jul 2025 08:51:30 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/163] 6.12.39-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 07:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.39 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.39-rc1.gz
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
