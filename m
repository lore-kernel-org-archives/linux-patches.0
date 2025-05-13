Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E81A2BE0F0
	for <patches@lists.linux.dev>; Tue, 13 May 2025 17:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157649; cv=none; b=FKdxc6pNRb48LRS6JOQ9mC5Um1bnk39qb3mTDnzlO46mSjU02fDZAdBpYJP+PmyZMZBdhdLWjRzgJE0wPtghiFJG8ftyiHLuwGL/uLlAXK6En9plFbuB6/0kAZAedcLJZAsITVUBpCjbSj9tFL8LQ1KUOWvomqcxxGt8fswYta0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157649; c=relaxed/simple;
	bh=ORgTGq0r7wJyiDFtwXEgoHBuy3lcDA/b8RLDPsQ9cJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kzY1dEvZ1913KPgpvPUBxxU9Em+p57kh9G6zecDFTcRCMRiU8D1XztAkEbvmJGml+UiX45yMkKpz3d/fGYmNilpy+PJqdotVlNeYT/0DqHq48tRDRjv7h2aFUNc2xvEwwSzxTIHR2DldUsq4QPVVxTRVAV2k+ssaeJxNSRz1KBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLZ1tvo+; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLZ1tvo+"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4774ce422easo64455931cf.1
        for <patches@lists.linux.dev>; Tue, 13 May 2025 10:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1747157646; x=1747762446; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/yHcz6mMYEIJbmi3MxPPcq/Bqop867905UG+HusUSuA=;
        b=SLZ1tvo+WV0Eg4pJ6LJgBO1NWkD5fvDnJSlsZM0X28GojEjXNlsEJmDw1ZQu2ydtpi
         1FNasdm4zqQqtvs71tQVbGpYkYXBtrCbtCYMGfvQfyJPnBbw3p5zBX95Gm6ix6oDAbLu
         fn33xTB8S6e168vAtvlDQQkwz8l0KEq/A92Kg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157646; x=1747762446;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/yHcz6mMYEIJbmi3MxPPcq/Bqop867905UG+HusUSuA=;
        b=gX7kc0SQ3KABndPV7uE9jNK95NfDtT/Aqxslm1exjCBwYOQkqWehc3wcsAHey9WzEC
         yysos9rHiQlxl/EqfpCJzFdJEqbxlDa/Sofctf7adBG6k6X5Xqj2UHT2Dgitw/mOfa1B
         HxtrfLlJHZmiSVMBlh9e0B99KKDYTs+MdeFXG+0AlvATeXlyg4sXrZtFYWh3+GK7Aq29
         32BzLHLBkuiQhMlOq+Ss/KQMML9EG42rZqQl5XfzL00iuyddiGWSeDr18A5r6XvBR7L+
         skxiVwVxAKcsMlITdVJN6OvSVktnVAD+5jUJWPRRlAtb8Ik/Q5qRXUFRGa3NJTJ5leYL
         iGHA==
X-Gm-Message-State: AOJu0YzJrrGFGbwEzKrZOfDNhpCURQnQlchmqqXUVhsL1xkNuYoYQcBd
	CSNwEkaXgL9EJk+HoQZG8Z30zfsbIfjBPyWqWyRvrm7anYeIkPVemljlZIXhYa349abME+++YXa
	T
X-Gm-Gg: ASbGnct/i35NAyB1f9NdYy4kHVEgvE7gXkuelr6R7TdZUJxxSE8uzKhJH3Gfc1L/jzO
	5oESIhdilquWbpGGNfvH4d6k5w6lwDKpa5h6YxJAQOaf3EV6+utKR2COC2tPMvICQEU90TJvM7V
	2de+39QUEMl40EPMDjQv510O1fjfyGKFo8q6g/0CEaFTEfUOzJIHqeg+44Usjib4HBrOHRZoTNx
	8Uw00flOJh/iqF9T0r1Sj9w3U0i2pStwoPDzna4cSGDNb7y2FP+RF9EkiXOrwNrmmSPf2of+KsQ
	X+MDHN1h/Ff3+/nTTbmg2KRjWqhw8qeI6nExC6h8b2uY/4g2GWMEd8D7/rGwuJdW6nYLK6Cz
X-Google-Smtp-Source: AGHT+IHnUVXnn/cpedUFGgvCl0xpvLpgIL/c/z6hDeUnR2wDQyCd57P1RCSfX1X7sblLh0kPIHFq+A==
X-Received: by 2002:a05:6e02:1887:b0:3d6:d145:2ffb with SMTP id e9e14a558f8ab-3db6f80b0c0mr5126025ab.21.1747157635105;
        Tue, 13 May 2025 10:33:55 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa22658dd0sm2157241173.114.2025.05.13.10.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 10:33:54 -0700 (PDT)
Message-ID: <08f7e5bc-1a20-45ed-9334-3c2f90504b83@linuxfoundation.org>
Date: Tue, 13 May 2025 11:33:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/54] 5.15.183-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/25 11:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.183 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.183-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
