Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B44178399
	for <patches@lists.linux.dev>; Sun, 16 Jun 2024 12:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718541401; cv=none; b=FNWItRHGHTg/tCXkY2xymTQC9PTk2iOMEdpmuNrJdHbFo9aglSJYsNBwlzvCpWJLy/jBY4QHNwx1j7BVHU/QuQKitxjptrWWkf1Et+yyA2agnAXI3jR/Wd4r/scugC3nj0Z5XrYSL4mEU3xoD3hAD9KBoYItI8391kOVlVocjec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718541401; c=relaxed/simple;
	bh=fakACLntQ1iyFtnBpE49FE1WP3zNby3OBHq0weXJveY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kkOStHY9yRE8XO5tEoAzVzC0cXq8Zv1eS1Qr4dtkYftVW6v4oyWmjmAyunN27Uu/1Bh35sQfjDnKne2YOTa2v27PTJW+FejEqQ8IHWV3+farGU/VjP99zS5MgkStjKm7ou3By958X9E7T3wGtDrsk1FMtkT4ocQd/4aLpKoPYOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EyZTF0ST; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EyZTF0ST"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-795a4fde8bfso210754785a.2
        for <patches@lists.linux.dev>; Sun, 16 Jun 2024 05:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718541399; x=1719146199; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=B4DZRhtubWM7wW43QYGTxHEqFQddJ1NEWjvPCxCJAMI=;
        b=EyZTF0STpwEJ2jhfL0PMADPQ7SLsXsUr2bycgje4Z3DCt6qidAgmAVdQZWfpuK5oXf
         B5C3mYeQN1csMiB9ilvt0rmjFA083Z+XKGsR20fzj5c5paNxiBfqldCg9sriMKSeshuJ
         JPhZvBl2d9W2nWw+lSDuAWEE5jxhB5DbXWhF9sdFX2SD3tQPfF0J1o4f2D5FW3Ne80p/
         qJPTCyCFTS2DmgGPlW9kVKcAmhx9Adat8IQxt7j7eCA7o+Mi2ot4uwPdSSSxN3EQHz7h
         25uo7CR6zgtGg8pOs8iwB+ArdRFB/e2UUB2qNT+m2WNL0PTwY+FnIMljecCkNm577XpI
         GCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718541399; x=1719146199;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B4DZRhtubWM7wW43QYGTxHEqFQddJ1NEWjvPCxCJAMI=;
        b=dp622E/wKrI6NIc7DQZlollNMTES20gqrpXs16kmxiBumRNg1RXcyhrcD/bQr4huPp
         k8QRWz2+bz8Pa8o3lH7ypVxvHIEKf7O02BgV8L3mGL8gDQL4aSQ7pAs4h3HUPbFbmWaX
         McAN2D12e+4u7vqDA4+E17PjYb98BsHto7q99n/8EvIUqbQJPxnOTW/yNzDpeWk1b66X
         XfG5Q0PrWoupWdl6cwxs31rkjxjL0EoYMq+oKJof/DgTaKY5FOAI4BLD7tUAdHtkwKyV
         WdGcNcv+geUTDKqymGHSaSlL+B/kUPTgekuEVb4zytHcRpCY/+QlqKOfCIQ/ZjJIqlEa
         eAmQ==
X-Gm-Message-State: AOJu0Ywv894v2GeTQf27j8ADJdG2iBzhZQpLrRPAbq6Q4XFD3UFZvi3W
	ipiqtjGyeNrGia+9UfybqoeINXfWhe/F104Lse8sEqGVZUg7Ae7c
X-Google-Smtp-Source: AGHT+IHCJAYlfyiKffH9zTBhfQ80FPol1xmT9oaMfzZXg4xh+NfcoZ+c0EqAraDm4TJu4v/sF8kC9w==
X-Received: by 2002:a05:620a:1991:b0:795:4671:d494 with SMTP id af79cd13be357-798d240e2dfmr921541485a.25.1718541398526;
        Sun, 16 Jun 2024 05:36:38 -0700 (PDT)
Received: from [192.168.1.114] ([196.64.245.53])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-798aaee575fsm335344885a.40.2024.06.16.05.36.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jun 2024 05:36:37 -0700 (PDT)
Message-ID: <3f8e1951-6026-43c9-90e4-ae4305e98136@gmail.com>
Date: Sun, 16 Jun 2024 13:36:11 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/202] 5.4.278-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240613113227.759341286@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit





On 6/13/2024 12:31 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.278 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.278-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMST using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
