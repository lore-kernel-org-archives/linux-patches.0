Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9E81DDC2A
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 22:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757371393; cv=none; b=BEi/boPIA74nOFBnOwMZ8b4xdSIrTgMwHI/p/HZLwSXSr6YW5Zd7ypbe7TZc6MAQ7jozFMp4VvF1Ho7obxV4+aLRkV5x6T2p3TpkcWPbRC+1pGYBdERXmRPRjM9IIfQH1u80k6iYuVwyet0UhVI8g5zSbr7z3tpUS4NypvKSF24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757371393; c=relaxed/simple;
	bh=AP6NA17UFEK4vS8khTfuPrfkV1ahMoXWguAGdqx28dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BenqpHRul0N6gDMxK6xBp4wepY6X09UWqG0Vv+bZVCDI549Ismi2hY8EpB2a7l+jbsb+GkQlExXED0f/aBaiXbohzMvp02myFQlmUEsSdeG+93e/ZpqDzFEGHvvNIE39MO+FyVofw4sh9SNSh6a7iDng75NjdFBuGHhL/8oWY9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UixjvtlF; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UixjvtlF"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-88762f20125so392058639f.0
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 15:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1757371388; x=1757976188; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gbMGQyBboCuY5jK2F7f01ZV8qrT1w01meJgp/Y4sXz8=;
        b=UixjvtlFU1gKqjTNU6vBH+xopSUEDfQgfhaG5ZZJVK6XQaN8a5csESENMcbW4qEoHo
         dDW6ZMjky3qF0Zsku8s+pqx/ukncERJ1moBKhXXeEUp/7rsRltbdd66V68MfXzU5KPFl
         UH92pHwo/K4WlMWRQMcdUkysU/s25ob5dKEXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757371388; x=1757976188;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gbMGQyBboCuY5jK2F7f01ZV8qrT1w01meJgp/Y4sXz8=;
        b=oStB7naW1UsltxbrCNS0pJ+3avp1YxeEU8puphmOYGGe8W4Di2FxY0tUI2jSHx1S+y
         cUDD4Qnuyd54bbtv51TNjKdd+IqjRMMcO8dXJm2Is+2Fj53BlrWpe34sLQQc/y4VyYBN
         zo4SnMtIzZXzTbmsePr3STVv1KUCcz8AF5Gj/5PVo034GxQiMeEmYgXabWZNx1+tdEkg
         Jmro1j0GcRu6UZCl9d8v7d+I06EMtLtCJXNkSDtSDE5UHQGKHm/ZSgZdUk59ymQ8/qnu
         Ys/mOjw/Waprw4jzRykyAYK5aQi0zb5oPZcRsyONEDX/2ZMJYk+D2lWWnQ5yjLgf2SlM
         WVcA==
X-Gm-Message-State: AOJu0YyYd97ORDNGd/65cYL7FftXPXjuljPuK136XhUDk5hZfWLcAyBI
	MsCjKAZ2yzloum1IeRUuu9XwKFhlw/TwsjAZ3GDzMRFIM+QtJq+3x4vaeTEYJGCDGhz/VL4OxAD
	H3Jge
X-Gm-Gg: ASbGncswNpOaOUkJihx2WXj6NW83j5sfiEsBHpxZcmuF0eMK/WFPzoIehZJahNQUTQl
	77/tKIWR9wibaM1mtRy/Qrk9FDp8kgKbEzQu65k8eD0l0VBm6r+l65I/IeiH/U7ogExLf6g5Fbh
	qog9hUsdgHtlkMMb8gopE+Zo5qAR6oSTkiZTNAYECwGwMkAFSi+F/fSTA0Klr4m0epOIf93QQOi
	DwvzqFc0eOlx4alfCy/JgFZjYcI/QnLbwRBxqM0kbWL8+b5BkB6Uz3RM+7CqsA3NsLsd5//PzrM
	+7698SN0o/toMeJ11wFvJVOGNBjXxt6jyDGx8jGJcj9KKRHc+DIJIQmfgzOpbW8whMiFgNC6AyR
	YfBaTaAAfKem4pQnY0ZewjJ+p41MMyUuZJDoV9181xbj9rQ==
X-Google-Smtp-Source: AGHT+IG1BYp9Gge7NGDgi1L3gZTM5bfgvO7yzZ7+WLI8pWF6z3lCfVf2BGettYKpVA4ktS0Of3Te7g==
X-Received: by 2002:a05:6602:2c95:b0:883:fb4c:973f with SMTP id ca18e2360f4ac-887774dbf89mr1524260839f.2.1757371388285;
        Mon, 08 Sep 2025 15:43:08 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8871e2eb0edsm864803239f.2.2025.09.08.15.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 15:43:07 -0700 (PDT)
Message-ID: <9aa01cd5-a736-41a9-ba24-0f0c2001e878@linuxfoundation.org>
Date: Mon, 8 Sep 2025 16:43:06 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/104] 6.1.151-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/25 13:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.151 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.151-rc1.gz
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
