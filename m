Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793287288;
	b=shDvhgI9oRtkxYWogW1cgQT3LW10QejBvW9s9I66YqRpOealaTmWvfRrvEK2OyiBlO3B
	 Zmrqfokhh3EW//pBSEc+UB1m3n9IPLKCvfj4q/SYidmZrxVfnJv1Rg5AM5DDrS1gXx/wh
	 mxgeRK5dUM6CDTyuLBC2Bs84QA2w0bAjh5Qa40ZwUrrmZG+fht1xxLmE0GU3P2VE1Ixep
	 /u1aE4Rta7yU1rjJnOIok89cC63X0CQ+FsqaC4llMgg8I9cmFTfYWC7aUdb9mT+QoFHWv
	 9CFxzRzR/GoCtpx8AwFOx0kzaFSu1qVnQMlthSpKyZXaWRLE6OMPAr2K0WGxEnVQw+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793287288;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=6BGV7yfySv9YIO2Ud9WZxlpBcZd34hv06GQf4K+p8/M=;
	b=lECxoaClT05VdloJ0oD4mfpdn+AG1goRdM2yoqs2RjJ9koJ+A14JNom3WivXQUAod5XM
	 uMOd2n14Ix0rZtzl5CEZoDX7t1Z7nq085xX6hnFT9haMIDD1pe216MoNkFzCHANRDdNBC
	 N87ma4xaBSJls1BZVtuWX/ADQyMmrQ0aJMxix3rd/4qgOV2wEATw3WCg+xwQYVl5H8Bpk
	 TEOlb885r+K2RQtvbSbcdphJscL4gHht5d8GmM1lO2jbQvqnSMnZtQw1JsaBA2v+q4JO5
	 5Q+7h2s2tilL18A67Oslp51maTeFEKwtHA14kilJEhoZ8uOsM8LL+6gN1OgmCrBkQ/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=Ky3eBYKL;
	arc=none smtp.remote-ip=209.85.160.49
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9661606A323
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 15:21:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9661606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=Ky3eBYKL
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-49e1251674cso970380fac.2
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 08:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793287286; x=1793892086; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6BGV7yfySv9YIO2Ud9WZxlpBcZd34hv06GQf4K+p8/M=;
        b=Ky3eBYKL/Jwy5ihUxgfumqzhkbdn+81aR01Qld/YTwCEescWV2Uj2zfu6e/K3YN+pF
         pYhQKazPai1CyV/L5uGLgbU2MI+tK469nX3OvH4V8oxzDnURzs03mTWKn2pYIv7+N76a
         LlMaiYPXtoj3AkOPUKpwv2p+VQH0JySEzqGMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793287286; x=1793892086;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6BGV7yfySv9YIO2Ud9WZxlpBcZd34hv06GQf4K+p8/M=;
        b=S4FLYqlBaigOVuWqVubrVVXAQmC/Lslpq85vB39PLZCbLl1SbemIBWdTySwoUtQDnf
         9sTLVbbWiT9DHLOCkPnTwyunJdwvibfAqg9uosy3HDpHekzMH0epSECRj6uFYS2si0BA
         WuJHQ92CtijlaZ1rfjOMvWfF4gdzcfhzjwxpzlrMxO5Eu5OLeu+l2dzZ2ZGa4IsSLlEi
         sSFkJyCtVboiwNy+TeiN0fGJ+5Tx43mbNHYzTfJxgcMs6/wo20GVIZ1n3cFu2AJiWJPu
         utBuOWVJYTes8I4MQ8vsWyITxjZWz1wElhi7t8qYGUsQYwkUv86g0V1jLY666H5uob16
         S5hg==
X-Gm-Message-State: AFq9FYJpexvOthOiP6XoMRxOIqRns2ndnlq5WIWG2oAyQzLEOExRCA0x
	QDpZd4OL4oK2nWNSe/mP92wIGxDFKMYFcL3F4iqLcEmx5gTxaZazFgdDnBTl9YUNe+g=
X-Gm-Gg: AYBFou23fClLkohf6UlqllfOfNkG2xgLosmRV9kPFRWWahfFeNeHsBWKyHByVhDK/ZC
	2flEFbnf9rvveDkdwc328XJsWrhtI83BsoL7t0ULI4X0n6G3LWItSbVvzhhFvCEIjPgHzcPt+Oa
	YjBM92fxpd40Ifew18NeG1ZKi2kn8ZGimFVfFApG8sU1rmTNLR48spH0oux8kasuwa1JQC33alK
	B6K4QWKjTonC60sYY5JBxffzt1yLLat0KMGasYa8GHLif/GhWAAD3LvSJ+PoLpj1eQwvSXm0VHX
	3tFjrAT6edj1cezwcb7Ijqwx8g2GbzhXp6+pRkdhwXe4OOQ2nDhnaiT+/AaOkvunczwxTeziM28
	65ws8V3zQq1/zwceHU+XZvz80uLiAfaZbwNfZO+CYbDAAcNqHayfsOBhzOrneUNy+ue62Jq0mp/
	Us6iwI892yoDPs9JHoPNzXTDV4qGpdmBReLZYUb/eP35+LCfWVm+RU8SU1YvuoCN1MM1zzgIqar
	DnvJ4DBYTpuZUpn/Dw2zafx+5fQ9r+vRwYkEII7SmBiROAX99ZnotDthUMtV5nVzb5ygYflWHYA
	e8fHslcHI0OpdaJcbVuR9TDBniW1I7OeVn61tGs=
X-Received: by 2002:a05:6870:314:b0:47d:b8a7:40f5 with SMTP id 586e51a60fabf-4a8bb9f0b69mr3976866fac.22.1793287285561;
        Thu, 29 Oct 2026 08:21:25 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a901ff3779sm1006fac.4.2026.10.29.08.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 08:21:24 -0700 (PDT)
Message-ID: <111e33a2-72a8-43a9-8a10-a065339c3ca0@linuxfoundation.org>
Date: Thu, 29 Oct 2026 09:21:21 -0600
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
Subject: Re: [PATCH 6.18 000/109] 6.18.60-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 10:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.60 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.60-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
