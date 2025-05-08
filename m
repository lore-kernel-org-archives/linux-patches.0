Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFF5275878
	for <patches@lists.linux.dev>; Thu,  8 May 2025 14:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746715680; cv=none; b=Ol7DG+jLTIZfSL2eey6U4YSe07idpmYSObRxV06De7/aLLFusEVf2UAYujpIF0CFIIPqtRbImaVU4KwywNwbOrOi0KU0accC/S5IJIle6WBYSgmI/DBhvXdX0jaGUUhYSp4UUUrwtmD9FJ+ziHSbUVfZhK6svJBGAvrA/a2+ioE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746715680; c=relaxed/simple;
	bh=OP0WRNpQ3AhTCII2JqnV9mcyFJ8DbeYGPnHp7gBLYfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tA6qxPecbAlwNCHy5Q5X/oKM9tFs1RMSAxDg5O/gIAAXsm6D3w3K25kWCgNLvlMKzGtkiL/B4Qa1z2UmO+jm1qWAVrm323gC1VBdhldVOzZdF3cPxo3wtLwyWMhWY+dXjZOKrmoW+gagvyNzgP390733ypYMfvCCpoYNjFkr7n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgD5M+05; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgD5M+05"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-2d071fcd89bso473743fac.3
        for <patches@lists.linux.dev>; Thu, 08 May 2025 07:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1746715676; x=1747320476; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZbKXS17FLCeINM3f26BpfyHxYt8ulznWKq5GCJKKZ7s=;
        b=MgD5M+05ha6XfnkCXXRYm3sSqPyt9gNpYbGB7hEPM/g86PJUymIA/KnKdymIOsqf/A
         wgIWYxj41OkktigUxylmoH5Rn4+R9RLLlezVXsRkfboJiNa+FH/fBp4O1GL6udcj1lCi
         XktPQ1U6SDkuzGbS2qHvUnD7pAIqh177PA2EI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746715676; x=1747320476;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZbKXS17FLCeINM3f26BpfyHxYt8ulznWKq5GCJKKZ7s=;
        b=qQ1UAFLO2tF3+xFXpQefIayHURsUNUtBrQfGC88HnDOYLoi6o8eVvd7iqr1WXwCHkO
         e1Yt1hcoqwkKN1rqcISmtjZ1O9JDvJJ3Zfn4K5zSnyY2uX9xG+10b1tw2TKmFqxwJoZk
         +d7+kPi5OWMDYfwbgaH5Dm7fNv9ougRZm/nD2Hr7OOlg/t/tMdiylTcXOH1wepih67jt
         gzIkxhb18hOs3CLbpjC4+awOzxXNZQB+7UnVrwiNnJgl931iyuk2WmschU0T/BSqYemg
         OXYzednDG8olSRbUAb9V4EDU2Lgt/DJLTOczJOFUpELti9UNh7qALjahJqTs8x0LC3kP
         Zigg==
X-Gm-Message-State: AOJu0YwTKQnstUgLWsN2E44SKNbDJnMU2SkFuBHWMiqLd1Wwe7hJLyTS
	hwr3K3kDdoPx3lkpzxbGlkAGi5r5WZIppL7S4vQHskqFBtrtVna0mqxSjoA+KLU=
X-Gm-Gg: ASbGncvk3TZuMYRtBWUzLguJWAY8FvIvN9/BhviVdMUTJywkNwluQRVsULw2u6SJ24K
	5KqjSQbsz4lWnd70TCsm1bDUVW5wkRG/sUvfWQU/L2awNefvoBdOQot1JDSZpAZpJtE/xb5Je2s
	ETrCe4/UKJUJbGIuVymTJnLY+6UNk9UNBZOpRa+MRLkg5jPFIA8KqM4W0sU7dbBv5VnO0QTDAV4
	M7bT4wq1imr27rZ0MEoDjfWvZc8e6eSVvEcRYr8+JtrrV26A+WF/ci68UuuOEWfYqLuMObaWLYE
	ET65MztBjfhNWMYixxnLZQyf9ObLiMPMFPdGOJKR7bZu84l39Dk=
X-Google-Smtp-Source: AGHT+IGEA5a4mOTrYmH7D6XLU6ZecdwkH7ReVPSCIEcHWSuV4+go/qkk5dvHLhAUPmYAL8ZzKUhwxw==
X-Received: by 2002:a05:6871:20d:b0:2d4:d393:8e47 with SMTP id 586e51a60fabf-2db5bd5c4d3mr4693133fac.4.1746715676231;
        Thu, 08 May 2025 07:47:56 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88a91977bsm3220210173.54.2025.05.08.07.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 07:47:55 -0700 (PDT)
Message-ID: <e6503d21-6e95-44d4-bf84-9412d61d7605@linuxfoundation.org>
Date: Thu, 8 May 2025 08:47:55 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/164] 6.12.28-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/25 12:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.28 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.28-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
