Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C121925AC
	for <patches@lists.linux.dev>; Wed, 20 Nov 2024 23:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732144933; cv=none; b=EhM+wmLn6NxG2fMd5uwbRnv/AYjAVdB9xrZjITlrCem0Yx1miur2+dW4kFEtyEfFoCaJxVmHI/32LAFkWrxLfnau2szBaJaBYiqzeljx0ObGLOnzEHdfHs79ctglNanbc8b5Axd9+fq08flLgEh8l71MYXG17JoFkMmRBk9QJgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732144933; c=relaxed/simple;
	bh=jgDIqGZI7Qz9TWm+MGExUPJL+GPCEewDXf9PNDtwKvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hbDjiLG/tNBMQQRVOXgaH+rbzQ+5nCZ3EVGPI6+F3+kvpwEucHbDUsWqfUzOFr1Kwz/lvAnNy/V9XuLlsn0Si+UVqgu2imEIQ7WdVEM69I4nGhXbA3gaQOc87ddGs6Uw737/WlZXMOR511sK3LDZaFJ05rKBecRXKrglb5DBQeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LI4UoAsS; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LI4UoAsS"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a75cad5eddso967435ab.3
        for <patches@lists.linux.dev>; Wed, 20 Nov 2024 15:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1732144931; x=1732749731; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zNrmDAVT/R4KOHT7JjL9sZNJ7b8BJs3agtROKa254/I=;
        b=LI4UoAsStb6x9f+eojmQR7IbFMk0Mybasy/Xvex17s6cSc8Lrvb8CeXmC2v6IWhhYC
         gYE4ork6vGCocGL47o1dyDAheGRVP6G/nGtdpjf1kfL1RiyxSCqB87cHoc/VOBzVFm4L
         XBaSQBVZZa1ZkGazqQE+1pUZvCVC+Yo9zLVBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732144931; x=1732749731;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zNrmDAVT/R4KOHT7JjL9sZNJ7b8BJs3agtROKa254/I=;
        b=XSfEwAsNKaGXFMBDSUZlk7kfkUaXjwjuW75cRPk07CFEOFnMKY7earco55QrSX19HU
         6EGKT8DzcYBcyhtZEO4d+tdOmMGVPpvHiPFagsZdYjx60JF1INJYlbAuOdhk8pV8zPvL
         RQJtfQ7sK1NjqvZZbLk0fHhs2Ipd26WJ7Ss0r55oRPXwn6g2BSueEqJexz4mASC0mImS
         fT447ksSHMDJDmID1FYhLoHqQtdB66KjhT92tfxnNgc5ybYzaRVYFifL7mlgh7vRn0jL
         3fUwlp4gDXi5uEg8Ly1vUJDXDwIr/2Yxw0JNIodNaFHT2+wtvonYthsSvC3YlDqd1PI4
         b6DA==
X-Gm-Message-State: AOJu0YzUa8h0AByKPSyv3hS27y6YMkL5yNWTnQhLSe1oESLqvKzQT+EM
	v/Yu7mcZEOxrL1tTETL/RNqiejlXhsMYCcxRRLowhXA7geNX0SXeKldl0sk42pk=
X-Gm-Gg: ASbGncuzq4aI+zwDtRVea6/L5v47f9YFQQOxLVGNrERlozbyezA+j+LYMiCT7xrj5un
	pP/rwzgqLReaelITKgTlSyNuUHmaCjUpKvGFfteJu37mjXP7FTiuA8pgQa3/LQjWP44Fgh4fbOY
	k6koUEE7Ay/RnMWuFxFQqmIwKvNjEGgnl6gnm82pvCqbBq63h7sAA4BuIjw+EDMUTgUvC5u0w74
	SNYQqtGCJwW/MTllxCvojqcRwAl0rZE6QdrpePeZJXyxvBjT9oL/daEw1MPNA==
X-Google-Smtp-Source: AGHT+IFQ6ZOS1DQSEJHQLfTo8fAp/CwP9Ri+uhc9AlpvsuSdF0Ze58MSF5XAOkYeTL8fNjZ5harxJg==
X-Received: by 2002:a05:6e02:1d89:b0:3a0:9c99:32d6 with SMTP id e9e14a558f8ab-3a78659d25cmr50689465ab.24.1732144929929;
        Wed, 20 Nov 2024 15:22:09 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e06d6eb77asm3347026173.5.2024.11.20.15.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 15:22:09 -0800 (PST)
Message-ID: <6179b0fd-0427-4179-b8c1-7f488fe6b7b5@linuxfoundation.org>
Date: Wed, 20 Nov 2024 16:22:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 05:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.119 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:57:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.119-rc1.gz
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

