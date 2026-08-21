Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3997342902E
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 14:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323929; cv=none; b=W+TkRu9BvJrZVxcitKKAK3baw+WrquFyLY89XSlxPtKiLGz6oLBhaO1LEV5qEeApZLtYL/bnvG3Xv24Sxc+eBuSfo1SFSpdzkvy1kIVICzjHThF6cVjsZH77uF8kxnoqQFpmeffXzHNILSp2Nj9+a2d48qPYFo9cWM5qGs840Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323929; c=relaxed/simple;
	bh=VTcM92vj44+5XCO8TjP5rjlfBncjyI8PP1vsSAHNuvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u/BB9nGhWtDTk2d+ynAf6qhD1VWLoOPynp7hm9FNy/SUm2t+RsbcQZE+QFzbbNh93SeE6UJ7rJzItN7PMPMpkmYNTP5hmYbSyZ8dW6yK+uBKTjQOAxE4Ye3PDRRRkg63fPcFV0Ul6ebVPe6n8fzft8MyyR8K4uLw6ixuknqrNMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sauychba; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sauychba"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-49ff971e903so1548654b6e.0
        for <patches@lists.linux.dev>; Fri, 21 Aug 2026 07:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787323926; x=1787928726; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Da3i+pZee9b7u3Za9DGDENY+ryDfxHSaO86YOiio4c=;
        b=SauychbanbVkVGGk1/ENDb9JLGnyL0cLOGQwnPifvmfhkBxTpSsPPSsdnYk3ktwHM/
         0s4fAH+5xdyIe01KL0/N0OBj/6fWF1jpZpuUBmGVI53TtsMx2w1W81jOhlblKmTKpYmx
         kmNTv6hX9AEzn/05/NKqTunuvrL8RPw0zmRoI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787323926; x=1787928726;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4Da3i+pZee9b7u3Za9DGDENY+ryDfxHSaO86YOiio4c=;
        b=UTpJn9TwZhTpP7v9O1TdpTEFTlstdBf9rC2UkpkgN/D3edDDGBeNILz2tzoe5g/wcd
         Qcp9WUs9bioKhJtqaz30t32PHQnGLQ+yvmPXft6+BkqRK68uPKk5mhh7I8j3dsUmUNq5
         JfySJV4huqusxcYLp7JbzHnCnFl+tusNM2NT/+euHkYV50jI8OXjiCb9nqH+rakRx9kW
         uonhUNqTsWVBhBctlty4vBK+BkeyfvL5TpzUlvhaskaeswrDn9WKJ9xzpWm2C0kVKGA+
         zoLPCtZgZ9jxFn+cn9Yra8h9UCv11xVvxLvRzQ9G1stweb9A/Tey1rFQxAO7l9nSU2f9
         PaWw==
X-Gm-Message-State: AOJu0Yz904xvg6KB86VArXs5ExxX1O/o1jM92vAbRMZUz7WfwMqHtpBK
	k4J7qEKRecNVGWem4TXK/l1gwffgdpcqmMWDpUe4EnA1EpHXRelJCRUPbpPR99BndRs=
X-Gm-Gg: AR+sD135CAFjq1cZHUIe3SNtG9AVgNYiXSNJIJVrIx0BGYmgOy+oKNmXcvvPoXATAbu
	f7b1Nv4CbgtKrwIMq/ifsICR5625/TydYs7Mfws+Y5pkWwA5kzWArZ5jEbScWl6pG1wl1P4utmx
	0mWL0lpC4ylMR8nxTR/Z/vlaap1ntT/WF2/O0/a1ZyWpndHf/6brJUw8WDg9Ov5PY8mVi+Ar67c
	oDIcGttKrywBcDQ+himLHgcvZJOahxWvMD/wZJdSDDXEKfDwAljS9CuT/0rR13IXfte1DyXjHDV
	tWNRuq6b+fYvNUULMIpTTj8n0OAYKnM+7PRMTa5cPS9ZQD2ijc4/2CcG0hGqxQK0Bc3NZjXkh7+
	Uu1wbXa/8ku328zJSvjzaIA+0ppQbVTeEMOjBmfOAWJ9MtpvTzNI7GHVzuDFEHZCiNKRHNHX63R
	C/cDzjvbDYDHeUmYckgxrqQVrWXtKQySAbfp1dZh4/k0ByKNepBN3ShrUdcJd+pkCbA9YYNw==
X-Received: by 2002:a05:6808:6b47:b0:4af:9364:b5a9 with SMTP id 5614622812f47-4b2cdbca4b5mr13366176b6e.6.1787323925935;
        Fri, 21 Aug 2026 07:52:05 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b2d6711e15sm4996967b6e.1.2026.08.21.07.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 07:52:05 -0700 (PDT)
Message-ID: <b3a59904-0c4c-478f-acd9-e56397d3e51d@linuxfoundation.org>
Date: Fri, 21 Aug 2026 08:52:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/220] 6.12.105-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 08:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.105 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.105-rc1.gz
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
