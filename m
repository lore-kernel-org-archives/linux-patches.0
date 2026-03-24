Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B7F2DEA98
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 19:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774380099; cv=none; b=hO3LbFfGuxskzXLgBydBi7PNZlYnhJH+MihOgEIKP34XcyMN7cNPcA9+3EiW0yoYw51lveDoMepzkHpIGBCMW3wLFIg+m+R4OmbUKjQ7b2Eq7OX9Au0rySEwkYIKSZn6W4FRk1jRBZ0Yfh40YbyY9kZDT4YGz8Ed9ti9VmDHcRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774380099; c=relaxed/simple;
	bh=1ggRSxfqVjf+Nkyd6/5CnLXPxn5r8Z7UtuC7H2J1Yi8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=aSvrhVyATyc2rTnKCas6NKd4hCRFwr0AFhWhrXTNUyFhX5XUZUQX6voyMpoHK4P4SLL/7mrEqzUI86y5ZuxlkkWEzTPluPXLSx9VJNt2FCqZqlxnE7IxhFW6ytZHmK2QViPV65xtJc/CaNZmWatnxNtH+pZ/QGa5M+aOaZmF9n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RIozMeMa; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RIozMeMa"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89c40b33bddso2058596d6.1
        for <patches@lists.linux.dev>; Tue, 24 Mar 2026 12:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774380097; x=1774984897; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x7OYuNJrumOUG8swZz30U31phe5D0Nn9dOcsToznFEA=;
        b=RIozMeMaeC+at9uEVpCq+moki7ry9I/Z/5khaT+dP4uV+jZOj4YJHuCVizvFrYlg+I
         0Xgm0ZHDOxKMtKhr48srS+1PCOkPxzaNeQcmBcvQgzxBG+gqBA1wC4bUKPkubeRReiVl
         WGs/9c8lA/Ai5EeU0IZ1IzuiDsOIPyAL6A9Qt0DbtpW0rrd6UijWVq4drepyVgOjR+0E
         EL43vI9p0A2x81NYl/SuCkvS8jXDqcvd9S9ZhWBVMGdTbkRyxCUZkHNF59X992m+JMwr
         +e+7WfCC5Q//wBmP4dCXROYsmzV+0VnN1j7wjNkqYGH0ngGvBRfX2qg6NfwxzdLm8j2i
         ogoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774380097; x=1774984897;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x7OYuNJrumOUG8swZz30U31phe5D0Nn9dOcsToznFEA=;
        b=AurBKJS1ecA5tT7TN2fdHqh4r0BhqyOMRwAwxfHevrwEaHcakiZ1KO89joZti6FVIx
         y3EtjJIyWSL0C/vM/U/GybXwXbb7VnpBKSyp6oyOEhrnswp0eAs7o1cBfnAYQlCXYdTj
         jsTJiQoMecwMR7t3QvmcAY/2Hcg4e1zxbiNWaPOpS3t1pBN5bouVPBEKOnXdrEzxiP3k
         xiiDEG2WOTxqdeyJVLXzt0Ipekvb0ef4X/I4gYMKw9lChbeYq+yk/BXLmL1zzoAUrh6v
         Soi0lTSHT42VZYlJmYWHCcj/ydOv/pbeEIBq9lIQG0FveN66lJ8TBPJ8VHQSMzdTciIv
         RFiA==
X-Gm-Message-State: AOJu0YwLujuOSqewM73iyI7tNCftkuGWdD0JUS89R1ZLtnSDkYxWoXwJ
	U64kiTMmHArT2Xv41toXsZrq9WQXla2DuLVq0X743C/pbNmWBbJZlwuH
X-Gm-Gg: ATEYQzyLkyezmsggUMAYVB58v+93F/xnKO978eR5JiMzcrD4PLSk2yDFpxnAqrwYECU
	Uu8iVW+kFZVER/lTuSSVz+d8V+8wCas/bcKFraLrWetMYBCl+L58htiRwNXVXJ0kw8t96wkGAZS
	CnEPcpunuL1UaY177IYMEWfyXUPw08NptVSsyV02iiJ4ijPSHxuiZeTFp+CPHOIH/v8ZEpfDnzB
	9rMeyCXmXQmmjhqiyTKbNAmHbR7/NqpPcZhL8GjM0sZm9GOiYIKuqW+ne2SWsYgM3p3boLQOS9d
	sW0VnDuQy8Bw7G3CQVWF8UJ8Jtw2eCCJ4ltDl+3bfhQDRkHBDQNKFVynAqutAHYghzSaaFVwQDZ
	adrgkyyhnwP2ctcRYb8nHRympLSnJRi0GH/e08+VGCgJXhOgFwu0cglGAq1dI+m2MFGoD5Pe/DH
	xPeIjyJNCk0DCICQoCSam0ozrt8gTmvO6LcM/5XhYTHeoZBKrdh0LDszDVQKh8
X-Received: by 2002:a05:6214:21e5:b0:899:fa7f:7144 with SMTP id 6a1803df08f44-89cb4ee1e3cmr63152656d6.26.1774380096647;
        Tue, 24 Mar 2026 12:21:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c8536ba60sm123576176d6.44.2026.03.24.12.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 12:21:35 -0700 (PDT)
Message-ID: <cb569289-15af-4bd4-a654-7b04a3690559@gmail.com>
Date: Tue, 24 Mar 2026 12:21:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260323134504.575022936@linuxfoundation.org>
Content-Language: en-US, fr-FR
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 06:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
