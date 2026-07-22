Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96404416868
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784739970; cv=none; b=Ovc09c6w4SyhNZNmzSRKXPEIbyYlPtAWpmnelnlFZ9urWQvFgZR85kvC4FnMrwIVmZ2ZpJVLHCDRAy0UUg9Jc/hZ/7yydE77H9n1rLg/YOHANOrdzIARrGyv0oaNCccOFR75QAFqvIIoxbVxD3P5Rt7OikPNdHeklrr+vyCNsD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784739970; c=relaxed/simple;
	bh=PhHY5OapL17Z9SnPRBE0Knm7qcuY9mOc0SLNq/JjaTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XuYQELBFbjR0BN33Pl+DdoAaBuCvRy3b44ymtfWArbdbQu4+PXMZ7V880sOqA9LOtFZSK7oq8bMKwJ6nQy0zQLDPxt2wGr69Yv7p89zv2Ul18/gddYf0adecNU3BsM9i/WtKuRe0DyWq0wFrLEf3vhghyaaYcBzQaJ5vs8LaO7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxLAjrKx; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxLAjrKx"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e6b5737bb2so9877573a34.1
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 10:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1784739967; x=1785344767; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NZSO8OvxTDLN5UFyY7dc60tHnurAXrxnY1hLSFHH3LI=;
        b=JxLAjrKxHbYsr2ayyuM/uLqUnV0q9N0mKiwq8SljoDdPtseunsYXZPuENrx19Xki3I
         6UIz9RqXROsyj7ZJSehZLqI3QpCmKdr9+YiCUo99gU7k04qbpI02ZD4hgeNdOjoWejZv
         WSYzS+ngLbDwGlACgNeoFQPkUBcWTbUUMkWR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784739967; x=1785344767;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NZSO8OvxTDLN5UFyY7dc60tHnurAXrxnY1hLSFHH3LI=;
        b=WesQ41iEqpmpgHFhBooT3HC5T5vSTgMtDs+4a/pSOk8ZTdpvp/wicAUGvf0tJGhI2u
         rRzQ5wokL8TxYuEOiP3K2AhIgkGzpDcA3Vt6llBk2SwkZsaNeMH1UZ5HfhPYvAKQ+YP8
         2bl3nZ2TIWrRDxl08DmCHdxOKtoxLkP7gBl32XkecJpmUzU7Ug+CaT5TZ5VDC2D2effp
         LznHkyCqqxXwcvB//ji/RnVt9oVGRQvbmLn/a2jrbyBOWGGPlFaVjvUoJeT93RUfEzSG
         jj/YZcxesWFkd4q3ckpaiSGVwZlaCZhg8tG6uSNPyoZIw0/FX05X62hpk/FbWf4C7bZw
         /apQ==
X-Gm-Message-State: AOJu0YygSay3Q6eMPAwNp28DP05SKnti0ezZMORWbxXr+ckr3kl2Cijt
	8zoBVmnBD/5A3CDazV9Xsi5SVlur9/+gghJyh1wa2j6TKX41QKkCPbkqDc7L1kfJqwY=
X-Gm-Gg: AR+sD11e2kjoozVdeQtYtln+j7Yeud9Mah7q7sn8MqMXtX/PCf+a7YUNTHAtyucT18G
	z9/x4oLpdFxEmo8fNtGkYvz0znM+oAf1fQV+eMS6QL1HM3zE+ce68DF1rBDJtkZ+h6Y6hkRaeTu
	qGcdk6xqiNSkvwD7/ey/D0KBv5c/I0iJgol7Wq8s+Rn4LvYvfg5Wfbqm3MCt4lHSXu2aX66/Tn3
	0pgBaVcAQXf2rkGeL0YcyWwTGy/6w/mv8ZHBMB/iTtQMuylFO/5N07kBhQh5tiiH0zm7TUEdfF9
	bxHdwmTUnJVignvAy6kP/F4h4zDbkySiENp+w/avNwtrnsdSAJL6aR7QGBzfc72lUmDCToT7kpp
	osx6bCtnyzrYmscK0VrgiRYfXSea6YuLleRNKEpNZZt5mqAP2x7J7fI/hd7ILSJyfiL0OtC80Gn
	ChxQQbw3JaFPitBGWv5tQN9g==
X-Received: by 2002:a05:6830:4195:b0:7e9:d3aa:e391 with SMTP id 46e09a7af769-7ed9aa5776fmr12393314a34.6.1784739967396;
        Wed, 22 Jul 2026 10:06:07 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ee2a0b0fbfsm1714272a34.23.2026.07.22.10.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 10:06:06 -0700 (PDT)
Message-ID: <4eaee968-0944-4f58-b642-017cf19c95c2@linuxfoundation.org>
Date: Wed, 22 Jul 2026 11:06:04 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1276] 6.12.97-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 09:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.97-rc1.gz
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
