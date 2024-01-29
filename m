Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896D74C3D4
	for <patches@lists.linux.dev>; Mon, 29 Jan 2024 23:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706570190; cv=none; b=plTbwS2vW1u+J2qW2LafOy8sEXYyeHiZvbl+Lw39wBAFAdJJ4MQlu/oCkbn3ddYHNoJev+/VrZj4pHC9Y19OWF/t2+BJqGaHIBFl/DqhQk2mY1ghbUI0M75WKKXGCBGHS5kZHP+1QdQxlB4hcol2rt7jdI9DZ12aPKIn9diqetI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706570190; c=relaxed/simple;
	bh=EHU/gFLmRVzGlHoLA/zjYW4/9gQBhzXmrwpJH2AHQlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DJFbyUG8M0gK+erBtUPwrFpX2uxHbItrf+DNHWCRhUSo1nxA+e3RP6JSMyjeIkH+Oe8MBhRuG8htYTOJ6hyE1Fs9HheKDn/xbtMzCo6mgfuzYVHv29GnW9zmts1pT+dGhqWQxs7c5VEA1xg0uY3/0ULFJCbCcdqMAn9JxOASNSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMP7I1vI; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMP7I1vI"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso45613439f.0
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 15:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1706570186; x=1707174986; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v2XpaGGZCWFpMyaB9aPEtxHOP3hYJmSQiAvS87bMfNM=;
        b=YMP7I1vInWwy7HfMhJxeBg+M3BPxfTP3EfMF50YvpWWRAVFa5XpcF84RLGD3t3wyYt
         hkjfjroNbXxch0owDWWv6/B5J8y2lcoP+90NhHIF37CrtmuYYZQD5QFIFgaIrSooqtln
         TEDs1wvNwUujGO9/Mr/lOc/f4xSMZs2vYBeJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706570186; x=1707174986;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v2XpaGGZCWFpMyaB9aPEtxHOP3hYJmSQiAvS87bMfNM=;
        b=T5wUooAlEG6efYcptKiG8NV/bZfUdf69dALohmNo0j7vMJvyRmvK0MPZSzzgLsJONk
         8q9fWIVQfvaG8HXHJThfIG5ierJSb7Ysol88rapde2G8f+of83Nwk8W448Nl1CsadwVi
         nYBggiqmAKa027uzbCBKIAGTTB2JLbaCR9qHpo+9QqSq8P8jCNhmTnTWfAnSauO5fwBJ
         Zic5E+a/ws9W9RLJE/AwvvbTjb8l9U3zbDQJTItt8n0u/OLTLgGlcSi5chMI2oDk8uyS
         zIgmc63ZcLYoSBfPKaCoLrZNs8Rbu/La/N+V5+bM2BvFxtkdICaHC8TD8EvbNPRSwXXb
         O3VA==
X-Gm-Message-State: AOJu0YzfDKJL99/Cpz9KBcTUj2ifmzL2mWUJrmNc4K8TOq++n3WjQkR9
	Kdhla+bAcT1fQhMYhk1Wf6VJI1VMQcI28zkPMDsci4LeXqj6jjYVHn5Iy9LeZ+0=
X-Google-Smtp-Source: AGHT+IE06yL/FKzzFPN8CpJNqqMMYEYB7Ec6sTMjdLr826q5Y5ke1zuJTodWnXyDOQTPnb13WBUS0Q==
X-Received: by 2002:a5e:c748:0:b0:7c0:bd3:ab7d with SMTP id g8-20020a5ec748000000b007c00bd3ab7dmr502826iop.0.1706570186744;
        Mon, 29 Jan 2024 15:16:26 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id g19-20020a02c553000000b0046edf6bffedsm1988701jaj.85.2024.01.29.15.16.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 15:16:26 -0800 (PST)
Message-ID: <b065a083-e87b-42ad-8d49-a71f0c53b303@linuxfoundation.org>
Date: Mon, 29 Jan 2024 16:16:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/185] 6.1.76-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/24 10:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.76 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Jan 2024 16:59:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.76-rc1.gz
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
