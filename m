Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793394325;
	b=whcS4lFBfnhHYuxKm51Ic0nGUKh0Jg9IKkHQ46qtUbW+4N//3w0ZpJxht5a+rj+xhTn7
	 q8WGd10hRg/lHpY+FuA7qdU/N9ce9MYvwEecu7i//ZjKOeVUVMyPfJrib7xTQaGIvqaOP
	 fL3YumjGRcDlqata5TjcO02kLPZY0GlTHuxVSiRpLwOFkaM62iTKQWIPFXX4x1ruSHNgS
	 3cLHsTTAQCH26c91NWrMIcaoOaQdYG4ez58R1qmDz05LI/iiT8MVSYLT1TAbQJVXunliY
	 niTJjgTV1uo39IupXMGHj6ljMZXP40hWb3aB+NfRvdWHPmxoT/QWAOWF3gZSiDdL9nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793394325;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Y7H7nb9mTg2yg96+dA1v16VbiSLf+tKxcACbeKkZCEw=;
	b=khFyZWfyzp45vRiOBgci0pYCFBSyWpaoi4bzJcJeI5GyQvnL9U7oX727JGI+zgFphiO1
	 K7lagX3W2YCMSE2fmhkzN6drv8GvrsmPKgkkfnjHYy4bX9IffX92M/ZAlhaP4/7ReMf+Y
	 unddlEZq4bHE87HecZnkJTjTY5z26qC1kurwG6s2ObbT7vvghcnr0NwiAEyCxH2zVpNdR
	 zDDqrRkR6UvxhDhg+wBn+XiCvR4mcke3DVwyLBaRdt/XX0B7+j69ccJvWKkRQURhKSDnq
	 NdYuHC1AnF7xuIgW8MOwrmeHLQovMnWAoX+iBEIC24V1HmN4Ppcq0R2v192sNAza3Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=A7x35CNo;
	arc=none smtp.remote-ip=209.85.210.46
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F34606A31F
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 21:05:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87F34606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=A7x35CNo
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-843a4ca671eso523495a34.2
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 14:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793394323; x=1793999123; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y7H7nb9mTg2yg96+dA1v16VbiSLf+tKxcACbeKkZCEw=;
        b=A7x35CNoyXxY4ZwSeRFr0Y1LpG9f/R+FVaF8ItYyQPKnpAJ+f0A8vW+t8JMadXJZxB
         xg7ppEOsSqJvzGfGFAhUVetbK/tyesw2f+CjvpMfYE8jWNVBEm6NKxuFaRtLZkZFeNVJ
         XlJx/yTFHyI/5HTuxhusax2o9hVjNcRO9C/Yc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793394323; x=1793999123;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y7H7nb9mTg2yg96+dA1v16VbiSLf+tKxcACbeKkZCEw=;
        b=Tseje0VV+n9CBLqrYw3/L9IKtwS6swMsgUSiOr/8Si5PYQMoDIOgwi4qX18JPPmB2/
         kuCocYDEpBfM1M1VY+WcEUD+WtesnMT9+r3mjyie1HNdJkUTyKOrVfBNHC4w2quWpk5z
         jfrDMizrxZA36R13+d0CQmDlriyxcDHepOA2ebLExSGvN2oS3axwR14FowueUlnLo6DM
         5Fh/n2YV1tA9Qv7FKZaB2+AvYGFZ+WjjtSESifzMDD9YKFb1QqnCox2EK8Gt/9Bwa9NH
         +oTSMXVBvDaH3uDDgq4Clc+MpoogxP3dvFaE4rm1l9m/uLzfdkRdErnkDVsAALYyKTIw
         shNQ==
X-Gm-Message-State: AFq9FYI/J+igbyXOUIHLLTHO2YU3z5qrP/t2fmgS/uIJ5oiSCgi071yJ
	Fmwn5OFz/vlCfawLMCC8p77pHRxm+UroDseMhAMKzmD+lHLpsjfUPTkAoVYcYrd3QHI=
X-Gm-Gg: AYBFou0GE9BFHFvJZ/ZvycpPSMrzakWwwRwUcZUkFnK50Sd1wi1gN3dvuKnF8YPccQR
	uTwBwANLrvrs2C3BQL2ay8hdU/bOJtLnTWIcOLnt3S50RuHXgtOdKvfo+W3qfI/SXnEpFyhYQAA
	SD93ayDQIhUUslIiApWCm7f1LX4jhgKLi7uJAOBDDpA3zFDTZ+jXxYM7UCaxuLAPlMy6hkXJ5og
	88xUdYTvO2R9GPoca2i5wheCSFTDC4Pw44SOIWbNQcujV5eX2MSmGn4icjMwC4Wdo+US3h+Tsqp
	XxeHZERX7La7diwWnWOVfvbx8A9QRCRKGsjF4AkuMyzU35BGtIYTNaY37vFOvcxTWcGjLfy7REX
	4XBybDoi/W2JvBLRuxp1Pvd2auBTvA7N+obYEflcDvBAb2OGbgX80aqDqyrSaNCsBAsoMbPDhTb
	KGSKYSIHjyT+HY9j1uuYUKGFNOxZPdRdCi6TKCbpXc4MS+Pvy2BC2dYVnf0IBnC5gnAPNgCAI1W
	KaPDOLtEsTfuLioDuWZ7BZOHg9qZ24hMsKgm70udJPliPTkPUy3H6270m4q4TrizRqbcTBvYG9/
	QnI57oEY/ibdkFEB71+K5hEvrHWOYYTjoObRDw==
X-Received: by 2002:a05:6830:640e:b0:821:a94d:3b51 with SMTP id 46e09a7af769-85d36660667mr2466155a34.25.1793394323484;
        Fri, 30 Oct 2026 14:05:23 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85d3545b875sm2999366a34.5.2026.10.30.14.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 14:05:22 -0700 (PDT)
Message-ID: <01c04f5c-5a39-4a51-ab0a-4bb4dd89b80a@linuxfoundation.org>
Date: Fri, 30 Oct 2026 15:05:19 -0600
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
Subject: Re: [PATCH 7.2 00/10] 7.2.15-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261030121255.257615100@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/26 06:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.15 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Nov 2026 12:12:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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
