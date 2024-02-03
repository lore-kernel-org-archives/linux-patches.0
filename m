Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F55B134B6
	for <patches@lists.linux.dev>; Sat,  3 Feb 2024 21:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706997395; cv=none; b=CRMY+zPlAzAJXXKSiLdOS2cnbbMdRVq4zNFzxiZA3mLSerXAHZtQsb9F5+TuOPh4o69oibT9rUVoJWTKr/j/27DOzmhDTLxMsJnKWgxlDQZ3BMT8pt1BGtu/l40d9vtn9BJAl3vG08y8VHpCfcDOhbYtD091qqIA7tOpnMGWfCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706997395; c=relaxed/simple;
	bh=oPiHuL7R+vkA095SZL64km4wfSqPTATslzLvOlfzXlg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=muQKEOKl/FKOSTLpkem4HcJUzjXHh03yvREu2cmbqxGJov70u/WvQ7GSrcq9orSsOtfZSmPEiyFV0g2Hf+C+xhvgtmIkTWUzLSL4oEiWVk09UBqIlaPaY407QjExGyZC1ScJ7/2h8VXOhMt0bHydl/crPQtFCnttl4o6NlY2fzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AJTlOXhj; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AJTlOXhj"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-78562c1ca4dso27120585a.0
        for <patches@lists.linux.dev>; Sat, 03 Feb 2024 13:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706997393; x=1707602193; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XlJORjV0cMXk8TeZ5ODKyQU7XXUQGwVFK1QhooGB8ms=;
        b=AJTlOXhjtBtlFNwMv91rygwq8FtYnDgzdaBK5JgGRark2LyVo5a4RStph2DWGPeqFt
         UYPZdVNE89jjLkpkJhKInShctk5QN+8vHJfdvEf3K9IVFNAluD8nuOlklH54p1Pzh51L
         /OHyqHr/1y1vWlXE9Moq6upuI6FL+Fz59dsbVWGe/mALU51MjdAy6Sy3bAtSOZGrUOjp
         K0O0NY8eUT9OlVwy3u3P/Lbc5y79Zpl477wpzjpOcp2ShddJodeFxzRGNr0n3bTUt5mA
         08d26S+NVf5NsKOIvgdEkYXze0e7tmc6wi8rMLdlB57Q2seTapK5/7jI0wHEDJqCJasN
         6CXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706997393; x=1707602193;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XlJORjV0cMXk8TeZ5ODKyQU7XXUQGwVFK1QhooGB8ms=;
        b=TnYIN+1mKVipWxFuzM2f5uTsWKU1FNKBJ/kZgh0e8ubQEBpq5Jcl4kYAu99JeGr+Vc
         tvo1rpKP6SJakue6+6UFYEM8Y/Rn7EIvqUD3zCaGtgeUA13ChSIiCr5ygQXUeVcI/R/j
         deJyKzoE8n1J4jlrdGNKf95ni/vmbA3ZPqOIe/wAM03h+9Jsr7ZBPnsq6aO0m1F5X7jj
         G6wgmNAIjXmR0NOxcTZ7ODE4zfaBjI6vvKdvmso+rAK4GX0fvjAd7dsB8GRZdSF2yL7/
         zxe/tKNgKeVwVC2QOFzo6PiytUarP/Nj+SKmYAsyL6LMOad1FJ7CCV/AzyOayCOEjQwy
         Kryw==
X-Gm-Message-State: AOJu0YzDhhPYQ8NMeVUAoWZ2us2PyWOVg5XIsGsudp0jLMR3buBVhwfc
	GY4fHTx3Tgq0ZuEKY2B5AS7v0ww36vvoL8hBMyd84YQfmZYqRnAZ
X-Google-Smtp-Source: AGHT+IGAOcEH3n+j1N34lCv6qXlG2Sn1UWAlfEqhLr/IwErxbW69Bxp1xKWo68098ckgeeNUh7Dpeg==
X-Received: by 2002:a05:620a:3913:b0:785:6fea:906c with SMTP id qr19-20020a05620a391300b007856fea906cmr2091213qkn.16.1706997392864;
        Sat, 03 Feb 2024 13:56:32 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW52quavIiaDvF7UuLWuuSylr5aHyKuO38AwJApZvz3vh0kcfoyBCW/G066/FJ45tH3uvtriGHRjVzvCnybPRrhcO/jmvjLPMjhPeiuaLtfpok9CdactCgGsxnqMgpGAE11hYUnls3/28cOaLiMTU8vBUS+1JNSAw+XPW6a1UvSHhi1nbiSQa/2xeqJfApdM72m3oWsRJo8Vn6TN7xVvmZxMWu3MQMzkJriU0Z7t+h3d1R/tw4/8vDhry0FQtrlyd4oUfuWv+Od5lX8WJFfvhCjJTUzF5CssCEauzBMlWD1KqSLzZu8UIRajZpbUlHhEVgBRFKH+YegjT0sK4jZnrIJB03RBApHFRyKf6vyGN/yEHpYHDDOCDwxXlTazTrZXaEfsioTKVYlHyASpkH67Zm6UBdc8cpYpAWwAwAVKJ1GAL55LD3lHYHTuOX98qO/MJTWcFb/yZb/6+z554mpctKioImNU3VlVQMHHXn/Mgp2UUNekhCRhuiR7lgLR/eNdkmC7rmHujyb
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id o18-20020a05620a22d200b00783fb468e7bsm1732958qki.44.2024.02.03.13.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Feb 2024 13:56:32 -0800 (PST)
Message-ID: <e638c370-e3b4-40a6-9d6b-0de9fff63c28@gmail.com>
Date: Sat, 3 Feb 2024 13:56:29 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/355] 6.7.4-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240203174813.681845076@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <20240203174813.681845076@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/3/2024 9:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.4 release.
> There are 355 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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
