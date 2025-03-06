Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F0D1991C9
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741276985; cv=none; b=WoFd/6+HlIns0EyWU2K32APaxVpoyItfiSeBfTskyuGq9NJhjIa8uxmPdBC6Hh6Z5K860wG+pZsDJEIlFokAdXMI6zUTAkQ9zcJX2Za+f4YI2ECiAKPaDW/7u0EEglmiQMj2GoKNpGf3yOUX3Tp3Nn0rDN0ZKOPzIqPlxgXJx5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741276985; c=relaxed/simple;
	bh=0X8fzsx8XEbpOxpV8HrcWj7hY8lw5IrV7LsB+2rmsE0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pWDdaiUCprzyWBx/ZyaXOQvP8+vVOwr4j8U/qvFqcZDaqp/ljcqj9/LSXySnvRSeduFwRyrU+rKfeBTxJzFZJUrueHph8mpUD7L4TmXmb6PF1u5gQAjdxkskgpVsJ9hGmyl4qglbs+a+ZoXxDxU3OmlrAB1fUTrxGZYAQcsiKEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ewcxh3kG; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ewcxh3kG"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-854a68f5a9cso62521639f.0
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 08:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1741276982; x=1741881782; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j3XSirLFPAgrsOh899VUHNdAsamjZowsu/g7XQvoJIk=;
        b=Ewcxh3kG4ELR0tWgPYLbv521tELI17GAW9mPc0yeQYntyFImGdV7+9H7mdDI2R8rXR
         QFaQ6UeuEJtOsCEAx5ZwK1la51tYLgK+LrbVoALts9BIOkhQJ1H5/KTb9DpPEPbE7hMS
         KA3M6x9b8GFuQfpihItX1gd+ICMfmfQw/+a6o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741276982; x=1741881782;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j3XSirLFPAgrsOh899VUHNdAsamjZowsu/g7XQvoJIk=;
        b=wPM2/KoayzqIQPJZF9wewN8KZvDEc+UZz9AfJzhoGtiJ6PNZb9JONM23twLo5/J4eO
         Qmo2hW3DHVsmC6PuHcBX0qEwHEfJPAmd4J7VOUzHTS6CM6zkNVeYGQgCBOVurTlc6Xtf
         WMoJ7sNl94g9tPzdYy8eQD5Qw+Fg9jSmdpx9uOyk7N1RV56xJ8xM0NsDnxv1WfdYn8Ot
         NMa+a3PxQTYbXI0ePSFkznnI2y1HKHYe46Wb6kYvAb+l6vAnBz0ykiYyBMnXVD9NjrYE
         Vn5ugJNNaPbq30SM7S2zV+uYn6K5x9AqM4TEZs7EiOJUvxjI83ZR9RppwHKYGv9UTyfd
         BtJA==
X-Gm-Message-State: AOJu0Yw5gVEobfHJzilQLH7tFeEyc9a5J7iB/0/zKSWzAafQKWgOmOlV
	YV8OMi/IOrF19dv9F09sLXl7Dj/5tMYHOAdNte83Do+94DEUdf6tOKuldKEGPzY=
X-Gm-Gg: ASbGncujDU17L65zqOOSPBrlp9Pu84RTF0HudlTMs8m0LDuzoI4wCIixZ3l3KFXo8oi
	aEfcZHin7hCm0Pu4IW1cXdlVjr6rp6/Kb/MsNwYpmFhDhq3S+yfikH9Z09/NYAORN1EG3aJzIpY
	Y7vc3cA6c6Hm3pS2RlbxDe/gW6DrloimFph+qEqFyyya/G/egWotKF/waYoVuBTDzvI2z/DZqLL
	r3E5CBBlSZmT28B25K2HRxGVyc/kXfshwGIadHhABEm2dR15Y+HZpWK/ZnoRC2kyu5+L9FGkT2m
	SOnWlp6z6ETnOmKBQK58fFuK2oeGWxs3iWnEhmLyupJZ/1ZdznKwoUM=
X-Google-Smtp-Source: AGHT+IGWay0XtX2xEGhlTLVfQE3wwjgEqfmpH+eUSvs/Zkzr9M+ED5qQk35B1GuVVL04/oO707vqog==
X-Received: by 2002:a05:6602:4818:b0:85b:6:fd2b with SMTP id ca18e2360f4ac-85b1cfa9450mr7928739f.4.1741276981997;
        Thu, 06 Mar 2025 08:03:01 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f20a06d42esm397089173.137.2025.03.06.08.03.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 08:03:01 -0800 (PST)
Message-ID: <74eaf401-83c4-4098-a16c-c72c62127e22@linuxfoundation.org>
Date: Thu, 6 Mar 2025 09:03:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/142] 6.6.81-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/25 10:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.81 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.81-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
