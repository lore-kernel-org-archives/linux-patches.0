Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794254571;
	b=qhdPN5BQVw483JrjJSPRDjOZQrAhURDF4ux0Q/+KxxZS9FF4FQqEFnWPUzWoXxqWRiB9
	 Mc2i64cMeXRnDVwIZvubeyMiwRqZyJZF/A5CK+HGmQhzTa/ZL0OwstQfhzmqzt8ral0d3
	 GEzNtBowK81D5SMBTxDOWBTk6er+HP9ego45bJzNKDB643pzM0iXP/9U2kNV3EqnKjQy7
	 u+HK8lF57kJM33ri2yYjfesr7zboLYfRTkZlI80/RkL6GYhc/Bldrz2ghyOZqjDVYB4u0
	 9revg+FXML2CdU3Dee9mMfBySwBbw+/DfCEPsaTFfeP1MyPNw04Dn2SL99ORT9QdCAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794254571;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=erhI7CgGmnjEIhSdlY+i5ow50tWs7bchacWIGAhyT1Y=;
	b=SzQTsHgCcthdH19hjf0iY7/fMcmUCtuADhYDURCwDstJs5fmz0xB2rH5E7d7hJ3ez6FF
	 HMcXEAneNc1LwBEHqsfrepih9qBgv3pkKWeW/hlqz21n6SfiKePCtlfpBqdR4PLJk8BVB
	 O/WLXPMSi5r9+P6QcmtAyJzNY77r5TXGn/d2WTpf+3oCnt8lGotO3QxdXV5NtrO4xstT1
	 m/V/Axu2t9eZYb9tPTRFgpc1HeERlj6RWsNhMHXB/gp5KKosYQzWgOTjnFlqnveXuO7Zv
	 EYMhdgeQq3Swl4RIkHS01oVzo2mOJAzwmJr3RtVQiIBt/PJQyWYB8J2ZbPvy5tEzbDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=VHQuvr5n;
	arc=none smtp.remote-ip=209.85.161.42
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C9360A2609
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 20:02:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78C9360A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=VHQuvr5n
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-717034b331dso729521eaf.2
        for <patches@lists.linux.dev>; Mon, 09 Nov 2026 12:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1794254569; x=1794859369; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=erhI7CgGmnjEIhSdlY+i5ow50tWs7bchacWIGAhyT1Y=;
        b=VHQuvr5nF9981JrSjUswCqLE7Px1AxzMkDcRXBD3VK6p6469bW4yiDT8h6lKIPxp7r
         irJB04SXR/OxUhoWnQ+5/YJXTG76qzUaiao71Pge8ek9k61bjHl3nE9fAp3RtkdX+/oG
         DXHTv1e7+5nboYsynMlNqC/EFgdDPYfBjncZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794254569; x=1794859369;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=erhI7CgGmnjEIhSdlY+i5ow50tWs7bchacWIGAhyT1Y=;
        b=ljd910ZAOtg8rM98Y2lZWqqaEftTW3zTXc2xr5BPKTn+Yf5B0absGuQJSWszM5UqHw
         9nDCTBsMcwO/C87wCVuQpa9GQuRIM0HdOTo3zc2PEO4rOsactv8fJTin3xsxJTJXHG4d
         TxMsw/IqLZ55UBETGUBZGLgx5lmehCJvZ2/oBC8jSr07NoyIIdALD6IoGdpGocAEEBiC
         R7/whVxxCESGBXXLnbtghkM5n7XvfU6rGJDTCUi39u2qU9aGaSRlFL7TacJrfng30lDF
         l1gTxzHOxpQDgJomPqISZw0vQwQx2JBdYeudb4aSMYwD1jPRRCWPK3nx8ZZcNzFZS1iH
         i6AQ==
X-Gm-Message-State: APuU4Z91h78ZZdGAvvi+zeWiRbydQjnPo2d0B9WFODyUlVhfgL7VoWO0
	4+PiZ44ZxDIrMokzUYSVMB3l7EaDgRyfWqZ9pv7VBZiE+a4Gvjv5z2+UYFKcYxELE50=
X-Gm-Gg: AYBFou05Q1VNxxRf8W/kz4pA4GY4YRW5aqXrBhOGb2BeKRL+cFpMMaV4cWov5fXI3B6
	uj9W9d7U2GUGbjg8A7SzwgG/DU6rqVfSuJW34Qltw1YP38xnkolVzChjjYQC0ik5YM9g6eMJhBv
	4zXzifF3l6tb8FMoYeurBdzvdzyLPlEAKXv6+ezuLzh7C/1rUK/ABNQ99CGob5gSPrXZd4v+pJg
	uqmI2GlUXA9sgtH278GSurP/WPIIgbVaGJirA0epDXOgegEN2iGuNKOV+PZDIchcnT7XTiUWePF
	88BfvapvoQOdOLXQh6bu+rlISqCw1rD//ZkVvNFn5K40jk1/OAFObODha6OCbIRUq/IlNp0PDSy
	D1ijRKcDwjncsbWdOmMPgYqT+9HSWy1zV5YMk7XBF2G2ryvEz2tTOHLChTKaByoCwCQrvV2sTWE
	FTlRMJ+KLT1AGKJl0oJMnn6uxE4pmrnAeDoVJ/CYfFKTKQZhqKrM9oC+3QWpkoaAzYp7ml+jgdI
	Do6CGV7Pw2ki+Rlzt5iRdADPbnTFUn0x5ZiI1zcYguULTNhcPc/3M6nPeVUUvtuW+MUWParCriD
	sg7UUP8iZB2D6QY4pJcYTkA6EW5XJfPjqWsBIQ==
X-Received: by 2002:a05:6820:1391:b0:6b7:8415:d78b with SMTP id 006d021491bc7-718a5a6057fmr114851eaf.54.1794254569267;
        Mon, 09 Nov 2026 12:02:49 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-718a8f660b2sm109293eaf.4.2026.11.09.12.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 12:02:47 -0800 (PST)
Message-ID: <0860d94e-c972-4159-8fc2-75885451eb64@linuxfoundation.org>
Date: Mon, 9 Nov 2026 13:02:44 -0700
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
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/26 06:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.4 release.
> There are 1257 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
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
