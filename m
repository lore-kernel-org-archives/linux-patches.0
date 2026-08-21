Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C624286409
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 14:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323873; cv=none; b=naPVOq3J0umcfTAxzWVr/qAKLV3aVxwImxpuFvvt6e5JSB/HNZ96ZjmXwtu0Ik9lhepu0gMP5KckS6+taEeXu9bkDJzGfb7bVnb/iGCHdTvqDKc/76ZDSJdKnPIL34iYwOmCI3r1TepGdmmNoS6gX0eSf5S+UbnF2dhkpb3gnxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323873; c=relaxed/simple;
	bh=CRp27lqDZgOXD4tiLjlZfyzg5q6jxbXWzIW/ojVkc4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W5w/nAhEJxIR4OJ+z/jiARXH/+UDXSfYwWGIlxG3/f4cJ3BTCCOBpZKqNT59+JBNqa7tIJv4LN+fMOonlEaDTkHSAq8JgrLx68vbKYLuqKflwtkUnOjy/Z4Chp6ZcVYyjCTD6TEeyT0votmlvhfLGNt/q2vACvkC9PbAPMEmx4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dntGiRjl; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dntGiRjl"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7ec1e9d3359so996637a34.0
        for <patches@lists.linux.dev>; Fri, 21 Aug 2026 07:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787323865; x=1787928665; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Eh/QBlhCo/p3Xy0RDKBNUg2dR1LdfJY2hyz0GHgOcww=;
        b=dntGiRjlgnp/g4skzMSFUKTpmcmj91E9LmaELf2VSfMlwYobPhLx0hKENrMfL+G7B3
         QuBF8dJAUBSF6E1uMdBc1WduOQ9rxnk/k8e+Kq6kubGGVw1+R+qrG/DpqVeFWT8DPiuK
         c9SoW0xxBOwikYg1AodBG8eOQ50EVaxN4Pe8E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787323865; x=1787928665;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Eh/QBlhCo/p3Xy0RDKBNUg2dR1LdfJY2hyz0GHgOcww=;
        b=PGxSwdmhLAgy8iqPrAFj8Zbrk0BLJXNDB5U7tKDaFYRA869Yn6fFAv0Vy7PWThqDoa
         MFBdpeAeTsWUVZAjQPVxMSUAukrEhuzjTs0MQcwQ3gTLU+xLviGEpZcI3fsA3Ketc7ko
         QueG8sEZLbIlbXSsWAANrZRxlw8qg4TmM0SvQkZONF7aBI9E3X/5sVhOwOVhm7YKLoEh
         Q+VRc8C7nUlSFwDB3nlJUoEFUylResB9y2l0Q2YSHXikESdCp/fmeykMW+sNPB5oAf3H
         v2Kf2m+MSYz5/NyB4o+d+5gOJXUmR2FahOj0xWR/2p0IRbsGCHb0WEFvWVi/3XlgZ6o8
         FhUg==
X-Gm-Message-State: AOJu0Yw4W5yvqtcxOMINhDUkFoSiD4dLvh+++5lkATVV4fAL3JB9n+RS
	7l4Sx87zIRBeX1U9oA85C1cZH8VtiC7QcAKDp5vdY/vRjPh3pG5TyFjpsqkcXIQxUHA=
X-Gm-Gg: AR+sD10kNTRpswiJDgshZgKOjBvJfVPaglW037h8346gTwXZZGL48TA9YljUvESAawQ
	RY1gw/iqReWbhq6RYz/NcbS6egB+iQBGe56OXSBNGTmAxyk13bhzeuCceNSatEz/42uOvgmDejg
	f2HKzahjOfinA1c7aXVxPCDM3BxSGlZ9jC4k4Q/pNWRj6d2rpvGTD728xcglaJh1HBhkkYsPlcT
	o/8FOWTkCT4ZlRim+2xi/hfRv4k7lMfjFZvjXw/FPi9vaUppu9SUDFlG38G+w9tBYV7zMBEwWUl
	DKRoPvTF6s7YDc8ZHhi5OGEMU8oFakVYpxufVo65cTv0/UYMsOop22+CJh7xlpp/1Y5S0uw9hVK
	OTB76wjawFgVz7L+tDSIYlVlGSPXx3/wiHzCcEvGgCvPJVxtRL3q/S/ZJwcVTOWDtbgi+wraekQ
	PfND4JMiQhTyEjlZNPKk9/INztcv1wDtLZhSPv1BFFIpWwV2CsyXH1zPGn0yPggepqxTAHTw==
X-Received: by 2002:a05:6830:4996:b0:7dd:9b19:a875 with SMTP id 46e09a7af769-7f4612f17abmr8760480a34.2.1787323865061;
        Fri, 21 Aug 2026 07:51:05 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f43fe70721sm7528209a34.6.2026.08.21.07.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 07:51:04 -0700 (PDT)
Message-ID: <1cdded16-effa-4ea0-b012-eca77b7fb8b5@linuxfoundation.org>
Date: Fri, 21 Aug 2026 08:50:59 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/217] 6.18.46-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 08:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.46 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.46-rc1.gz
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
