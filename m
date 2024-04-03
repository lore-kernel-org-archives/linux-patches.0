Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AF715686D
	for <patches@lists.linux.dev>; Wed,  3 Apr 2024 23:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712185210; cv=none; b=kRAMf7x5zetVBtIJ7BpwpCzrzYfxIMzRALTLRG0GAdBTCwZFe7WnBysXLduOAaJbBQ+8OAvsSoADUyhb6nRJm/JQNRRH2PFsXQUMKIH+Yc8lM4M00Tma/g18rVo+uWdy0UdLn5pwv9LrrqKOXPyQ7Z+OTq+tUJfHr0qrCKW2SJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712185210; c=relaxed/simple;
	bh=jmIV0GOw5opWjSRaLZcl7S1Iprv49UC3ViIj5KVGbdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lbe/0GPaVwRMfrM+FooW9daNoBl/AzMiBbVQ2hceJZkKWU/EzkFDxXpvPoLrylmx9UWzrOONC8LGQ6zjI7dlMPHqpq73iX5t6xez9alNP4r5Pt0e+gvFymCWCHpFTlQ43Y65XBh/7BM29ciJwNqyE8AtDRdWvNbcm49pgJWLmwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTlQDcuJ; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTlQDcuJ"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so7748039f.1
        for <patches@lists.linux.dev>; Wed, 03 Apr 2024 16:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712185208; x=1712790008; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dDl1NAxggtWfWoUqJc0/YE9Vva3ljQrZuJwUEtA4epk=;
        b=HTlQDcuJzW2WKCeKanb3vKPDIpZAM4xVWOmtXmaOI8lw8INHcD3sHiTosgevB2nwdt
         +kr/l3ayo9QTVWie9Ur+8ORTweDruPT3o0TBe2/KZnQN+iFHgiOVV0fLqz0P29ZTapTw
         eGnk9VXOLxXPy4oSmWfMjwOZii6zblSvJ3c4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712185208; x=1712790008;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dDl1NAxggtWfWoUqJc0/YE9Vva3ljQrZuJwUEtA4epk=;
        b=MkKRsx4UQ57l67S8nSg0vGFu2gs23g/ExBejggB86aQek1gzF27xlMmuD2smKvAkXt
         i0xM2gZMhtr1CSq4ZwLIAK7OLY4O1QU4OXWsBhKvQ6982eDRBexl1t3PsGFTUVz3eTES
         ITnXflSo26La3zJTXDeCMe0aPwymkBrHylwhaxZP+OgIRQ7Rfok8dzA8s53/YqPNvsuk
         M6Vxt2Yy5ROozxifIP6nq5ZYY6P0glV4lzwvoj3t9+KUoREdOFShEbdDE7pl4X6T1683
         MBfhr9MsEVAm1qO2eHCu3obEexgDcn0JJjDc3wT6kP7mO+eDX9zOYm0gL7CskWLn71hN
         1O3w==
X-Gm-Message-State: AOJu0YwGfmL7bx9V8cQoGkY0shFz5Xwl1Jts/L2Lb1jAKCsa/0l9+Ql0
	9B0NebQnBIi3jBNFvZp/E7KDi5EH1COtPKfM+SwSEyDWP7ovkdFIo9BWb99EkTo=
X-Google-Smtp-Source: AGHT+IFl5XEZ2ibJnPA43ZuAvjF2L0kiBzzsvfNYmw9cYR0Av/jzR05d3ho2D1+yTpz0sqmI2dVeRg==
X-Received: by 2002:a05:6602:3418:b0:7d0:bd2b:43ba with SMTP id n24-20020a056602341800b007d0bd2b43bamr1609782ioz.0.1712185207862;
        Wed, 03 Apr 2024 16:00:07 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id t31-20020a056638349f00b0047be37bfbbdsm4057220jal.153.2024.04.03.16.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Apr 2024 16:00:07 -0700 (PDT)
Message-ID: <a515127e-7609-4947-aec1-4a7cbdf72c40@linuxfoundation.org>
Date: Wed, 3 Apr 2024 17:00:06 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 00/11] 6.8.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240403175125.754099419@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240403175125.754099419@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/24 11:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.4 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Apr 2024 17:51:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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
