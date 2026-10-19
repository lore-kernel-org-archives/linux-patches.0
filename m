Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792436597;
	b=paVjktjtDVflHUVb62mRlSHmx7I9AtR5OwXfaDp2YA47Q5SUMuYhF3HZNPtKX5ZlKKDJ
	 2pg9C0ri8HwLQCLIEgPyXf7ygIXFVdL/SgUyuwmlTmo5gkMS1G97Nnng/BGdGZLWS/znT
	 C3M9byZ97AuQUQupghk+B28VPf3eNm9iFpGx/CoZp3GYQB7cJa595XtFyKy9Y3ntFmA58
	 m53ol0fAMc8zOJWgX8x9HCGNB5unkk9PIrTTZjY0aVLDaKt3tLKSLsoTkXxfW2GSjtM+0
	 kee9hHLMf9nh6KxLScq4FYDbzVmL5rkNylTnZXnSFnbWJy9zVQnQfH2Um9/ZCsU2eTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792436597;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=zwQ9u0fSM+DQnMR6u0nh+yQlIZlqj4FNm9oRCXT8s+I=;
	b=p/q1MncAiYEnbBQ2UxvRzxX/Q5XBajmV2L4vqZDkqCcn1vKGYRSrCClAP6WvjDjOYXgM
	 0uqeIFgllMLSStuavVZPzxb9hwoLTKEAfToG+cCiyOwu+kUXwcvJmuyImdUedQzxacTt3
	 j/wVvDHQnySsAR4Ao0tMdL2L6kAVVtAB9fHH4TNrJetXG8BrzqJ6KVNhXPQ9mgMAjyyL3
	 yQJH0aXmUzpkyxU/RwM7lvKaZhuzXFkvDlGLZnS7k+CvC1fYVN09gqArwktBfqa5DGXX3
	 hcPLXGU/V4tJowmBiOejmndqNOgxvaP9f+/pvVNyyswqoruto6a5brFlOLN4/g87/gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="YD/eHyR3";
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A8C606A31C
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 19:03:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1A8C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YD/eHyR3
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a06b27bf9bso491562b3a.2
        for <patches@lists.linux.dev>; Mon, 19 Oct 2026 12:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792436596; x=1793041396; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zwQ9u0fSM+DQnMR6u0nh+yQlIZlqj4FNm9oRCXT8s+I=;
        b=YD/eHyR3QdbMoRQwktnpTQxwZBUZI4brCi1h9M+1kQEW3rpKJLyJpQ9j5/pE9wH0RI
         8wH4IYm4DkFVw9VrWznxcvX5V5kXQNZAj5TXwWfLhLJASC9u+zw4BFk2NR/cBMk2nG+R
         Wc/NqpQ4SkhAQfOLtbUx6XCwoVJJxiVhiBMAqp5EycbaitzoMwkNRHV2GqQ2nJp8/JT3
         XKQqGOhaFYii1fqi55XeCyv8ZQH3WGnfx3Vj4r5FAMD/JxZIWrnciELQH8vdnWCjb2VH
         OkYAgfsuawWs48D+O3/Zg/OzWY8lFC603MpqmaiQitwB2B1z/1bCHWiIGaQgiWoX8XKl
         lxYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792436596; x=1793041396;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zwQ9u0fSM+DQnMR6u0nh+yQlIZlqj4FNm9oRCXT8s+I=;
        b=p11UYSMAVWCuJTYUxIdw52fhOcX6faOTJggqcrMg/Oj6ejQS946dK96FUjmFRkiF3g
         1j0CVDgx15lFgG4CkFsnvxE1SQjgMEHjvhISOelYwAb7mrL43qPOlTBJPD4PwUvDk5Ck
         0UMZEuDXxOQJTQyhG+SyQrwANCzNFs6dUQGsCKClvt7CktupsNrv7mJyq1LdrJosTyNG
         A6rcEZX405ZkUn2Gyc3gT3CEop8is5jWZhLmXH3NEUKf64BrIS/Kq00DjYL9xR7Zw+Lc
         cfSjrjOzxxj/tSuItJBwRqM3oiOcLRW8r0FLjF4gGvGB1h1oHn5QEjEMuDka8WIWj7tF
         S8Qw==
X-Gm-Message-State: AFq9FYKLevV7A8PbsIqzg387DAp1PeA3b8/S/rxL3pbISrPZLuV5TMe2
	il6f90AWM1OWWmX2A3LYaukNqY2O+xaphe/LFC3LrBUkPHcKxr/DG9q1
X-Gm-Gg: AYBFou3rxtnU0lG1D31BG7YOQi62k3OlxuHJTJ00BFp4ua+Vd4z9yNr8TJNLa0mH/+o
	1fDSzEn1BRpdNMbj4HTS37jj/yEgUOFxodojwGRnyT+H8YZC1qGZguhP1tDW4HIITonZ00tp2UG
	3QQypSvtaESKcpoRceH5w5B/pC35Y2NBlGullitS+vbwzU/aDjGjxHIYMrpTlKLstXmSGIfUiNQ
	fySazYtLdOVtcxF1gI7PmC9+zVl6vp+AgBuiZzDzGG1USdtXYvOmh2mkzLTPQzhYi0No+ycCsGz
	zXherAgr1UHTo8FVsAw29bTHawG/eTGl/Uj5YrEPSoAbCgym5ViT4x71g6RpZjNO1AdVeXAbdsJ
	nj+bcZWYKubZwT5+bfGpfs2YXl5QG7v0MHJNSs0ObMBTZrielUbRsttKo+rcanK3n54Wuv55MQw
	wrRMPkOVSYfxmd1p4k4cViVhcEKAAZm9ro38h5wFQnQ8niKMZ69Ezdig20v9rAovukPYOCe0g23
	Vq5LD9rkaEGqtzZWqHTb4DO
X-Received: by 2002:a05:6a21:498f:10b0:3e2:678a:b521 with SMTP id adf61e73a8af0-3e2678ab8f5mr535254637.71.1792436595996;
        Mon, 19 Oct 2026 12:03:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd6549c7034sm4220834a12.16.2026.10.19.12.03.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 12:03:15 -0700 (PDT)
Message-ID: <5fbcd61c-a997-471f-8a63-9f70f323bcdf@gmail.com>
Date: Mon, 19 Oct 2026 12:03:07 -0700
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
Subject: Re: [PATCH 7.2 00/10] 7.2.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261017155059.698368299@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 08:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.12 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Oct 2026 15:50:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
