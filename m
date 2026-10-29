Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793288277;
	b=TKYkB5DDH3wIyu6QACaQaxe/0xeX9HFu3juC6+sBgJVp6czYCbYZvcx17lkJkcV7ENyE
	 TaZDkjoVUM89SRy8qMXIEQjXze/jiu5LkzknoSBJP4tBiroReG/t6Uafsv71x8QdcNzUt
	 DfBuroURHs2nrICQrOO2lYQEtN3iEnNNXPql4pXBcYZJhUbkWr5DCZHjaaUDtOT3VsoJI
	 JXHpJOlM46tF1ZLE9OAJhqXXJsi30UxFzUsWsdsUHt3ebb1mMDMzcMmO3AMY6D6MPenFG
	 GSWkTPz51cnxN6OsueEEDXguiT9/F56FIXhSrcx5ImNS5iu2NqSJtE7mdh8aPkGa0eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793288277;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=2V4JLnzK67IJcCHq2My/KdT+6D1UK3FIaHGDhvNAL2Q=;
	b=WmKOsBGGkw3AO71M1LYj7xD71EjAD4uEsdTRjzudKct8AYSu8uOp6pYXgMybtXCT3j9A
	 xB53bHhykxKx3LRlQrP/R+rDnd9o03JEWP+RhtuBQ0DEU9GRiKJwk1vZc/M5+bpjPgI42
	 EeiEKDB40GzI9MW9xJ1TGsBQS5A3WF8MLzMEh37pJp+m6NrI6JO7dduVeBJqtFaRtrgBp
	 lxxl3lK7WpPAAmNIwoojZd7SdfwQ4svZA4l85bGEPgQzbGlZo35L5rkYc6xFQeGB+9vNw
	 WOmxtu/5P/vf/2a9Yi+IojBRLtilVSGNgh1D6TSbtiAKC8wE1374yConEWuzLjGDOXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=FwsjFvhB;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61753606A31F
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 15:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61753606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=FwsjFvhB
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4697404c2bso312168466b.2
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 08:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793288275; x=1793893075; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2V4JLnzK67IJcCHq2My/KdT+6D1UK3FIaHGDhvNAL2Q=;
        b=FwsjFvhB+hyQp10cbRl5m1ryYXmvY247IfmtSk2kBXyN8BXDlI2jRBA1E2naClcxod
         J6qR0UQuVtFCb44H2A57k+HnTkWrEuv8qWlOkvYvytnlYp6ejcFH/gKPMqlwKH8lcrVd
         Z9HUfS2/ffmyOzVRCR+tEW83dlwLOW5xpBhO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793288275; x=1793893075;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2V4JLnzK67IJcCHq2My/KdT+6D1UK3FIaHGDhvNAL2Q=;
        b=sSdbsVr5xh8cbnYwD7R/+q0pnsHqlu/eKdhQ3/GjTgy/Cz2FAF+cVF93xzU7ACpbUa
         x6abXpRWS2Ngw6lRXEFsV3JtHsn+MvomPuS6dBjSdWFJFMpwYzUmJWv9lSQK4mXmjduF
         kI+LSwegw9dnxSGoZwci2k4vf33JWWG4weG7aUPCd16P7tm+upJmClTypQTcpaeaktrj
         4KooAUceQxIut4WFImCmKTC0Ve5+BOqloGblyDk9knHocI6GIb2tfW3/zZIdS60XFYPF
         RL9Vc1F3zInlp+wRx4yZXTmQL+6L2pjEXLJSYWZASX8HZmkm0uoBgWbin6+qq4Pyt+7R
         qSQw==
X-Gm-Message-State: AFq9FYKMdCHb75PSPfkfhEsSuyfyQmFJYPwq2LW/XC7+EXr1UEq6FxXf
	AWND/zaC+NMX/C/nf8YGHbxyyLwB3zesruEO/ctnganQcBW9vaC1p/IRP2jauh7imp8=
X-Gm-Gg: AYBFou2u8yn+k34mClhoZg741VjsKc8vLTzEyNPt6I0gDlnekL8J8GVVCwQ+Addx04Z
	t2Wt1osOkqqdJRTGrLYuGkSs8by9MfbvmFfuzeI8QA+Y3juO2t0fvf7pestWTvBp80mbHYNM/6C
	bobowmXT+6Gcv0L+8fbc0SjcdxHpKOh3c2kFlpB7bbQXHPAwF0iUJgX34mDF5EVYwb95ZEvrWT4
	WVFk6m7er04ytDCgG/aNc7sJbwlcfGSNJ4gF7eytug09R6FCZBg/kJzKhWG5AbJ9bIgGqq7aG/x
	1LF+nuxOZRNuJ0K1y1WamIMx/ZHes5sTfGiilUsLdSnLOVYBd3d/hG1oGt7J3F4AbqMbVYUOD+N
	wEzuxJ5CZVeEA07pPWm59/9ChMb5VAbwywsClCsYYaPJaOrT3lIcIXLwbsABUf/BRUvJLNSgGRo
	joHw/BOJHmqwnEuo4Wi9BdSCj5vxVJ+WcoEiyq63nsRT8UlC55MAGEksFeMsTSem1Bb1bJ31poU
	ka4Ay6R5d0OGV+xX2njF0UE0uASgN0Yyq9XRSihixppaV12q5QZSo1/j3kKqb4ikIqv2nT/Z17G
	Lh9XYS4I5mRKxc1bUxJujuuhSL09Wz7mypeJcg==
X-Received: by 2002:a17:907:3f88:b0:c40:80eb:c54e with SMTP id a640c23a62f3a-c49bddac533mr513399766b.4.1793288274113;
        Thu, 29 Oct 2026 08:37:54 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4ca26498edsm3437966b.21.2026.10.29.08.37.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 08:37:52 -0700 (PDT)
Message-ID: <5ad973b7-4e0f-4122-8abf-5c5d59b51ee6@linuxfoundation.org>
Date: Thu, 29 Oct 2026 09:37:45 -0600
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
Subject: Re: [PATCH 6.1 0000/1887] 6.1.191-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 10:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.191 release.
> There are 1887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 17:02:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.191-rc1.gz
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

