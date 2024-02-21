Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D892212D76D
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 23:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708558951; cv=none; b=S4SIqCNdUBdLQ3uaPwfQvEo4NOo9lg1IPtHFEztC3kXAQQfbr0vsc0P1OephbaHn3rjmSNqjhfO9lQvKCiG1k+EGskanjiusIyD2xuo7ij+WowF9Xl5u10tUBjF+BTygSZH7qGU9SS9pwjqlGRWWQVrhyAp+yQ7Y1+QIC+bpt2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708558951; c=relaxed/simple;
	bh=DRjQ2RMrvvFcgAl8DJc22OUJZXfHIMDxQKsf1bZcINU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OdHOVaE2IpisDEi2+Rh0yQAteM1hfEIT/HU3Lfth6nBwevsrZyVOOp78Bls4skQXfgooPgOwZVTyU7DU3L5h5fxwYmC6+NCv1fxyOX/0EV7nLmN3qpJ2sQi2JaUfVxGzv9WdISqpbxafVpaijwG/VbguoTBxypqbJkkmMf7ZJaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1d4Ok9a; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1d4Ok9a"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-365306a6455so4225905ab.0
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 15:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1708558949; x=1709163749; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TToKF+RcIDqTyQ1ZlzqOBzZqj3ctKqshlDQrKFkCjgo=;
        b=M1d4Ok9azp4LrYea2Dfw/mLWLHEOAei2exiBzEgYe7bhvbleJL6DWtnzQf0C9/WjTP
         5qUzHS2zp7ImljJumqzUVYBU9FKjRZ9e60sMsppwdTI8NnhNb2O8HGSqpeC+vX1jg7et
         I6A8L8y+PcoaFRo83yulbu+ns8nXsNI21NYGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708558949; x=1709163749;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TToKF+RcIDqTyQ1ZlzqOBzZqj3ctKqshlDQrKFkCjgo=;
        b=syV6ijfHtcSUt0LG7Kms+w5SiHQShb7qLOy5mNkjrwrEWVQ5QbSwx9D5qUD1nL1zkL
         TrBXlCdGbIZsUzg3Mbu8j5mE7/3+QtAXSljiHI+5RL69rPNE7kC1E1uHH4xCxqfm0H3c
         H9wbjafqjK/qFQd1NaYGIGwc58tEVv1/YpROmFuQrEQ8k0xwZHn5CH7CCtrSM2WwIHCj
         Cj1tSx+ETLtIsCziTX5Kd/u/ObKa8OmlfvMjMBw7TacMyuXLja81+8v7zuJalLoxK7OJ
         XQxlxMgMtzwh7cIqr2ZAFuEmHokCtkEBoYbvUReQk/wWugnLt+R2XIU2pKFkqcdGqUi7
         Nr4w==
X-Gm-Message-State: AOJu0Yx/NlIp1qKfrk5Qp+hHqZ2wNk/8PbsNbbpzobyRtSW/uol0Ab21
	oAOoOiWXaSzOzLkRkOZlj9RFrlA/Hh1RpIgNRJF1rcbXe9oB6YnjMhHoNz1ydKY=
X-Google-Smtp-Source: AGHT+IHS5EsQmsWHtFblC+GYNPn2/aXeJ+RVQCDeZ9fkYYv60uAvnFKF7Vu3HzcvspHc3fuwT+z7QA==
X-Received: by 2002:a05:6e02:170e:b0:363:c82e:57d9 with SMTP id u14-20020a056e02170e00b00363c82e57d9mr16758159ill.3.1708558949053;
        Wed, 21 Feb 2024 15:42:29 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id y11-20020a02904b000000b00473cdc58012sm2932344jaf.134.2024.02.21.15.42.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 15:42:28 -0800 (PST)
Message-ID: <988f0326-5895-4491-af82-c6619b048816@linuxfoundation.org>
Date: Wed, 21 Feb 2024 16:42:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 000/202] 4.19.307-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 06:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.307 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.307-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
