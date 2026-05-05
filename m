Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7876B48AE01
	for <patches@lists.linux.dev>; Tue,  5 May 2026 15:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777996309; cv=none; b=Zf6D9K6QvKA06SC/iQnwxPiTujih1ZYxefHy/Y05ghUYxIGCIKEwtmiDpKQxD4oR8LAvS5R4bY9xWLVXlz6T5Eidyf3+rnhX5XscP/TvrAQUu0FC/ZU0/vb7gdoIOZl/NvRLrC7vq2vNNQp+3YSw8phvFqDv8KFMlUXuFDrDc5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777996309; c=relaxed/simple;
	bh=awcIw/4fwJ1g0c3g2Sh7ge3eFIYyfDIecRfHiwyGW8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l2BZgMx0h5ErHGrtfY01TcNKd6jCS0EkZhV2swpiyEgsY9mhW/lGS5rxqZ9uCBXb+/lI6b8J8mwFGFwqUIZnxoSJvBrUTCAUmkbepbwspW1uapdcZtDFkN3z6SaYb4jknmNgJH8Mdz7c/5mguTg5WkeSumDstaBV3rJ+kxqKIuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+N0+EkD; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+N0+EkD"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d4c383f2fcso4890691a34.0
        for <patches@lists.linux.dev>; Tue, 05 May 2026 08:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1777996306; x=1778601106; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UAHPocfZ9QrMyLyykTWYGDm3AQeZnbOC9erlVzF0T5k=;
        b=a+N0+EkDsayhQAzQ2MR0Nd+WaLwfV/cqma62Ypcz8mILAHtsTysZ44QKjqijFrbO4j
         1R9CRNu43aphvRSuTy2YTAf0ZtYaWngFahLdqkJr8AIlXQZ0l6yt+W2V2ufQ8C/28i2q
         64UuMhyeL94jdmcPPM7DXIKVmiFsONyLy8ZPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777996306; x=1778601106;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UAHPocfZ9QrMyLyykTWYGDm3AQeZnbOC9erlVzF0T5k=;
        b=oJd2gtNhM0p+JbtCtF+oFKTPyJsfI8AF7K1cUVWR5KKrWgx6iZ7HF2zcm7BEPMrgq6
         xiPyAr7Qt/P5p7HnfG6NGSqTLU0aRKFdBgSYJGqqrDtG4JofwrbuHtQN05zU0VA8Xt+8
         5kD8lkrWAaKtLBMhBkNBnvVkIBfguMYrxdxKvXcnuj1KB7oJPJnwbL6pcfy0TlejoPxF
         IDkq40+NGoDU2sGdTMaY7HxSsfMPNhYr0P5xO2Vc6/V3zYJOjSSQjS7Km6+nm5marCRJ
         13NtWzkEL0+wMAKD7Rvq/hO3N2WDixqGYQjaRuoksAYNdMTaV1OXrxftGJsdJ5BO+c+d
         hpnw==
X-Gm-Message-State: AOJu0Yy8ccE3HIH7tMUdL17aTizVy5oPldbX+PZ2gRBRoXvDPBnJSinI
	kgCLduvoxdd2rTmOzxq0oNB+swOVC9xGD3w58Ew1aK6BS/gaxwDu3bOwdKxcaMvIN6w=
X-Gm-Gg: AeBDies+qexa7ZRpvsj8um2edc8V+rgI8Wtt8TRCEpd4uDb5S5wJX5jR6pSQUQpsUCd
	1/umwfLWaPCnwSEOjsvaj1cHjDyNB9k8hVf6sA5NXZ29pgRpYiJrkp+Vdh1XvsJWyZ69mJl2thN
	pDEHahtEA/JcZVrzgiuGJSSWMzKB/GEv+TEBvat0kKSVPWC6LYyW33P49jJIj+Kp9SUerelkmUH
	K9wKWYFiwz1acVBDwNFAtxiTxJTiDrSqFDzg0c1UWYR/HelfZ+I+fTnFW9f4FUzBxO0ZVRqXkx5
	buzZd96H1fihlvemBhqe+RXtjXA4UhdtpBcttSD7Qz1EBsLERuuJ1kcpTg34tZxqSHkZCJdep+p
	PtyLb2fohvfEN7dLPSgFkm8cgIJsoA/BCYY52TVJmRL3e2gULp4Okts9HR/QbmfM4v2lkMS0Oki
	Ufk/vqa+4+lw9vAvmtPDNtm7qc8UtQOuDoO8wBQWC1WA==
X-Received: by 2002:a05:6820:2109:b0:694:8b8a:b44f with SMTP id 006d021491bc7-696979c99f3mr7538140eaf.13.1777996306387;
        Tue, 05 May 2026 08:51:46 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-434548c56fcsm14510405fac.4.2026.05.05.08.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:51:45 -0700 (PDT)
Message-ID: <a243571c-1ba5-4978-8ee1-0d01ca132277@linuxfoundation.org>
Date: Tue, 5 May 2026 09:51:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/275] 6.18.27-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/26 07:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.27 release.
> There are 275 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2026 13:50:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.27-rc1.gz
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
