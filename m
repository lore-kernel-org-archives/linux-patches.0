Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793039927;
	b=VJQZ7ntuvf/9pEu5LXcAG5gLvnnCMYNUfFxKisElIvNnDqyj8G5HoJF6Bylgq4VlZy1K
	 /8CjBnrwmHTl8oRg8ewjKV2gMp7SZE6te21CW+ssOgpokAECt1uxmDcYlHphsa7S91qFV
	 S87Ge3/aA+g6qpBWqUXvXwoTrYBA5qTTXRhGJABb8skrpkHcUWaEaElXThe7xU/t80V+t
	 iEMezuKgiG32J5HVVpq0XIU6MomaJaVi5U1+h3G85FuS4zb0Mnm8fZB0y+CZcx5Z4LPR6
	 9NeoOA4tzfSxmk0h04/F/25FQyJJKjzSKH0ocak/7vYVkJhYP3Jm1sChXXnrYZvnFGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793039927;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=qtkfCa1ACFlx/Umc0D+/jZFN6SiMdUN5vaZm0FGpPXQ=;
	b=Tb/LzZxSY5T0S9AYvVDLdZJ6b2Txx4ra4FTCFxJzoNb0Y2zroB+xMC0go13o70XgrQ3M
	 7nJ4FHeb67fXzaRNtOBLGQCtHbcU3m9bAsvBtvkCqQmsfb26kzqF8etDGqeVy4ZRV+rDC
	 U7njoJcuTN6d2TrJqcMD46RthnZ7ZW18Qu1zfmYVwpNKZ/sP6sPw+myra0PqxGLZ+joJJ
	 8whOwiFEwPlPeLQ/EWjsbZKHuW5K9Zi5wp8gYL05C1tv8l5jdVcyNA3avah5u4pfW75xF
	 uExMJ4NkGXaGN5cHzw0sh6eF1EcM4VY/YD5xgW8R3RrdMFKwBDtqlGFuUf6op6WeMqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=IardY9II;
	arc=none smtp.remote-ip=209.85.210.41
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32820606A31D
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 18:38:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32820606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=IardY9II
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7f84a55cc06so2039856a34.2
        for <patches@lists.linux.dev>; Mon, 26 Oct 2026 11:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793039924; x=1793644724; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qtkfCa1ACFlx/Umc0D+/jZFN6SiMdUN5vaZm0FGpPXQ=;
        b=IardY9IIuMeW2AF3995x5R5n5O932sWnS1ETkjT8OR1FvXWvvhwF9sC3mk0FZnDCC9
         EXXqXeHqkmhhLPrh9DLX1wP+8ew1GTiI2mjLLhoDLPT5+pENJ9pFAiFpzrV5yMHFGLTC
         31meyI12/hpvBx3GoHI8ZcyjBNaWzUSO9J0I0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793039924; x=1793644724;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qtkfCa1ACFlx/Umc0D+/jZFN6SiMdUN5vaZm0FGpPXQ=;
        b=q1mezHpX/S4b/OXboK0B6V0pqd9VC5sdpNtIOsKxLiMMj39+eE3JnJQMegBxFExlPa
         48wukUdM60FxoUA91cXLXkeh0ZdT3kxwdK3WiSMo/aIhdx4vR3ihX7Tb58Y57kUDy5Q/
         RaYCnGqrz+St8v1o1+aMAYOqJv5388cJhAYG+JSinMFvuaKLBWS4b4MF2FVaB3sHNvwN
         iUhlWz/AbwAJt/RFRVIOMXf8s6N45gTeKvtoM38x19XEq70o2Y++wIN7Md9gxOlLmzEa
         usQlrG2i+gNzX1DYcQHoljDDeO9WsQznxPsK8EMAtnd6+P+UNEDddeL2WZ8aXsR9M25g
         uDLw==
X-Gm-Message-State: AFq9FYJIW/3vJe+Yk7f/2DYxSCzPId5L9o4RvAW6KKo4Y9uI9cY0e27d
	CrFe9U1hiPD6YdaZvsQlKnKphfWRu2yZVvIEBOumcV2DSR6wy6Gh9HDgfrAQX061f58=
X-Gm-Gg: AYBFou3Q3YEJLUk66SUbRGilt06aTy7jR03QWX6XA6Tndqx5YfkGohwTcM1P3YdviKk
	Og/UxkZ/5m6JH6J4LUuxq4thPthJPhyix8PG7fUNhh6d7oi4FKzr0i/ThdzpoSEhy4z4lPiOnya
	U1oEJRzh+20OSO4gMxnP7zN3OI2t5g6ujEXbOeTXaAncR6PsrFNFnlUZwBJoenPQzbA8nPpS8Tr
	4pqtuC03SZ7/DJDPrEa7hbhcdkyM8eOnDYFacl5eX2tYCGtSuKomtbi4iIX+xa3Etma/8ezsvM/
	YjfOXZ3XGFBTNHZdS9F/uwK2TETfa32CYjMRWKRmz4IUuHw9oO/nLjsiJqfu0SrRybj5/3UeVak
	kTQ2mYeImbW2XIjMP1SdFDvZcwudx+17BmplpxOoOY+6CvYzmAYr9kWF5+kJAt3bAWW3Y6zNQbR
	ycYddogWvPPEnJFU/Cx7kkYdriy1somtxnOFqzuAk1+M9N+NLV1Iic77AP7+OTSwyVlWmdFdCOB
	4Ir0xXIPAV1JwdmMEwXdCbEiobCA50SVR6YMAI6VMq+ZKUlzS5TgEx+JoFlkmNgON0=
X-Received: by 2002:a05:6830:2b11:b0:834:b015:aed2 with SMTP id 46e09a7af769-850fda467b9mr5329495a34.6.1793039924057;
        Mon, 26 Oct 2026 11:38:44 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-850fa99bd35sm8395712a34.8.2026.10.26.11.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 11:38:43 -0700 (PDT)
Message-ID: <a072b675-62ef-4076-b3fe-7a344516e992@linuxfoundation.org>
Date: Mon, 26 Oct 2026 12:38:38 -0600
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
Subject: Re: [PATCH 7.2 000/231] 7.2.13-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261025125805.309934791@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261025125805.309934791@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/25/26 06:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 27 Oct 2026 12:57:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.13-rc3.gz
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
