Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B32326941
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 17:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781716566; cv=none; b=k2s9fzLPO1ED8jAdRLaBEJvMCEsbiop0GPZDrR2UcpLHpSB5JWvjA0cpg6ZAotokdC+qVeexEX8t65Q/T6bP1emIw9Rw1dywx9f24qM67+quxxA/g2DfVsduXlL3XtjyIPGHP9P/JqBSnlO5bJspcIx+efBS60bPYmGxqlDn1/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781716566; c=relaxed/simple;
	bh=VLKV5gdnm0shYQ2A9HFU2FqDC5E4UCpdCGHSxLKoBbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E4bsMpplbXN9BT/MFM+LcK8ccRvMuR2NXGGsYySTwfpI2C4HEl1subyj/EyI5mozrXZxMbJbMRlsUx2B4r0rkRQvAXz2H5c9EwlVURueEFHAQJ9N3W6jsHOiq0W2k/AQjIzI4Ader/hyi5EFVIOnbMf0yQW5CX/rhK9ololgyqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dU3zllkw; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dU3zllkw"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7e6b5737bb2so5241374a34.1
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 10:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1781716562; x=1782321362; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=29lQJSUvYDcMCTBEsR/0mMzg0Mzs+ypLDfHFqaF3Xic=;
        b=dU3zllkwoi0k/LolxZmk9Aub9O6rZnrZAQ/WkVzDZowCL3a5yNXnBaz+D+oNXo0VNA
         4mfnEVaQ0Q9O72xs/oaWYJW6A3iwuyc4j1VqianBnVJazisQP2QV7N/UFimU4Al96/Tq
         ybdQxIrkQWgg1s4l5Zbu9gAb1SfHeRD5fBUek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781716562; x=1782321362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=29lQJSUvYDcMCTBEsR/0mMzg0Mzs+ypLDfHFqaF3Xic=;
        b=jhSSYp+GvzBaPTEV3f6Ijt5Qjh0kh3QoBknUbFo1fSaq8ejq4cGJJa80eoLhEN6Bqu
         H1q0vmnZ1HZ7/z3SbCl/1BoxfoM27YloOYFUvZ0lppmsC6gI6a5Q28FJqFkitiynKWs3
         ZJPePwjXmA1pLHVsKstiBQSmbD0WCzd8PvGipGlvSzBQ07SCNleQEF1w35AqKnzh/5Ea
         8iUCZds9uFmNHTZygXvu3ovyBy4Y1ObsThhtHhutQCfjmv6ukiPV3ylbyYdJfuCIooN8
         Ofe35csQ5HTdjWpqZSHpupDk6ect096y4SrCHbgOjsiaLpv2GlVukNNAIT5SLjm5Kq86
         9bPQ==
X-Gm-Message-State: AOJu0Ywl7chGpy8ProjKuvt54GNdNuwnP0xRoY5hxIUGnWC+bbGioUKQ
	7IubpQydqbdNJTi6k/cn8AjcqZijYB+9+5FOZ2L7K7sWLf/8JK7RatYpBCavqKTCbTA=
X-Gm-Gg: Acq92OGc8EmEh5/BPZfxqjvr7t1v0PArFIohouy3zKNzKqOTKhKSwj4E/36CoEqBaTM
	qe26bV//2ITG4/P/FiniyUo5XSTBJC4slvm3F8P3FUXNtT9en51tN1h58y4/xQYNftdMImSZYDx
	gTF3HoD9y2xJcFQDe78OeI+a9CTva8dKhu6+Cyjg6eKoDRDliF0UPuY1UhPwJarZHPWFmUpflT8
	FtiHsGdiiT7X/Xb8p0K6JsA+p2zbs7CbcInZePq9v40I1vqIEFCUraqgr7ACBYAJj1RyCGgyApZ
	OWYQ0fIgY1xX48bQRErXzXk9aIHZDXBpqqGP1/eXWsfToL+ghSuOqU/yQLkj8Jl9eeiR/kcQ+gv
	sRhgQZSEKUeM6GQxGGL2nx5wzp40/KRy7lndYpFCegQWEnzDAsVHf9sYidSyMkPrEImwtQK1GSl
	htY8VnfDjO/y8O2SDF6DD2
X-Received: by 2002:a05:6830:f8e:b0:7e7:16b9:e274 with SMTP id 46e09a7af769-7e90c5bcebfmr3399266a34.8.1781716562094;
        Wed, 17 Jun 2026 10:16:02 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e79f5a1df1sm9641059a34.3.2026.06.17.10.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 10:16:01 -0700 (PDT)
Message-ID: <c7acb5f7-fe12-4cc3-937a-0e5b2476a74c@linuxfoundation.org>
Date: Wed, 17 Jun 2026 11:15:59 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/378] 7.0.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/26 08:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.13 release.
> There are 378 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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
