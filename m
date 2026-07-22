Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDE94028FE
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 16:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784739450; cv=none; b=mSqdkObJ2vw2Qd03+erEEspBPgeMc7AKZ9KRNhswUBcFJC0n4YvRzdUEwaRcraLoe7ZTs54EIAXfhbkHIpe2ro7BLViIrSaU1awaAafn2TeQUXjD32aR+zPcj9pD1lSQoMRwRr8x4RP9xJkDzEMe9hIMXt4VrpllkG/U+7mab0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784739450; c=relaxed/simple;
	bh=uCX/YMZs+bW0+HV3qZk1hPOpTSniASdlSrxjEiGbR2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rbgv4I9WEE2Gn91HiMzSxINIFRp9h09Xl9Dbq7o6tPmTkac4D+EmiTuE1SrDeqwNEuj9mdtypnkxth95yeZtnIOd4sTtG595DrIHlKe4+YVEfJWLTgMFBTTwJVad++CfxI/J3X/K9G/8nRs3OPvvUMYBxiUNbRW6oAuLhkzLowY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGe4m8fu; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGe4m8fu"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7ec3b429a3aso1507712a34.1
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 09:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1784739447; x=1785344247; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ujUCo8FHFBDihMIuGFqtWgMTJvOgj4wPRWijZvZJVaQ=;
        b=FGe4m8fupwSdzVLMBzzbveZT0GbO5RvzppAzLW5DPxX/7Yagvu4YrNhsP21KxupAiC
         w1/ckpEBiaWUIh3uWAYxnOUW9JcRlhHFNXTlVh4QRVDhP6qJYQ4yShfbXe2hbTtiI9cY
         2HgtF6rPJVG8ij2+NkzXA0BdTHNtJPdgJhXR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784739447; x=1785344247;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ujUCo8FHFBDihMIuGFqtWgMTJvOgj4wPRWijZvZJVaQ=;
        b=YAWKlbpPrNWpBD0YVlCl32Ezr/vaWvRR+MBxdzyuu3U7g1sNm3+rBu3eMWL06uL/9o
         22n+fBzWOS05rUFKzKkl0jw5ZOcZvHJK11Y4teJMwKLjEbx1AIJqhOSFB0Utm/OMp54Y
         NOTPrnOQuWt2UmvbaePaJLQU4CZKFAzU++HIR5Lg9vIhQwqVXKkx+8YRhCivbJ16tTKU
         KVJZBWEtPIOZRl1I+M+H8Zui96PfuYcF6gmliJiB6ZvwmEh2IVpivs0z+7HXpAuXlw3U
         fRvjdhTA+jI65OkyeYoDApBqQ/mt4EuM9hTlWkEi2F17c8zFKuQLn2BOxxdKm5AXj84Y
         m2aw==
X-Gm-Message-State: AOJu0YyBQT8idCBSDVIPsTV5OsDEXQrS2I+lZdRbBjiyMJeQ2hEN+tko
	IM01wqEONJOdB3wQqnj2+G4dOnJL41WzZN9Tp0ixb2kXsQ34+ZY6A5H3qs/pC2TJHtc=
X-Gm-Gg: AR+sD11Mhx5jejjgn6Z6/Scl/ABKl1ghr/HemJj2LU+W0vQG+UOMWEP4Ro4C7rV7qt5
	ZOaYO9CZxk0v7Iyf3MAazVFEkHrD0knp6S3L1mswMwJsZy9TNhSdgKymPYvgvRJvoMFx43wCIRn
	kVLiCyf1z+0BByUu37VPv3qXu5ozk7mK3Xnq8w5Ijp3Hownn4MQNowviUMyfk27hN6JXb4ahGa6
	b1DFG5WHARYj+A/J9VxrsV//spEBeawJFVP6+PhyE3FfxEyhAjEiYzR/KGRarkrMdNNAKgsHJtq
	Fqc6pmchaAZVweQ2ahXM7jN7UD0zVOkbjPhLJzna2yt0YVGl46uo/8hb3ykciGtVHepUZ7Ftf0B
	gtOPFKT7kDm6EDWbM5RDFcOtMJ9Azq3B1dPe8Ep/92+JO3XUYSZma/GOdH78hEC8pMWdy3/5pwp
	nDsNCaXQrQnvI=
X-Received: by 2002:a05:6830:4390:b0:7eb:cc5f:a6df with SMTP id 46e09a7af769-7eda4d39912mr12668713a34.18.1784739447526;
        Wed, 22 Jul 2026 09:57:27 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ee2a0b3ee5sm1709410a34.24.2026.07.22.09.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 09:57:27 -0700 (PDT)
Message-ID: <d98c92e3-ab03-4732-8343-333222fb83d9@linuxfoundation.org>
Date: Wed, 22 Jul 2026 10:57:23 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/1611] 6.18.40-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 09:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.40 release.
> There are 1611 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.40-rc1.gz
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
