Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAA3443D
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 00:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707869848; cv=none; b=CZPIuVry/wnDW9pTeO+pjTPYHuXduv80WfnSHdX0VCjrkSPiBEf9cBZY0Ql/LjOnrh9Id4xswQIE3lagLQUZP+NORQE5ViyXP2bihBcUX6CsLg/YhdVaX+580ZLOUSN8GN23fNsN7wajEl4ZoI4srZPgKB1JngHjByYPNBC8BOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707869848; c=relaxed/simple;
	bh=GtNPwOVeYqEoQND8csoZlzv6nrrvTMepd1LrHxfG9Dc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nj3MoxRXehMIgoyyJIt/7sne81GkUoVSw4PQPKOrJZ+zJpMYMEXkkPyZUNcJkjHYmq+ofxjrO1KJWxfNW+Gmr1CaV8q8tEwJC3X7DZ5PIXsJW4OsynRNhCHF7oS2WfCNLSj4YEc60uenfUJcyDRSZ7yQ0IGawOrvfTZxmfjHUkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJp+EgdY; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJp+EgdY"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso48706639f.0
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 16:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1707869846; x=1708474646; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8R1ZRFNPBDSJKTf9xhbBZxVe1DfFeuBRTvA+gPMKArY=;
        b=bJp+EgdYqXhDhvHZ5KhK1H5cPWRqDzMMHvnUvX6o6tpQVxilkhriNfPkeT8DIDW+Ey
         Snvea+gE8jZi013kmmrMVYGQ1BzrcRxaA7N+Xx6H0azX95Uk39AkEFwQezayDVXcnVUu
         WFppy+gvb3rrvxocGBxXNy34obeeIQ60rlw2U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707869846; x=1708474646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8R1ZRFNPBDSJKTf9xhbBZxVe1DfFeuBRTvA+gPMKArY=;
        b=p/4Zu7HAW09/D/PJCzGvDgUujlWJVsOwoQKF8eFQnUrbeymCTryuNhbAGlgvhOPxOm
         z5KpfrpAdiAYN+TZ2ik61yNoAaaEsolEoVbZBUGZRowB9rS2mglZlzdeNlI06aoIHNIx
         CSBu9vLvQt7wD1iwbaW4BsWo083kGj+M/CHdAPx8i6l7KKdwGl6gG+B2RpaMTfoTRcV3
         SpPhAT+z9NHyxsa/qnUStER7uZKnewnCjgk1Gk4wDV9hmcnRJuJFLfIS8++eaXU5fMMc
         Rg1wPGlaVmN/+UvPj47TO8nHGHY/u8m8eta4NdciwLQpJ3WmKSO8j9WaQcyzmdP/FfIo
         zWzQ==
X-Gm-Message-State: AOJu0Yzl5AOccL5Bqs9sKnI+X5JxcDmHFeeAzhrdo4l/j3vXxkpYDQiL
	9MJR7fcvN1Arbk7+kmMCuv1mrGu+54dOWFh2v0oP4N+P2KGa4WlOjgTvQVNU5Lc=
X-Google-Smtp-Source: AGHT+IFGag4hMH+UjZfIrNALOjx0iTOt+qW4FggRBh/NEjikHy6F0nGspfe+Go/nWvUqvVrOBwQjsw==
X-Received: by 2002:a05:6e02:1d87:b0:363:dc84:ef56 with SMTP id h7-20020a056e021d8700b00363dc84ef56mr1461086ila.1.1707869846047;
        Tue, 13 Feb 2024 16:17:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUJQruroDPboQu4W7vqSgcJpaFCwZkx/7K+IODSFDmLCHX3CTRFDleS5GZ+DK9cXEIPmDW3GVdi/2QrMsTZFoVHFT0CGXm99RLcvIXrcUBkxYNE0HgGeywyUvYLxTtVagWmjn0T9FhGUws1tvh+0x0x4YmRzcai0KfCTiWNa8x9/OUbwPeMPgCRWUtgoQ4QkJvWMAL84DzUUqdBO15C3fV9dJ/DrA0J48IKjUNn8v4vP6aoHNhkVXz3jAzSfhv7C3inKy6yNcREy1/rKgW6CYNF6R0rynxpLdb3KPlS3NSvAkNdE7jQ1t6ipIfcwIbMNR3yLlCPLAqVncB0kO1cXFF9OUnQWyEFhuo7/IJn5T17NW1PffTbqmJ59DHlBwaheWmAPMmEUochD3e68A4jmOhUZNOQq9ILcBdT2ImxIsewiBMEac1P6JmEWObXxarlYltdOiLnKqOsRrDfaTs4IEqSa+GhdtqjJkpj4Lt89dDKyrZNOeu9gT/4MwPxoSqiE4PnjPdOxarLJ4keORWfZZskCwbncdbK/vTCWzDf3sARJOLeF+pCu+d4BveMbSWknPW7kzVgDzSywA==
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id db7-20020a056e023d0700b00363bf95e16fsm2788860ilb.15.2024.02.13.16.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 16:17:25 -0800 (PST)
Message-ID: <a343de6a-c377-4a81-abbf-6e98652bac29@linuxfoundation.org>
Date: Tue, 13 Feb 2024 17:17:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/64] 6.1.78-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/24 10:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.78 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.78-rc1.gz
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
