Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F41318ED9
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 18:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775757978; cv=none; b=aOhL2mYlwOHAfFTGjL/8C5g3lmCLlnoeGNOCO0vc2uaEY94GyWhJZIqsbAXVHfaJORBQsK/SrFusmotE5J4sNwwiGajyPj0cW30IYLoaGqhjzKp1+K/Ny1Ihk0FJOilgAWVwLQ4m42yE6QnRInv6uMJ3UeDfAX46w8D6hcrifOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775757978; c=relaxed/simple;
	bh=Ep/bNCiLNilr+2407QjX5N1et8bGDYN51q8pKpmp26U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P3OiTH9Z7vlwaplcIppTsn+GkDgHdyPSj2eo5lp8a/B/4/3CDi9/9dYAavRtwfP4w4m46agMamK5dchUlM9na8bRKJic2B5/hEv1/w/bO8/KFVGz22l06QvlksyVQH+9sFMcqpCEjui031BOSO2Y/DwHEKMn22dwFoUwnm+iNgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0MjUFYu; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0MjUFYu"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-47018d341f8so885112b6e.3
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 11:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1775757975; x=1776362775; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LC/Le1MW2BQyntnqxIySdIWWVYKn2c+zuYiwa/nivS0=;
        b=R0MjUFYuXADY/Vdpw4BZZh7qXS7qh8Q+C6JajuBfLIi9XwEB5INlx6fo7DvP0Axo/I
         SRCw6hZ8X88lUE6NMH3VeBP22/pv1H49ajj4qSNasVL/gSkUiteud/0MlOAe7SW08RQU
         pdgG2vaf0kmhkwNo3HVXPw1h5cFoYozl8ObEE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775757975; x=1776362775;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LC/Le1MW2BQyntnqxIySdIWWVYKn2c+zuYiwa/nivS0=;
        b=HMsthEzba9Ib93zCkkRpIguKi4nReydhAECbxbvRUbItDLEtC8lXS2IYlg/W17LQaQ
         XzCcRGlDc293HXOB/sPhu20zurS+uFKYiZ8AxlcTDHpaqj2Er5zAfI349nTtFU46Pc2Q
         oAsqHWP7xs7Ol59sJRjuSYhVxDtVDTNtBEXM88ZkVazGK621yce0W7wDMWpy4ME5Dz/5
         5d4OmTPTnKL2vVtrnRTtGKt4OHPgZgZnDFahJpYxSay8umvZoTdAzxOGHtMLucsnD/KU
         +FTIxYOCS8jnQg4PGJrc+jMNOb83umOgF+Mulc3rM2AuqxzW4UFApnAmDQ6AULY8WCg2
         Ovmw==
X-Gm-Message-State: AOJu0YxLSJaQFhTKUF+ywPcAvCeXcu8fsFe484Cnln4AmRLgbFRWq7Rb
	ou+ZyHE2fn6BK0Hya9Qz138lBj5l/PhvPSRKfJkoPGZU6DTrj8ZhHAp2PLeptSYEyIo=
X-Gm-Gg: AeBDiesAcLLjTxYDSDAuY5wqeaEhdal+v0LIwKAc+EVihIWWBadnzl4/C+3+PPTUyNd
	c5oxpNLh1w2Ks7EzFNAqVydqwNdOjnNej6BhLOrdvp8BBvglVTWDjOXIrM3/cnXqFX29AlRdbsr
	/PBxuG/GMkfhvvaiX0Cq/niuRhq8/yS73vGgmhVpSGNef61gIeyaUn3iPNnUdGegj8z0VYPlnGV
	AV1cx++9LfXwcyPYtSDLMgw5qlA7EWdQC7pjpp5WdF//Oysy7HhDPgC8ZmNQY4Y2ltHfo3ThIrG
	/Rm2QNtiCIyQl8qO8ZlDsJymXBsNSz++qGjV5vVI0FDZp/akH+vnGHChcBvPQKPGJadxCAgzE53
	ZkDw02GplS5aw4CJjome/5pX9YemONDkgGnpT8IR5uKZneyvXPy/kv/OaouxhDG5pzWUnO/dbJ4
	Jr/ssqPhPM9p99KIEMwjxFPNrjNixDA8hryhw=
X-Received: by 2002:a05:6808:4f52:b0:475:be6f:aa with SMTP id 5614622812f47-4789e42cbbamr149336b6e.19.1775757974898;
        Thu, 09 Apr 2026 11:06:14 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-423ddb23a9asm322146fac.10.2026.04.09.11.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:06:14 -0700 (PDT)
Message-ID: <b1a166d5-6a86-4731-984a-75736f600ead@linuxfoundation.org>
Date: Thu, 9 Apr 2026 12:06:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/312] 6.1.168-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/26 11:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.168 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.168-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
