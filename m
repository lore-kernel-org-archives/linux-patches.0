Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3F5626DF
	for <patches@lists.linux.dev>; Tue, 28 May 2024 21:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716933241; cv=none; b=OJgnwXljwduHmsKbrcz9tGNueDV5zvQ3xPBdQZYYpgRsqOuOB+4Ck1kQvDrcgDUlxZZyZscuAJjaJ72VdFFS2uBBXYEhEfFfv3dhfZQRy8/5jm5/Zb7a3KLJmzfgi+Y80lr+hwM0F1XBU9Vg9ktFp5tBVtu22Wzw4xIJKul8MI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716933241; c=relaxed/simple;
	bh=1qdczpPOuQX42ByroNXbNe+HO1MN3jMHmqL4n2GjsDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dsmgp/GrVV/zHQCvm/4V7M+lj0SoKW7FwrXLIdp3ysF0q9Id8qB0unbq0IzLOxoeD02u30aT9cSP8KJf3qV940MhwsnB9+5+jq5M0aSMu663XcyZ9gDwZXkP4xkSEORwpflcPrNlmXX5Qoaud08pOT/JRi0RxDDORGuTmcpPeYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJ8Qsxwn; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJ8Qsxwn"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7ead7e95c91so4794839f.3
        for <patches@lists.linux.dev>; Tue, 28 May 2024 14:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1716933239; x=1717538039; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FfACfrliUC8RvUZvSpo29lWjHhmcZI934D2GcMw4Ck8=;
        b=WJ8Qsxwnsdo5wPLWd4jKiWsMJ9mnPv/iLTptGrdGFWv2/BlTceB5iPCfcIKdGBtc6I
         ThiQ3mITqGjLlDBXy9VjziL6NNwf9p8VTjjFNJ1Uk4L/kXrFCEeWd2oRppwiZD/v15TK
         f18vMNJsrkULj5nWUXap0mAhG5SJ/gkaevBVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716933239; x=1717538039;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FfACfrliUC8RvUZvSpo29lWjHhmcZI934D2GcMw4Ck8=;
        b=IOjZi+IZ3/0HF3+0rGwBfxfJkgVm+bh7MpK3/mi/gL6oMXiUmbcgS3WXXydpZuthAs
         vL/UxJUqzYWvTNk0wCAZ7/d4D31OjvVCSv0rVYJrc5YVa6IBJoXNV/Tg+nMKbXfCgDzK
         MPC1+wRmsOHmLGwF0nxomhSGKlxzWSVdAWEvb+TGsabSin6fze2sJlIXCd1HMDyTbY3B
         C/LLFcXb0zXyzvFLSf0/JUuaQVo2hy50xPtzLBcmR3zFvjA5vEfObrBQu6sS6SswQOP9
         ZAK6AwT3b5zMLpTOlbir1F3NIv4Nk/YydXoU+qxjnxcTEvWvWO4i4tzBWSPOPyhZwqGT
         sNiQ==
X-Gm-Message-State: AOJu0Yy6rUd//uxiljBFWQFFqTSKb81RaGweSuu4+VTvOef/g6fdGPDJ
	dJj6Q66PsaCOGxB6F5tFnHH1aP36OCXxzcIrpS+K3gwHHWyWYi76/PXAZH9+HnE=
X-Google-Smtp-Source: AGHT+IGlp+f9XTmGdfRN8ZCb2asH0wxF0ge73+1BXthKHmMYyHK/ofz+zklI+icES/RDoyHkhVbhgA==
X-Received: by 2002:a6b:ee11:0:b0:7e1:7e15:6471 with SMTP id ca18e2360f4ac-7e8c5f86536mr1456721639f.1.1716933238758;
        Tue, 28 May 2024 14:53:58 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b0f70c8acesm611762173.84.2024.05.28.14.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 14:53:58 -0700 (PDT)
Message-ID: <073f7048-5c3c-4581-a6ef-2e46f7d35ade@linuxfoundation.org>
Date: Tue, 28 May 2024 15:53:57 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 000/493] 6.8.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/27/24 12:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.12 release.
> There are 493 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 May 2024 18:53:22 +0000.
> Anything received after that time might be too late.
> 

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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
