Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ABD41A55F
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 14:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323991; cv=none; b=UoublTnD3RCeyGMo6xfwufo7M2KOCS+2gwCfUCUb4giWGkySo9DuCTwioeMUCAwkBzEC1osjXOjiHbBDavp+WP05O3vwVCZ2n53+XdBKdOsf+TTEMkAJDxn385+WLqC8lty+K35qRJW3tLyqpAw5t73n8Z6saZI2Cz8rzLC4nec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323991; c=relaxed/simple;
	bh=f80evFUKcYBwSkEcmUDXzlyi5hNw03mAxg46c6N9LnU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cCnXylxK+KErORz0Yo4c/bZy5UGoo7UHZBqWRRmyvJjDcWp0xN0eXv8pQCK0yr6oKPlM+AZJCgeW7VBccyRD1YGgACiEqXHniiroEmx8/gVR7ssXqdWLLjV8AFTZ//rgBF7cDI6jFEcOPDKckgeVmItdrFV694yvZdeWrxWJFjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1/HdkQ7; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1/HdkQ7"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-4583b1703d3so649010fac.3
        for <patches@lists.linux.dev>; Fri, 21 Aug 2026 07:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787323988; x=1787928788; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pRw6+Ijntw5BuwKAYSl816AG3AcfEQ9/cpfIZBBwBps=;
        b=b1/HdkQ70m/r1rod5nIux6NakgSr5jF8w97yLelZ8ONO8ryOZyhZlMpenEr/qTj9N2
         s48jwuHyTt5lcszS3OwMkfRrRRTf8V541B4c596FpFmvJKiyKoynyciIx3diOr285pfH
         o2VJzcWhD+sdoPKHRHPqZmlw5yKrl5oMajjZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787323988; x=1787928788;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pRw6+Ijntw5BuwKAYSl816AG3AcfEQ9/cpfIZBBwBps=;
        b=aUPRXlQJPC7XvAqBq+aYP3wxr176pg5239G+8Hvg/hJfXmiJOsRgLc8i8PCeztAgb0
         ZyRZjcb75U3Pn3qESQvemM3MSDpWq7bRyWkzIm8xC8eVicyhkjlUAKVceRn3yehqd3NC
         qgg6QgbaPGP1BERz7M8Klxo0bQ47xe2z+CNe1jaYkv+qZv6qac6DeJVeKrJYj2N3Wsqk
         aUcDC2mu7u5fUYdkKJuyIxQUhS1damvRqy5NuPN+ZDMFOx5DAqe1YWkvTwhiFi5Ht+yO
         eW72LJuLqSGFbkmXiRPBqeL9Rnas+npPRsKEWD49xQivGuIE380fQjBSkAjFba4R4zI8
         mv3Q==
X-Gm-Message-State: AFuF++lL4Ejc7NNCouLe0TpPZMd9fpbkI9+X5TY4nNIjEIkEkoeA8D6D
	1sN9oikwPyozMdmMFF7j/clAjHPcHLshvDXfK5mEu2nQYUb7tlD/2vH8ouEdYyxaajg=
X-Gm-Gg: AR+sD10W5S4tVVQAO1ajA94RPegM8oAu0ThRmxhsOmm6pDoV5WsLhsLZX8M+WbEfuBe
	aSlAjHLTglrfrjtmx4H8TLCQFA99EGt0u0sOTMslIspnuhoEIwnRuXtPv5ZRbz9ROUk3AzDEaYO
	JvbuCgtOMKwsHlMAVIduwj7blUivZKdiTaqRXpRP455kl50U2RNoal3s5Is73udzc08MUHyJ/Fb
	6mjrdHSxv22/zTKjASNxGciviZPjGHe89U0rsi6qCQrFUZ0Xi/NYjK8LaB6PBfVJia0u0mkKt6U
	Bh931nDJYZGfFin2WJqKJI8lwX1tSQs1C0n9qgyciqq0Gvaa78lQH6mXirbWuFqzsxFNqnJQXNs
	8iwq+DQPdkUi72Bxw/aOMU3ZK6PBVfepRuEx5AFgUQYykUOx+wqtf3Ii2/0e2qfSYQEE2ok9XD4
	35E/baxVZMHiJQukXAfFve8srowngR6F+zbCaUq6TYgTfzgDFh7qUd/CGZeYKS+1Sy033c0w==
X-Received: by 2002:a05:6870:8106:b0:44c:d6f0:7f70 with SMTP id 586e51a60fabf-46351421357mr6721721fac.17.1787323987661;
        Fri, 21 Aug 2026 07:53:07 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4632a54fc4esm4525536fac.3.2026.08.21.07.53.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 07:53:06 -0700 (PDT)
Message-ID: <74071f91-c410-4c29-9852-1644e3f1dacb@linuxfoundation.org>
Date: Fri, 21 Aug 2026 08:53:02 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.153-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 08:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.153 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.153-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
