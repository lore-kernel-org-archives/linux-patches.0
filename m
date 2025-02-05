Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403961922C4
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 17:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738777284; cv=none; b=LFypN8cAVGCmnMq0OIjK6kiAj4ahiOU+gR8+ezg3rbsAaTR1sLMDWOlowGN55G8lBJmEvfuiLQrsf5JRc6XbHW6/T+yyDuFdWM+lTUKYX3m1QLyc+tE5JgbqqlQ4BViYOE+YSZ+tt6wcHzNr7ZTOeZ4ma0YuvcO9JKJA6QcTMgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738777284; c=relaxed/simple;
	bh=qK8LCX7OG+Lpp+lf+znYUBF65w45hd7V1sPfz9dedeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vpi5ttOZ58AN87PGOwUQcB02SyC3umeouEZ+S2SJ2XBeRMhbulbpAC+sBQG/NcLc1bYN8T32IKW/tuDiNS+TcL7DwD5Hz/yQNsQEUAFN08buTurBIrQqilp8+oyf6rWByt4Idv1lkOE5wfYGgplvRAPjVov9a+zQcaBcH3h0qwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fIefqPYW; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fIefqPYW"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-721d213e2aeso19396a34.3
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 09:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738777282; x=1739382082; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=P2I+AE75ayJRLzPPhA6yQrL20xtvTEfMhQVZu3c/aYk=;
        b=fIefqPYWWJQIB8DqFw4M6Twx1y+9oCf3qB6ZME4/MFOYq3wFFvULEMUa6ILxDRRf/7
         /RKCmCNFcr24YPn5jbe/cQR1szu7fXRpEANt/e3hj9ukZQeP/5H8jKy/kP66s9OH02Ch
         J0LGo4G7fRKMEQHI85dqJmxM6moPLVEFBpwaRlFgDu6JbKkuH4RA+9Ta9OZ4ybU0JIOB
         /hiEsayuJNpd6lVEkrRwSM811B0s5ttuzzeLI5+rKj4Lah2Bs4srJWysVQFXnFA1tVp8
         5h0sO/BGmFPnFvqK6lnX5/Cj2omNik0ZXtkyXDJRfwxLCiXkR7cs4TAOvjsX6l+N0VBL
         NgKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738777282; x=1739382082;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2I+AE75ayJRLzPPhA6yQrL20xtvTEfMhQVZu3c/aYk=;
        b=Gq09Ds3gn1MbLbI1ashQr7Kue8uDvIeTsmY/TFeJKZOSA0IhrHi+Yv5rcFGn4Gtc9P
         3or0eBpzYsHjp8AWR+kpVSF+7Ydl8W33PzLXO/42pxexha/mg4VQph+epqXN0EmkJrh5
         IHqEzt8vUf69pHwtN3k20zHf5QAjZZQ48UYYLQpS9f6jGw7vPKmaq3m68g9tY+swyKGX
         J2lZG3eCL7Vvo1C5Z70FYb5kT8GOHOtFD5LE0aKoTmcwH/x2fSRuxtcFyaena9Qv46+Z
         err6VjA0BrpV7tLSCEN1zgnCvqdijwrZtjsBDcRQ9LzpUmzuAUrDwOJemLPK6avGhOm/
         /4DA==
X-Gm-Message-State: AOJu0Yw4dUahj2Bhs6ltrFnQ4VpmyjV8ILrwORPOUgHA6FqavCsg03aW
	R/Fj9P0vEWqne0sfM/tl2UMUP+HBpkHkmuy9jZw+XAKBRwOYe9A2WB0HnGb+
X-Gm-Gg: ASbGncsdH44FXV2lBQ0vl+v2P3YtlSQ04/83T/HHJNfR3z6JcBJ8UFmqb5pR4/W2N/m
	8MnmLJyPDzjqOEbPTMfQhQC7dT4Fc25TDIbHFn8Z8c3Zgee1kbf/FeCGVpH44e7fKJv2c7GnkJR
	QNYM/xxS7X052jLFBdBUR4strYbPmYIpCwV04O+/Qc27jtq6ceDha45RtP07LL1Gp3EOIuSA5OA
	FA5JMT2Vylvadv0yjtQVSanh41iirql+maG6BcYqIbk71ai8uyJO6YGy9RFCbVEh1ILwzvMXQ+l
	+3a5EshQRCFcmMOy7Nh4CSTHu0IexINrQ5oXuBqbMeA=
X-Google-Smtp-Source: AGHT+IGCCV/djrPhG7I/tsvKJyINrTjM5vCqp5TLh0vkRWyb8yypfVuYrOzfffZkTjhGbkE+Rnh/iA==
X-Received: by 2002:a05:6830:6787:b0:71d:4624:3f45 with SMTP id 46e09a7af769-726a4251be0mr2737150a34.18.1738777282035;
        Wed, 05 Feb 2025 09:41:22 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-726618ba0acsm4019345a34.48.2025.02.05.09.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 09:41:21 -0800 (PST)
Message-ID: <a3756bd8-8595-462b-8cdd-a39a7bce3f18@gmail.com>
Date: Wed, 5 Feb 2025 09:41:19 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/590] 6.12.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250205134455.220373560@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/25 05:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 590 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Feb 2025 13:43:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
