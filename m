Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795103498;
	b=vpENqGNuiewQGtsiPevFmDefsa5fomJIv5e8e53ck6rhELG5emIudzaQruECZs3xH0ny
	 oAkgupAgj+JJBN3XZB7oSm6VLphwfO6ow0QX8HeOwImsSY2oDwxFp/QMjB/aEn6s1gAp2
	 5DMiBRQo7wSGtmGHc+a5GedfA8An4/V76pJbhLD+6OebXeDd0lwDY0ICuvj4NBUyDrdhD
	 5nUz9MpWFl/plJYh8wHjI8mb7GDZcL4W6DX9OJSvI8nP2WY2Ex5fYLqok5ZTHkQCkJ4QP
	 hX/5FxkB0KlqQipaUYcUfgy0lvPD+ZNtBFD+u+O8oMYq2Lr72IjpCccw9eAhB8PXBJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795103498;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=pwFAcpg5sRyeKkdxr9R3kiTvutc3HKeMb0lAkM/rhbk=;
	b=l5meoiNg1ONic1dOGpkcX3eQjpbJPBlyGaskACNFz8d7d5KSHcwUoEqwFvhtHTcU6EE4
	 dr3tKlEsQQYX19hN2jM+0ZPDzeKCt0CoBiQ+R5p8VpYaY+5jk4Kws0nbbtKyt4nxuRuE2
	 BRFGe/skuKDsXjVxEo0q5eDoWNB9jDn6+eVGC6ywWTbpfkU/kAHvkY+eG/J45hsHN0Xt0
	 8Wmt2MRf+6XU+vH3GFrl+1iyKbkD4CO1WvMAAKuRnvb24hgP/IdvM9ffKA2yJFVt8q7hR
	 IvUuUU6io9ndPd/aI40xYFcll/AuG6FmXzH1RoKbhYDI9JoxT16j1ISLnGn7P/PP8xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=BDjqgILV;
	arc=none smtp.remote-ip=209.85.210.46
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E26606A320
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 15:51:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14E26606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=BDjqgILV
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-862b98b2e47so927772a34.2
        for <patches@lists.linux.dev>; Thu, 19 Nov 2026 07:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1795103496; x=1795708296; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pwFAcpg5sRyeKkdxr9R3kiTvutc3HKeMb0lAkM/rhbk=;
        b=BDjqgILVb/jHfLynsDR+9uGJ3sCvhnieBjrZxvjhidzfWtj9VECYquU0k7DF6MKuI1
         zsUgp9Leisd/jcbiYw7GNPlnsAwg//N947B9rVv/5Ej/H+H8kxmFgoHzKd0GU8nI1pZx
         axrkel7Ix3KRlXnwkQmtsPbPzBl7pYLwxzcOc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795103496; x=1795708296;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pwFAcpg5sRyeKkdxr9R3kiTvutc3HKeMb0lAkM/rhbk=;
        b=t3zASM8JiY28FWsEDgZM6VTsZTObciyBzHoF4fyH2lK0miHVPw8QGUVRlslMYj5Wd1
         UmAZLeV0PKRkjgHZzWK0x/h6WRK781ZWRUNMTrFN3X/MtxrO3p5om/pqf6HFdHa8VNLB
         JO0jIlos4EXftYLcxk0mJurT51Nq+K2tUGNLSSK1UORQHyMLGyQaEIUfhH+aKLuH4F5L
         8/4VMKOcqs+OhYPa4eUZpl4qQqt8fxAncLbiFn9JX6jVBjiTWJyzFQSRJxEPHMNMpNuZ
         QNRdKrZhEimZfHOAXEFqZtEo1H7nXWYYTi/8xR0X+//y+S+tAYLNb/6AfYPdC55yQm46
         FGKQ==
X-Gm-Message-State: APuU4Z9Au++fL0HQ9qim2eGJtPr7aEgnhWomyu/EW7IsblpjuVMtOUKK
	JFoemitzOZo+WC/dfbp1gl0e6EI5dCROL3Obwm8AQleeDN5WxGrKoecIQF+ScO3nkGA=
X-Gm-Gg: AYBFou2WbIe8Q0End3B5gU5IcVFESsZGwhRSbhev0ZmvT4FemvzkjGbODBtK53p3mJZ
	SlXw9igxjXrliPgX3sI/FTzqLuWnTD2uxHVXZOFCc//Khj8Je20Gmfm/iCf4LPzXjRMJoQ38yaf
	G0U7befmWFjCaywTqI8Iyn7H4hcsSW5gY44Iq/I3i8yNItj5XK5odTDBL1EZeZGMMTTkcYDprh5
	Ayiw/MiJ2FCAT9dTZLr1IjdLAVB0AuWtupVGaNFWehVz3Goh0l5dgui1wLkI3IJpahpxJzqAH2m
	PFm9wnAB1cPU9qsd23MuOnVj0HvX6aT/Cupz2n5PQCtlVE8dNJG2PBxzAy9UOPasBG7GQVSg8U/
	kSWlUJlSvKczgscKHxPnP9LkTdjCfBSYqBAjC+xCiw7tmdJC07xPXbFVX262g/ZXP0lKDm7BmP7
	UTJWCbX/BhxOsCCwSgdPOnn/W8SIlpO9B07G8tmThO+CNPMvtee4AB3+/L6VX7JaGd38dJ27Ilg
	qNn+X55CdNchELULIaqpTNfwXrkPCa8ZpZj100D0wDHq4qXy5vr0hsxJzhRDvSP6ff7SfmMuWZv
	2mDcsJDQxBPBiId/29s/mStLlDpaPHpvqpoYtw==
X-Received: by 2002:a05:6830:348e:b0:81e:abb6:749f with SMTP id 46e09a7af769-86315490d2emr351905a34.8.1795103496017;
        Thu, 19 Nov 2026 07:51:36 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-862f01d492dsm4792444a34.6.2026.11.19.07.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 07:51:35 -0800 (PST)
Message-ID: <aaa60c66-1cf8-4cff-9ba2-1d490fbd6673@linuxfoundation.org>
Date: Thu, 19 Nov 2026 08:51:31 -0700
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
Subject: Re: [PATCH 5.15 0000/2214] 5.15.226-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 07:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.226 release.
> There are 2214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.226-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
