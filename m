Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6DE1EF36C
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 02:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757298926; cv=none; b=sck6uoQce7tnjBUwDC2NJ+7ZUSKC744fN5ySOG19WPcIoPnUr2hk9XJDFU037uxA2ju2oZmu05pprRDQif7GHs6g17114Be+TN0V1zBYDf5Ygbx0caKt0oVFD2BbL6AkphHPSyHyeXdTu/4GS1+5JpB1OC4fiX1g3/QwaypHU1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757298926; c=relaxed/simple;
	bh=VSS6ir5H1rLcgyOKz27cb1Gwqh9thNcgwB96WeHqhIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oXE5jEk6au/kn4WPdqeSI+oZXgOoE8+aQGNGH75tUNaWL8epShNtp+1ZVX1LcSG51G5iwgN5Kxa8gYNJvEAlqdJHt2ZM1TN0Oh/iIEHS9qck+LiQjp6+xdpuW9KuLfC12tqwNdVGn/Ygb21Qji7Yz5YNVmA4qZzHc/6slSqx79Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aJYtIR6Q; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJYtIR6Q"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-772679eb358so3510531b3a.1
        for <patches@lists.linux.dev>; Sun, 07 Sep 2025 19:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757298924; x=1757903724; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=id+ytg1Zw34+FuI6CdCcR1u66CDbUUTObLJkdajO1hU=;
        b=aJYtIR6QaC5ZDk0m0Vv7KdaaRX7gajsM+/hrelUbWjh4XTt/HE07bNB3gpkvHzdDjo
         /CQq/p2x8Keik40dwsgABHPyoK6vZ/DcFbDJO5e1SfPbwl5whcEfzwKh/pSYEkP0du2e
         DUH0MZSk+mbBozZE8rslKwan8JoN1rPlvaWXZPgRqyZO4pmKBg0mYcY2UkXRtIl7gk+L
         Oyu9q+jTqQNcCtXLvAEIQJ4Ex2Ontj0qNCo1aEwQG+nLcYuHo6IL0j06lcGhxhcDSsQi
         j0mbr+qoi22wBdYm81IG3I2j/XDlruxpO20mmYTubrhAV2As3KO3JPrMCAhDfkeTPI+E
         UhQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757298924; x=1757903724;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=id+ytg1Zw34+FuI6CdCcR1u66CDbUUTObLJkdajO1hU=;
        b=TXf134sWmM/S4BnYZEMdeEA9fJoHxwzVfID46QUdpHknq12TnM7ZZynhdKdpl9s0Iu
         5Emm7N6eQi5QB2LaS/9Pc70oe3KvqvenOXC3uHpnUd+2Ywk/IIwj7IlUyBAZ0HVP43u3
         mTwbDiI+n+7wmApIO2AB67kXTUKhH/n7PAwRUgeHbJl/UH/ucdez7hFOAGYdFIBX1MES
         j7jXW/4yjsHc45K0zM0fw1JeCbRGgP3ws7rUZ1xxMXKA2tlY39fKbdwfP0NSKdyFl7Fi
         B82hC+m+WUKDpnD2l4Oc0qWHGpBOseb62LUTKD9GZTPrhBLaQTxkcmtuZxVnQXEC7COP
         RyKA==
X-Gm-Message-State: AOJu0YyR0g2vjNSfG+535+BMQr9a5ndIIyW27G3vr/A6pIGlO9DU7M40
	om0xbMjcb+37O51KUHAUOtXMP0VtsPvoLjwuTyN6aM4Uocl6/MToBp1a
X-Gm-Gg: ASbGncvTHEQqnB4AhPvajsPFO7VomaANlqihXKSITMvFrmbPrv71jjDupTT+3fqeLpq
	66xorMWIdhZAY4ECjj9McFByY7JUj45JvDcSch3d+7Gq3cBGy6g8bZhjwuCViLUKiUhvNpDHF79
	UdmXvuUPSvu6CyfwDRKgY2fgdyyBpR2SVW4lAkKv1A+z8TNoWpLpAlHn9dYpwaspKlDrqgG4qvc
	iXf2NnWn4aTKX8z+iNea1U0yzqCFaLlkMChCinvEioNwoyOWqM1CaYsG/W4PU111IcSzJLcQdQL
	ZTCwb3vI8N1iEWSzPrXnTm6yi5lVtgCIv0kCV+nWbwVwbx0LlzHjUZaEof/MTqIJd6Jy2swhgwl
	2V3WLXBFrBgr34OZpAX+PjAdDeD7L8XzVuogrxbfcBvxDx3m0hFcmUCen7ygCzLam
X-Google-Smtp-Source: AGHT+IGpdUunw0Gu8o9Wejzox61260OWqaxdo0CyYNFeV00m/Tjhkk84xkW8KDorPix6AVFyzFNvaw==
X-Received: by 2002:a05:6a00:1a8f:b0:771:fab2:83ca with SMTP id d2e1a72fcca58-7742dc9e36fmr7998415b3a.4.1757298924379;
        Sun, 07 Sep 2025 19:35:24 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77267a225e6sm18193577b3a.94.2025.09.07.19.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Sep 2025 19:35:23 -0700 (PDT)
Message-ID: <ea3bafcb-ab3c-460d-9c27-b2d2171912e1@gmail.com>
Date: Sun, 7 Sep 2025 19:35:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/64] 5.15.192-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250907195603.394640159@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/7/2025 12:57 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.192 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.192-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

