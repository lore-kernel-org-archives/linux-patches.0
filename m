Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C102D2C08BB
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 17:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780335044; cv=none; b=E+xxcXTYxpYL6Hi6mGZel1XuqNkn2+DDHz0yFIDFDOl5aYY/IxzuncpdTgRg3MdGmnqiLqIXIsh9MSy4CNWV31e5ktqZZYv7I/3SGNDlfIVPeoOy8tkm3g73dOc+hY13kQesvdI6w8PfBKeEwMZPdv3Gu7XSyaRJuHqE60ByEcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780335044; c=relaxed/simple;
	bh=kVfhB7fiqpX15B9e1Tu0EUPsVLPPQuD1A6f1Bf2rIRI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=CYFHA2K8wZNkyZPi9ui4wujP003BMtssh6zARZ9XEB1gr2ze0NlHPNGsMWlL+p04sEr7b8Modl7qk58ohBcAGas30rkSOxvTU9oM8qZXLOS+pl00vmRefWpD7l1PGWHQ+q5Knnp5Gy14CyH3AzcFmVRjA5OLPzeRn6hZBhiMD1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ssgTY9Vl; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ssgTY9Vl"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9156ceb55ffso65707085a.0
        for <patches@lists.linux.dev>; Mon, 01 Jun 2026 10:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780335041; x=1780939841; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k9PVT73NwZV2mjPO8f2HRljt0Q/UvloyOhDI//UxRJI=;
        b=ssgTY9VlXsZYkzZ338eMDpsVT3ZZjsMYERi/S2BEiNa2BieVM9YFjtURdGv0q3Rmyc
         crnczgAdmEE8tti1BgpWMKdIlHZpU75IK2hIQZZYTk2jRduIKmCJzdLHmSncQ5804WFb
         hqMEuBByiyNUWg6RxVtYBHRNUh1zvunDpr1oF1JAP1p5ALiHTERX7o4ojHV002yZDV5r
         vt/MQkrr331ucZZiqonO1/CiOd7t/drGjFflSZwqZUq727XpmVUPo6mjztJ+uS2iVpfH
         RLdMRn5N4f70t4Ai1cBD8gOOe+9uu9jb/bXHpyG5/ymKZ/XvVlXUH/utakC/8X6H1xFl
         cA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780335041; x=1780939841;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k9PVT73NwZV2mjPO8f2HRljt0Q/UvloyOhDI//UxRJI=;
        b=Qr8O1W6Zb0rLSg6TwVaPTUYoIRkJKQDo/EtzhM0/wplauULizRV1tzYFw9hPW/kHPl
         6FgGkZgf2QOpUdZoTRhmJZTmZTm+qo27H2dthTNR/qwnt7dXadMykRbv3/ojDTnaQr97
         wn7u5kKY5WnR4B62TDEE26tyTn0VVR5RROLAN4mWtUOGsB8Lr1hHrEwHXawBtoJgZ6nz
         oD26Ztm8eQsEQ532Mm6Lb6D5DfvyZXK6SMgsNsCLesxXDDbMgF5du8Cw9pBawKjdMwqu
         WnW3BoXKhmx9ky1Z5NN0+RMlqOHBbUS9bnda6cEcFJgpucrF4c9pWPeLladhrgvEqbvU
         nLng==
X-Gm-Message-State: AOJu0Yz5dUZhnE9QZETP5L8o//yP1m/RzvShRg8LoAG3PTY4dNMf91+K
	RZhZUsZGuE9GvfJGt8VRsiu2TbvIJvZdcCBHfCvRqlaIe3f16hWkuDqk
X-Gm-Gg: Acq92OFTD24IhfBuz4EgmL2k7n/JLep75/FG7QWHHm3k3XjJYOgb9WFGrSECWKvngkM
	KQCh/ByPaRrwEeLw/G+ps5hy0dHuOQP50K2PWP5e8+ykqLgdOThVdIO8u/3SaQTX5aLq5OpPk94
	ADdyZTWe01qnhKr/D7VutA73j0BZ0Evq9hT8/AVdW7lf0O1QAr0Q3mNNg6yI1qOW3MB/BLt/8bR
	nYR5l4+z+rHrG0TsMR5mrC+gXfKP3AgOnjPk6VlXnjuVvzxa0oAQeSY+SkxmutwXqNtOYhQ6m7c
	zAoWCLxjoupAsptsjHdzZbA3bLw3sLqcu77mQIDilhqYjdZ9oCyNv/BPNegUsdG+SgCx7y6Mbqv
	2+fdHvPJ2IeGeSgp7s50YI85mibMo92D70PqV2pKgYHiLoXE87J6xbDkPgsY001RgD/SaDUTEM0
	JamnsegJPlBMxqdSF1OaCLcp9chaJlSlUnboki7fh72sH15Dx/ten1ikSN5Hq4XEt9MLSRqv0=
X-Received: by 2002:a05:620a:649c:b0:912:671b:d090 with SMTP id af79cd13be357-9153d999728mr1802258585a.24.1780335040441;
        Mon, 01 Jun 2026 10:30:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915325fae79sm1064758785a.26.2026.06.01.10.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 10:30:39 -0700 (PDT)
Message-ID: <bf8eda29-9c02-42c1-a55b-023b5d30f84b@gmail.com>
Date: Mon, 1 Jun 2026 10:30:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/969] 6.1.175-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260530160300.485627683@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/30/2026 8:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.175 release.
> There are 969 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 01 Jun 2026 16:01:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.175-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

