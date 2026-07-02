Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07E7318EC1
	for <patches@lists.linux.dev>; Thu,  2 Jul 2026 17:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783014263; cv=none; b=ufBGiKe7Xc/agJKVh8++KVmDkw1VoA+hrWzryqC1pma8wJD8j/G/wZwE19YLtmYRM+/7uhM+I8MGBibm6jaUCWtqXInun1TnV2BC1G8uMqr8RcqY3mju1zxxhBaEajUCyARRPN307/mTlMMiu7ooPZIJ1nOEtM2eoEUoRVY5cSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783014263; c=relaxed/simple;
	bh=slYQfA95u4w9IfAmSQlot7YQrqu1NxdBnaQ4y+GqwuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mrRLIurRmB+6l8qv/XXl9IfV5gI/C8mpX0zbzP8Igkd6CdOtUY7KZWqEeUMDoqEE2TFRSLaS7y0ye7V0WAz0QWGtWP9wD4NH28fF+ceNu+gBrtNujnXWrJUZyjgNH3125icVMXBoOPodnMFBDOzprBZ1W2iojcDXbp53HZ4HrzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8wf5o7W; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8wf5o7W"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7eb5bdb50fcso495926a34.1
        for <patches@lists.linux.dev>; Thu, 02 Jul 2026 10:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1783014261; x=1783619061; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HK9U9SbnZZhSV1BjuVIdjTw4J1whSoiAiJpu28W0Epw=;
        b=T8wf5o7Wow6tYivikruGcWKYhezgXgIGL9gE8ovvcQOOXglpUhXXzeMvToUwEC9RLw
         nwAhQyvv+HV043n9OelJbfLjktAB24HoAl8yKdd76oaVYxDs0BPkgk2eBcrsGOddzZSG
         a1AcCDaAaud0nn/kaBscF+rJiSsHzXd4rl12w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783014261; x=1783619061;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HK9U9SbnZZhSV1BjuVIdjTw4J1whSoiAiJpu28W0Epw=;
        b=U9oObiQ9NSfLfS5bEaGD2VV6YqmEeChxyTMQu/E1NnlLGGbMMU/LYQpMGTc3eeFD5Q
         Ib1P1sEay4yvjyeUhwNESInomzWky0AUOvxe0PalLhNaz76cLfGec7jOqKdTLcfdWEBl
         //KoveYnuW/sREd5TthJDelkCpAJ3s3KatawWPg3VjhoTUM7vEJ2aPQQXavD8KmvwAqP
         976DrM4gevAqkb16yucva4Ish2wAQ996qQCd1RfKELhb3rMkJKFGyMh/HuoSahrAxoPO
         r3fJDgB3gUohWYpYJOpr7gvdA1exJrp/zxPeBsFUgVNrWIDI9745M99uHdU7uu11Qlsp
         MHVg==
X-Gm-Message-State: AOJu0Yz/wepgw9CErZ5HxpM8H+2zPd70sgZryndw3V2tPZy36yRr/Qha
	xd6Lv6e2ymFNPJBqzj8ABmpO4tJER1HOXb8DK70awHajHsTWStGPztgaQ4v0D+Z8v7Q=
X-Gm-Gg: AfdE7cmYLXIT4DvHb14/2QHC0ZoAuDuM/mbG1a1LbP9GfzT9cDQCX6QiXwSuBs7MKkN
	6EZcYxB5B8fK33uG4LXpZ1AOMyr+Wa/7PtFoxTzxEyIxnsGPcy10Pa8PZ6hAOejDJmJUyp4g7Et
	+1KOmdOjEafK9IMBUX+xjc4ZcCXSMGxxO/9UK4lSI6gEMdAo9qFgdmLii9cgu2QAFQWCaazqRXL
	AdDtI4EW5Bada6nxZI6Z5PZyuLN6rhjJhqmWKj8isr6Yy8DlGg/tvq6k8Q9Tgyd9bRV9aJZL2Q+
	IeFmtA4eNnylUCvi7jOlMSRjsh2YBDIRBCKkr6pBEaK+fkhj6nP61tRIaYlKts6Ep6NdAg0+CjA
	HPt3Q6+UqOWmaVPLOhjlQqEs2yN1bFG7pdMMdoP/1b6vfuvi0SJxMjOulilJ+1gEa+9yTMZYG0N
	hU7pbSmc+f8fNUqAYeK59DB0BO4dk4mF0=
X-Received: by 2002:a05:6830:6816:b0:7d7:e142:2ead with SMTP id 46e09a7af769-7eb504b30d2mr3873128a34.20.1783014260892;
        Thu, 02 Jul 2026 10:44:20 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7eb542d017csm3026439a34.8.2026.07.02.10.44.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 10:44:20 -0700 (PDT)
Message-ID: <0585b5ab-f9a1-4922-b2f4-167d0402758c@linuxfoundation.org>
Date: Thu, 2 Jul 2026 11:44:18 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/120] 7.1.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/26 10:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.3 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.3-rc1.gz

I am seeing 404 on this link. Maybe I will it more time for it to show up on
kernel.org

Same with 6.18 link - haven't tried the others.

thanks,
-- Shuah
