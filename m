Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793297804;
	b=Lw1fzuHnE750RA5/bzg/wyoBw+sMAGkAdpUrrBNEx6NZzX5u7Nbpe3xMY3UkN70QKXsu
	 sfhHKFmGBn3L6iR6tcCP+ybq+3y+AUbu/PU27KPMPr8OttvEkhn+4oRIm5QqYHvgbDC4x
	 5vPqZQRwtVU8j/iiO5y4fLukxCWhetnIdf80vTvxHCms0HBx7Q/NhaQmf/Rjc7IJdrY1R
	 tXVwJSW/C3AVgqy8iJInQJPvw77wgrMIoNROQLimbo+DkWA2PH8I97sHagTPbAeiOAXzC
	 x3gCvuh7LC/l+Rvk/9+T9ll6iZN0cju7lyNvTT2GpfS92KsnHu1lmahLqFD+/g1jSpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793297804;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=99z/FjcazCZQi4D66B/SibaBChuRIkU7h/mfNRp/Qdw=;
	b=oyvNVlCClY5cS5tsC6qc5nXJNkSBdExHOWSoWhe6B27odQmGZ7V4uPEAi+oAhUBdRSy4
	 Zr1PBQAWFs1cYHhfkN9WMSlAZ5MhEyVAXVjiRLkiQhuZtwPdlmAJL4dZL1N0vraGZKDzf
	 L1zX/c3qwoA6z38tXzX6hb4f3Gl+x48nd+4gHCWJhvcgAQcAWQ5ovifDb3clM1WE/mxqG
	 WD806xe97TH+9BD191YZ9zR0LtLCrXkj1YaLR6hmi+fPOKDjc/MdpPsAkQ04XLXyDPAS5
	 WUvfZtc7UwJNByk+IDfl8eXTFBiOY/pKkQMSSQDUdJrLmgxD8UHWHdmo2Ih2T0cIGhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aDaSDe1m;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEE460A380D
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 18:16:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CEE460A380D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aDaSDe1m
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a06e79e152so1413265b3a.0
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 11:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793297804; x=1793902604; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=99z/FjcazCZQi4D66B/SibaBChuRIkU7h/mfNRp/Qdw=;
        b=aDaSDe1mceIxHEo9GBIrTLLZEa9AbCH9HQ6Ije/q3+S2TCjA32KsG4iOhpd9SdlrrJ
         ciauFPhi5+a0yUWGQ1RjP++18exkSigNpAIESYuV7Ls7WJZdseClXziFXLSPrOe1RK37
         ajI3vXEdy/wONBYhgad7GwoC7BKlUbNziKi0adDE/URBEtN82gWK1m49/5kETLW2pZ9q
         AQfRja/rrd7/ntrcG073sd5KvB23zoH8Ilkxcr17ZkaeWJapgcie2EJJS8oMLP/M3cZA
         Ot29aaAqhB0QPCQOZxGVRa7RI2mTI/WBPHsqL5Md7N9c3tEVR4mcqAZqTBwfKVW9GPcL
         DLvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793297804; x=1793902604;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=99z/FjcazCZQi4D66B/SibaBChuRIkU7h/mfNRp/Qdw=;
        b=vzBE8B7P2UDGBQHJ+sSipc4JWmKOeWf/QbVhvHA9rlxiv7VCJ+Bnmw5oH+AEDZ3lIP
         Aco2SXZMMjaCE86Gmy8CB9URfZIFw4id9e076ZjRiwNF1QapuB1T6P7URnMSceP4aSNs
         TNkwJtaERlS15cfvRInG2Afea2c0qa5Ha/ATa15+NmahSCIYrWyDOYT6fW9e05hKSwPW
         +ceeEsaEDAgTfR26e+Ssorp8Yyx+Y7kPWf+Fxan2Eih9ZgAnenzZGwVOu8zBYveenlsm
         PMGxb8isg2X0qjyS/c3T/Ysqnad1Fwz+vKt1NiDhpFObj7ir+qs/VqmRwk6xqUoYjAAA
         5z/A==
X-Gm-Message-State: AFq9FYJh8SI4EiHp7WlwTN6p38PM6S7whhfWPP5Gznar0aHxDXQgkVUR
	wMFg/5cDUZE/oNRXbwN5EmOplomK1nPMnBs9jdOwTkFliM4foMvPcjFB
X-Gm-Gg: AYBFou3YA5SC+uiyqdCUI72voyb0gNECxhsitwkMzNfb9EVZH82nWe/3XduTB7k38S3
	7on9kNtvOL/1TtnXCDAOZbWdSK6w/4IURnhRNir32wqnMpUP91od+aSRe3MkFFsJqhrnqbYlXCU
	/43xMZPYCnz58LBKPw/FCPvn3VSyJjADfR5ZgtRp5U9OY5WkD6IXnqzmqP4WMDh+sAVCiAonXID
	oKAdTtcSJHi7V8523nP7FyZj+P2fiDhH9WTRaIo4ap4h4pbrsOC46jFzaA7OK04UihoPord3uBh
	5Wye2dn7aW0pnv9DJktnXVn2rLsKcvR8saPpTuF73Fuv4/d65esK7VuKnmG6n+76kYV3k7mVvDV
	0WPTXuKTqvXfElYpScvFcsqQOndg5uDBKq40Y5F60giG91qpBbPGA8NzWykIwnFhotnapBJ3MOj
	FJg1iclrsX5YopvHXhwU/UyF3Fx5St3JTL1vFroGmYhX9E+XZowcxdLvwp7z7yW5TPfjtBpuuQf
	NESGhFbbpDuZzFgEEUW2TOBjJVUb2oe266U6Zr6DohcXmnq5Ogc+H7Y761+kwt8UfZbPH/SMqAO
	l9QoGhcKu4qYADUYdA15lZ/jyCS2FZd1ueOrKpCKgbCi55T23x/7gnUS
X-Received: by 2002:a05:6300:8044:b0:3de:5302:e92a with SMTP id adf61e73a8af0-3e928953719mr74781637.17.1793297803762;
        Thu, 29 Oct 2026 11:16:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a98a0bd09fsm192069b3a.51.2026.10.29.11.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 11:16:43 -0700 (PDT)
Message-ID: <654c7978-3771-4c09-89f8-c5d23bba42de@gmail.com>
Date: Thu, 29 Oct 2026 11:16:41 -0700
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
Subject: Re: [PATCH 6.1 0000/1879] 6.1.191-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261029073135.159947193@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261029073135.159947193@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/26 00:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.191 release.
> There are 1879 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Oct 2026 07:28:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.191-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

There is a problem with the SCMI fixes that have been back ported: 
scmi_device_request_notifier()'s REQUEST/UNREQUEST cases are empty and 
scmi_probe() never calls scmi_device_create() for DT protocol nodes, so 
no SCMI protocol devices get created and clock consumers defer forever.

We are missing ee5dcedaf72d ("firmware: arm_scmi: Introduce a new 
lifecycle for protocol devices"), with that one cherry picking cleanly, 
the boards work as expected.

Thanks!
-- 
Florian
