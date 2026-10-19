Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792453801;
	b=SLXZBO5PmUGZFmFuaB/wHNAuRkXovg03QkpIaStY2XCYmNq0xVsU1fGiiqqaeLUigf1X
	 yA7s/j1xNLmju4/98J2hZP/9hB/HWvTDLjl6J2wKUc5mBpv1VTWorf4hI44C3iEFMj7Vk
	 AXXyOQr92A0N04ytChjTAzxWZmxRNk0Kk9bR4U9dGCEWf+qyfR0EtpWOXrGEcdrJn1Mt6
	 1SH0s49G58BZMAvq9qjvF+JCbvh997Clk1Yk9eNveU3NxAyZWU+q1ePh90rUUkWu1FR49
	 2UsLPLKZ5Ww9NORzzlvz1+zzowsUbBjpawrCCDbl/l1HAdFBziUI14krmhRKjbbm2yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792453801;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=DD8Fwe5v4TmgrbD+fiaZCMxv0O6FicbhV371nOaahNo=;
	b=N/Zbh49oFA2CLz5L7GFTv2vduBtXz/srd7WhnxHNW9ThCz7q3GD/fQ6LkbVJhCvoZWkV
	 4aLyNSdJMKta+8JKW+Ix4IgsCW7G9a4q3mts+V8ZDmCWKXCE0p398MvGORdMkX6LueSFg
	 4h3pEA1P1L9RQc1XOFT5iLKaqZXuAJqN9OhZ7Zp8Rru21vtmmdKpzxLW3EOuZOeN8uXO5
	 3Cgj6DCWgMQ+Dn1jCdoJo7ng+55tF7c+6SaGEmrUtQRPTIUxysBonoZDbvezTDY2Vr6WT
	 XUwsZNFFZn4l4zPx66euGPRCD+aosvnvv9geHiwZKzBNTnxsq0bcQej45j/Z8qHtiOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=AKVmMqip;
	arc=none smtp.remote-ip=209.85.210.47
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA93606A31B
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 23:50:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EA93606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=AKVmMqip
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-825b40f8a26so1301213a34.1
        for <patches@lists.linux.dev>; Mon, 19 Oct 2026 16:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1792453799; x=1793058599; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DD8Fwe5v4TmgrbD+fiaZCMxv0O6FicbhV371nOaahNo=;
        b=AKVmMqipQgTjj9KQ2ZBdwaglc/2Di1ke2XqQVEgaeDgkEkvseINDL5Z0XZCFj+Xhvu
         gDxL39rR0DF5JnVKGMZ50EVyC215YUTNxHjo8leqb26Df5ikVYdn1S6qjR00XrDwRGQB
         AYhkoSDmYv5cmyoKQE3mlppueJrDOzRmqugrs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792453799; x=1793058599;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DD8Fwe5v4TmgrbD+fiaZCMxv0O6FicbhV371nOaahNo=;
        b=DzhO/SePLIPPNOHWbupiGKJH+rmDvzV5OcPJqdafeD00B95zv/3qGAHpMb2xH2w5ps
         qmD8AGIScI4Q49aIhKPil0gNHEIPzmCtzcGQdHvLQ9Ox57A1a/ur7EhllWQwEh6KnaPI
         fZ1YYWW2fyWsUhSesFSAYwNiaLjZIhsKlTav+/eLwwx69DzYjFYknCDawhUOpMpf6h/+
         rz6Zt8eq5HKzldMBGmj8TXNBCv/e+Zzw2rya44z00qJc073yWrEbvK85K/slVdPeA6mL
         iCYoSQHZL+yoaE0ZD8rQYNTnN+j7pbiq1ob7+Jydg7vOolCdvEIXjTfFz6RF1NdJMsXc
         uaEA==
X-Gm-Message-State: AFq9FYLNbvHasq//pOSNMKWal5AZ5cp3ech/hmXsDM+J+hsy8D6Cg0Bv
	nUl6hquNETziB+oYroEJXEFACzGaFEqaN8gBaUe2aLX9Y1L8tj/5p/ip5mZy2O+VZIs=
X-Gm-Gg: AYBFou1NIxgeEKCLsc37CsRTdcQ/tv2g+k/9cWTW742abTO2LTroN+4ve/Jk4yoBQ75
	VroyOP4gzb+mPe66qnw+oMDcNFNb6xS8i4EiE63HvmuliAXLsermCsBTfoPta+elNs3+LGr78XI
	9yL0UVm7HEN1l6p9EZvXf6sSLIaA7+D8ES8CvokimP8/tsBu6CwxhckdqERAGzCTNQEA33g6Z/c
	y2CpYq8yuXLd5fYQaJBG8ORAfkj0YemRu1jEm9TaIqLnb/FSLNQyym+tjYFYWMaejaGaNbtsVsp
	3S/JbfcQGuRzczDVkHoUqXpiGuszfKvJAqd3oPgjfSQ8PNfy6xZOPQY2E3ZVb6o6AA3rmQamM6v
	T1pOT2mg/UzAY7QJXGlEJreKPecpLagX8Ic3ohvPeR3wHrB1AzR62qcybWECNKIzpU0qQsdrPpJ
	PrHBv9R4UYkcDCBCd3xBU5o5zubwTv1Qzzvmc2KNdiI3jF6hRw85pJ1qjXKtsr714NcBRYZ+phO
	+9ohFkM
X-Received: by 2002:a05:6830:83b4:b0:7fa:5c68:d04d with SMTP id 46e09a7af769-8450097d1fcmr9148770a34.23.1792453799136;
        Mon, 19 Oct 2026 16:49:59 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-842a53d8a52sm10631518a34.11.2026.10.19.16.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 16:49:58 -0700 (PDT)
Message-ID: <c93ef8f1-5d63-4a99-ac1c-c07ed233e22d@linuxfoundation.org>
Date: Mon, 19 Oct 2026 17:49:51 -0600
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/869] 6.12.114-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 09:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.114 release.
> There are 869 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Oct 2026 15:59:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.114-rc1.gz
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
